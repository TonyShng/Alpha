source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '13.0'
inhibit_all_warnings!

use_frameworks!

def core_pods
  # Network
  pod 'Moya/RxSwift', '~> 14.0.0'
  # JSON Mapping
  pod 'ObjectMapper', '~> 4.2.0'
  pod 'SwiftyJSON', '~> 5.0.1'
  # Router
  pod 'URLNavigator', '~> 2.3.0'
  # UserDefault
  pod 'SwiftyUserDefaults', '~> 5.3.0'
  # Rx
  pod 'RxCocoa', '~> 5.1.1'
  # Realm
  pod 'RealmSwift', '~> 10.12.0'
end

def ui_pods
  # Auto Layout
  pod 'SnapKit', '~> 5.0.1'
  # Image
  pod 'Kingfisher', '~> 6.0'
  # Toast
  pod 'Toast-Swift', '~> 5.0.1'
  # Presenter
  pod 'SwiftEntryKit', '~> 1.2.7'
  # SkeletonView
  pod 'SkeletonView', '~> 1.24.0'
  # segmentView
  pod 'JXSegmentedView', '~> 1.2.7'
  # EmptyView
  pod 'EmptyKit', '~> 4.2.0'
end

def tool_pods
  # KeyboardManager
  pod 'IQKeyboardManagerSwift', '~> 6.5.6'
  # Lint
  pod 'SwiftLint', '~> 0.43.1', :configurations => ['Debug']
  # FLEX
  pod 'FLEX', '~> 4.5.0', :configurations => ['Debug']
  # Logging
  pod 'CocoaLumberjack/Swift', '~> 3.6.2'
  # Dates
  pod 'SwiftDate', '~> 6.3.1'
  # Download
  pod 'Tiercel', '~> 3.2.2'
  # JS
  pod 'dsBridge', '~> 3.0.6'
  # NetworkReachability
  pod 'ReachabilitySwift', '~> 5.0.0'
  # PhotoBrowser
  pod 'JXPhotoBrowser', '~> 3.1.3'
  # PhotoPicker
  pod 'ZLPhotoBrowser', '~> 4.3.5'
  # Touch Text
  pod 'ActiveLabel', '~> 1.1.0'
  # Refresh Loading
  pod 'ESPullToRefresh', '~> 2.9.3'
  # Memory Leak
  pod 'MLeaksFinder', '~> 1.0.0', :configurations => ['Debug']
  # Ads
  pod 'Google-Mobile-Ads-SDK'
end

target 'AlphaProject' do
  core_pods
  ui_pods
  tool_pods
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      end
    end
  end
end
