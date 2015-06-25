class DeviceInterface
  constructor: (bus, slug) ->
    @bus = bus
    @slug = slug

  addToCalendar: ->
    @bus.post("AddToCalendar", @slug)

  addToMap: () ->
    @bus.post("AddToMap", @slug)