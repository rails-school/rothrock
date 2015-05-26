class ClassList
    constructor: (app) ->
        @app = app

        Caravel.getDefault().register "DisplayClassList", (name, data) =>
            template = Template7.compile($$('#class-list-template').html())
            $$('.js-class-list').html(template({ tuples: data }))
            #$$('.js-class-list li:first-child hr').css('display', 'visible')
            Caravel.getDefault().post "ProgressDoneEvent"
