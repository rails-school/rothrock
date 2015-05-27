class ClassDetails extends BaseController
    constructor: (app) ->
        super app

        @blockSelector = '.js-class-details'
        @attendanceToggle = $('.js-toggle-attendance')
        @toolbar = $('.toolbar')

        @attendanceToggle.on 'click', () =>
            if @canIToggleAttendance
                @getBus().post 'UpdateAttendance', @isAttending
            else
                @getBus().post 'UnableToToggleAttendance'

        @getBus().register "DisplayClassDetails", (name, data) =>
            @_setContent data

        @getBus().register "CanIToggleAttendance", (name, data) =>
            @canIToggleAttendance = data
            @attendanceToggle.text 'RSVP!'
            @toolbar.addClass 'unsigned'

        @getBus().register "SetAttendance", (name, data) =>
            @isAttending = data
            @toolbar.removeClass 'unsigned'
            if @isAttending
                @attendanceToggle.text 'unRSVP'
                @toolbar.addClass 'attending'
            else
                @attendanceToggle.text 'RSVP!'
                @toolbar.removeClass 'attending'

    _setContent: (data) ->
        @fork()

        @toolbar.show()

        @template = Template7.compile($('#class-details-template').html()) unless @template?
        data.teacher.gravatar = "http://www.gravatar.com/avatar/#{md5(data.teacher.email)}"

        attendees = data.schoolClass.students
        if attendees > 1
            attendees = "#{attendees} students will attend this class"
        else if attendees == 1
            attendees = "1 student will attend this class"
        else
            attendees = "Be the first to join this class!"

        data.schoolClass.attendees = attendees
        $(@blockSelector).html(@template({ data: data }))

        $(@blockSelector).find('.js-class-details-map').on 'click', () =>
            @getBus().post "RequestClassDetailsMap"

        @done()