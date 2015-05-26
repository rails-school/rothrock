class ClassDetails extends BaseController
    constructor: (app) ->
        super app

        @blockSelector = '.js-class-details'

        @getBus().register "DisplayClassDetails", (name, data) =>
            @_setContent data

    _setContent: (data) ->
        @fork()

        $('.toolbar').show()
        $('.toolbar-inner').html('<a href="#" class="link">RSVP!</a>')

        @template = Template7.compile($('#class-details-template').html()) unless @template?
        data.teacher.gravatar = "http://www.gravatar.com/avatar/#{md5(data.teacher.email)}"

        attendees = data.schoolClass.attendees
        if attendees > 1
            attendees = "#{attendees} students will attend this class"
        else if attendees == 1
            attendees = "1 student will attend this class"
        else
            attendees = "Be the first to join this class!"

        data.schoolClass.attendees = attendees
        $(@blockSelector).html(@template({ data: data }))

        @done()