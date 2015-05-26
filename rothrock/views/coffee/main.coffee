myApp = new Framework7()

$$ = Dom7

mainView = myApp.addView '.view-main', {
    dynamicNavbar: true
}

classListController = new ClassList myApp

myApp.onPageBack 'class-details', (page) =>
    classListController.onBack()

new ClassDetails myApp