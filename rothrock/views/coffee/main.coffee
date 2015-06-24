myApp = new Framework7()

$$ = Dom7

mainView = myApp.addView '.view-main', {
  dynamicNavbar: true
}

classListController = new ClassListController myApp
singleClassController = null
settingsController = null

myApp.onPageBeforeInit 'settings', (page) =>
  classListController.onPause()
  if not settingsController?
    settingsController = new SettingsController myApp
    Caravel.getDefault().post("StartingSettingsController")
    settingsController.onStart()

  Caravel.getDefault().post("ResumingSettingsController")
  settingsController.onResume()

myApp.onPageBeforeInit 'single-class', (page) =>
  classListController.onPause()
  if not singleClassController?
    singleClassController = new SingleClassController myApp
    Caravel.getDefault().post("StartingSingleClassController")
    singleClassController.onStart()

  Caravel.getDefault().post("ResumingSingleClassController")
  singleClassController.onResume()

myApp.onPageBack 'single-class', (page) =>
  Caravel.getDefault().post("PausingSingleClassController")
  singleClassController.onPause()
  Caravel.getDefault().post("ResumingClassListController")
  classListController.onResume()

myApp.onPageBack 'settings', (page) =>
  Caravel.getDefault().post("PausingSettingsController")
  settingsController.onPause()
  Caravel.getDefault().post("ResumingClassListController")
  classListController.onResume()

Caravel.getDefault().post("StartingClassListController")
classListController.onStart()
Caravel.getDefault().post("ResumingClassListController")
classListController.onResume()