INSERT INTO person (personnummer, first_name, last_name, phone_number, address)
VALUES
  ('850716-9541','Unity','Aline','050-954-2518','571-1803 Ut, Street'),
  ('690515-4305','Vincent','Ila','012-637-2222','Ap #443-5429 Libero St.'),
  ('040201-1234','Alexa','Jin','042-219-4453','5286 Aliquet Street'),
  ('760216-5552','Hayley','Eleanor','024-883-7724','140-8122 Euismod St.'),
  ('760216-5552','Marcus','Adams','071-284-5964','671 Non St.');



INSERT INTO job_title (job_title)
VALUES
  ('Library-management'),
  ('Principal'),
  ('Professor');

INSERT INTO department (department_name, person_id)
VALUES
  ('Department-of-Chemistry', 5),
  ('Department-of-Physics', 5),
  ('Department-of-Biology', 5),
  ('Department-of-IT', 5),
  ('Department-of-Math', 5);


INSERT INTO employee (person_id, salary, employee_id, supervisor_id, department_id, job_title)
VALUES
  (1, 34532, 1418, 1, 4, 'Professor'),
  (2, 35194, 1656, 2, 5, 'Professor'),
  (3, 32338, 1835, 3, 1, 'Professor'),
  (4, 38639, 1296, 5, 2, 'Professor'),
  (5, 47559, 1588, NULL, 3, 'Principal');

INSERT INTO skill_set (person_id, skill)
VALUES
    (1, 'Communications'),
    (1, 'Administration'),

    (2, 'Mathematics'),
    (2, 'Programming'),

    (3, 'Physics'),
    (3, 'Lab Work'),

    (4, 'Chemistry'),
    (4, 'Safety'),

    (5, 'Leadership'),
    (5, 'Management'),
    (5, 'Budgeting'),
	(5, 'Communications');

INSERT INTO salary_history (person_id, salary, valid_from, valid_to)
VALUES
  (5, 20000, '2023-01-01', '2023-12-31'),
  (5, 22000, '2024-01-01', '2024-12-31'),
  (5, 25000, '2025-01-01', NULL);

INSERT INTO course_layout (course_code, course_name, min_student, max_student, hp, version_id)
VALUES
  ('SF3642','Topologi',50,80,7.5,1),
  ('SF3641','Matematisk-statistik',45,170,7.5,1),
  ('SF2621','Fourier-och-Laplace-transform',50,115,7.5,1),
  ('SF1626','Partiella-differentialekvationer',50,170,7.5,1),
  ('SF3646','Differentialekvationer',55,150,7.5, 1),
  ('SF3642', 'Topologi', 75, 100, 15, 2);


INSERT INTO course_instance (id, num_students, course_code, study_period, study_year, version_id)
VALUES
  (1, 71,'SF3642','P3',2025,1),
  (2,161,'SF3642','P2',2025,2),
  (3,57,'SF2621','P3',2025,1),
  (4,69,'SF1626','P4',2025,1),
  (5,107,'SF3646','P1',2026,1);
  
INSERT INTO teaching_activity (activity_name, factor)
VALUES
  ('Lecture',6),
  ('Tutorial',2),
  ('Lab',2),
  ('Seminar',2),
  ('Other',2),
  ('Admin',1),
  ('Exam', 1);

INSERT INTO planned_activity (planned_hours, activity_id, course_instance_id) VALUES
  (95, 1, 1),
  (20,  2, 1),
  (70, 3, 1),
  (30, 4, 1),
  (20, 5, 1),
  (0, 6, 1),
  (0, 7, 1),

  (110, 1, 2),
  (60,  2, 2),
  (0,   3, 2),
  (45, 4, 2),
  (28, 5, 2),

  (85, 1, 3),
  (95, 2, 3),
  (40, 3, 3),
  (0,  4, 3),
  (18, 5, 3),
  (0, 6, 3),
  (0, 7, 3),

  (130, 1, 4),
  (0,   2, 4),
  (0,   3, 4),
  (75,  4, 4),
  (25,  5, 4),

  (100, 1, 5),
  (55,  2, 5),
  (90,  3, 5),
  (0,   4, 5),
  (30,  5, 5);





INSERT INTO allocation VALUES (2, 3, 2, 50); /* tut*/  
INSERT INTO allocation VALUES (4, 3, 3, 20); /* lab*/
INSERT INTO allocation VALUES (5, 3, 4, 18); /* lab*/

INSERT INTO allocation VALUES (6, 3, 4, 18); /* Admin*/
INSERT INTO allocation VALUES (6, 3, 5, 18); /* Admin*/
INSERT INTO allocation VALUES (7, 3, 5, 18); /* Exam*/
INSERT INTO allocation VALUES (7, 3, 2, 18); /* Exam*/


INSERT INTO allocation VALUES (1, 1, 1, 20); /* Vincent kursen SF3642, lecture hours */
INSERT INTO allocation VALUES (5, 1, 1, 20); /* Vincent kursen SF3642, Other hours */
INSERT INTO allocation VALUES (6, 1, 1, 0); /* Vincent kursen SF3642, Admin hours */
INSERT INTO allocation VALUES (7, 1, 1, 0); /* Vincent kursen SF3642, Exam hours */
INSERT INTO allocation VALUES (2, 1, 1, 20); /* Vincent kursen SF3642, lecture hours */


INSERT INTO allocation VALUES (4, 2, 1, 20); /* Vincent kursen SF3642, lecture hours */
INSERT INTO allocation VALUES (5, 2, 1, 20); /* Vincent kursen SF3642, Other hours */
INSERT INTO allocation VALUES (6, 2, 1, 0); /* Vincent kursen SF3642, Admin hours */
INSERT INTO allocation VALUES (7, 2, 1, 0); /* Vincent kursen SF3642, Exam hours */

INSERT INTO allocation VALUES (1, 3, 1, 8); /* Vincent kursen SF3642, lecture hours*/
INSERT INTO allocation VALUES (2, 3, 1, 50); /* Vincent kursen SF3642, tutorial hours */
INSERT INTO allocation VALUES (5, 3, 1, 10); /* Vincent kursen SF3642, other hours */
INSERT INTO allocation VALUES (7, 3, 1, 0); /* Vincent kursen SF3642,exam hours */


INSERT INTO allocation VALUES (2, 4, 1, 30); /* Vincent kursen SF3641, tutorial hours */
INSERT INTO allocation VALUES (5, 4, 1, 20); /* Vincent kursen SF3641, other hours */
INSERT INTO allocation VALUES (6, 4, 1, 0); /* Vincent kursen SF3641,exam hours */

INSERT INTO allocation VALUES (2, 5, 1, 100); /* Vincent kursen SF3641,exam hours */
