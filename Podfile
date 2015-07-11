# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
use_frameworks!

target 'Rails School' do
  pod 'Realm' # Using Realm instead of RealmSwift as there are some Obj-C deps
  pod 'SwiftyJSON'
  pod 'Alamofire'
  pod 'DateTools'
  pod 'SwiftEventBus', :git => 'https://github.com/cesarferreira/SwiftEventBus.git'
  pod 'SCLAlertView', :git => 'https://github.com/vikmeup/SCLAlertView-Swift.git'
  pod 'KVNProgress'
  pod 'Caravel'
  pod 'Regex'
end

target 'Rails SchoolTests', :exclusive => true do
    pod 'Realm/Headers'
end

