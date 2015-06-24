myApp = new Framework7()

$$ = Dom7

mainView = myApp.addView '.view-main', {
  dynamicNavbar: true
}

singleClassController = new SingleClassController myApp
singleClassController.onStart()
singleClassController.onResume()