myApp = new Framework7()

$$ = Dom7

mainView = myApp.addView '.view-main', {
  dynamicNavbar: true
}

classListController = new ClassListController myApp
settingsController = null

myApp.onPageBeforeInit 'settings', (page) =>
  classListController.onPause()
  if not settingsController?
    settingsController = new SettingsController myApp
    Caravel.getDefault().post("StartingSettingsController")
    settingsController.onStart()

  Caravel.getDefault().post("ResumingSettingsController")
  settingsController.onResume()

myApp.onPageBack 'settings', (page) =>
  Caravel.getDefault().post("PausingSettingsController")
  settingsController.onPause()
  Caravel.getDefault().post("ResumingClassListController")
  classListController.onResume()

Caravel.getDefault().post("StartingClassListController")
classListController.onStart()
Caravel.getDefault().post("ResumingClassListController")
classListController.onResume()