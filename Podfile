# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

def shared_pods_for_target
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxMKMapView'
    pod 'Alamofire'
    pod 'Firebase/Core'
    pod 'Firebase/Database'
end

target 'ShiftLog' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  shared_pods_for_target
  # Pods for ShiftLog

  target 'ShiftLogTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ShiftLogUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
