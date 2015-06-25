class ClassListController extends BaseController
  constructor: (app) ->
    super app
    @listSelector = '.js-class-list'

    @logoSelector = '.js-logo'
    @upcomingCounterSelector = '.js-upcoming-classes'

    @settingsSelector = '.js-settings'

    @cardWrapperSelector = '.js-class-card-wrapper'
    @cardSelector = '.js-class-card'
    @goingPinSelector = '.js-class-going-pin'
    @countdownSelector = '.js-class-countdown'
    @rsvpSelector = '.js-class-rsvp-button'
    @shareSelector = '.js-class-share'

  getBus: () ->
    Caravel.get('ClassListController')

  onStart: () ->
    @cardTemplate = Template7.compile($('#class-card-template').html())

    @getBus().register 'ReceiveClasses', (name, data) =>
      @fork()
      $(@upcomingCounterSelector).text("Upcoming Classes: #{data.length}")
      $(@listSelector).html(@cardTemplate({ classes: data }))
      @slider = new Slider
        slideWrapper: $(@listSelector)
        cardWrapperClass: @cardWrapperSelector[1..]
        goingPinClass: @goingPinSelector[1..]
        countdownClass: @countdownSelector[1..]
        cardClass: @cardSelector[1..]
        rsvpClass: @rsvpSelector[1..]
        attendeesClass: 'js-class-attendees'
        shareClass: @shareSelector[1..]
        gutter: 10

      $(@listSelector).find(@cardWrapperSelector).each (i, e) =>
        slug = $(e).data('slug')

        # Trigger insight
        $(e).find(@cardSelector).first().on 'click', () =>
          @getBus().post('TriggerInsight', slug)

        # Trigger share menu
        $(e).find(@shareSelector).first().on 'click', () =>
          new ShareMenu(@getApp(), @getBus(), slug).show()

        # Toggle rsvp
        $(e).find(@rsvpSelector).first().on 'click', () =>
          slug = $(e).data('slug')
          @getBus().post("ToggleAttendance", slug)

      @done()

    $(@settingsSelector).on 'click', () =>
      @getBus().post("TriggerSettings")

    @getBus().register 'ReceiveSchool', (name, data) =>
      if data == "cville"
        $(@logoSelector).attr('src', 'logo-charlottesville.png')
      else
        $(@logoSelector).attr('src', 'logo-sf.png')

  onResume: () ->
    $('.navbar').addClass('hidden')