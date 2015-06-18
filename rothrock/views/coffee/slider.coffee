class Slider
  this.ANIMATION_DURATION = 500

  constructor: (options) ->
    @slideWrapper = options.slideWrapper
    @cardWrapperClass = options.cardWrapperClass
    @goingPinClass = options.goingPinClass
    @countdownClass = options.countdownClass
    @cardClass = options.cardClass
    @rsvpClass = options.rsvpClass
    @attendeesClass = options.attendeesClass
    @shareClass = options.shareClass
    @gutter = options.gutter

    @cards = []
    @slideWrapper.find(".#{@cardWrapperClass}").each (i, e) =>
      @cards.push($(e))

      if i == 0
        $(e).css
          left: 0
      else if i == 1
        $(e).css
          left: $(e).width() + @gutter
      else
        $(e).css
          left: ($(e).width() + @gutter) * 2

      @_setCardDesign($(e))

      hammertime = new Hammer.Manager(e)
      hammertime.add(new Hammer.Pan({ event: 'customPanLeft', threshold: 50, direction: Hammer.DIRECTION_LEFT }))
      hammertime.add(new Hammer.Pan({ event: 'customPanRight', threshold: 50, direction: Hammer.DIRECTION_RIGHT }))
      hammertime.on 'customPanLeft', (ev) =>
        return if i == @cards.length - 1
        return if @isAnimating

        @isAnimating = true
        @cards[i].animate { left: -@cards[i].width() - @gutter }, Slider.ANIMATION_DURATION
        @cards[i + 1].animate { left: 0 }, Slider.ANIMATION_DURATION, null, (e) =>
          @isAnimating = false
        if i < @cards.length - 2
          @cards[i + 2].animate { left: $(e).width() + @gutter }, Slider.ANIMATION_DURATION

      hammertime.on 'customPanRight', (ev) =>
        return if i == 0
        return if @isAnimating

        @isAnimating = true
        if i < @cards.length - 1
          @cards[i + 1].animate { left: (@cards[i].width() + @gutter) * 2 }, Slider.ANIMATION_DURATION
        @cards[i].animate { left: @cards[i].width() + @gutter }, Slider.ANIMATION_DURATION
        @cards[i - 1].animate { left: 0 }, Slider.ANIMATION_DURATION, null, () =>
          @isAnimating = false

  _setCardDesign: (wrapper) ->
    pin = wrapper.find(".#{@goingPinClass}").first()
    countdown = wrapper.find(".#{@countdownClass}").first()
    card = wrapper.find(".#{@cardClass}").first()
    rsvp = wrapper.find(".#{@rsvpClass}").first()
    attendees = wrapper.find(".#{@attendeesClass}").first()
    share = wrapper.find(".#{@shareClass}").first()

    pin.css
      top: 0
      left: 0

    cardTop = pin.outerHeight(true) / 2
    cardLeft = pin.outerWidth(true) / 2
    cardHeight = wrapper.height() - attendees.outerHeight(true) - share.outerHeight(true)
    cardHeight = cardHeight - cardTop - rsvp.outerHeight(true) / 2
    card.css
      top: cardTop
      left: cardLeft
      width: wrapper.outerWidth() - (pin.outerWidth(true) / 2)
      height: cardHeight

    countdown.css
      top: card.position().top - countdown.outerHeight(true) + parseInt(countdown.css('border-bottom-width'))
      left: card.position().left

    rsvp.css
      top: cardTop + cardHeight - rsvp.outerHeight(true) / 2
      left: (card.outerWidth(true) - rsvp.outerWidth(true)) / 2 + cardLeft

    attendees.css
      top: card.position().top + card.outerHeight(true) + rsvp.outerHeight(true) / 2
      left: (card.outerWidth(true) - attendees.outerWidth(true)) / 2 + cardLeft

    share.css
      top: attendees.position().top + attendees.outerHeight(true)
      left: (card.outerWidth(true) - share.outerWidth(true)) / 2 + cardLeft
