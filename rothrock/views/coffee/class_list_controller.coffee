class ClassListController extends BaseController
  constructor: (app) ->
    super app
    @listSelector = '.js-class-list'
    @logoSelector = '.js-logo'

  getBus: () ->
    Caravel.get('ClassListController')

  onResume: () ->
    @fork()
    @cardTemplate = Template7.compile($('#class-card-template').html()) unless @cardTemplate?

    @getBus().register 'ReceiveClasses', (name, data) =>
      $(@listSelector).html(@cardTemplate({ classes: data }))
      @done()

    @getBus().register 'ReceiveSchool', (name, data) =>
      if data == 1
        $(@logoSelector).attr('src', 'logo-charlottesville.png')
      else
        $(@logoSelector).attr('src', 'logo-sf.png')


