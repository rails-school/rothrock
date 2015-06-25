class SingleClassController extends BaseController
  constructor: (app) ->
    super app

    @singleClassSelector = '.js-single-class'

    @sectionSelector = 'section'

    @mapSelector = '.js-map'
    @calendarSelector = '.js-calendar'

    @rsvpButtonSelector = '.js-rsvp-button'
    @shareSelector = '.js-share'
    @closeTriggerSelector = '.js-close-trigger'
    @footerSelector = "#{@singleClassSelector} footer"

  getBus: () ->
    Caravel.get('SingleClassController')

  onStart: () ->
    @template = Template7.compile($("#single-class-template").html())
    @getBus().register "ReceiveClass", (name, data) =>
      @fork()

      $(@singleClassSelector).html(@template(data))
      slug = $(@sectionSelector).data('slug')

      # Set layout
      $(@rsvpButtonSelector).css
        bottom: $(@footerSelector).outerHeight() - $(@rsvpButtonSelector).outerHeight() / 2
        left: ($(@footerSelector).outerWidth() - $(@rsvpButtonSelector).outerWidth()) / 2

      # Set listeners
      $(@mapSelector).on 'click', () =>
        new DeviceInterface(@getBus(), slug).addToMap()

      $(@calendarSelector).on 'click', () =>
        new DeviceInterface(@getBus(), slug).addToCalendar()

      $(@rsvpButtonSelector).on 'click', () =>
        @getBus().post("ToggleAttendance")

      $(@shareSelector).on 'click', () =>
        new ShareMenu(@getApp(), @getBus(), slug).show()

      $(@closeTriggerSelector).on 'click', () =>
        @getBus().post('CloseInsight')

      @done()