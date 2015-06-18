var $$, BaseController, ClassListController, SingleClassController, Slider, classListController, mainView, myApp,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Slider = (function() {
  function Slider(options) {
    this.slideWrapper = options.slideWrapper;
    this.cardWrapperClass = options.cardWrapperClass;
    this.goingPinClass = options.goingPinClass;
    this.countdownClass = options.countdownClass;
    this.cardClass = options.cardClass;
    this.rsvpClass = options.rsvpClass;
    this.attendeesClass = options.attendeesClass;
    this.shareClass = options.shareClass;
    this.gutter = options.gutter;
    this.cards = [];
    this.slideWrapper.find("." + this.cardWrapperClass).each((function(_this) {
      return function(i, e) {
        var hammertime, ref;
        _this.cards.push($(e));
        if (i === 0) {
          $(e).css({
            left: 0,
            zIndex: 1
          });
        } else {
          $(e).css({
            left: $(e).width() + _this.gutter,
            zIndex: (ref = i === 1) != null ? ref : {
              2: 1
            }
          });
        }
        _this._setCardDesign($(e));
        hammertime = new Hammer(e);
        hammertime.on('panleft', function(ev) {
          if (i === _this.cards.length - 1) {
            return;
          }
          if (_this.isAnimating) {
            return;
          }
          _this.isAnimating = true;
          _this.cards[i].animate({
            left: -_this.cards[i].width() - _this.gutter
          }, 500);
          _this.cards[i + 1].animate({
            left: 0
          }, 500, null, function(e) {
            $(e).css('z-index', 1);
            return _this.isAnimating = false;
          });
          if (i < _this.cards.length - 2) {
            return _this.cards[i + 2].css('z-index', 2);
          }
        });
        return hammertime.on('panright', function(ev) {
          if (i === 0) {
            return;
          }
          if (_this.isAnimating) {
            return;
          }
          _this.isAnimating = true;
          _this.cards[i].css('z-index', 2);
          if (i < _this.cards.length - 1) {
            _this.cards[i + 1].css('z-index', 1);
          }
          _this.cards[i].animate({
            left: _this.cards[i].width() + _this.gutter
          }, 500);
          return _this.cards[i - 1].animate({
            left: 0
          }, 500, null, function() {
            return _this.isAnimating = false;
          });
        });
      };
    })(this));
  }

  Slider.prototype._setCardDesign = function(wrapper) {
    var attendees, card, cardHeight, cardLeft, cardTop, countdown, pin, rsvp, share;
    pin = wrapper.find("." + this.goingPinClass).first();
    countdown = wrapper.find("." + this.countdownClass).first();
    card = wrapper.find("." + this.cardClass).first();
    rsvp = wrapper.find("." + this.rsvpClass).first();
    attendees = wrapper.find("." + this.attendeesClass).first();
    share = wrapper.find("." + this.shareClass).first();
    pin.css({
      top: 0,
      left: 0
    });
    cardTop = pin.outerHeight(true) / 2;
    cardLeft = pin.outerWidth(true) / 2;
    cardHeight = wrapper.height() - attendees.outerHeight(true) - share.outerHeight(true);
    cardHeight = cardHeight - cardTop - rsvp.outerHeight(true) / 2;
    card.css({
      top: cardTop,
      left: cardLeft,
      width: wrapper.outerWidth() - (pin.outerWidth(true) / 2),
      height: cardHeight
    });
    countdown.css({
      top: card.position().top - countdown.outerHeight(true) + parseInt(countdown.css('border-bottom-width')),
      left: card.position().left
    });
    rsvp.css({
      top: cardTop + cardHeight - rsvp.outerHeight(true) / 2,
      left: (card.outerWidth(true) - rsvp.outerWidth(true)) / 2 + cardLeft
    });
    attendees.css({
      top: card.position().top + card.outerHeight(true) + rsvp.outerHeight(true) / 2,
      left: (card.outerWidth(true) - attendees.outerWidth(true)) / 2 + cardLeft
    });
    return share.css({
      top: attendees.position().top + attendees.outerHeight(true),
      left: (card.outerWidth(true) - share.outerWidth(true)) / 2 + cardLeft
    });
  };

  return Slider;

})();

BaseController = (function() {
  function BaseController(app) {
    this.app = app;
    this.bus = Caravel.getDefault();
  }

  BaseController.prototype.getDefaultBus = function() {
    return this.bus;
  };

  BaseController.prototype.getApp = function() {
    return this.app;
  };

  BaseController.prototype.onStart = function() {};

  BaseController.prototype.onResume = function() {};

  BaseController.prototype.onPause = function() {};

  BaseController.prototype.fork = function() {
    return this.bus.post("ProgressForkEvent");
  };

  BaseController.prototype.done = function() {
    return this.bus.post("ProgressDoneEvent");
  };

  return BaseController;

})();

ClassListController = (function(superClass) {
  extend(ClassListController, superClass);

  function ClassListController(app) {
    ClassListController.__super__.constructor.call(this, app);
    this.listSelector = '.js-class-list';
    this.upcomingCounterSelector = '.js-upcoming-classes';
    this.logoSelector = '.js-logo';
  }

  ClassListController.prototype.getBus = function() {
    return Caravel.get('ClassListController');
  };

  ClassListController.prototype.onStart = function() {
    this.cardTemplate = Template7.compile($('#class-card-template').html());
    this.getBus().register('ReceiveClasses', (function(_this) {
      return function(name, data) {
        _this.fork();
        $(_this.upcomingCounterSelector).text("Upcoming Classes: " + data.length);
        $(_this.listSelector).html(_this.cardTemplate({
          classes: data
        }));
        new Slider({
          slideWrapper: $(_this.listSelector),
          cardWrapperClass: 'js-class-card-wrapper',
          goingPinClass: 'js-class-going-pin',
          countdownClass: 'js-class-countdown',
          cardClass: 'js-class-card',
          rsvpClass: 'js-class-rsvp-button',
          attendeesClass: 'js-class-attendees',
          shareClass: 'js-class-share',
          gutter: 10
        });
        return _this.done();
      };
    })(this));
    return this.getBus().register('ReceiveSchool', (function(_this) {
      return function(name, data) {
        if (data === "cville") {
          return $(_this.logoSelector).attr('src', 'logo-charlottesville.png');
        } else {
          return $(_this.logoSelector).attr('src', 'logo-sf.png');
        }
      };
    })(this));
  };

  return ClassListController;

})(BaseController);

SingleClassController = (function(superClass) {
  extend(SingleClassController, superClass);

  function SingleClassController(app) {
    SingleClassController.__super__.constructor.call(this, app);
    this.blockSelector = '.js-class-details';
    this.attendanceToggle = $('.js-toggle-attendance');
    this.toolbar = $('.toolbar');
    this.attendanceToggle.on('click', (function(_this) {
      return function() {
        if (_this.canIToggleAttendance) {
          return _this.getBus().post('UpdateAttendance', _this.isAttending);
        } else {
          return _this.getBus().post('UnableToToggleAttendance');
        }
      };
    })(this));
    this.getBus().register("DisplayClassDetails", (function(_this) {
      return function(name, data) {
        _this._setContent(data);
        return $('.js-class-details-share').on('click', function() {
          return _this.getApp().actions([
            {
              text: 'Text a friend',
              onClick: function() {
                return _this.getBus().post("ClassDetailsText");
              }
            }, {
              text: 'Email a friend',
              onClick: function() {
                return _this.getBus().post("ClassDetailsEmail");
              }
            }, {
              text: 'Share on Facebook',
              onClick: function() {
                return _this.getBus().post("ClassDetailsFacebook");
              }
            }, {
              text: 'Share on Twitter',
              onClick: function() {
                return _this.getBus().post("ClassDetailsTwitter");
              }
            }, {
              text: 'Cancel',
              color: 'red'
            }
          ]);
        });
      };
    })(this));
    this.getBus().register("CanIToggleAttendance", (function(_this) {
      return function(name, data) {
        _this.canIToggleAttendance = data;
        _this.attendanceToggle.text('RSVP!');
        return _this.toolbar.addClass('unsigned');
      };
    })(this));
    this.getBus().register("SetAttendance", (function(_this) {
      return function(name, data) {
        _this.isAttending = data;
        _this.toolbar.removeClass('unsigned');
        if (_this.isAttending) {
          _this.attendanceToggle.text('unRSVP');
          return _this.toolbar.addClass('attending');
        } else {
          _this.attendanceToggle.text('RSVP!');
          return _this.toolbar.removeClass('attending');
        }
      };
    })(this));
  }

  SingleClassController.prototype._setContent = function(data) {
    var attendees;
    this.fork();
    this.toolbar.show();
    if (this.template == null) {
      this.template = Template7.compile($('#class-details-template').html());
    }
    data.teacher.gravatar = "http://www.gravatar.com/avatar/" + (md5(data.teacher.email));
    attendees = data.schoolClass.students;
    if (attendees > 1) {
      attendees = attendees + " students will attend this class";
    } else if (attendees === 1) {
      attendees = "1 student will attend this class";
    } else {
      attendees = "Be the first to join this class!";
    }
    data.schoolClass.attendees = attendees;
    $(this.blockSelector).html(this.template({
      data: data
    }));
    $(this.blockSelector).find('.js-class-details-map').on('click', (function(_this) {
      return function() {
        return _this.getBus().post("RequestClassDetailsMap");
      };
    })(this));
    $(this.blockSelector).find('.js-class-details-calendar').on('click', (function(_this) {
      return function() {
        return _this.getBus().post("RequestClassDetailsCalendar");
      };
    })(this));
    return this.done();
  };

  return SingleClassController;

})(BaseController);

myApp = new Framework7();

$$ = Dom7;

mainView = myApp.addView('.view-main', {
  dynamicNavbar: true
});

classListController = new ClassListController(myApp);

myApp.onPageBack('single-class', (function(_this) {
  return function(page) {
    singleClassController.onPause();
    return classListController.onResume();
  };
})(this));

myApp.onPageBack('settings', (function(_this) {
  return function(page) {
    settingsController.onPause();
    return classListController.onResume();
  };
})(this));

classListController.onStart();

classListController.onResume();
