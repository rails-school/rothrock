class SettingsController extends BaseController
  constructor: (app) ->
    super app

  onStart: () ->

  onResume: () ->
    $('.navbar').removeClass('hidden')