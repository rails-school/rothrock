class ShareMenu
  constructor: (app, bus, slug) ->
    @app = app
    @bus = bus
    @slug = slug

  show: () ->
    @app.actions [
                   {
                     text: 'Text'
                     onClick: () =>
                       @bus.post('TriggerShareText', @slug)
                   },
                   {
                     text: 'Email'
                     onClick: () =>
                       @bus.post('TriggerShareEmail', @slug)
                   },
                   {
                     text: 'Facebook'
                     onClick: () =>
                       @bus.post('TriggerShareFacebook', @slug)
                   },
                   {
                     text: 'Twitter',
                     onClick: () =>
                       @bus.post('TriggerShareTwitter', @slug)
                   },
                   {
                     text: 'Cancel',
                     color: 'red'
                   }
                 ]