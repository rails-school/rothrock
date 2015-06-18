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
          @getApp().actions [
                              {
                                text: 'Text'
                                onClick: () =>
                                  @getBus().post('TriggerShareText', slug)
                              },
                              {
                                text: 'Email'
                                onClick: () =>
                                  @getBus().post('TriggerShareEmail', slug)
                              },
                              {
                                text: 'Facebook'
                                onClick: () =>
                                  @getBus().post('TriggerShareFacebook', slug)
                              },
                              {
                                text: 'Twitter',
                                onClick: () =>
                                  @getBus().post('TriggerShareTwitter', slug)
                              },
                              {
                                text: 'Cancel',
                                color: 'red'
                              }
                            ]

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

    @getBus().register "SetAttendance", (name, data) =>
      isAttending = data.isAttending
      cardWrapper = $(@listSelector).find("#{@cardWrapperSelector}[data-slug='#{data.slug}']").first()

      rsvpButton = cardWrapper.find(@rsvpSelector).first()
      if isAttending
        rsvpButton.addClass('unrsvp')
        rsvpButton.text('unRSVP')
      else
        rsvpButton.removeClass('unrsvp')
        rsvpButton.text('RSVP')

      goingPin = cardWrapper.find(@goingPinSelector).first()
      countdown = cardWrapper.find(@countdownSelector).first()
      if isAttending
        goingPin.removeClass('invisible')
        countdown.addClass('going')
      else
        goingPin.addClass('visible')
        countdown.removeClass('going')

  onResume: () ->
    $('.navbar').addClass('hidden')