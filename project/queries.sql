--INSERTS--------------------------------------------------------------------------------------


--Import data from the both csv files clean the data and insert it to the database

.import --csv people.csv people_temp

UPDATE "people_temp"
SET "number" = NULL
WHERE "number" = "";

INSERT INTO "people" ("niss","locality","street","number","zip_code","first_name","last_name","bday")
SELECT "niss","locality","street","number","zip_code","first_name","last_name","bday" FROM "people_temp";


DROP TABLE "people_temp";

.import --csv vehicles.csv vehicles_temp

UPDATE "vehicles_temp"
SET "description" = NULL
WHERE "description" = "";

INSERT INTO "vehicles" ("plate","seats","brand","model","year","price_multiplier","description","owner_id")
SELECT "plate","seats","brand","model","year","price_multiplier","description","owner_id" FROM "vehicles_temp";

DROP TABLE "vehicles_temp";


--Insert the drivers the owners from people
INSERT INTO "drivers" ("person_id","drivers_license","cellphone")
VALUES ("1","093128","910000000");

--Insert trips
INSERT INTO "trips" ("date","start_time","end_time","final_price","expected_price","gps_start","gps_end")
VALUES
("01-01-2024","11:10","11:25","5.50","4.50","0.991029:13.4810284","0.571289:15.123125"),
("01-07-2024","23:00","23:05","1.10","1.10","5.231231:11.3124145","4.231515:11.541256"),
("01-08-2024","10:10","12:00","30.00","23.50","0.991029:13.4810284","0.571289:15.123125");

--Insert clients
INSERT INTO "clients" ("person_id","trip_id","classification")
VALUES ("3","1","5"),("4","2","3"),("5","3","2"),("6","3","5"),("7","2","1"),("8","1","5");

--Insert car trip and driver
INSERT INTO "car_trip_and_driver" ("driver_id","car_id","trip_id")
VALUES ("1","1","1"),("1","1","2"),("1","1","3");

--Insert ables
INSERT INTO "able" ("driver_id","car_id","date","time_start","time_end","gps")
VALUES ("1","1","01-01-2024", "08:00","13:00","0.991029:13.4810284"),("1","1","01-07-2024", "18:00","00:00","5.231231:11.3124145"),("1","1","01-08-2024", "08:00","13:00","0.991029:13.4810284");




--QUERIES-----------------------------------------------------------------------------------------


--Get work periods of driver Diogo Monteiro
SELECT * FROM "able"
WHERE "driver_id" = (
    SELECT "id" FROM "drivers"
    WHERE "person_id" = (
        SELECT "id" FROM "people"
        WHERE "first_name" = 'Diogo' AND "last_name" = 'Monteiro' LIMIT 1
    )
);

--Get vehicle and driver combo from trip with id=2
SELECT * FROM "vehicles_and_drivers_trip"
WHERE "trip_id" = 2;

--Get vehicles owned by Inês Silva
SELECT * FROM "vehicles_owners"
WHERE "first_name" = 'Inês' AND "last_name" = 'Silva';

--Get the average trips classification
SELECT "trip_id", ROUND(AVG("classification"),2) AS "Average Classification",COUNT("classification") AS "Number of Classifications"
FROM "clients"
GROUP BY "trip_id"
ORDER BY "Average Classification" DESC;

--Get drivers info from trip 1
SELECT * FROM "drivers_info"
WHERE "first_name" = (
    SELECT "first_name" FROM "vehicles_and_drivers_trip"
    WHERE "trip_id" = 1
)
AND "last_name" = (
    SELECT "last_name" FROM "vehicles_and_drivers_trip"
    WHERE "trip_id" = 1
) LIMIT 1;

--Get first and last name from driver with best classifications
SELECT "first_name","last_name" from "vehicles_and_drivers_trip"
WHERE "trip_id" = (
    SELECT "trip_id" FROM (
        SELECT "trip_id", ROUND(AVG("classification"),2) AS "Average Classification",COUNT("classification") AS "Number of Classifications"
        FROM "clients"
        GROUP BY "trip_id"
        ORDER BY "Average Classification" DESC
        LIMIT 1
    )
);

--Get trips made on 01-01-2024
SELECT * FROM "trips"
WHERE "date" = '01-01-2024';

