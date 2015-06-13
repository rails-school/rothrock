class ClassListController extends BaseController
  constructor: (app) ->
    super app
    @listSelector = '.js-class-list'

    $('.toolbar').hide()

    @getBus().register "DisplayClassList", (name, data) =>
      @_setContent(data)

      $(@listSelector).on 'refresh', () =>
        @bus.post "AskForRefreshingClassList"

    @getBus().register "RefreshClassList", (name, data) =>
      @_setContent(data)
      @getApp.pullToRefreshDone()

  onBack: () ->
    $('.toolbar').hide()

  _setContent: (data) ->
    @fork()
    $(@listSelector).find('li.card').each (i, e) =>
      $(e).off('click')

    @template = Template7.compile($('#class-list-template').html()) unless @template?
    $(@listSelector).html(@template({ tuples: data }))

    $(@listSelector).find('li.card').each (index, e) =>
      $(e).on 'click', () =>
        @getBus().post 'RequireClassDetails', $(e).data('slug')

    @done()


