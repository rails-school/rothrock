class Slider
  constructor: (options) ->
    @slideWrapper = options.slideWrapper
    @cardWrapperClass = options.cardWrapperClass
    @goingPinClass = options.goingPinClass
    @countdownClass = options.countdownClass
    @cardClass = options.cardClass
    @rsvpClass = options.rsvpClass
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
          left: $(e).width()
          zIndex: (i == 1) ? 2: 1

      #@_setCardDesign($(e))

      hammertime = new Hammer(e)
      hammertime.on 'panleft', (ev) =>
        return if i == @cards.length - 1
        return if @isAnimating

        @isAnimating = true
        @cards[i].animate { left: -@cards[i].width() }, 500
        @cards[i + 1].animate { left: 0 }, 500, null, (e) =>
          $(e).css('z-index', 1)
          @isAnimating = false
        @cards[i + 2].css('z-index', 2) if i < @cards.length - 2

      hammertime.on 'panright', (ev) =>
        return if i == 0
        return if @isAnimating

        @isAnimating = true
        @cards[i].css('z-index', 2)
        @cards[i + 1].css('z-index', 1) if i < @cards.length - 1
        @cards[i].animate { left: @cards[i].width() }, 500
        @cards[i - 1].animate { left: 0 }, 500, null, () =>
          @isAnimating = false

  _setCardDesign: (wrapper) ->
    pin = wrapper.find(".#{@goingPinClass}").get(0)
    countdown = wrapper.find(".#{@countdownClass}").get(0)
    card = wrapper.find(".#{@cardClass}").get(0)
    rsvp = wrapper.find(".#{@rsvpClass}").get(0)
    attendees = wrapper.find(".#{@attendeesClass}").get(0)
    share = wrapper.find(".#{@shareClass}").get(0)

    pin.css
      top: 0
      left: 0

    countdown.css
      top: pin.outerHeight(true) / 2 - countdown.outerHeight(true)
      left: pin.outerWidth(true) / 2

    cardTop = pin.outerHeight(true) / 2
    cardHeight = wrapper.height() - attendees.outerHeight(true) - share.outerHeight(true)
    card.css
      top: cardTop
      left: pin.outerWidth(true) / 2
      height: cardHeight

    rsvp.css
      top: cardTop + cardHeight - rsvp.outerHeight(true) / 2
      left: (wrapper.width() - rsvp.outerWidth(true)) / 2