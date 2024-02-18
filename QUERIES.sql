-- HW2
-- Student names:

-- A. 447 different members attended at least one class on January 10th. 
-- How many different members attended at least one class on January 15th?
-- Explanation: We first look at the member ID from the "Member" table.
-- We create a connection between the ID and the MID from the "Attends" table and Attends CID and ID from the "Class" table.
-- We then extract the the date January 15th to get the members that attended at least one class then.

SELECT COUNT(DISTINCT M.ID) AS "Members that attended at least one class on January 15th"
FROM Member M
JOIN Attends A ON M.ID = A.MID
JOIN Class C ON A.CID = C.ID
WHERE EXTRACT(MONTH FROM C.date) = 1 AND EXTRACT(DAY FROM C.date) = 15;


-- B. 4 different class types require more than 20 light dumbbells. 
-- How many class types require more than 20 yoga mats?
-- Explanation: 



-- C. Oh no! Some member hacked the database and is still attending classes but has quit according to the database. 
-- Write a query to reveal their name!
-- Explanation: 


-- D. How many members have a personal trainer with the same first name as themselves, 
-- but have never attended a class that their personal trainer led?
-- Explanation: We first look at the member ID from the "Member" table and create a connection between the IID and the ID from the "Instructor" table
-- We then compare their first names, extracting their first names using SUBSTRING.
-- We then use a subquery to get the classes members attended and personal trainer led and use NOT IN to get the ones that have not attended those.

SELECT COUNT(*) AS "Members"
FROM Member M
JOIN Instructor I ON M.IID = I.ID
WHERE SUBSTRING(M.name, 1, POSITION(' ' IN M.name) - 1) = SUBSTRING(I.name, 1, POSITION(' ' IN I.name) - 1)
AND I.ID NOT IN (
    SELECT DISTINCT C.IID
    FROM Class C 
    JOIN Attends A ON C.ID = A.CID
    JOIN Member M ON A.MID = M.ID
    WHERE C.IID = M.IID
);

-- E. For every class type, return its name and whether it has an average rating higher or equal to 7, or lower than 7, 
-- in a column named "Rating" with values "Good" or "Bad", respectively.
-- Explanation: 



-- F. Out of the members that have not quit, member with ID 6976 has been a customer for the shortest time. 
-- Out of the members that have not quit, return the ID of the member(s) that have been customer(s) for the longest time.
-- Explanation: 


-- G. How many class types have at least one equipment that costs more than 100.000 
-- and at least one other equipment that costs less than 5.000?
-- Explanation: We first look at the "Type" table and create a connection between the ID and the TID from the "Needs" table,
-- and Needs EID and the ID from the "Equipment" table, using aliases to get one instance where the equipment costs more 
-- than 100.000 and one where the equipment costs less than 5.000

SELECT COUNT(*) AS "Class types"
FROM Type T
JOIN Needs N1 ON T.ID = N1.TID
JOIN Needs N2 ON T.ID = N2.TID
JOIN Equipment E1 ON N1.EID = E1.ID AND E1.price > 100000
JOIN Equipment E2 ON N2.EID = E2.ID AND E2.price < 5000
GROUP BY T.ID;

-- H. How many instructors have led a class in all gyms on the same day?
-- Explanation: 




-- I. How many instructors have not led classes of all different class types?
-- Explanation: We first look at the "Instructors" table and check if there exists an ID from the "Type" table
-- where there does not exist a class from the "Class" table of that type that the instructor has led.

SELECT Count(*) AS "Instructors"
FROM Instructor I 
WHERE EXISTS (
    SELECT T.ID
    FROM Type T
    WHERE NOT EXISTS (
        SELECT *
        FROM Class C 
        WHERE C.IID = I.ID
        AND T.ID = C.TID
    )
);



-- J. The class type "Circuit training" has the lowest equipment cost per member, based on full capacity. 
-- Return the name of the class type that has the highest equipment cost per person, based on full capacity.
-- Explanation: We first look at the "Type" table and create a connection between the ID and the TID from the "Needs" table,
-- the Needs EID and the ID from the "Equipment" table, and we get the equipment cost per member by taking the sum of all 
-- equipments for that type multiplied by the quantity, and divide it by the capacity.
-- We then use "HAVING" to check if the cost is greater or equal to all other members total cost using a subquery.

SELECT T1.name AS "Class type with highest equipment cost per person"
FROM Type T1 
JOIN Needs N1 ON T1.ID = N1.TID 
JOIN Equipment E1 ON N1.EID = E1.ID
GROUP BY T1.name, T1.capacity
HAVING SUM(E1.price * N1.quantity) / T1.capacity >= ALL (
    SELECT SUM(E2.price * N2.quantity) / T2.capacity
    FROM Type T2
    JOIN Needs N2 ON T2.ID = N2.TID 
    JOIN Equipment E2 ON N2.EID = E2.ID
    GROUP BY T2.ID, T2.capacity
);

-- K (BONUS). The hacker revealed in query C has left a message for the database engineers. This message may save the database!
-- Return the 5th letter of all members that started the gym on December 24th of any year and 
-- have at least 3 different odd numbers in their phone number, in a descending order of their IDs,
-- followed by the 8th letter of all instructors that have not led any "Trampoline Burn" classes, in an ascending order of their IDs.
-- Explanation: 