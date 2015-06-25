class SingleClassController extends BaseController
  constructor: (app) ->
    super app

    @singleClassSelector = '.js-single-class'

    @sectionSelector = 'section'

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

      # Set layout
      $(@rsvpButtonSelector).css
        bottom: $(@footerSelector).outerHeight() - $(@rsvpButtonSelector).outerHeight() / 2
        left: ($(@footerSelector).outerWidth() - $(@rsvpButtonSelector).outerWidth()) / 2

      # Set listeners
      $(@rsvpButtonSelector).on 'click', () =>
        @getBus().post("ToggleAttendance")

      $(@shareSelector).on 'click', () =>
        new ShareMenu().show(@getApp(), @getBus(), $(@sectionSelector).data('slug'))

      $(@closeTriggerSelector).on 'click', () =>
        @getBus().post('CloseInsight')

      @done()