DROP TRIGGER IF EXISTS alt ON allocation;
DROP TABLE IF EXISTS allocation;
DROP TABLE IF EXISTS planned_activity;
DROP TABLE IF EXISTS course_instance;
DROP TABLE IF EXISTS teaching_activity;
DROP TABLE IF EXISTS salary_history;
DROP TABLE IF EXISTS skill_set;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS course_layout;
DROP TABLE IF EXISTS job_title;
DROP TABLE IF EXISTS person;


CREATE TABLE person (
  id SERIAL PRIMARY KEY,
  personnummer CHAR(20) NOT NULL,
  first_name CHAR(20) NOT NULL,
  last_name CHAR(20) NOT NULL,
  phone_number CHAR(15),
  address CHAR(30)
);



CREATE TABLE job_title (
  job_title CHAR(40) NOT NULL PRIMARY KEY
);


CREATE TABLE department (
  department_id SERIAL NOT NULL PRIMARY KEY,
  department_name CHAR(40) NOT NULL,
  person_id INT NOT NULL REFERENCES person(id)
);



CREATE TABLE employee (
  person_id INT NOT NULL PRIMARY KEY REFERENCES person(id),
  salary INT NOT NULL,
  employee_id INT NOT NULL,
  supervisor_id INT REFERENCES person(id),
  department_id INT NOT NULL REFERENCES department(department_id),
  job_title CHAR(40) NOT NULL REFERENCES job_title(job_title)
);



CREATE TABLE skill_set (
	skill CHAR(15) NOT NULL,
	person_id INT NOT NULL REFERENCES employee(person_id),
	PRIMARY KEY (skill , person_id)
);



CREATE TABLE salary_history (
 person_id INT NOT NULL REFERENCES employee(person_id),
 salary INT NOT NULL, 
 valid_from DATE NOT NULL,
 valid_to DATE,
 PRIMARY KEY (person_id, valid_from)
 );




CREATE TABLE course_layout (
  course_code CHAR(10) NOT NULL,
  version_id INT NOT NULL,
  course_name CHAR(50) NOT NULL,
  min_student INT NOT NULL,
  hp DECIMAL(3,1) NOT NULL,
  max_student INT NOT NULL,
  PRIMARY KEY (course_code, version_id)
);




CREATE TABLE course_instance (
  id           INT PRIMARY KEY,
  num_students INT NOT NULL,
  study_period CHAR(10) NOT NULL,
  study_year   INT NOT NULL,
  course_code  CHAR(10) NOT NULL,
  version_id   INT NOT NULL,
  FOREIGN KEY (course_code, version_id)
    REFERENCES course_layout(course_code, version_id)
);





CREATE TABLE teaching_activity (
  id            SERIAL NOT NULL PRIMARY KEY,
  activity_name CHAR(40) NOT NULL,
  factor        INTEGER NOT NULL
);



CREATE TABLE planned_activity (
  activity_id       INTEGER NOT NULL REFERENCES teaching_activity(id),
  course_instance_id INTEGER NOT NULL REFERENCES course_instance(id),
  planned_hours      INT NOT NULL,
  PRIMARY KEY (activity_id, course_instance_id)
);

CREATE TABLE allocation (
   activity_id        INT NOT NULL REFERENCES teaching_activity(id),
   course_instance_id INT NOT NULL REFERENCES course_instance(id),
   person_id          INT NOT NULL REFERENCES employee(person_id),
   allocation_hours   INT NOT NULL DEFAULT 0,
   PRIMARY KEY (activity_id, course_instance_id, person_id)
);

CREATE OR REPLACE FUNCTION checkemployeelimit()
RETURNS TRIGGER AS $$
DECLARE
    instance_count INT;
    new_period CHAR(10);
    new_year INT;
    already_has_course BOOLEAN;
BEGIN
    SELECT study_period, study_year
    INTO new_period, new_year
    FROM course_instance
    WHERE id = NEW.course_instance_id;

    SELECT EXISTS (
        SELECT 1 
        FROM allocation 
        WHERE person_id = NEW.person_id
          AND course_instance_id = NEW.course_instance_id
    )
    INTO already_has_course;

	
    SELECT COUNT(DISTINCT ci.id)
     INTO instance_count
	 FROM allocation a
	 JOIN course_instance ci ON ci.id = a.course_instance_id
	 WHERE a.person_id = NEW.person_id
 	 AND ci.study_period = new_period;  


    IF NOT already_has_course AND instance_count >= 4 THEN
        RAISE EXCEPTION 
            'Teacher % cannot have more than 4 courses in period % year %',
            NEW.person_id, new_period, new_year;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS alt ON allocation;

CREATE TRIGGER alt
BEFORE INSERT ON allocation
FOR EACH ROW
EXECUTE FUNCTION checkemployeelimit();

SELECT
    ci.course_code AS "Course Code",
    pa.course_instance_id AS "Course Instance ID",
	cl.hp AS "HP",
    ci.study_period AS "Period",
	ci.num_students AS "#Students",
	SUM(CASE WHEN ta.activity_name = 'Lecture'
		THEN pa.planned_hours * ta.factor ELSE 0 END )
    		AS "Lecture Hours",
	SUM(CASE WHEN ta.activity_name = 'Tutorial'
		THEN pa.planned_hours * ta.factor ELSE 0 END )
    		AS "Tutorial Hours",
	SUM(CASE WHEN ta.activity_name = 'Lab' 
		THEN pa.planned_hours * ta.factor ELSE 0 END )
    		AS "Lab Hours",
	SUM(CASE WHEN ta.activity_name = 'Seminar' 
		THEN pa.planned_hours * ta.factor ELSE 0 END )
    		AS "Seminar Hours",
	SUM(CASE WHEN ta.activity_name = 'Other' 
		THEN pa.planned_hours * ta.factor ELSE 0 END )
    		AS "Other Overhead Hours",
	SUM(2 * cl.hp + (0.2 * ci.num_students))
		AS "Admin",
	SUM(32 + (0.725 * ci.num_students))
		AS "Exam",
	(	
		SUM(pa.planned_hours * ta.factor) FILTER (WHERE ta.activity_name = 'Lecture') + 
		SUM(pa.planned_hours * ta.factor) FILTER (WHERE ta.activity_name = 'Tutorial')+ 
		SUM(pa.planned_hours * ta.factor) FILTER (WHERE ta.activity_name = 'Lab')+ 
		SUM(pa.planned_hours * ta.factor) FILTER (WHERE ta.activity_name = 'Seminar')+ 
		SUM(pa.planned_hours * ta.factor) FILTER (WHERE ta.activity_name = 'Other')+
		SUM(2 * cl.hp + (0.2 * ci.num_students))+ 
		SUM(32 + (0.725 * ci.num_students))
	) AS "Total Hours"	
FROM course_instance AS ci,  
	course_layout AS cl, 
	teaching_activity AS ta, 
	planned_activity AS pa
WHERE ci.id = pa.course_instance_id 
	AND cl.course_code = ci.course_code 
	AND cl.version_id = ci.version_id  
	AND ta.id = pa.activity_id 
	AND  pa.activity_id = ta.id 
	AND pa.course_instance_id = ci.id
	AND ci.study_period = 'P1'
	


GROUP BY 
    ci.course_code,
	pa.course_instance_id,
    cl.hp,
    ci.study_period,
    ci.num_students;



  
