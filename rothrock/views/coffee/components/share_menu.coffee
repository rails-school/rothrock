class ShareMenu
  show: (app, bus, slug) ->
    app.actions [
                  {
                    text: 'Text'
                    onClick: () =>
                      bus.post('TriggerShareText', slug)
                  },
                  {
                    text: 'Email'
                    onClick: () =>
                      bus.post('TriggerShareEmail', slug)
                  },
                  {
                    text: 'Facebook'
                    onClick: () =>
                      bus.post('TriggerShareFacebook', slug)
                  },
                  {
                    text: 'Twitter',
                    onClick: () =>
                      bus.post('TriggerShareTwitter', slug)
                  },
                  {
                    text: 'Cancel',
                    color: 'red'
                  }
                ]