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
      $(@listSelector).find('.js-class-card-wrapper').each (i, e) =>
        $(e).css('width', w)
      new Slider
        slideWrapper: $(@listSelector)
        cardWrapperClass: 'js-class-card-wrapper'
      @done()

    @getBus().register 'ReceiveSchool', (name, data) =>
      if data == 1
        $(@logoSelector).attr('src', 'logo-charlottesville.png')
      else
        $(@logoSelector).attr('src', 'logo-sf.png')


