class Slider
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
          zIndex: 1
      else
        $(e).css
          left: $(e).width() + @gutter
          zIndex: (i == 1) ? 2: 1

      @_setCardDesign($(e))

      hammertime = new Hammer(e)
      hammertime.on 'panleft', (ev) =>
        return if i == @cards.length - 1
        return if @isAnimating

        @isAnimating = true
        @cards[i].animate { left: -@cards[i].width() - @gutter }, 500
        @cards[i + 1].animate { left: 0 }, 500, null, (e) =>
          $(e).css('z-index', 1)
          @cards[i + 2].css('z-index', 2) if i < @cards.length - 2
          @isAnimating = false

      hammertime.on 'panright', (ev) =>
        return if i == 0
        return if @isAnimating

        @isAnimating = true
        @cards[i].css('z-index', 2)
        @cards[i + 1].css('z-index', 1) if i < @cards.length - 1
        @cards[i].animate { left: @cards[i].width() + @gutter }, 500
        @cards[i - 1].animate { left: 0 }, 500, null, () =>
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
