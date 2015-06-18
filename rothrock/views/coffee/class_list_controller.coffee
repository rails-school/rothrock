class ClassListController extends BaseController
  constructor: (app) ->
    super app
    @listSelector = '.js-class-list'

    @logoSelector = '.js-logo'
    @upcomingCounterSelector = '.js-upcoming-classes'

    @settingsSelector = '.js-settings'

    @cardWrapperSelector = '.js-class-card-wrapper'
    @cardSelector = '.js-class-card'
    @shareSelector = '.js-class-share'

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
        cardWrapperClass: @cardWrapperSelector[1..]
        goingPinClass: 'js-class-going-pin'
        countdownClass: 'js-class-countdown'
        cardClass: @cardSelector[1..]
        rsvpClass: 'js-class-rsvp-button'
        attendeesClass: 'js-class-attendees'
        shareClass: @shareSelector[1..]
        gutter: 10

      $(@listSelector).find(@cardWrapperSelector).each (i, e) =>
        slug = $(e).data('slug')
        $(e).find(@cardSelector).first().on 'click', () =>
          @getBus().post('TriggerInsight', slug)
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

      @done()

    $(@settingsSelector).on 'click', () =>
      @getBus().post("TriggerSettings")

    @getBus().register 'ReceiveSchool', (name, data) =>
      if data == "cville"
        $(@logoSelector).attr('src', 'logo-charlottesville.png')
      else
        $(@logoSelector).attr('src', 'logo-sf.png')


