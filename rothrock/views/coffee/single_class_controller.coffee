class SingleClassController extends BaseController
  constructor: (app) ->
    super app

    @rsvpButtonSelector = '.js-rsvp-button'
    @footerSelector = 'footer'

  onStart: () ->

  onResume: () ->
    # Set layout
    $(@rsvpButtonSelector).css
      bottom: $(@footerSelector).outerHeight() + $(@rsvpButtonSelector).outerHeight() / 2
      left: ($(@footerSelector).outerWidth() - $(@rsvpButtonSelector)) / 2