/*   Find the names of all students who are friends with someone named Gabriel.*/

Select Name
FROM Highschooler, Friend
WHERE ID=ID1 and ID2 in
(Select ID
FROM Highschooler 
WHERE name = "Gabriel");


/*  For every student who likes someone 2 or more grades younger
 than themselves, return that student's name and grade, and the name and grade of the student they like.*/

Select H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler as H1, Highschooler as H2, Likes as L
WHERE H1.ID=L.ID1 and H2.ID=L.ID2
and H1.GRADE > (H2.GRADE + 1);

/*  For every pair of students who both like each other
, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.*/

SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler as H1, Highschooler as H2, Likes as L1, Likes as L2
WHERE (H1.ID = L1.ID1 AND H2.ID = L1.ID2) AND (H2.ID = L2.ID1 AND H1.ID = L2.ID2) AND H1.name < H2.name;

/*  Find all students who do not appear in the Likes table (as a student who likes or is liked)
 and return their names and grades. Sort by grade, then by name within each grade.*/

SELECT NAME, GRADE
from highschooler where id not in (Select ID1
FROM LIKES UNION SELECT ID2 FROM LIKES);

/*  For every situation where student A likes student B, but we have no information about whom B likes 
(that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.*/

SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler as H1
INNER JOIN LIKES AS L ON H1.ID = L.ID1
INNER JOIN Highschooler as H2 ON H2.ID = L.ID2
WHERE ID2 not in (SELECT ID1 FROM Likes);

/* Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, 
then by name within each grade.*/

SELECT name, grade
FROM Highschooler 
WHERE ID NOT IN 
(
SELECT ID1
FROM Friend, Highschooler as H1, Highschooler as H2
WHERE ID1 = H1.ID and ID2 = H2.ID and H1.Grade != H2.grade
)
ORDER BY grade, name;

/* For each student A who likes a student B where the two are not friends, find if they have a friend C in common 
(who can introduce them!). For all such trios, return the name and grade of A, B, and C. */

SELECT H1.ID, H2.ID
FROM Highschooler as H1, Highschooler as H2, Likes as L
WHERE H1.ID = L.ID1 and H2.ID = L.ID2 and H1.ID NOT IN (
	SELECT ID1 
	FROM Friend
	WHERE H1.ID = ID1 and H2.ID = ID2);

/*  Find the difference between the number of students in the school and the number of different first names. */

SELECT COUNT(ID) - COUNT(DISTINCT(name))
FROM Highschooler;

/*  Find the name and grade of all students who are liked by more than one other student.*/

SELECT name, grade
FROM Highschooler 
WHERE ID in (

SELECT ID2
FROM Likes
GROUP BY ID2
HAVING COUNT(ID1) > 1

);