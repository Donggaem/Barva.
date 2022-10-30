# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Barva.' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Barva.
pod 'Alamofire'
pod 'IQKeyboardManagerSwift'
pod 'SnapKit'
pod 'Tabman'
pod 'Pageboy'
pod 'FSPagerView'
pod 'Kingfisher'
pod 'DropDown'
pod 'Gifu'


  # Workaround for Cocoapods issue #7606
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings.delete('CODE_SIGNING_ALLOWED')
      config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
  end
end
