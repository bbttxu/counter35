# stats.coffee

Stats_compiled = new Meteor.Collection "stats_compiled"

Template.stats.compiled = ()->
  Stats_compiled.find()