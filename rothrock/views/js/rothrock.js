var BaseController;

BaseController = (function() {
  function BaseController(app) {
    this.app = app;
    this.bus = Caravel.getDefault();
  }

  BaseController.prototype.getBus = function() {
    return this.bus;
  };

  BaseController.prototype.getApp = function() {
    return this.app;
  };

  BaseController.prototype.fork = function() {
    return this.bus.post("ProgressForkEvent");
  };

  BaseController.prototype.done = function() {
    return this.bus.post("ProgressDoneEvent");
  };

  return BaseController;

})();

var ClassDetails,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ClassDetails = (function(superClass) {
  extend(ClassDetails, superClass);

  function ClassDetails(app) {
    ClassDetails.__super__.constructor.call(this, app);
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
        return _this._setContent(data);
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

  ClassDetails.prototype._setContent = function(data) {
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
    return this.done();
  };

  return ClassDetails;

})(BaseController);

var ClassList,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ClassList = (function(superClass) {
  extend(ClassList, superClass);

  function ClassList(app) {
    ClassList.__super__.constructor.call(this, app);
    this.listSelector = '.js-class-list';
    $('.toolbar').hide();
    this.getBus().register("DisplayClassList", (function(_this) {
      return function(name, data) {
        _this._setContent(data);
        return $(_this.listSelector).on('refresh', function() {
          return _this.bus.post("AskForRefreshingClassList");
        });
      };
    })(this));
    this.getBus().register("RefreshClassList", (function(_this) {
      return function(name, data) {
        _this._setContent(data);
        return _this.getApp.pullToRefreshDone();
      };
    })(this));
  }

  ClassList.prototype.onBack = function() {
    return $('.toolbar').hide();
  };

  ClassList.prototype._setContent = function(data) {
    this.fork();
    $(this.listSelector).find('li.card').each((function(_this) {
      return function(i, e) {
        return $(e).off('click');
      };
    })(this));
    if (this.template == null) {
      this.template = Template7.compile($('#class-list-template').html());
    }
    $(this.listSelector).html(this.template({
      tuples: data
    }));
    $(this.listSelector).find('li.card').each((function(_this) {
      return function(index, e) {
        return $(e).on('click', function() {
          return _this.getBus().post('RequireClassDetails', $(e).data('slug'));
        });
      };
    })(this));
    return this.done();
  };

  return ClassList;

})(BaseController);

var $$, classListController, mainView, myApp;

myApp = new Framework7();

$$ = Dom7;

mainView = myApp.addView('.view-main', {
  dynamicNavbar: true
});

classListController = new ClassList(myApp);

myApp.onPageBack('class-details', (function(_this) {
  return function(page) {
    return classListController.onBack();
  };
})(this));

new ClassDetails(myApp);
