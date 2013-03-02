# server.coffee

dons =
	name: "Don's Silver Beet",
	capacity: 80
	occupancy: 53

harveys =
	name: "Harvey's"
	capacity: 120
	occupancy: 63

kitchenmaid =
	name: "Kitchenmade Rehersal Studios"
	capacity: 100
	occupancy: 23

downtown =
	name: "Downtown Abbey"
	capacity: 60
	occupancy: 43

andrews =
	name: "Andrews"
	capacity: 90
	occupancy: 32

andrews =
	name: "Andrews"
	capacity: 90
	occupancy: 43

kickersdancehall =
	name: "Kickers Dance Hall"
	capacity: 110
	occupancy: 73

app_bootstrap = ->
	venues = [dons, harveys, kitchenmaid, downtown, andrews, kickersdancehall ]
	Venues.insert({name: venue.name, capacity: venue.capacity, occupancy: venue.occupancy}) for venue in venues if Venues.find().count() < 1

Meteor.startup app_bootstrap