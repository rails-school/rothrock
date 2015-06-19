myApp = new Framework7()

$$ = Dom7

mainView = myApp.addView '.view-main', {
  dynamicNavbar: true
}

classListController = new ClassListController myApp
#singleClassController = new SingleClassController myApp
settingsController = null

myApp.onPageBeforeInit 'settings', (page) =>
  classListController.onPause()
  if not settingsController?
    settingsController = new SettingsController myApp
    settingsController.onStart()
  settingsController.onResume()

myApp.onPageBack 'single-class', (page) =>
  singleClassController.onPause()
  classListController.onResume()

myApp.onPageBack 'settings', (page) =>
  settingsController.onPause()
  classListController.onResume()

classListController.onStart()
classListController.onResume()