var $$, BaseController, ClassListController, SettingsController, SingleClassController, Slider, classListController, mainView, myApp, settingsController, singleClassController,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Slider = (function() {
  Slider.ANIMATION_DURATION = 500;

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
        var hammertime;
        _this.cards.push($(e));
        if (i === 0) {
          $(e).css({
            left: 0
          });
        } else if (i === 1) {
          $(e).css({
            left: $(e).width() + _this.gutter
          });
        } else {
          $(e).css({
            left: ($(e).width() + _this.gutter) * 2
          });
        }
        _this._setCardDesign($(e));
        hammertime = new Hammer.Manager(e);
        hammertime.add(new Hammer.Pan({
          event: 'customPanLeft',
          threshold: 30,
          direction: Hammer.DIRECTION_LEFT
        }));
        hammertime.add(new Hammer.Pan({
          event: 'customPanRight',
          threshold: 30,
          direction: Hammer.DIRECTION_RIGHT
        }));
        hammertime.on('customPanLeft', function(ev) {
          if (i === _this.cards.length - 1) {
            return;
          }
          if (_this.isAnimating) {
            return;
          }
          _this.isAnimating = true;
          _this.cards[i].animate({
            left: -_this.cards[i].width() - _this.gutter
          }, Slider.ANIMATION_DURATION);
          _this.cards[i + 1].animate({
            left: 0
          }, Slider.ANIMATION_DURATION, null, function(e) {
            return _this.isAnimating = false;
          });
          if (i < _this.cards.length - 2) {
            return _this.cards[i + 2].animate({
              left: $(e).width() + _this.gutter
            }, Slider.ANIMATION_DURATION);
          }
        });
        return hammertime.on('customPanRight', function(ev) {
          if (i === 0) {
            return;
          }
          if (_this.isAnimating) {
            return;
          }
          _this.isAnimating = true;
          if (i < _this.cards.length - 1) {
            _this.cards[i + 1].animate({
              left: (_this.cards[i].width() + _this.gutter) * 2
            }, Slider.ANIMATION_DURATION);
          }
          _this.cards[i].animate({
            left: _this.cards[i].width() + _this.gutter
          }, Slider.ANIMATION_DURATION);
          return _this.cards[i - 1].animate({
            left: 0
          }, Slider.ANIMATION_DURATION, null, function() {
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
    this.logoSelector = '.js-logo';
    this.upcomingCounterSelector = '.js-upcoming-classes';
    this.settingsSelector = '.js-settings';
    this.cardWrapperSelector = '.js-class-card-wrapper';
    this.cardSelector = '.js-class-card';
    this.goingPinSelector = '.js-class-going-pin';
    this.countdownSelector = '.js-class-countdown';
    this.rsvpSelector = '.js-class-rsvp-button';
    this.shareSelector = '.js-class-share';
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
        _this.slider = new Slider({
          slideWrapper: $(_this.listSelector),
          cardWrapperClass: _this.cardWrapperSelector.slice(1),
          goingPinClass: _this.goingPinSelector.slice(1),
          countdownClass: _this.countdownSelector.slice(1),
          cardClass: _this.cardSelector.slice(1),
          rsvpClass: _this.rsvpSelector.slice(1),
          attendeesClass: 'js-class-attendees',
          shareClass: _this.shareSelector.slice(1),
          gutter: 10
        });
        $(_this.listSelector).find(_this.cardWrapperSelector).each(function(i, e) {
          var slug;
          slug = $(e).data('slug');
          $(e).find(_this.cardSelector).first().on('click', function() {
            return _this.getBus().post('TriggerInsight', slug);
          });
          $(e).find(_this.shareSelector).first().on('click', function() {
            return _this.getApp().actions([
              {
                text: 'Text',
                onClick: function() {
                  return _this.getBus().post('TriggerShareText', slug);
                }
              }, {
                text: 'Email',
                onClick: function() {
                  return _this.getBus().post('TriggerShareEmail', slug);
                }
              }, {
                text: 'Facebook',
                onClick: function() {
                  return _this.getBus().post('TriggerShareFacebook', slug);
                }
              }, {
                text: 'Twitter',
                onClick: function() {
                  return _this.getBus().post('TriggerShareTwitter', slug);
                }
              }, {
                text: 'Cancel',
                color: 'red'
              }
            ]);
          });
          return $(e).find(_this.rsvpSelector).first().on('click', function() {
            slug = $(e).data('slug');
            return _this.getBus().post("ToggleAttendance", slug);
          });
        });
        return _this.done();
      };
    })(this));
    $(this.settingsSelector).on('click', (function(_this) {
      return function() {
        return _this.getBus().post("TriggerSettings");
      };
    })(this));
    this.getBus().register('ReceiveSchool', (function(_this) {
      return function(name, data) {
        if (data === "cville") {
          return $(_this.logoSelector).attr('src', 'logo-charlottesville.png');
        } else {
          return $(_this.logoSelector).attr('src', 'logo-sf.png');
        }
      };
    })(this));
    return this.getBus().register("SetAttendance", (function(_this) {
      return function(name, data) {
        var cardWrapper, countdown, goingPin, isAttending, rsvpButton;
        isAttending = data.isAttending;
        cardWrapper = $(_this.listSelector).find(_this.cardWrapperSelector + "[data-slug='" + data.slug + "']").first();
        rsvpButton = cardWrapper.find(_this.rsvpSelector).first();
        if (isAttending) {
          rsvpButton.addClass('unrsvp');
          rsvpButton.text('unRSVP');
        } else {
          rsvpButton.removeClass('unrsvp');
          rsvpButton.text('RSVP');
        }
        goingPin = cardWrapper.find(_this.goingPinSelector).first();
        countdown = cardWrapper.find(_this.countdownSelector).first();
        if (isAttending) {
          goingPin.removeClass('invisible');
          return countdown.addClass('going');
        } else {
          goingPin.addClass('invisible');
          return countdown.removeClass('going');
        }
      };
    })(this));
  };

  ClassListController.prototype.onResume = function() {
    return $('.navbar').addClass('hidden');
  };

  return ClassListController;

})(BaseController);

SingleClassController = (function(superClass) {
  extend(SingleClassController, superClass);

  function SingleClassController(app) {
    SingleClassController.__super__.constructor.call(this, app);
    this.rsvpButtonSelector = '.js-rsvp-button';
    this.footerSelector = 'footer';
  }

  SingleClassController.prototype.onStart = function() {};

  SingleClassController.prototype.onResume = function() {
    return $(this.rsvpButtonSelector).css({
      bottom: $(this.footerSelector).outerHeight() + $(this.rsvpButtonSelector).outerHeight() / 2,
      left: ($(this.footerSelector).outerWidth() - $(this.rsvpButtonSelector)) / 2
    });
  };

  return SingleClassController;

})(BaseController);

SettingsController = (function(superClass) {
  extend(SettingsController, superClass);

  function SettingsController(app) {
    SettingsController.__super__.constructor.call(this, app);
    this.settingsSelector = '.js-settings';
    this.emailFieldSelector = '.js-email-field';
    this.passwordFieldSelector = '.js-password-field';
    this.twoHourDropdownSelector = '.js-2h-reminder';
    this.dayDropdownSelector = '.js-24-reminder';
    this.newWorkshopSelector = '.js-new-workshop-alert';
    this.logOutSelector = '.js-log-out';
    this.twitterSelector = '.js-twitter';
  }

  SettingsController.prototype._findEmailField = function() {
    return $(this.settingsSelector).find(this.emailFieldSelector).first();
  };

  SettingsController.prototype._findPasswordField = function() {
    return $(this.settingsSelector).find(this.passwordFieldSelector).first();
  };

  SettingsController.prototype.getBus = function() {
    return Caravel.get('SettingsController');
  };

  SettingsController.prototype.onStart = function() {
    return this.getBus().register('SetSettings', (function(_this) {
      return function(name, data) {
        _this._findEmailField().val(data.email);
        $(_this.settingsSelector).find(_this.twoHourDropdownSelector).first().val(data.twoHourReminder);
        $(_this.settingsSelector).find(_this.dayDropdownSelector).first().val(data.dayReminder);
        return $(_this.settingsSelector).find(_this.newWorkshopSelector).first().prop('checked', data.newLessonAlert);
      };
    })(this));
  };

  SettingsController.prototype.onResume = function() {
    $('.navbar').removeClass('hidden');
    $(this.settingsSelector).find(this.twoHourDropdownSelector).first().on('change', (function(_this) {
      return function(e) {
        return _this.getBus().post('TwoHourReminderNewValue', $(e.target).val());
      };
    })(this));
    $(this.settingsSelector).find(this.dayDropdownSelector).first().on('change', (function(_this) {
      return function(e) {
        return _this.getBus().post('DayReminderNewValue', $(e.target).val());
      };
    })(this));
    $(this.settingsSelector).find(this.newWorkshopSelector).first().on('change', (function(_this) {
      return function(e) {
        return _this.getBus().post('LessonAlertNewValue', $(e.target).prop('checked') ? 1 : 0);
      };
    })(this));
    this.isEditingCredentials = false;
    this._findEmailField().on('blur', (function(_this) {
      return function(e) {
        if (_this.isEditingCredentials) {
          _this.isEditingCredentials = false;
          return _this.getBus().post('SaveCredentials', {
            email: $(e.target).val(),
            password: _this._findPasswordField().val()
          });
        } else {
          return _this.isEditingCredentials = true;
        }
      };
    })(this));
    this._findPasswordField().on('blur', (function(_this) {
      return function(e) {
        if (_this.isEditingCredentials) {
          _this.isEditingCredentials = false;
          return _this.getBus().post('SaveCredentials', {
            email: _this._findEmailField().val(),
            password: $(e.target).val()
          });
        } else {
          return _this.isEditingCredentials = true;
        }
      };
    })(this));
    $(this.settingsSelector).find(this.logOutSelector).first().on('click', (function(_this) {
      return function(e) {
        return _this.getBus().post("LogOut");
      };
    })(this));
    return $(this.settingsSelector).find(this.twitterSelector).first().on('click', (function(_this) {
      return function(e) {
        return _this.getBus().post("Twitter");
      };
    })(this));
  };

  return SettingsController;

})(BaseController);

myApp = new Framework7();

$$ = Dom7;

mainView = myApp.addView('.view-main', {
  dynamicNavbar: true
});

classListController = new ClassListController(myApp);

singleClassController = null;

settingsController = null;

myApp.onPageBeforeInit('settings', (function(_this) {
  return function(page) {
    classListController.onPause();
    if (settingsController == null) {
      settingsController = new SettingsController(myApp);
      Caravel.getDefault().post("StartingSettingsController");
      settingsController.onStart();
    }
    Caravel.getDefault().post("ResumingSettingsController");
    return settingsController.onResume();
  };
})(this));

myApp.onPageBeforeInit('single-class', (function(_this) {
  return function(page) {
    classListController.onPause();
    if (singleClassController == null) {
      singleClassController = new SingleClassController(myApp);
      Caravel.getDefault().post("StartingSingleClassController");
      singleClassController.onStart();
    }
    Caravel.getDefault().post("ResumingSingleClassController");
    return singleClassController.onResume();
  };
})(this));

myApp.onPageBack('single-class', (function(_this) {
  return function(page) {
    Caravel.getDefault().post("PausingSingleClassController");
    singleClassController.onPause();
    Caravel.getDefault().post("ResumingClassListController");
    return classListController.onResume();
  };
})(this));

myApp.onPageBack('settings', (function(_this) {
  return function(page) {
    Caravel.getDefault().post("PausingSettingsController");
    settingsController.onPause();
    Caravel.getDefault().post("ResumingClassListController");
    return classListController.onResume();
  };
})(this));

Caravel.getDefault().post("StartingClassListController");

classListController.onStart();

Caravel.getDefault().post("ResumingClassListController");

classListController.onResume();
