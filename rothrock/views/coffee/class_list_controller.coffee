class ClassListController extends BaseController
  constructor: (app) ->
    super app
    @listSelector = '.js-class-list'

  getBus: () ->
    Caravel.get('ClassListController')

  onResume: () ->
    @fork()
    @cardTemplate = Template7.compile($('#class-card-template').html()) unless @cardTemplate?

    @getBus().register 'ReceiveClasses', (name, data) =>
      $(@listSelector).html(@cardTemplate({ classes: data }))
      @done()

    @getBus().post('RequireClasses')


