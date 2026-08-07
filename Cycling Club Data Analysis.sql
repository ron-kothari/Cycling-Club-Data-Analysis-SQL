-- SECTION 1: CREATE TABLES

-- Create the Club_Member table
CREATE TABLE Club_Member (
    Member_ID INT PRIMARY KEY,
    Name VARCHAR(200) NOT NULL,
    Postcode VARCHAR(20) NOT NULL,
    House_Number VARCHAR(255),
    Ethnicity VARCHAR(255)
);

-- Create the Bike table
CREATE TABLE Bike (
    Bike_ID INT PRIMARY KEY,
    Type VARCHAR(100) NOT NULL,
    Brand VARCHAR(100),
    Wheel_Size DECIMAL(4, 2),
    Member_ID INT,
    FOREIGN KEY (Member_ID) REFERENCES Club_Member(Member_ID) ON DELETE CASCADE
);

-- Create the Track_Time table
CREATE TABLE Track_Time (
    Track_ID INT PRIMARY KEY,
    Member_ID INT,
    Track_Date DATE NOT NULL,
    Track_Time TIME,
    Track_Name VARCHAR(30) NOT NULL,
    Bike_ID INT NOT NULL,
    FOREIGN KEY (Bike_ID) REFERENCES Bike(Bike_ID) ON DELETE CASCADE,
    FOREIGN KEY (Member_ID) REFERENCES Club_Member(Member_ID)
);

-- Create the Track_Location table
CREATE TABLE Track_Location (
    Track_Name VARCHAR(100) PRIMARY KEY,
    Address_Postcode VARCHAR(20) NOT NULL,
    Contact_Num VARCHAR(20) NOT NULL,
    Track_Length DECIMAL(5, 2),
    Terrain_Type VARCHAR(15)
);

-- SECTION 2: INSERT STATEMENTS

-- Insert data into Club_Member table
INSERT INTO Club_Member (Member_ID, Name, Postcode, House_Number, Ethnicity) VALUES
(11234, 'Bob', 'N12LZ', '21', 'White'),
(12234, 'Dylan', 'N31WZ', '26', 'Other'),
-- Add more members here ...

-- Insert data into Bike table
INSERT INTO Bike (Bike_ID, Member_ID, Type, Brand, Wheel_Size) VALUES
(1, 11234, 'MountainBike', 'Carrera', 24.00),
(2, 12234, 'RoadBike', 'Specialized', 20.00),
-- Add more bikes here ...

-- Insert data into Track_Time table
INSERT INTO Track_Time (Track_ID, Member_ID, Track_Date, Track_Time, Track_Name, Bike_ID) VALUES
(1, 11234, '2020-09-14', '00:12:34', 'WoodyRoads', 1),
(2, 12234, '2020-10-12', '00:09:52', 'CityTrack', 2),
-- Add more track times here ...

-- Insert data into Track_Location table
INSERT INTO Track_Location (Track_Name, Address_Postcode, Contact_Num, Track_Length, Terrain_Type) VALUES
('WoodyRoads', 'E37TT', '07964826586', 3.00, 'Forest'),
('CityTrack', 'SW4ER', '07554675468', 2.00, 'Roads'),
-- Add more track locations here ...

-- SECTION 3: UPDATE STATEMENTS

-- Update Bike Type for a specific member
UPDATE Bike
SET Type = 'RoadBike'
WHERE Member_ID = 11234;

-- Update Track Time for a specific member
UPDATE Track_Time
SET Track_Time = '00:10:12'
WHERE Member_ID = 12234;

-- SECTION 4: SINGLE TABLE QUERIES

-- 1) List track times for a specific member (e.g., Jenifer)
SELECT Member_ID, Track_Date, Track_Time
FROM Track_Time
WHERE Member_ID = 12334;

-- 2) List members with above-average track times
SELECT Member_ID, Track_Time
FROM Track_Time
WHERE Track_Time > (SELECT AVG(Track_Time) FROM Track_Time);

-- 3) List members with names starting with 'A'
SELECT Name
FROM Club_Member
WHERE Name LIKE 'A%';

-- 4) Sum of track lengths for 'Roads' terrain, grouped by Track Name
SELECT Track_Name, SUM(Track_Length)
FROM Track_Location
WHERE Terrain_Type = 'Roads'
GROUP BY Track_Name;

-- 5) List tracks used in October 2020
SELECT Track_Name
FROM Track_Time
WHERE Track_Date BETWEEN '2020-10-01' AND '2020-10-31';

-- 6) List bikes with a total wheel size greater than or equal to 24 inches
SELECT Bike_ID, SUM(Wheel_Size) AS Total_Wheel_Size
FROM Bike
GROUP BY Bike_ID
HAVING SUM(Wheel_Size) >= 24.00;

-- SECTION 5: MULTIPLE TABLE QUERIES

-- 1) List member names and ethnicity for those who cycled on 'CityRoads' track
SELECT C.Ethnicity, C.Name
FROM Club_Member C
INNER JOIN Track_Time T ON C.Member_ID = T.Member_ID
WHERE T.Track_Name = 'CityRoads';

-- 2) List member names who have a bike with 24-inch wheels in alphabetical order
SELECT C.Name
FROM Club_Member C
INNER JOIN Bike B ON C.Member_ID = B.Member_ID
WHERE B.Wheel_Size = 24.00
ORDER BY C.Name ASC;

-- 3) List members with track times less than 20 minutes on 'CityRoads'
SELECT C.Name
FROM Club_Member C
INNER JOIN Track_Time T ON C.Member_ID = T.Member_ID
WHERE T.Track_Time <= '00:20:00' AND T.Track_Name = 'CityRoads';

-- 4) List members who use a 'MountainBike'
SELECT C.Name
FROM Club_Member C
WHERE C.Member_ID IN (SELECT B.Member_ID FROM Bike B WHERE B.Type = 'MountainBike');

-- 5) List members who cycled on a 'Forest' terrain track
SELECT C.Name
FROM Club_Member C
INNER JOIN Track_Time T ON C.Member_ID = T.Member_ID
INNER JOIN Track_Location L ON T.Track_Name = L.Track_Name
WHERE L.Terrain_Type = 'Forest';

-- 6) List members who cycled on a 3 km long track
SELECT C.Name
FROM Club_Member C
INNER JOIN Track_Time T ON C.Member_ID = T.Member_ID
INNER JOIN Track_Location L ON T.Track_Name = L.Track_Name
WHERE L.Track_Length = 3.00;

-- SECTION 6: DELETE ROWS

-- Delete a specific member from Club_Member
DELETE FROM Club_Member
WHERE Member_ID = 12344;

-- Delete a specific track location
DELETE FROM Track_Location
WHERE Track_Name = 'InclineCycle';

-- SECTION 7: DROP TABLES

-- Drop tables
DROP TABLE Track_Time;
DROP TABLE Bike;
DROP TABLE Club_Member;
DROP TABLE Track_Location;
