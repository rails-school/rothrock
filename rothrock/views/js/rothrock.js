var ClassList;

ClassList = (function() {
  function ClassList(app) {
    this.app = app;
    Caravel.getDefault().register("DisplayClassList", (function(_this) {
      return function(name, data) {
        var template;
        template = Template7.compile($$('#class-list-template').html());
        $$('.js-class-list').html(template({
          tuples: data
        }));
        return Caravel.getDefault().post("ProgressDoneEvent");
      };
    })(this));
  }

  return ClassList;

})();

var $$, classListController, mainView, myApp;

myApp = new Framework7();

$$ = Dom7;

mainView = myApp.addView('.view-main', {});

classListController = new ClassList(myApp);
