# server.coffee

andys =
  name: "Andy's",
  capacity: 200
  occupancy: 10

banter =
  name: "Banter"
  capacity: 99
  occupancy: 10

# todo - update burguesa's capacity
burguesa =
  name: "Burguesa"
  capacity: 60
  occupancy: 10

dans =
  name: "Dan's Silverleaf"
  capacity: 230
  occupancy: 10

haileys =
  name: "Hailey's"
  capacity: 400
  occupancy: 10
#  slug: haileys

# todo - update the hive's capacity
thehive =
  name: "The Hive"
  capacity: 992
  occupancy: 10

jandjs =
  name: "J&J's Pizza"
  capacity: 90
  occupancy: 10

thelabb =
  name: "The Labb"
  capacity: 280
  occupancy: 10

mellowmushroom =
  name: "Mellow Mushroom"
  capacity: 300
  occupancy: 10

rubbergloves =
  name: "Rubber Gloves Rehearsal Studios"
  capacity: 230
  occupancy: 10

sweetwater =
  name: "Sweetwater Grill and Bar"
  capacity: 80
  occupancy: 10


app_bootstrap = ->
  venues = [andys, banter, burguesa, dans, haileys, thehive, jandjs, thelabb, mellowmushroom, rubbergloves, sweetwater ]
  Venues.insert({name: venue.name, capacity: venue.capacity, occupancy: venue.occupancy, waiting: 0}) for venue in venues if Venues.find().count() < 1

Meteor.startup app_bootstrap