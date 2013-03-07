# google_analytics.coffee
# #

Template.google_analytics.rendered = () ->
  _gaq = _gaq or []
  _gaq.push ["_setAccount", "UA-39061418-1"]
  _gaq.push ["_trackPageview"]
  (->
    ga = document.createElement("script")
    ga.type = "text/javascript"
    ga.async = true
    ga.src = ((if "https:" is document.location.protocol then "https://ssl" else "http://www")) + ".google-analytics.com/ga.js"
    s = document.getElementsByTagName("script")[0]
    s.parentNode.insertBefore ga, s
  )()
