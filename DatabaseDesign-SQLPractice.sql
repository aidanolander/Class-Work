CREATE database assgn2;
USE assgn2;
-- 2 I. Write a database description for each of the relations shown, using SQL DDL (shorten, abbreviate, or change any data names, as needed for your SQL version). Assume the following attribute data types:
-- StudentID (integer, primary key)
-- StudentName (25 characters)
-- FacultyID (integer, primary key)
-- FacultyName (25 characters)
-- CourseID (8 characters, primary key)
-- CourseName (15 characters)
-- DateQualified (date)
-- SectionNo (integer, primary key)
-- Semester (7 characters)
CREATE TABLE STUDENT(
StudentID INTEGER NOT NULL,
StudentName VARCHAR(25) NOT NULL,
CONSTRAINT Student_PK PRIMARY KEY(StudentID));

CREATE TABLE FACULTY(
FacultyID INTEGER NOT NULL,
FacultyName VARCHAR(25),
CONSTRAINT Faculty_PK PRIMARY KEY(FacultyID));

CREATE TABLE COURSE(
CourseID VARCHAR(8) NOT NULL,
CourseName VARCHAR(15) NOT NULL,
CONSTRAINT Course_PK PRIMARY KEY(CourseID));

CREATE TABLE QUALIFIED(
FacultyID INTEGER NOT NULL,
CourseID VARCHAR(8) NOT NULL,
DateQualified DATE,
CONSTRAINT Qualified_PK PRIMARY KEY(FacultyID, CourseID),
CONSTRAINT Qualified_FPK FOREIGN KEY(FacultyID) REFERENCES FACULTY(FacultyID),
CONSTRAINT Qualified_CPK FOREIGN KEY(CourseID) REFERENCES COURSE(CourseID));

CREATE TABLE SECTION(
SectionNo INTEGER NOT NULL,
Semester VARCHAR(7),
CourseID Varchar(8) NOT NULL,
CONSTRAINT Section_PK PRIMARY KEY(SectionNo),
CONSTRAINT Section_FK FOREIGN KEY(CourseID) REFERENCES COURSE(CourseID));

CREATE TABLE REGISTRATION(
StudentID INTEGER NOT NULL,
SectionNo INTEGER NOT NULL,
CONSTRAINT Registration_PK PRIMARY KEY(StudentID, SectionNo),
CONSTRAINT Registration_StFK FOREIGN KEY(StudentID) REFERENCES STUDENT(StudentID),
CONSTRAINT Registration_SePK FOREIGN KEY(SectionNo) REFERENCES SECTION(SectionNo));

INSERT INTO STUDENT
VALUES (38214,"Letersky");
INSERT INTO STUDENT
VALUES (54907,"Altvater");
INSERT INTO STUDENT
VALUES (66324,"Aiken");
INSERT INTO STUDENT
VALUES (70542,"Marra");

INSERT INTO FACULTY
VALUES (2143,"Birkin");
INSERT INTO FACULTY
VALUES (3467,"Berndt");
INSERT INTO FACULTY
VALUES (4756,"Collins");

INSERT INTO COURSE
VALUES ("ISM 3113","Syst Analysis");
INSERT INTO COURSE
VALUES ("ISM 3112","Syst Design");
INSERT INTO COURSE
VALUES ("ISM 4212","Database");
INSERT INTO COURSE
VALUES ("ISM 4930","Networking");

INSERT INTO QUALIFIED
VALUES (2143,"ISM 3112",'2005-09-01');
INSERT INTO QUALIFIED
VALUES (2143,"ISM 3113",'2005-09-01');
INSERT INTO QUALIFIED
VALUES (3467,"ISM 4212",'2012-09-01');
INSERT INTO QUALIFIED
VALUES (3467,"ISM 4930",'2013-09-01');
INSERT INTO QUALIFIED
VALUES (4756,"ISM 3113",'2008-09-01');
INSERT INTO QUALIFIED
VALUES (4756,"ISM 3112",'2008-09-01');


INSERT INTO SECTION
VALUES (2712, "I-2015", "ISM 3113");
INSERT INTO SECTION
VALUES (2713, "I-2015", "ISM 3113");
INSERT INTO SECTION
VALUES (2714, "II-2015", "ISM 4212");
INSERT INTO SECTION
VALUES (2715, "II-2015", "ISM 4930");

INSERT INTO REGISTRATION
VALUES (38214, 2714);
INSERT INTO REGISTRATION
VALUES (54907, 2714);
INSERT INTO REGISTRATION
VALUES (54907, 2715);
INSERT INTO REGISTRATION
VALUES (66324, 2713);

ALTER TABLE STUDENT
DROP COLUMN Class;

-- 2 II. Write SQL data definition commands for each of the following queries:
-- How would you add an attribute, Class, to the Student table?
ALTER TABLE STUDENT ADD Class VARCHAR(10);


-- How would you remove the Registration table? 
DROP TABLE REGISTRATION; 

-- How would you change the FacultyName field from 25 characters to 40 characters?
ALTER TABLE FACULTY MODIFY FacultyName VARCHAR(40);

-- 2 III. Write SQL commands for the following:
-- Create two different forms of the INSERT command to add a student with a student ID of 65798 and last name Lopez to the Student table.
INSERT INTO STUDENT
VALUES (65798, "Lopez");
INSERT INTO STUDENT (StudentID, StudentName)
VALUES (65798, 'Lopez');

-- Now write a command that will remove Lopez from the Student table.
DELETE FROM STUDENT
WHERE StudentName = "Lopez";


-- Create an SQL command that will modify the name of course ISM 4212 from Database to Introduction to Relational Databases.
UPDATE COURSE
SET CourseName = 'Introduction to Relational Databases'
WHERE CourseID = 'ISM 4212';

-- 2 IV. Write SQL queries to answer the following questions:
-- Which students have an ID number that is less than 50000?
SELECT StudentName FROM STUDENT 
WHERE StudentID < 50000;

-- What is the name of the faculty member whose ID is 4756?
SELECT FacultyName FROM FACULTY
WHERE FacultyID = 4756;

-- What is the smallest section number used in the first semester of 2015?
SELECT MIN(SectionNo) FROM SECTION
WHERE Semester = "I-2015";


-- 2 V. Write SQL queries to answer the following questions:
-- How many students are enrolled in Section 2714 in the first semester of 2015?
SELECT COUNT(*) AS student_count FROM REGISTRATION AS R
INNER JOIN SECTION AS S ON R.SectionNo = S.SectionNo
WHERE S.SectionNo = 2714 AND S.Semester = 'I-2015';

-- Which faculty members have qualified to teach a course since 2008? List the faculty ID, course, and date of qualification.
SELECT FacultyID, CourseID, DateQualified
FROM QUALIFIED
WHERE DateQualified >= '2008-01-01';

-- 2 VI. Write SQL queries to answer the following questions:
-- What are the courses included in the Section table? List each course only once.
SELECT DISTINCT CourseID FROM SECTION;

-- List all students in alphabetical order by StudentName.
SELECT StudentName FROM STUDENT
ORDER BY StudentName;

-- List the students who are enrolled in each course in Semester I, 2015. Group the students by the sections in which they are enrolled.
SELECT C.CourseID, S.SectionNo, GROUP_CONCAT(StudentName) AS students
FROM COURSE AS C
JOIN SECTION AS S ON C.CourseID = S.CourseID 
JOIN REGISTRATION AS R ON S.SectionNo = R.SectionNo 
JOIN STUDENT AS ST ON R.StudentID = ST.StudentID 
WHERE S.Semester = 'I-2015'
GROUP BY C.CourseID, S.SectionNo;

-- List the IDs of all faculty members who are qualified to teach both ISM 3112 and ISM 3113.
SELECT DISTINCT Q1.FacultyID
FROM QUALIFIED Q1, QUALIFIED Q2
WHERE Q1.FacultyID = Q2.FacultyID 
AND Q1.CourseID = 'ISM 3112' 
AND Q2.CourseID = 'ISM 3113';

-- 2 VII. Write SQL queries to answer the following questions:
-- Display all courses for which Professor Berndt has been qualified.
SELECT Q.CourseID FROM QUALIFIED AS Q
JOIN FACULTY AS F
ON F.FacultyID=Q.FacultyID
WHERE F.FacultyName = "Berndt";

-- Which instructors are qualified to teach ISM 3113?
SELECT F.FacultyName, F.FacultyID FROM FACULTY AS F
JOIN QUALIFIED AS Q ON F.FacultyID = Q.FacultyID
WHERE Q.CourseID = "ISM 3113";

-- 2 VIII. Write SQL queries to answer the following questions:
-- What are the names of the course(s) that student Altvater took during the semester I-2015?
SELECT C.CourseName FROM SECTION AS S
JOIN REGISTRATION AS R ON S.SectionNo=R.SectionNo
JOIN COURSE AS C ON C.CourseID = S.CourseID
JOIN STUDENT AS ST ON ST.StudentID = R. StudentID
WHERE S.Semester = "I-2015"
AND ST.StudentName="Altvater";

-- List names of the students who have taken at least one course that Professor Collins is qualified to teach.
SELECT ST.StudentName FROM STUDENT AS ST
JOIN REGISTRATION AS R ON R.StudentID = ST.StudentID
JOIN SECTION AS S ON S.SectionNo = R.SectionNo
WHERE S.CourseID IN (
	SELECT C.CourseID FROM COURSE AS C
	JOIN QUALIFIED AS Q ON C.CourseID = Q.CourseID 
	JOIN FACULTY AS F ON F.FacultyID = Q.FacultyID
	WHERE F.FacultyName = "Collins"
);

-- List the names of the courses that at least two faculty members are qualified to teach.
SELECT CourseName FROM COURSE
WHERE CourseID IN(
SELECT DISTINCT Q1.CourseID FROM QUALIFIED Q1, QUALIFIED Q2
WHERE Q1.CourseID = Q2.CourseID
AND Q1.FacultyID != Q2.FacultyID);

-- Which students were not enrolled in any courses during semester I-2015?
SELECT StudentName FROM STUDENT
WHERE StudentName NOT IN (
	SELECT ST.StudentName FROM STUDENT AS ST
	JOIN REGISTRATION AS R ON ST.StudentId = R.StudentID
	JOIN SECTION AS S ON S.SectionNo = R.SectionNo
	WHERE S.Semester = "I-2015");
    
    
