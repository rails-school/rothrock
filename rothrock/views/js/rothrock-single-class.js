var $$, BaseController, ShareMenu, SingleClassController, mainView, myApp, singleClassController,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ShareMenu = (function() {
  function ShareMenu() {}

  ShareMenu.prototype.show = function(app, bus, slug) {
    return app.actions([
      {
        text: 'Text',
        onClick: (function(_this) {
          return function() {
            return bus.post('TriggerShareText', slug);
          };
        })(this)
      }, {
        text: 'Email',
        onClick: (function(_this) {
          return function() {
            return bus.post('TriggerShareEmail', slug);
          };
        })(this)
      }, {
        text: 'Facebook',
        onClick: (function(_this) {
          return function() {
            return bus.post('TriggerShareFacebook', slug);
          };
        })(this)
      }, {
        text: 'Twitter',
        onClick: (function(_this) {
          return function() {
            return bus.post('TriggerShareTwitter', slug);
          };
        })(this)
      }, {
        text: 'Cancel',
        color: 'red'
      }
    ]);
  };

  return ShareMenu;

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

SingleClassController = (function(superClass) {
  extend(SingleClassController, superClass);

  function SingleClassController(app) {
    SingleClassController.__super__.constructor.call(this, app);
    this.singleClassSelector = '.js-single-class';
    this.sectionSelector = 'section';
    this.rsvpButtonSelector = '.js-rsvp-button';
    this.shareSelector = '.js-share';
    this.closeTriggerSelector = '.js-close-trigger';
    this.footerSelector = this.singleClassSelector + " footer";
  }

  SingleClassController.prototype.getBus = function() {
    return Caravel.get('SingleClassController');
  };

  SingleClassController.prototype.onStart = function() {
    this.template = Template7.compile($("#single-class-template").html());
    return this.getBus().register("ReceiveClass", (function(_this) {
      return function(name, data) {
        _this.fork();
        $(_this.singleClassSelector).html(_this.template(data));
        $(_this.rsvpButtonSelector).css({
          bottom: $(_this.footerSelector).outerHeight() - $(_this.rsvpButtonSelector).outerHeight() / 2,
          left: ($(_this.footerSelector).outerWidth() - $(_this.rsvpButtonSelector).outerWidth()) / 2
        });
        $(_this.rsvpButtonSelector).on('click', function() {
          return _this.getBus().post("ToggleAttendance");
        });
        $(_this.shareSelector).on('click', function() {
          return new ShareMenu().show(_this.getApp(), _this.getBus(), $(_this.sectionSelector).data('slug'));
        });
        $(_this.closeTriggerSelector).on('click', function() {
          return _this.getBus().post('CloseInsight');
        });
        return _this.done();
      };
    })(this));
  };

  return SingleClassController;

})(BaseController);

myApp = new Framework7();

$$ = Dom7;

mainView = myApp.addView('.view-main', {
  dynamicNavbar: true
});

singleClassController = new SingleClassController(myApp);

singleClassController.onStart();

singleClassController.onResume();
