class ClassListController extends BaseController
  constructor: (app) ->
    super app
    @listSelector = '.js-class-list'
    @upcomingCounterSelector = '.js-upcoming-classes'
    @logoSelector = '.js-logo'

  getBus: () ->
    Caravel.get('ClassListController')

  onStart: () ->
    @cardTemplate = Template7.compile($('#class-card-template').html())

    @getBus().register 'ReceiveClasses', (name, data) =>
      @fork()
      $(@upcomingCounterSelector).text("Upcoming Classes: #{data.length}")
      $(@listSelector).html(@cardTemplate({ classes: data }))
      new Slider
        slideWrapper: $(@listSelector)
        cardWrapperClass: 'js-class-card-wrapper'
        goingPinClass: 'js-class-going-pin'
        countdownClass: 'js-class-countdown'
        cardClass: 'js-class-card'
        rsvpClass: 'js-class-rsvp-button'
        attendeesClass: 'js-class-attendees'
        shareClass: 'js-class-share'
        gutter: 10
      @done()

    @getBus().register 'ReceiveSchool', (name, data) =>
      if data == "cville"
        $(@logoSelector).attr('src', 'logo-charlottesville.png')
      else
        $(@logoSelector).attr('src', 'logo-sf.png')


