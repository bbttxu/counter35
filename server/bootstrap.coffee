# server.coffee

dons = 
	name: "Don's Silver Beef",
	capacity: 80
	occupancy: 0

harveys =
	name: "Harvey's"
	capacity: 120
	occupancy: 0

kitchenmaid =
	name: "Kitchenmade Rehersal Studios"
	capacity: 100
	occupancy: 0

app_bootstrap = ->
	venues = [dons, harveys, kitchenmaid]
	Venues.insert({name: venue.name, capacity: venue.capacity, occupancy: venue.occupancy}) for venue in venues if Venues.find().count() < 1

Meteor.startup app_bootstrap