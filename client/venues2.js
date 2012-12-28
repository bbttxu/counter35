// I copied/adapted this code and didn't want to convert it to coffeescript

var okCancelEvents = function (selector, callbacks) {
  var ok = callbacks.ok || function () {};
  var cancel = callbacks.cancel || function () {};

  var events = {};
  events['keyup '+selector+', keydown '+selector+', focusout '+selector] =
    function (evt) {
      if (evt.type === "keydown" && evt.which === 27) {
        // escape = cancel
        cancel.call(this, evt);

      } else if (evt.type === "keyup" && evt.which === 13 ||
                 evt.type === "focusout") {
        // blur/return/enter = ok/submit if non-empty
        var value = String(evt.target.value || "");
        if (value)
          ok.call(this, value, evt);
        else
          cancel.call(this, evt);
      }
    };
  return events;
};

// Template.venues.events(okCancelEvents(
//   '#new-venue',
//   {
//     ok: function (text, evt) {
//       var id = Venues.insert({name: text});
//       Router.setVenue(id);
//       evt.target.value = "";
//     }
//   }));

////////// Tracking selected list in URL //////////

var TodosRouter = Backbone.Router.extend({
  routes: {
    ":venue_id": "main"
  },
  main: function (venue_id) {
    Session.set("venue_id", venue_id);
  },
  setVenue: function (venue_id) {
    this.navigate(venue_id, true);
  }
});

Router = new TodosRouter;

Meteor.startup(function () {
  Backbone.history.start({pushState: true});
});