# venues.coffee

Session.set 'venue_id', null

Venues = new Meteor.Collection("venues")


popularity_sort = (a,b) ->
	a_percent = (a.occupancy / a.capacity )
	b_percent = (b.occupancy / b.capacity )
	return -1 if a_percent > b_percent
	return 1 if a_percent < b_percent
	0

Template.top_three.hot = () ->
	venues = Venues.find({}, {sort: {name: 1}}).fetch()
	venues.sort( popularity_sort )
	venues.slice(0,3)

Template.top_three.events
	'mousedown a.venue-name': (evt) ->
		Session.set 'venue_id', this._id
		Router.setVenue(this._id)
	'click a.venue-name': (evt) ->
		evt.preventDefault()



Template.top_three.percent_full = () ->
	Math.round(this.occupancy / this.capacity * 100)

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

Template.details.percent_class = () ->
	percent = Math.round(this.occupancy / this.capacity * 100)
	return "critical" if percent >= 100
	return "full" if percent >= 75
	return "half-full" if percent >= 50
	"empty"

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
	'click a.add': increment_counter
	'click a.subtract': decrement_counter
		
