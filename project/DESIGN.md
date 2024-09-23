# Design Document

By Diogo Fonseca

Video overview: <TODO>

## Scope

In this section you should answer the following questions:

* What is the purpose of my database?
My data base is a transports company that doesn't own any vehicles themselfs rather they outsource them, so they need to keep track of the clients,the owners, the drivers and the vehicles. The purpose of this database is for the company keep data on of all the previous factors, so they can handle statistics based on the classifications from the clients, recomend a driver based on the data of the vehicle a driver is using there classifications and there location.


## Functional Requirements

In this section you should answer the following questions:

* What should a user be able to do with your database?
The user(the company), can track classifications from a given trip, check the best driver based on classifications, check the driver who was on a certain trip, see what are the vehicle info and the owners and so on.

## Representation

### Entities

In this section you should answer the following questions:

* Which entities did I choose to represent in your database?
* What attributes those entities have?
All my entities and there atributes are in the file named "Modelo Relacional"

### Relationships

You can see a diagram of my database in the file named "Modelo EA", there you can see that People have three relations one with vehicles because people in our database can be owners of vehicles, I didn't create here a box saying Owners because that entitie is just a table where I link people with vehicles without any extra info, People have a relation with Driver because People can be a Driver, and a Driver has to be a person in People, People also links to Trips because they can be a client, trips don't need exactly to have clients because in my database you can have trips that are predestinated to happen and clients can join, although not yet implemented on the "queries.sql" file we can add an UPDATE statement on the "clients" table that links a person with a trip making them clients. Now about drivers, a driver is able to drive a car, and in this association between called "able" for lack of a better word we can see the active time a driver is in a vehicle and his location, also a driver is linked in a triple association with vehicles and trips where when is created a trip it's associated with a driver and a vehicle.

## Optimizations

In this section you should answer the following questions:

* Which optimizations did I create? Why?
I created four views one called drivers_info and this has the function of associating drivers table with people table so I can get more details on a driver based on his driver id, another view is called vehicles_and_drivers_trip in this view we get more info on the driver and his car from a certain trip this is useful when we based on a trip id want to see the name and which car was used, last one is the vehicles_owners on this view we can see more info on the vehicle owner and his vehicles based on the owner id this is good when we want to see all the cars owned by a certain person.
I created 9 indexes, 2 on vehicles, 2 on drivers, 1 on trips, 1 on clients, 1 on people, 1 on car_trip_and_driver and 1 one able_driver_index, all of this indexes where made to help speed up the time that takes to execute the queries in "queries.sql" whithout taking to much space on the hardware.


## Limitations

I believe I could have implement better the "id"s on drivers, owners, and clients and make them the person_id to which they are associated freeing some space in the memory, also the queries made can be optimized and could expanded upon.
