# venues.coffee

Meteor.subscribe("all_venues");
Meteor.subscribe("all_stats");
Session.set 'venue_id', null

Venues = new Meteor.Collection("venues")
Statistics = new Meteor.Collection("statistics")

###
HELPERS
###

now = () ->
  Math.round((new Date()).getTime() / 1000)

popularity_sort = (a,b) ->
  a_percent = (100.0 * a.occupancy / a.capacity )
  b_percent = (100.0 * b.occupancy / b.capacity )

  return -1 if a_percent > b_percent
  return 1 if a_percent < b_percent

  # if percentages are matched, compare on queue
  return -1 if a.waiting > b.waiting
  return 1 if a.waiting < b.waiting

  0

venue_link_mouse_down = (evt) ->
  Session.set 'venue_id', this._id
  Router.setVenue(this._id)

venue_link_click = (evt) ->
  evt.preventDefault()

venue_link_event_options =
  'mousedown a.venue-name': venue_link_mouse_down
  'click a.venue-name': venue_link_click

merge_in_stats = (venue)->
  asdf = Stats_compiled.find({_id: venue.name}).fetch()
  # docs = asdf.toArray() if asdf
  # keys = (key for key,value of asdf[0])
  if asdf[0]
    trend = asdf[0].value
    this_trend = "none"
    this_trend = "angle-up" if trend > 0.2
    this_trend = "double-angle-up" if trend > 0.6
    this_trend = "angle-down" if trend < -0.2
    this_trend = "double-angle-down" if trend < -0.6
    venue.trend = this_trend
  venue

Template.top_three.hot = () ->
  venues = Venues.find({}).fetch()
  venues.sort popularity_sort
  venues = (merge_in_stats venue for venue in venues)

Template.top_three.has_line = () ->
  return true if this.waiting > 0
  false


Template.top_three.percent_full = () ->
  Math.round(this.occupancy / this.capacity * 100)

Template.top_three.has_line = () ->
	return true if this.waiting > 0
	false

# Template.top_three.events = venue_link_event_options

###
DETAILS
###

Template.details.venues = () ->
  venue_id = Session.get('venue_id')
  Venues.find({_id: venue_id}, {sort: {name: 1}})



# TODO: this is used earlier and probably should live on the model
Template.details.percent_full = () ->
  Math.round(100 * this.occupancy / this.capacity )

foo = () ->
  percent = Math.round(this.occupancy / this.capacity * 100)
  return "critical" if percent >= 100
  return "full" if percent >= 75
  return "half-full" if percent >= 50
  "empty"


Template.top_three.percent_class = foo
Template.details.percent_class = foo

Template.details.over_capacity = () ->
  this.occupancy / this.capacity >= 1

decrement_numbers = (by_this_much = 1) ->
  (evt) ->
    evt.preventDefault()
    # update model
    venue_id = Session.get('venue_id')
    venue = Venues.findOne venue_id

    new_waiting = venue.waiting
    new_occupancy = venue.occupancy
    new_flux =  Math.abs(by_this_much)

    if venue.waiting > by_this_much
      new_waiting -= by_this_much
      new_occupancy = venue.capacity


    if venue.waiting < by_this_much
      new_waiting = 0
      new_occupancy -= (by_this_much - venue.waiting)

    if venue.waiting is by_this_much
      new_waiting = 0
      new_occupancy = venue.capacity

    if new_occupancy < 0
      new_occupancy = 0
      new_flux = 0
    venue.waiting = new_waiting
    venue.occupancy = new_occupancy


    venue.updated_at = now()
    venue.flux += new_flux
    Statistics.insert
      "venue": venue.name
      "venue_id": venue_id
      "change": 0 - by_this_much
      "occupancy": venue.occupancy
      "capacity": venue.capacity
      "waiting":  venue.waiting
      "reported_at": now()
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
      venue.waiting += shift
    venue.waiting -= 1 if shift is 0
    venue.updated_at = now()
    venue.flux += Math.abs(shift)

    Statistics.insert
      "venue": venue.name
      "venue_id": venue_id
      "change": shift
      "occupancy": venue.occupancy
      "capacity": venue.capacity
      "waiting":  venue.waiting
      "reported_at": now()
    Venues.update venue_id, venue

in_n_out = ()->
  (evt)->
    # evt.preventDefault()
    decrement_numbers(1)(evt)
    increment_numbers(1)(evt)


Template.details.events
  'click a.add-one': increment_numbers(1)
  'click a.sub-one': decrement_numbers()
  'click a.recycle.js-in-n-out': in_n_out()

  'click a.add-five': increment_numbers(5)
  'click a.sub-five': decrement_numbers(5)
