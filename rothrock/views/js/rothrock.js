var $$, BaseController, ClassListController, SingleClassController, classListController, mainView, myApp, settingsController, singleClassController,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

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
  }

  ClassListController.prototype.getBus = function() {
    return Caravel.get('ClassListController');
  };

  ClassListController.prototype.onResume = function() {
    this.fork();
    if (this.cardTemplate == null) {
      this.cardTemplate = Template7.compile($('#class-card-template').html());
    }
    this.getBus().register('ReceiveClasses', (function(_this) {
      return function(name, data) {
        $(_this.listSelector).html(_this.cardTemplate({
          classes: data
        }));
        return _this.done();
      };
    })(this));
    return this.getBus().register('ReceiveSchool', (function(_this) {
      return function(name, data) {
        if (data === 1) {
          return $(_this.logoSelector).attr('src', 'logo-charlottesville.png');
        } else {
          return $(_this.logoSelector).attr('src', 'logo-sf.png');
        }
      };
    })(this));
  };

  return ClassListController;

})(BaseController);

myApp = new Framework7();

$$ = Dom7;

mainView = myApp.addView('.view-main', {
  dynamicNavbar: true
});

classListController = new ClassListController(myApp);

singleClassController = new SingleClassController(myApp);

settingsController = new SettingsController(myApp);

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
