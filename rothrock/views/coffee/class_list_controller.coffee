class ClassListController extends BaseController
  constructor: (app) ->
    super app
    @listSelector = '.js-class-list'
    @logoSelector = '.js-logo'

  getBus: () ->
    Caravel.get('ClassListController')

  onStart: () ->
    @cardTemplate = Template7.compile($('#class-card-template').html())

    @getBus().register 'ReceiveClasses', (name, data) =>
      @fork()
      $(@listSelector).html(@cardTemplate({ classes: data }))
      w = $(@listSelector).width() * 0.9
      console.log w
      $(@listSelector).find('.js-class-card-wrapper').each (i, e) =>
        $(e).css('width', w)
      $(@listSelector).slick({ accessibility: false, edgeFriction: 0.15, infinite: false, variableWidth: true })
      @done()

    @getBus().register 'ReceiveSchool', (name, data) =>
      if data == 1
        $(@logoSelector).attr('src', 'logo-charlottesville.png')
      else
        $(@logoSelector).attr('src', 'logo-sf.png')


