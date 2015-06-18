class BaseController
  constructor: (app) ->
    @app = app
    @bus = Caravel.getDefault()

  getDefaultBus: () ->
    @bus

  getApp: () ->
    @app

  onStart: () ->

  onResume: () ->

  onPause: () ->

  fork: () ->
    @bus.post "ProgressForkEvent"

  done: () ->
    @bus.post "ProgressDoneEvent"