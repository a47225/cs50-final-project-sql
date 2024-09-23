--Create PEOPLE table
CREATE TABLE "people" (
    "id" INTEGER,
    "niss" INTEGER NOT NULL UNIQUE CHECK("niss">9999999 AND "niss"<100000000),
    "locality" TEXT NOT NULL,
    "street" INTEGER NOT NULL,
    "number" INTEGER,
    "zip_code" TEXT NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "bday" TEXT NOT NULL,
    PRIMARY KEY("id")
);

--Create table Driver
CREATE TABLE "drivers"(
    "id" INTEGER,
    "person_id" INTEGER NOT NULL,
    "drivers_license" INTEGER NOT NULL UNIQUE,
    "cellphone" INTEGER NOT NULL UNIQUE,
    PRIMARY KEY("id"),
    FOREIGN KEY("person_id") REFERENCES "people"("id")
);

--Create table Client
CREATE TABLE "clients"(
    "id" INTEGER,
    "person_id" INTEGER NOT NULL,
    "trip_id" INTEGER NOT NULL,
    "classification" INTEGER NOT NULL DEFAULT(0) CHECK("classification"<6 AND "classifaction">-1),
    PRIMARY KEY("id"),
    FOREIGN KEY("person_id") REFERENCES "people"("id"),
    FOREIGN KEY("trip_id") REFERENCES "trips"("id")
);

--Create table vehicles
CREATE TABLE "vehicles" (
    "id" INTEGER,
    "owner_id" INTEGER NOT NULL,
    "plate" INTEGER NOT NULL UNIQUE,
    "seats" INTEGER NOT NULL CHECK("seats">1 AND "seats"<90),
    "brand" TEXT NOT NULL,
    "model" TEXT NOT NULL,
    "year" INTEGER NOT NULL CHECK("year">1950),
    "price_multiplier" INTEGER NOT NULL,
    "description" TEXT,
    PRIMARY KEY("id"),
    FOREIGN KEY("owner_id") REFERENCES "people"("id")
);

--Create table trips
CREATE TABLE "trips" (
    "id" INTEGER,
    "date" TEXT NOT NULL,
    "start_time" TEXT NOT NULL,
    "end_time" TEXT NOT NULL CHECK("end_time">"start_time"),
    "final_price" NUMERIC NOT NULL,
    "expected_price" NUMERIC NOT NULL,
    "gps_start" TEXT NOT NULL CHECK("gps_start" LIKE '%:%'),
    "gps_end" TEXT NOT NULL CHECK("gps_start" LIKE '%:%'),
    PRIMARY KEY("id")
);

--Create association table between a car a trip and a driver
CREATE TABLE "car_trip_and_driver" (
    "id" INTEGER,
    "driver_id" INTEGER NOT NULL,
    "car_id" INTEGER NOT NULL,
    "trip_id" INTEGER NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("driver_id") REFERENCES "drivers"("id"),
    FOREIGN KEY("trip_id") REFERENCES "trips"("id"),
    FOREIGN KEY("car_id") REFERENCES "vehicles"("id")
);

--Create table able
CREATE TABLE "able" (
    "id" INTEGER,
    "driver_id" INTEGER,
    "car_id" INTEGER,
    "date" TEXT NOT NULL,
    "time_start" TEXT NOT NULL,
    "time_end" TEXT,
    "gps" TEXT NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("driver_id") REFERENCES "drivers"("id"),
    FOREIGN KEY("car_id") REFERENCES "vehicles"("id")
);

--table to regist all the changes on able to keep track
CREATE TABLE "able_logs" (
    "id" INTEGER,
    "type" TEXT NOT NULL,
    "old_date" TEXT,
    "new_date" TEXT,
    "old_driver_id" TEXT,
    "new_driver_id" TEXT,
    "old_car_id" TEXT,
    "new_car_id" TEXT,
    "old_gps" TEXT,
    "new_gps" TEXT,
    PRIMARY KEY("id")
);




--triggers--------------------------------------------

--trigers to when able is changed in any way
--when there is an update to the car_id, driver_id or to the gps signal
CREATE TRIGGER "able_updates"
AFTER UPDATE OF "driver_id", "car_id","gps","date"  ON "able"
FOR EACH ROW
BEGIN
    INSERT INTO "able_logs" ("type","old_date","new_date","old_driver_id","new_driver_id","old_car_id","new_car_id","old_gps","new_gps")
    VALUES ('update',OLD."date",NEW."date", OLD."driver_id", NEW."driver_id", OLD."car_id", NEW."car_id",OLD."gps", NEW."gps");
END;

--When there is an INSERT to the able table
CREATE TRIGGER "able_inserts"
AFTER INSERT ON "able"
FOR EACH ROW
BEGIN
    INSERT INTO "able_logs" ("type","old_date","new_date","old_driver_id","new_driver_id","old_car_id","new_car_id","old_gps","new_gps")
    VALUES ('insert', NULL,NEW."date",NULL, NEW."driver_id", NULL, NEW."car_id",NULL, NEW."gps");
END;

--When there is an DELETE to the able table
CREATE TRIGGER "able_deletes"
AFTER DELETE ON "able"
FOR EACH ROW
BEGIN
    INSERT INTO "able_logs" ("type","old_date","new_date","old_driver_id","new_driver_id","old_car_id","new_car_id","old_gps","new_gps")
    VALUES ('delete', OLD."date",NULL,OLD."driver_id", NULL, OLD."car_id", NULL, NEW."gps", NULL);
END;




--Views-----------------------------------

--View to get detailed info on drivers
CREATE VIEW "drivers_info" AS
SELECT "drivers"."id","first_name", "last_name", "cellphone", "drivers_license" FROM "drivers"
JOIN "people" ON "people"."id" = "drivers"."person_id";

--View to get driver and vehicles from trip
CREATE VIEW "vehicles_and_drivers_trip" AS
SELECT "trip_id","first_name", "last_name", "plate","brand","model","price_multiplier" FROM "drivers_info"
JOIN "car_trip_and_driver" ON "car_trip_and_driver"."driver_id" = "drivers_info"."id"
JOIN "vehicles" ON "car_trip_and_driver"."car_id" = "vehicles"."id";

--View to get the owners of the vehicles
CREATE VIEW "vehicles_owners" AS
SELECT "owner_id", "first_name", "last_name", "plate", "brand", "model" FROM "vehicles"
JOIN "people" ON "vehicles"."owner_id" = "people"."id";


--Indexes-----------------------------------

--Indexes Creation for faster searches on queries
--vehicles indexes
CREATE INDEX "vehicles_plate_index" ON "vehicles"("plate");
CREATE INDEX "vehicles_owner_index" ON "vehicles"("owner_id");

--drivers indexes
CREATE INDEX "drivers_person_index" ON "drivers"("person_id");
CREATE INDEX "drivers_cellphone_index" ON "drivers"("cellphone");

--trips indexes
CREATE INDEX "trips_date_index" ON "trips"("date");

--clients indexes
CREATE INDEX "clients_trip_index" ON "clients"("trip_id");

--people indexes
CREATE INDEX "people_first_name_index" ON "people"("first_name");

--car_trip_and_driver index
CREATE INDEX "cars_trip_index" ON "car_trip_and_driver"("trip_id");

--able index
CREATE INDEX "able_driver_index" ON "able"("driver_id");
