class SingleClassController extends BaseController
  constructor: (app) ->
    super app

    @singleClassSelector = '.js-single-class'

    @sectionSelector = 'section'

    @rsvpButtonSelector = '.js-rsvp-button'
    @shareSelector = '.js-share'
    @closeTriggerSelector = '.js-close-trigger'
    @footerSelector = 'footer'

  getBus: () ->
    Caravel.get('SingleClassController')

  onStart: () ->
    @template = Template7.compile($("#single-class-template").html())
    @getBus().register "ReceiveClass", (name, data) =>
      @fork()
      $(@singleClassSelector).html(@template(data))

      $(@shareSelector).on 'click', () =>
        new ShareMenu().show(@getApp(), @getBus(), $(@sectionSelector).data('slug'))

      @done()

  onResume: () ->
    # Set layout
    $(@rsvpButtonSelector).css
      bottom: $(@footerSelector).outerHeight() + $(@rsvpButtonSelector).outerHeight() / 2
      left: ($(@footerSelector).outerWidth() - $(@rsvpButtonSelector)) / 2