/*SQL CREATE TABLES*/ 
DROP TABLE resource_ CASCADE CONSTRAINTS; 
DROP TABLE CD CASCADE CONSTRAINTS; 
DROP TABLE book CASCADE CONSTRAINTS; 
DROP TABLE DVD CASCADE CONSTRAINTS; 
DROP TABLE subject CASCADE CONSTRAINTS; 
DROP TABLE area CASCADE CONSTRAINTS; 
DROP TABLE subject_area CASCADE CONSTRAINTS; 
DROP TABLE loan_type CASCADE CONSTRAINTS; 
DROP TABLE item_ CASCADE CONSTRAINTS; 
DROP TABLE membership CASCADE CONSTRAINTS; 
DROP TABLE library_member CASCADE CONSTRAINTS; 
DROP TABLE department CASCADE CONSTRAINTS; 
DROP TABLE staff CASCADE CONSTRAINTS; 
DROP TABLE student CASCADE CONSTRAINTS; 
DROP TABLE loan CASCADE CONSTRAINTS; 
DROP TABLE fine CASCADE CONSTRAINTS; 
  
CREATE TABLE resource_ ( 
   resource_id VARCHAR2(13) NOT NULL, 
   CONSTRAINT resource_pk PRIMARY KEY (resource_id), 
   CONSTRAINT resource_check_id_format CHECK (REGEXP_LIKE (resource_id, '(^[CD]\d+$)|(^\d+$)')), 
   CONSTRAINT resource_check_id_length CHECK (LENGTH(resource_id) BETWEEN 9 AND 13) 
); 
  
CREATE TABLE CD ( 
   cd_id VARCHAR2(11) NOT NULL, 
   title VARCHAR2(50) NOT NULL, 
   singer VARCHAR2(30) NOT NULL, 
   manufacturer VARCHAR2(30) NOT NULL, 
   release_date DATE NOT NULL, 
   no_of_disc NUMBER(2) NOT NULL, 
   CONSTRAINT cd_pk PRIMARY KEY (cd_id), 
   CONSTRAINT cd_fk FOREIGN KEY (cd_id) REFERENCES resource_(resource_id), 
   CONSTRAINT cd_check_id_format CHECK (REGEXP_LIKE (cd_id, '(^[C]\d+$)')), 
   CONSTRAINT cd_check_id_length CHECK (LENGTH(cd_id) BETWEEN 9 AND 11) 
); 
 
CREATE TABLE book ( 
   ISBN VARCHAR2(13) NOT NULL, 
   title VARCHAR2(50) NOT NULL, 
   author VARCHAR2(30) NOT NULL, 
   publisher VARCHAR2(30) NOT NULL, 
   publish_date DATE NOT NULL, 
   lang VARCHAR2(20) NOT NULL, 
   pages NUMBER(4) NOT NULL, 
   CONSTRAINT book_pk PRIMARY KEY (ISBN), 
   CONSTRAINT book_fk FOREIGN KEY (ISBN) REFERENCES resource_(resource_id), 
   CONSTRAINT book_check_isbn_format CHECK (REGEXP_LIKE (ISBN, '(^\d+$)')), 
   CONSTRAINT book_check_isbn_length CHECK (LENGTH(ISBN) = 10 OR LENGTH(ISBN) = 13) 
); 
 
CREATE TABLE DVD ( 
   dvd_id VARCHAR2(11) NOT NULL, 
   title VARCHAR2(50) NOT NULL, 
   main_actor_1 VARCHAR2(30) NOT NULL, 
   main_actor_2 VARCHAR2(30) NOT NULL, 
   studio VARCHAR2(30) NOT NULL, 
   release_date DATE NOT NULL, 
   run_time NUMBER(3) NOT NULL, 
   CONSTRAINT dvd_pk PRIMARY KEY (dvd_id), 
   CONSTRAINT dvd_fk FOREIGN KEY (dvd_id) REFERENCES resource_(resource_id), 
   CONSTRAINT dvd_check_id_format CHECK (REGEXP_LIKE (dvd_id, '(^[D]\d+$)')), 
   CONSTRAINT dvd_check_id_length CHECK (LENGTH(dvd_id) BETWEEN 9 AND 11) 
); 
 
CREATE TABLE subject ( 
   subject_id NUMBER(2) NOT NULL, 
   subject_name VARCHAR2(30) NOT NULL, 
   CONSTRAINT subject_pk PRIMARY KEY (subject_id) 
); 
  
CREATE TABLE area ( 
   area_id NUMBER(3) NOT NULL, 
   floor NUMBER(1) NOT NULL, 
   shelf NUMBER(2) NOT NULL, 
   CONSTRAINT area_pk PRIMARY KEY (area_id), 
   CONSTRAINT area_max_floor CHECK (floor BETWEEN 0 AND 2), 
   CONSTRAINT area_max_shelf CHECK (shelf BETWEEN 1 AND 50) 
); 
  
CREATE TABLE subject_area ( 
   subject_area_id NUMBER(3) NOT NULL, 
   subject_id NUMBER(2) NOT NULL, 
   area_id NUMBER(3) NOT NULL, 
   CONSTRAINT subject_area_pk PRIMARY KEY (subject_area_id), 
   CONSTRAINT subject_area_fk1 FOREIGN KEY (subject_id) REFERENCES subject(subject_id), 
   CONSTRAINT subject_area_fk2 FOREIGN KEY (area_id) REFERENCES area(area_id) 
); 
 
CREATE TABLE loan_type ( 
   loan_type_id NUMBER(2) NOT NULL, 
   loan_period NUMBER(2) NOT NULL, 
   CONSTRAINT loan_type_pk PRIMARY KEY (loan_type_id), 
   CONSTRAINT loan_type_check_period CHECK (loan_period = 0 OR loan_period = 2 OR loan_period = 14)   
); 
  
CREATE TABLE item_ ( 
   item_id VARCHAR2(5) NOT NULL, 
   resource_id VARCHAR2(13) NOT NULL, 
   copy_id NUMBER(2) NOT NULL, 
   subject_area_id NUMBER(3) NOT NULL, 
   loan_type_id NUMBER(2) NOT NULL, 
   CONSTRAINT item_pk PRIMARY KEY (item_id), 
   CONSTRAINT item_fk1 FOREIGN KEY (resource_id) REFERENCES resource_(resource_id), 
   CONSTRAINT item_fk2 FOREIGN KEY (subject_area_id) REFERENCES subject_area(subject_area_id), 
   CONSTRAINT item_fk3 FOREIGN KEY (loan_type_id) REFERENCES loan_type(loan_type_id), 
   CONSTRAINT item_check_id_format CHECK (REGEXP_LIKE (item_id, '(^\d+$)')) 
); 
  
CREATE TABLE membership ( 
   member_type_id NUMBER(2) NOT NULL, 
   member_type VARCHAR2(20) NOT NULL, 
   loan_limit NUMBER(2) NOT NULL, 
   CONSTRAINT membership_pk PRIMARY KEY (member_type_id) 
); 
  
CREATE TABLE library_member ( 
   member_id VARCHAR2(7) NOT NULL, 
   fname VARCHAR2(30) NOT NULL, 
   lname VARCHAR2(20) NOT NULL, 
   dob DATE NOT NULL, 
   email VARCHAR2(50) NOT NULL, 
   mobile VARCHAR2(15) NOT NULL, 
   billing_address VARCHAR2(100) NOT NULL, 
   member_type_id NUMBER(2) NOT NULL, 
   CONSTRAINT library_member_pk PRIMARY KEY (member_id), 
   CONSTRAINT library_member_fk FOREIGN KEY (member_type_id) REFERENCES membership(member_type_id), 
   CONSTRAINT library_member_check_id_format CHECK (REGEXP_LIKE (member_id, '(^(LIB)\d+$)')), 
   CONSTRAINT library_member_check_email CHECK (email LIKE '%@%' AND email LIKE '%.%') 
); 
  
CREATE TABLE department ( 
   department_id NUMBER(2) NOT NULL, 
   department_name VARCHAR2(30) NOT NULL, 
   CONSTRAINT department_pk PRIMARY KEY (department_id) 
); 
  
CREATE TABLE staff ( 
   staff_id VARCHAR2(4) NOT NULL, 
   member_id VARCHAR2(7) NOT NULL, 
   department_id NUMBER(2) NOT NULL, 
   position VARCHAR2(20) NOT NULL, 
   CONSTRAINT staff_pk PRIMARY KEY (staff_id), 
   CONSTRAINT staff_fk1 FOREIGN KEY (member_id) REFERENCES library_member(member_id), 
   CONSTRAINT staff_fk2 FOREIGN KEY (department_id) REFERENCES department(department_id), 
   CONSTRAINT staff_check_id_format CHECK (REGEXP_LIKE (staff_id, '(^\d+$)')) 
); 
  
CREATE TABLE student ( 
   student_id VARCHAR2(4) NOT NULL, 
   member_id VARCHAR2(7) NOT NULL, 
   department_id NUMBER(2) NOT NULL, 
   major VARCHAR2(40) NOT NULL, 
   CONSTRAINT student_pk PRIMARY KEY (student_id), 
   CONSTRAINT student_fk1 FOREIGN KEY (member_id) REFERENCES library_member(member_id), 
   CONSTRAINT student_fk2 FOREIGN KEY (department_id) REFERENCES department(department_id), 
   CONSTRAINT student_check_id_format CHECK (REGEXP_LIKE (student_id, '(^\d+$)')) 
); 
  
CREATE TABLE loan ( 
   loan_id NUMBER NOT NULL, 
   member_id VARCHAR2(7) NOT NULL, 
   item_id VARCHAR2(5) NOT NULL, 
   loan_date DATE NOT NULL, 
   return_date DATE, 
   CONSTRAINT loan_pk PRIMARY KEY (loan_id), 
   CONSTRAINT loan_fk1 FOREIGN KEY (member_id) REFERENCES library_member(member_id), 
   CONSTRAINT loan_fk2 FOREIGN KEY (item_id) REFERENCES item_(item_id) 
); 
  
CREATE TABLE fine ( 
   loan_id NUMBER NOT NULL,   
   paid_date DATE, 
   CONSTRAINT fine_pk PRIMARY KEY (loan_id), 
   CONSTRAINT fine_fk FOREIGN KEY (loan_id) REFERENCES loan(loan_id) 
); 
 
/*SQL INSERTING DATA*/ 
 
INSERT INTO membership VALUES(01,'staff'，10); 
INSERT INTO membership VALUES(02,'student',5); 
 
INSERT INTO library_member VALUES 
('LIB001','Kennith','Barber',TO_DATE('27-03-1956', 'DD-MM-YYYY'),'ken_barber@microsoft.com','07665189526','18 Church Road, Ton Pentre, CF41 7ED',01); 
INSERT INTO library_member VALUES 
('LIB002','Kennith','Jacket',TO_DATE('21-10-2000', 'DD-MM-YYYY'),'kenny_jacket_66@gmail.com','07651465179','15 Montgomery Way, Chandler Ford, SO53 3PX',02); 
INSERT INTO library_member VALUES 
('LIB003','Brad','Pitman',TO_DATE('15-09-1962', 'DD-MM-YYYY'),'bradpitters999@gmail.com','07186848981','4 Comma Close, Newcastle Upon Tyne, NE13 9EE',01); 
INSERT INTO library_member VALUES 
('LIB004','Glen','Johnson',TO_DATE('28-06-2000', 'DD-MM-YYYY'),'glenjohnsonpfc@gmail.com','07921882615','227 Lancaster Road North, Preston, PR1 2PY',02); 
INSERT INTO library_member VALUES 
('LIB005','Yan','Freund',TO_DATE('15-09-1962', 'DD-MM-YYYY'),'yfreund@yahoo.ca','07156517981','Sawpit House, High Street, Hogsthorpe, PE24 5ND',01); 
INSERT INTO library_member VALUES 
('LIB006','Stacy','Takasa',TO_DATE('15-09-1998', 'DD-MM-YYYY'),'stakasa321@gmail.com','07185529294','56 Dennis Road, East Molesey, KT8 9ED',02); 
INSERT INTO library_member VALUES 
('LIB007','Mark','Feamerson',TO_DATE('01-02-1977', 'DD-MM-YYYY'),'mark_feamster31@comcast.net','07399511822','34 Farm Lane, Plymouth, PL5 3PQ',01); 
INSERT INTO library_member VALUES 
('LIB008','Winston','Hernandez',TO_DATE('19-08-1994', 'DD-MM-YYYY'),'wapoyar852@hide-mail.net','07198481668','32 Coppice Gate, Cheltenham, GL51 9QL',02); 
INSERT INTO library_member VALUES 
('LIB009','Rebecca','Barber',TO_DATE('21-09-1980', 'DD-MM-YYYY'),'bakerrebecca@hotmail.com','07198529848','3 Chellow Dene, Mossley, OL5 0NB',01); 
INSERT INTO library_member VALUES 
('LIB010','Fergus','McCalister',TO_DATE('01-07-1997', 'DD-MM-YYYY'),'perezbrian@bryant.org','07195294941','2 Eaton Gardens, Spalding, PE11 1GY',02); 
INSERT INTO library_member VALUES 
('LIB011','Christopher','White',TO_DATE('27-03-1991', 'DD-MM-YYYY'),'christopherwhite@perez.biz','07189829628','2 Thornycroft Avenue, Southampton, SO19 9EA',01); 
INSERT INTO library_member VALUES 
('LIB012','Amanda','Arnold',TO_DATE('05-05-1991', 'DD-MM-YYYY'),'amanda23@hotmail.com','07189562981','17 Westfield Crescent, Thurnscoe, S63 0PU',02); 
INSERT INTO library_member VALUES 
('LIB013','Rebecca','Rodriguez',TO_DATE('09-04-1993', 'DD-MM-YYYY'),'rebecca63@jimenez.biz','07298519818','123 High Street, Iver, SL0 9QB',01); 
INSERT INTO library_member VALUES 
('LIB014','Melissa','Reeves',TO_DATE('18-11-1999', 'DD-MM-YYYY'),'melissa14@gmail.com','07289819818','26 Vicarage Road, Hastings, TN34 3NA',02); 
 
INSERT INTO department VALUES (01,'computer science'); 
INSERT INTO department VALUES (02,'electronic engineering'); 
 
INSERT INTO staff VALUES ('001', 'LIB001', 01, 'professor'); 
INSERT INTO staff VALUES ('002', 'LIB003', 02, 'professor'); 
INSERT INTO staff VALUES ('003', 'LIB005', 01, 'lecturer'); 
INSERT INTO staff VALUES ('004', 'LIB007', 02, 'lecturer'); 
INSERT INTO staff VALUES ('005', 'LIB009', 01, 'teaching assistant'); 
INSERT INTO staff VALUES ('006', 'LIB011', 01, 'teaching assistant'); 
INSERT INTO staff VALUES ('007', 'LIB013', 02, 'teaching assistant'); 
 
INSERT INTO student VALUES ('001', 'LIB002', 01, 'computer science'); 
INSERT INTO student VALUES ('002', 'LIB004', 01, 'computer science'); 
INSERT INTO student VALUES ('003', 'LIB006', 01, 'computing and information systems'); 
INSERT INTO student VALUES ('004', 'LIB008', 01, 'big data science'); 
INSERT INTO student VALUES ('005', 'LIB010', 02, 'electronic engineering'); 
INSERT INTO student VALUES ('006', 'LIB012', 02, 'electronic engineering'); 
INSERT INTO student VALUES ('007', 'LIB014', 02, 'telecommunication and wireless systems'); 
 
INSERT INTO resource_ (resource_id) VALUES ('D1137420190'); 
INSERT INTO resource_ (resource_id) VALUES ('D1018237377'); 
INSERT INTO resource_ (resource_id) VALUES ('D1039921794'); 
INSERT INTO resource_ (resource_id) VALUES ('D1237831462'); 
INSERT INTO resource_ (resource_id) VALUES ('D180159984'); 
INSERT INTO resource_ (resource_id) VALUES ('D999576545'); 
INSERT INTO resource_ (resource_id) VALUES ('D122347647'); 
INSERT INTO resource_ (resource_id) VALUES ('9780345339737'); 
INSERT INTO resource_ (resource_id) VALUES ('9780152465049'); 
INSERT INTO resource_ (resource_id) VALUES ('9781338299151'); 
INSERT INTO resource_ (resource_id) VALUES ('9781786751041'); 
INSERT INTO resource_ (resource_id) VALUES ('9780007525522'); 
INSERT INTO resource_ (resource_id) VALUES ('0008328927'); 
INSERT INTO resource_ (resource_id) VALUES ('0385093799'); 
INSERT INTO resource_ VALUES ('C988066191'); 
INSERT INTO resource_ VALUES ('C607207102'); 
INSERT INTO resource_ VALUES ('C40281531'); 
INSERT INTO resource_ VALUES ('C55112945'); 
INSERT INTO resource_ VALUES ('C732952558'); 
INSERT INTO resource_ VALUES ('C1183758443'); 
INSERT INTO resource_ VALUES ('C1183748328'); 
 
INSERT INTO book VALUES ('9780345339737', 'The Lord of the Rings', 'J.R.R. Tolkien', 'George Allen & Unwin', DATE '1955-07-29', 'English', 416); 
INSERT INTO book VALUES ('9780152465049', 'The Little Prince', 'Antoine de Saint-Exupéry', 'Petroleum Industry Press', DATE '1943-04-01', 'French', 96); 
INSERT INTO book VALUES ('9781338299151', 'Harry Potter and the Chamber of Secrets', 'J.K. Rowling', 'Scholastic Paperbacks Express', DATE '1998-07-02', 'English', 251); 
INSERT INTO book VALUES ('9781786751041', 'Alices Adventures in Wonderland', 'Lewis Carroll', 'Little Simon Express', DATE '1865-01-01', 'English', 352); 
INSERT INTO book VALUES ('9780007525522', 'The Hobbit', 'John Ronald Riel Tolkien', 'Harpercollins Express', DATE '1937-09-21', 'English', 310); 
INSERT INTO book VALUES ('0008328927', 'And Then There Were None', 'Agatha Christie', 'Daily Express', DATE '1939-11-06', 'English', 272); 
INSERT INTO book VALUES ('0385093799', 'Dream of the Red Chamber', 'Xueqin Cao', 'Writes Express', DATE '1953-07-01', 'Chinese', 352); 
 
INSERT INTO CD (cd_id, title, singer, manufacturer, release_date, no_of_disc) VALUES ('C988066191', 'Coast to Coast', 'Westlife', 'BMG',TO_DATE('2000-11-06', 'YYYY-MM-DD'), 2); 
INSERT INTO CD (cd_id, title, singer, manufacturer, release_date, no_of_disc) VALUES ('C607207102',  'Meteora', 'Linkin Park', 'Warner Records',TO_DATE('2003-03-25', 'YYYY-MM-DD') , 3); 
INSERT INTO CD (cd_id, title, singer, manufacturer, release_date, no_of_disc) VALUES ('C40281531',  'Enrique Iglesias', 'Enrique Iglesias', 'Warner Records',TO_DATE('1995-07-12', 'YYYY-MM-DD') , 1); 
INSERT INTO CD (cd_id, title, singer, manufacturer, release_date, no_of_disc) VALUES ('C55112945',  'Sanctuary', 'Simon Webbe', 'BMG',TO_DATE('2005-11-14', 'YYYY-MM-DD') , 1); 
INSERT INTO CD (cd_id, title, singer, manufacturer, release_date, no_of_disc) VALUES ('C732952558',  'And Rising', '98 degrees', 'Universal Music',TO_DATE('2002-03-12', 'YYYY-MM-DD') , 3); 
INSERT INTO CD (cd_id, title, singer, manufacturer, release_date, no_of_disc) VALUES ('C1183758443',  'The Platinum Collection', 'Blue', 'Warner Records',TO_DATE('2003-09-12', 'YYYY-MM-DD') , 4); 
INSERT INTO CD (cd_id, title, singer, manufacturer, release_date, no_of_disc) VALUES ('C1183748328',  'The Best of Ricky Martin', 'Ricky Martin', 'Sony Bmg Europe',TO_DATE('2008-01-08', 'YYYY-MM-DD') , 3); 
 
INSERT INTO DVD (dvd_id, title, main_actor_1, main_actor_2, studio, release_date, run_time) 
VALUES 
('D1137420190', 'The Shawshank Redemption', 'Tim Robbins', 'Morgan Freeman', 'Castle Rock Entertainment', DATE '1994-09-23', 142); 
INSERT INTO DVD (dvd_id, title, main_actor_1, main_actor_2, studio, release_date, run_time) 
VALUES 
('D122347647', 'Forrest Gump', 'Tom Hanks', 'Robin White', 'Paramount', DATE '1994-10-04', 142); 
 
INSERT INTO DVD (dvd_id, title, main_actor_1, main_actor_2, studio, release_date, run_time) VALUES ('D999576545', 'The Pursuit of Happyness', 'Will Smith', 'Jaden Smith', 'Relativity Media', DATE '2006-12-15', 117); 
INSERT INTO DVD (dvd_id, title, main_actor_1, main_actor_2, studio, release_date, run_time) VALUES ('D180159984', 'Braveheart', 'Mel Gibson', 'Kathleen McCome', 'Icon Production', DATE '1995-05-24', 177); 
INSERT INTO DVD (dvd_id, title, main_actor_1, main_actor_2, studio, release_date, run_time) VALUES ('D1237831462', 'A Beautiful Mind', 'Russell Crow', 'Jennifer Connelly', 'Universal Studios', DATE '2001-12-21', 135); 
INSERT INTO DVD (dvd_id, title, main_actor_1, main_actor_2, studio, release_date, run_time) VALUES ('D1039921794', 'Million Dollar Baby', 'Clint Eastwood', 'Hilary Swank', 'Warner Bros. Entertainment', DATE '2004-12-15', 132); 
INSERT INTO DVD (dvd_id, title, main_actor_1, main_actor_2, studio, release_date, run_time) VALUES ('D1018237377', 'Halt and Catch Fire', 'Lee Pace', 'Scott McNellie', 'AMC Studios', DATE '2004-06-01', 53); 
 
INSERT INTO loan_type (loan_type_id, loan_period) VALUES (1, 2); 
INSERT INTO loan_type (loan_type_id, loan_period) VALUES (2, 14); 
INSERT INTO loan_type (loan_type_id, loan_period) VALUES (3, 0); 
 
INSERT INTO subject (subject_id, subject_name) VALUES (1, 'English Literature'); 
INSERT INTO subject (subject_id, subject_name) VALUES (2, 'Chinese Literature'); 
INSERT INTO subject (subject_id, subject_name) VALUES (3, 'Pop Music'); 
INSERT INTO subject (subject_id, subject_name) VALUES (4, 'Comedy Movies'); 
INSERT INTO subject (subject_id, subject_name) VALUES (5, 'Drama Movies'); 
INSERT INTO subject (subject_id, subject_name) VALUES (6, 'Action Movies'); 
INSERT INTO subject (subject_id, subject_name) VALUES (7, 'Drama TV Series'); 
 
INSERT INTO area (area_id, floor, shelf) VALUES (1, 0, 1); 
INSERT INTO area (area_id, floor, shelf) VALUES (2, 0, 2); 
INSERT INTO area (area_id, floor, shelf) VALUES (3, 0, 3); 
INSERT INTO area (area_id, floor, shelf) VALUES (4, 1, 4); 
INSERT INTO area (area_id, floor, shelf) VALUES (5, 1, 5); 
INSERT INTO area (area_id, floor, shelf) VALUES (6, 1, 7); 
INSERT INTO area (area_id, floor, shelf) VALUES (7, 2, 1); 
 
INSERT INTO subject_area (subject_area_id, subject_id, area_id) 
VALUES (1, 1, 1);  
INSERT INTO subject_area (subject_area_id, subject_id, area_id) VALUES (2, 2, 2); 
INSERT INTO subject_area (subject_area_id, subject_id, area_id) 
VALUES (3, 3, 3); 
INSERT INTO subject_area (subject_area_id, subject_id, area_id) 
VALUES (4, 4, 4); 
INSERT INTO subject_area (subject_area_id, subject_id, area_id) 
VALUES (5, 5, 5); 
INSERT INTO subject_area (subject_area_id, subject_id, area_id) 
VALUES (6, 6, 6); 
INSERT INTO subject_area (subject_area_id, subject_id, area_id) 
VALUES (7, 7, 7); 
 
INSERT INTO item_ VALUES(1000,'D1137420190',1,5,1); 
INSERT INTO item_ VALUES(1001,'D1137420190',2,5,1); 
INSERT INTO item_ VALUES(1002,'D1137420190',3,5,2); 
INSERT INTO item_ VALUES(1003,'D122347647',1,4,1); 
INSERT INTO item_ VALUES(1004,'D122347647',2,4,1); 
INSERT INTO item_ VALUES(1005,'D122347647',3,4,2); 
INSERT INTO item_ VALUES(1006,'D122347647',4,4,2); 
INSERT INTO item_ VALUES(1007,'D122347647',5,4,2); 
INSERT INTO item_ VALUES(1008,'D999576545',1,5,1); 
INSERT INTO item_ VALUES(1009,'D999576545',2,5,2); 
INSERT INTO item_ VALUES(1010,'D180159984',1,6,1); 
INSERT INTO item_ VALUES(1011,'D180159984',2,6,1); 
INSERT INTO item_ VALUES(1012,'D180159984',3,6,1); 
INSERT INTO item_ VALUES(1013,'D180159984',4,6,2); 
INSERT INTO item_ VALUES(1014,'D1237831462',1,5,1); 
INSERT INTO item_ VALUES(1015,'D1237831462',2,5,1); 
INSERT INTO item_ VALUES(1016,'D1039921794',1,5,2); 
INSERT INTO item_ VALUES(1017,'D1039921794',2,5,2); 
INSERT INTO item_ VALUES(1018,'D1018237377',1,7,1); 
INSERT INTO item_ VALUES(1019,'D1018237377',2,7,2); 
INSERT INTO item_ VALUES(1020,'D1018237377',3,7,2); 
 
INSERT INTO item_ VALUES (1100, 'C988066191', 1, 3, 1); 
INSERT INTO item_ VALUES (1101, 'C988066191', 2, 3, 1); 
INSERT INTO item_ VALUES (1102, 'C988066191', 3, 3, 1); 
INSERT INTO item_ VALUES (1103, 'C607207102', 1, 3, 3); 
INSERT INTO item_ VALUES (1104, 'C607207102', 2, 3, 3); 
INSERT INTO item_ VALUES (1105, 'C607207102', 3, 3, 3); 
INSERT INTO item_ VALUES (1106, 'C40281531', 1, 3, 2); 
INSERT INTO item_ VALUES (1107, 'C40281531', 2, 3, 2); 
INSERT INTO item_ VALUES (1108, 'C40281531', 3, 3, 2); 
INSERT INTO item_ VALUES (1109, 'C55112945', 1, 3, 2); 
INSERT INTO item_ VALUES (1110, 'C55112945', 2, 3, 2);  
INSERT INTO item_ VALUES (1111, 'C55112945', 3, 3, 2); 
INSERT INTO item_ VALUES (1112, 'C732952558', 1, 3, 1); 
INSERT INTO item_ VALUES (1113, 'C732952558', 2, 3, 1); 
INSERT INTO item_ VALUES (1114, 'C732952558', 3, 3, 1); 
INSERT INTO item_ VALUES (1115, 'C1183758443', 1, 3, 2); 
INSERT INTO item_ VALUES (1116, 'C1183758443', 2, 3, 2); 
INSERT INTO item_ VALUES (1117, 'C1183758443', 3, 3, 2); 
INSERT INTO item_ VALUES (1118, 'C1183748328', 4, 3, 2); 
INSERT INTO item_ VALUES (1119, 'C1183748328', 1, 3, 3); 
INSERT INTO item_ VALUES (1120, 'C1183748328', 2, 3, 3); 
INSERT INTO item_ VALUES (1121, 'C1183748328', 3, 3, 3); 
INSERT INTO item_ VALUES (1122, 'C1183748328', 4, 3, 3); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1200, '9780345339737', 1, 1, 1); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1201, '9780345339737', 2, 1, 1); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1202, '9780345339737', 3, 1, 1); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1203, '9780152465049', 1, 1, 2); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1204, '9780152465049', 2, 1, 2); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1205, '9780152465049', 3, 1, 2); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1206, '9780152465049', 4, 1, 2); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1207, '9781338299151', 1, 1, 1); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1208, '9781338299151', 2, 1, 1); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id)VALUES (1209, '9781338299151', 3, 1, 1); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1210, '9781338299151', 4, 1, 3); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1211, '9781786751041', 1, 1, 2); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1212, '9781786751041', 2, 1, 2); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1213, '9781786751041', 3, 1, 3); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1214, '9781786751041', 4, 1, 3); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1215, '9780007525522', 1, 1, 2); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1216, '9780007525522', 2, 1, 2); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1217, '9780007525522', 3, 1, 2); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1218, '0008328927', 1, 1, 1); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1219, '0008328927', 2, 1, 1); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1220, '0008328927', 3, 1, 1); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1221, '0385093799', 1, 2, 2); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1222, '0385093799', 2, 2, 2); 
INSERT INTO item_ (item_id, resource_id, copy_id, subject_area_id, loan_type_id) VALUES (1223, '0385093799', 3, 2, 2); 
 
INSERT INTO loan VALUES(1,'LIB002',1101,TO_DATE('15-11-2021', 'DD-MM-YYYY'),TO_DATE('21-11-2021', 'DD-MM-YYYY')); 
INSERT INTO loan VALUES(2,'LIB003',1205,TO_DATE('12-11-2021', 'DD-MM-YYYY'),TO_DATE('15-11-2021', 'DD-MM-YYYY')); 
INSERT INTO loan VALUES(3,'LIB008',1104,TO_DATE('5-12-2021', 'DD-MM-YYYY'),NULL); 
INSERT INTO loan VALUES(4,'LIB010',1109,TO_DATE('1-11-2021', 'DD-MM-YYYY'),TO_DATE('21-11-2021', 'DD-MM-YYYY')); 
INSERT INTO loan VALUES(5,'LIB002',1202,TO_DATE('23-11-2021', 'DD-MM-YYYY'),TO_DATE('29-11-2021', 'DD-MM-YYYY')); 
INSERT INTO loan VALUES(6,'LIB002',1209,TO_DATE('7-12-2021', 'DD-MM-YYYY'),NULL); 
INSERT INTO loan VALUES(7,'LIB011',1002,TO_DATE('25-11-2021', 'DD-MM-YYYY'),TO_DATE('30-11-2021', 'DD-MM-YYYY')); 
INSERT INTO loan VALUES(8,'LIB004',1204,TO_DATE('25-10-2021', 'DD-MM-YYYY'),NULL); 
INSERT INTO loan VALUES(9,'LIB004',1003,TO_DATE('25-11-2021', 'DD-MM-YYYY'),TO_DATE('11-12-2021', 'DD-MM-YYYY')); 
INSERT INTO loan VALUES(10,'LIB005',1200,TO_DATE('10-12-2021', 'DD-MM-YYYY'),NULL); 
INSERT INTO loan VALUES(11,'LIB011',1201,TO_DATE('1-12-2021', 'DD-MM-YYYY'),NULL); 
INSERT INTO loan VALUES(12,'LIB007',1202,TO_DATE('15-12-2021', 'DD-MM-YYYY'),NULL); 
INSERT INTO loan VALUES(13,'LIB002',1106,TO_DATE('10-12-2021', 'DD-MM-YYYY'),TO_DATE('12-12-2021', 'DD-MM-YYYY')); 
INSERT INTO loan VALUES(14,'LIB010',1209,TO_DATE('15-11-2021', 'DD-MM-YYYY'),TO_DATE('23-11-2021', 'DD-MM-YYYY')); 
INSERT INTO loan VALUES(15,'LIB011',1107,TO_DATE('15-10-2021', 'DD-MM-YYYY'),TO_DATE('20-10-2021', 'DD-MM-YYYY')); 
INSERT INTO loan VALUES(16,'LIB007',1002,TO_DATE('15-11-2021', 'DD-MM-YYYY'),TO_DATE('19-11-2021', 'DD-MM-YYYY')); 
 
INSERT INTO fine VALUES(4, TO_DATE ('21-11-2021', 'DD-MM-YYYY')); 
INSERT INTO fine VALUES(8,NULL); 
INSERT INTO fine VALUES(9, TO_DATE ('13-12-2021', 'DD-MM-YYYY')); 
INSERT INTO fine VALUES(10, NULL); 
 
 
/*SQL CREATING VIEWS*/ 
CREATE OR REPLACE VIEW current_available_resources_locations AS (SELECT i.item_id, i.resource_id, i.copy_id, lt.loan_period, 
s.subject_name, a.floor, a.shelf,  
c.title AS cd_title, c.singer, c.manufacturer, c.release_date AS cd_release_date, c.no_of_disc,  
b.title AS book_title, b.author, b.publisher, b.publish_date, b.lang, b.pages,  
d.title AS dvd_title, d.main_actor_1, d.main_actor_2, d.studio, d.release_date AS dvd_release_date, d.run_time 
 FROM item_ i 
  JOIN subject_area sa ON i.subject_area_id = sa.subject_area_id 
   JOIN subject s ON sa.subject_id = s.subject_id 
    JOIN area a ON sa.area_id = a.area_id 
     JOIN loan_type lt ON i.loan_type_id = lt.loan_type_id 
      FULL OUTER JOIN book b ON i.resource_id = b.isbn 
       FULL OUTER JOIN cd c ON i.resource_id = c.cd_id 
        FULL OUTER JOIN dvd d ON i.resource_id = d.dvd_id 
         WHERE i.item_id NOT IN (SELECT item_id FROM loan WHERE return_date IS NULL)); 
 
CREATE OR REPLACE VIEW loan_records AS  
(SELECT l.loan_id, l.item_id, i.resource_id, i.copy_id, l.loan_date, l.return_date, lt.loan_period,  
s.subject_name, lm.member_id, lm.fname, lm.lname, 
ss.student_id, ss.major, ss.staff_id, ss.position, ss.department_name 
 FROM loan l 
  JOIN item_ i ON l.item_id = i.item_id 
   JOIN loan_type lt ON i.loan_type_id = lt.loan_type_id 
    JOIN subject_area sa ON i.subject_area_id = sa.subject_area_id 
     JOIN subject s ON sa.subject_id = s.subject_id 
      JOIN library_member lm ON l.member_id = lm.member_id 
       JOIN (SELECT * FROM ( 
            SELECT st.student_id, st.major, sf.staff_id, sf.position,  
             CASE 
              WHEN st.member_id IS NULL THEN sf.member_id 
              ELSE st.member_id 
             END member_id,  
             CASE  
              WHEN st.department_id IS NULL THEN sf.department_id 
              ELSE st.department_id 
             END dept_id 
              FROM student st 
              FULL OUTER JOIN staff sf ON st.member_id = sf.member_id) m 
              JOIN department d 
                ON d.department_id = m.dept_id) ss ON lm.member_id = ss.member_id); 
 
CREATE OR REPLACE VIEW fine_records AS 
(SELECT f.loan_id, lm.member_id, lm.fname, lm.lname, lm.dob, lm.email, lm.mobile, lm.billing_address, l.item_id, l.loan_date, lt.loan_period, l.return_date, f.paid_date, 
CASE  
 WHEN l.return_date IS NULL THEN '$' || FLOOR(SYSDATE - (l.loan_date + lt.loan_period))  
 ELSE '$' || FLOOR(l.return_date - (l.loan_date + lt.loan_period))  
END fine_amount 
 FROM fine f 
  JOIN loan l ON f.loan_id = l.loan_id 
   JOIN item_ i ON l.item_id = i.item_id 
    JOIN loan_type lt ON i.loan_type_id = lt.loan_type_id 
     JOIN library_member lm ON l.member_id = lm.member_id); 
 
CREATE OR REPLACE VIEW member_records AS  
 SELECT lm.member_id, lm.fname, lm.lname, lm.email, lm.mobile, lm.billing_address,  
  ss.student_id, ss.major, ss.staff_id, ss.position, ss.department_name, 
   m.loan_limit,  
    COUNT(CASE WHEN l.return_date IS NULL THEN 1 END) current_borrowings, COUNT(CASE WHEN l.return_date LIKE '%' THEN 1 END) historical_borrowings 
     FROM library_member lm 
      JOIN membership m ON lm.member_type_id = m.member_type_id 
       JOIN loan l ON lm.member_id=l.member_id 
        JOIN (SELECT * FROM ( 
        SELECT st.student_id, st.major, sf.staff_id, sf.position,  
         CASE 
            WHEN st.member_id IS NULL THEN sf.member_id 
            ELSE st.member_id 
         END member_id,  
         CASE  
            WHEN st.department_id IS NULL THEN sf.department_id 
            ELSE st.department_id 
         END dept_id 
        FROM student st 
         FULL OUTER JOIN staff sf ON st.member_id = sf.member_id) m 
          JOIN department d 
           ON d.department_id = m.dept_id) ss ON lm.member_id = ss.member_id 
            GROUP BY lm.member_id, lm.fname, lm.lname, lm.email, lm.mobile, lm.billing_address, m.loan_limit, ss.student_id, ss.major, ss.staff_id, ss.position, ss.department_name ORDER BY lm.member_id; 
 
/*SQL CREATING TRIGGERS*/ 
CREATE OR REPLACE TRIGGER prohibit_loan_due_to_overdue_res  
BEFORE INSERT ON loan  
FOR EACH ROW  
DECLARE  
has_overdues NUMBER(2); 
BEGIN 
    SELECT COUNT(member_id) INTO has_overdues 
     FROM loan_records 
      WHERE return_date IS NULL 
      AND SYSDATE >= (loan_date + loan_period) 
        AND member_id = :NEW.member_id; 
    IF (has_overdues != 0) THEN   
     RAISE_APPLICATION_ERROR (-20001, 'Member has been prohibited from borrowing resources due to overdue resources'); 
    END IF;     
END; 
/ 
CREATE OR REPLACE TRIGGER prohibit_loan_due_to_suspension  
BEFORE INSERT ON loan  
FOR EACH ROW  
DECLARE  
fine_owned NUMBER(2); 
BEGIN 
SELECT SUM(CASE WHEN l.return_date IS NOT NULL THEN FLOOR(l.return_date - l.loan_date-lp.loan_period) 
ELSE FLOOR(SYSDATE - l.loan_date-lp.loan_period) END) INTO fine_owned  
FROM fine f  
JOIN loan l ON f.loan_id = l.loan_id  
JOIN item_ i ON l.item_id = i.item_id 
JOIN loan_type lp ON i.loan_type_id = lp.loan_type_id 
WHERE f.paid_date IS NULL AND l.member_id = :NEW.member_id; 
IF (fine_owned  >= 10) THEN   
RAISE_APPLICATION_ERROR (-20002, 'Member has been prohibited from borrowing resources due to fine suspension'); 
    END IF;     
END; 
/  
CREATE OR REPLACE TRIGGER prohibit_loan_due_to_borrow_limit  
BEFORE INSERT ON loan   
FOR EACH ROW   
DECLARE   
current_total_loan NUMBER(2);  
loan_limit NUMBER(2);  
BEGIN  
SELECT COUNT(member_id) INTO current_total_loan FROM loan_records WHERE return_date IS NULL AND member_id = :NEW.member_id;  
SELECT loan_limit INTO loan_limit FROM member_records WHERE member_id = :NEW.member_id;  
IF (current_total_loan >= loan_limit) THEN    
RAISE_APPLICATION_ERROR (-20003, 'Member has been prohibited from borrowing resources due to exceeding maximum loan limit');  
END IF;     
END; 
/ 
CREATE OR REPLACE TRIGGER resource_not_available_to_loan 
BEFORE INSERT ON loan  
FOR EACH ROW  
DECLARE  
limit_ NUMBER(2); 
BEGIN 
SELECT lt.loan_period INTO limit_ 
FROM loan_type lt 
JOIN item_ i ON lt.loan_type_id = i.loan_type_id 
where :NEW.item_id=item_id; 
IF (limit_ = 0) THEN   
RAISE_APPLICATION_ERROR (-20004, 'This resource cannot be borrowed'); 
END IF; 
END; 
/ 
 
/*SQL CREATING QUERIES*/ 
SELECT od.loan_id, od.item_id, od.resource_id, od.loan_date, od.loan_period, FLOOR(SYSDATE - od.loan_date - od.loan_period) AS overdue_days,  
    lm.member_id, lm.fname || lm.lname AS name, lm.email, lm.mobile  
        FROM ( 
            SELECT loan_id, item_id, resource_id, loan_date, loan_period, member_id  
                FROM loan_records WHERE return_date IS NULL AND SYSDATE - loan_date - loan_period > 10) od 
                    JOIN library_member lm ON od.member_id = lm.member_id; 
 
 
 
SELECT l.loan_id, l.loan_date, b.title, c.title, d.title 
FROM loan l 
FULL JOIN item_ i ON l.item_id = i.item_id 
FULL JOIN book b ON i.resource_id = b.ISBN 
FULL JOIN cd c ON c.cd_id = i.resource_id 
     FULL JOIN dvd d ON d.dvd_id = i.resource_id 
      WHERE l.loan_id is not NULL; 
 
 
 
SELECT l.loan_id, l.loan_date, b.title AS book_title, c.title AS CD_title, d.title AS DVD_title, i.copy_id 
FROM loan l 
FULL JOIN item_ i ON l.item_id = i.item_id 
FULL JOIN book b ON i.resource_id = b.ISBN 
FULL JOIN cd c ON c.cd_id = i.resource_id 
FULL JOIN dvd d ON d.dvd_id = i.resource_id 
JOIN loan_type lt ON i.loan_type_id = lt.loan_type_id 
WHERE l.loan_id IS NOT NULL AND (SYSDATE > l.loan_date + lt.loan_period) AND l.return_date is NULL; 
 
 
SELECT resource_id, count(resource_id) AS counts 
 FROM loan_records 
 WHERE return_date IS NOT NULL 
   GROUP BY resource_id 
    ORDER BY counts DESC OFFSET 0 ROWS FETCH NEXT 5 ROW ONLY; 
 
 
 
SELECT subject_name, COUNT(subject_name) AS counts  
FROM loan_records 
  WHERE return_date IS NOT NULL 
   GROUP BY subject_name 
    ORDER BY counts DESC FETCH NEXT 1 ROW ONLY; 
 
 
SELECT * FROM  
    (SELECT department_name, resource_id, COUNT(resource_id) AS counts  
    FROM loan_records GROUP BY department_name, resource_id) m 
        JOIN (SELECT department_name, MAX(counts) AS max_count FROM  
            (SELECT department_name, resource_id, COUNT(resource_id) AS counts  
            FROM loan_records GROUP BY department_name, resource_id)  
                GROUP BY department_name) s 
                    ON m.department_name = s.department_name 
                        WHERE m.counts = s.max_count; 
 
 
 
 
SELECT i.resource_id  
 FROM item_ i 
  JOIN loan l ON i.item_id=l.item_id 
   WHERE l.return_date IS NULL  
    GROUP BY i.resource_id 
     HAVING COUNT (i.resource_id)-MAX(i.copy_id)=0; 
 
 
 
SELECT i.resource_id, i.copy_id, a.floor, a.shelf 
 FROM area a  
  JOIN subject_area sa ON sa.area_id=a.area_id 
   JOIN item_ i ON i.subject_area_id=sa.subject_area_id; 
 
 
 
SELECT * from (SELECT member_id,COUNT(member_id) AS NUM 
 FROM loan 
   GROUP BY member_id 
    ORDER BY COUNT(member_id) DESC ) WHERE rownum <=5; 
 
 
 
SELECT s.subject_name, a.floor, a.shelf 
FROM area a 
JOIN subject_area sa ON sa.area_id=a.area_id 
JOIN subject s ON s.subject_id = sa.subject_id; 
 
 
 
SELECT AVG(FLOOR(l.return_date - l.loan_date)) avg_return_time, lt.loan_period 
FROM loan l  
JOIN item_ i ON i.item_id=l.item_id  
JOIN loan_type lt ON lt.loan_type_id=i.loan_type_id  
WHERE l.return_date IS NOT NULL  
GROUP BY lt.loan_period; 
 
 
 
SELECT AVG(FLOOR((l.return_date - l.loan_date) - lt.loan_period)) avg_dates_late, lt.loan_period  
FROM loan l 
JOIN item_ i ON i.item_id=l.item_id 
JOIN loan_type lt ON lt.loan_type_id = i.loan_type_id 
WHERE return_date IS NOT NULL 
GROUP BY lt.loan_period; 
 
 
 
/*TESTING DECLARATIVE CONSTRAINTS AND TRIGGERS */ 
 
INSERT INTO library_member VALUES ('001','Kennith','Barber',TO_DATE('27-03-1956', 'DD-MM-YYYY'),'ken_barber@microsoft.com','07665189526','18 Church Road, Ton Pentre, CF41 7ED',01); 
INSERT INTO library_member VALUES ('LIB001','Kennith','Barber',TO_DATE('27-03-1956', 'DD-MM-YYYY'),'ken_barbermicrosoft.com','07665189526','18 Church Road, Ton Pentre, CF41 7ED',01); 
INSERT INTO staff VALUES ('s01', 'LIB001', 01, 'professor'); 
INSERT INTO student VALUES ('st01', 'LIB002', 01, 'computer science'); 
INSERT INTO resource_ (resource_id) VALUES ('f2137420190'); 
INSERT INTO book VALUES ('8328927', 'And Then There Were None', 'Agatha Christie', 'Daily Express', DATE '1939-11-06', 'English', 272); 
INSERT INTO CD VALUES ('q988066191', 'Coast to Coast', 'Westlife', 'BMG',TO_DATE('2000-11-06', 'YYYY-MM-DD'), 2); 
INSERT INTO DVD VALUES ('122347647', 'Forrest Gump', 'Tom Hanks', 'Robin White', 'Paramount', DATE '1994-10-04', 142); 
INSERT INTO loan_type (loan_type_id, loan_period) VALUES (3, 6); 
INSERT INTO area (area_id, floor, shelf) VALUES (1, 3, 1); 
INSERT INTO item_ VALUES ('it','D1137420190',1,5,1); 
 
 
INSERT INTO loan VALUES(20,'LIB005',1100,TO_DATE('15-12-2021', 'DD-MM-YYYY'),NULL); 
 
INSERT INTO loan VALUES(21,'LIB004',1101,TO_DATE('15-12-2021', 'DD-MM-YYYY'),NULL); 
 
INSERT INTO loan VALUES(22,'LIB010',1212,TO_DATE('15-12-2021', 'DD-MM-YYYY'),NULL); 
INSERT INTO loan VALUES(23,'LIB010',1216,TO_DATE('15-12-2021', 'DD-MM-YYYY'),NULL); 
INSERT INTO loan VALUES(24,'LIB010',1217,TO_DATE('15-12-2021', 'DD-MM-YYYY'),NULL); 
INSERT INTO loan VALUES(25,'LIB010',1221,TO_DATE('15-12-2021', 'DD-MM-YYYY'),NULL); 
INSERT INTO loan VALUES(26,'LIB010',1222,TO_DATE('15-12-2021', 'DD-MM-YYYY'),NULL); 
INSERT INTO loan VALUES(27,'LIB010',1223,TO_DATE('15-12-2021', 'DD-MM-YYYY'),NULL); 
 
INSERT INTO loan VALUES(28,'LIB001',1103,TO_DATE('15-12-2021', 'DD-MM-YYYY'),NULL); 
 
 
 
 