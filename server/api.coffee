# N.B. This is already declared in publish.coffee
# Venues = new Meteor.Collection "venues"

# api_startup = () ->
#   options =
#     # authToken: undefined
#     apiPath: 'api'
#     standAlone: false
#   venueApi = new CollectionAPI(options)
#   venue_api_options =
#     # authToken: undefined
#     methods: ['GET']
#   venueApi.addCollection(Venues, 'venues', venue_api_options)
#   venueApi.start()

# Meteor.startup api_startup
