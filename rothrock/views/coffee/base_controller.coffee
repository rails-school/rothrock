class BaseController
  constructor: (app) ->
    @app = app
    @bus = Caravel.getDefault()

  getBus: () ->
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