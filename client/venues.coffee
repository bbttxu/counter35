# venues.coffee

Session.set 'venue_id', null

Venues = new Meteor.Collection("venues")

Template.venues.venues = () ->
	Venues.find({}, {sort: {name: 1}})

Template.venues.percent_full = () ->
	Math.round(this.occupancy / this.capacity * 100)

Template.venues.events
	'mousedown .venue': (evt) ->
		Session.set 'venue_id', this._id
		Router.setVenue(this._id)
	'click .venue': (evt) ->
		evt.preventDefault()

Template.details.venues = () ->
	venue_id = Session.get('venue_id')
	Venues.find({_id: venue_id}, {sort: {name: 1}})		

# TODO: this is used earlier and probably should live on the model
Template.details.percent_full = () ->
	Math.round(this.occupancy / this.capacity * 100)




increment_occupancy = (shift) ->
	(evt) ->
		evt.preventDefault()
		venue_id = Session.get('venue_id')
		venue = Venues.findOne venue_id
		venue.occupancy = venue.occupancy + shift
		Venues.update venue_id, venue


increment_counter = increment_occupancy(1)

decrement_counter = increment_occupancy(-1)

Template.details.events
	'click p.add': increment_counter
	'click p.subtract': decrement_counter
		
