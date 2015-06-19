class SettingsController extends BaseController
  constructor: (app) ->
    super app

    @settingsSelector = '.js-settings'

    @emailFieldSelector = '.js-email-field'
    @passwordFieldSelector = '.js-password-field'
    @twoHourDropdownSelector = '.js-2h-reminder'
    @dayDropdownSelector = '.js-24-reminder'
    @newWorkshopSelector = '.js-new-workshop-alert'

    @logOutSelector = '.js-log-out'
    @twitterSelector = '.js-twitter'

  _findEmailField: () ->
    $(@settingsSelector).find(@emailFieldSelector).first()

  _findPasswordField: () ->
    $(@settingsSelector).find(@passwordFieldSelector).first()

  getBus: () ->
    Caravel.get 'SettingsController'

  onStart: () ->
    @getBus().register 'SetSettings', (name, data) =>
      @_findEmailField().val(data.email)
      $(@settingsSelector).find(@twoHourDropdownSelector).first().val(data.twoHourReminder)
      $(@settingsSelector).find(@dayDropdownSelector).first().val(data.dayReminder)
      $(@settingsSelector).find(@newWorkshopSelector).first().prop('checked', data.newLessonAlert)

  onResume: () ->
    $('.navbar').removeClass('hidden')

    $(@settingsSelector).find(@twoHourDropdownSelector).first().on 'change', (e) =>
      @getBus().post('TwoHourReminderNewValue', $(e).val())
    $(@settingsSelector).find(@dayDropdownSelector).first().on 'change', (e) =>
      @getBus().post('DayReminderNewValue', $(e).val())
    $(@settingsSelector).find(@newWorkshopSelector).first().on 'change', (e) =>
      @getBus().post('TwoHourReminderNewValue', $(e).prop('checked'))

    @isEditingCredentials = false
    @_findEmailField().on 'blur', (e) =>
      if @isEditingCredentials
        @isEditingCredentials = false
        @getBus().post('SaveCredentials', { email: $(e).val(), password: @_findPasswordField().val() })
      else
        @isEditingCredentials = true

    @_findPasswordField().on 'blur', (e) =>
      if @isEditingCredentials
        @isEditingCredentials = false
        @getBus().post('SaveCredentials', { email: @_findEmailField().val(), password: $(e).val() })
      else
        @isEditingCredentials = true

    $(@settingsSelector).find(@logOutSelector).first().on 'click', (e) =>
      @getBus().post("LogOut")

    $(@settingsSelector).find(@twitterSelector).first().on 'click', (e) =>
      @getBus().post("Twitter")