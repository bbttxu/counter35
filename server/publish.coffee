Venues = new Meteor.Collection "venues"
Statistics = new Meteor.Collection "statistics", ()->

Stats_compiled = new Meteor.Collection "stats_compiled"

Meteor.publish "all_venues", ()->
  Venues.find({})

Meteor.publish "all_stats", ()->
  Stats_compiled.find({})