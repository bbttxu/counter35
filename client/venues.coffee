# venues.coffee

Session.set 'venue_id', null

Venues = new Meteor.Collection("venues")


###
HELPERS
###

now = () ->
	Math.round((new Date()).getTime() / 1000)

popularity_sort = (a,b) ->
	a_percent = (a.occupancy / a.capacity )
	b_percent = (b.occupancy / b.capacity )
	return -1 if a_percent > b_percent
	return 1 if a_percent < b_percent
	0






venue_link_mouse_down = (evt) ->
	Session.set 'venue_id', this._id
	Router.setVenue(this._id)

venue_link_click = (evt) ->
	evt.preventDefault()

venue_link_event_options = 
	'mousedown a.venue-name': venue_link_mouse_down
	'click a.venue-name': venue_link_click

Template.top_three.hot = () ->
	venues = Venues.find({}, {sort: {name: 1}}).fetch()
	# venues.sort popularity_sort
	venues.sort 'waiting'
	venues.slice(0,3)

Template.top_three.events = venue_link_event_options


Template.top_three.percent_full = () ->
	Math.round(this.occupancy / this.capacity * 100)

Template.venues.venues = () ->
	Venues.find({}, {sort: {name: 1}})

Template.venues.percent_full = () ->
	Math.round(this.occupancy / this.capacity * 100)

Template.venues.events = venue_link_event_options




###
DETAILS
###

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

Template.details.over_capacity = () ->
	this.occupancy / this.capacity >= 1.0

decrement_numbers = (shift = 1) -> 
	(evt) ->
		evt.preventDefault()
		# update model
		venue_id = Session.get('venue_id')
		venue = Venues.findOne venue_id
		if venue.waiting > 0
			venue.waiting -= shift
			venue.occupancy = venue.capacity
		else
			venue.waiting = 0
			venue.occupancy -= shift
		venue.updated_at = now()
		Venues.update venue_id, venue

increment_numbers = (shift = 1) ->
	(evt) ->
		evt.preventDefault()
		venue_id = Session.get('venue_id')
		venue = Venues.findOne venue_id
		if venue.occupancy < venue.capacity
			venue.occupancy += shift
			venue.waiting = 0
		else
			venue.occupancy = venue.capacity
			venue.waiting += 1
		venue.waiting -= 1 if shift is 0
		venue.updated_at = now()
		Venues.update venue_id, venue

Template.details.events
	'click a.add.occupancy': increment_numbers(1)
	'click a.subtract.occupancy': decrement_numbers(1)
	'click a.recycle.occupancy': increment_numbers(0)		
	'click a.add.waiting': increment_numbers(1)
	'click a.subtract.waiting': decrement_numbers(1)
