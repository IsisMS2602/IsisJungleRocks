# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

# ignore all warnings from all pods
inhibit_all_warnings!

target 'IsisJungleRocks' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for IsisJungleRocks
  pod 'Alamofire', '~> 4.8.2'
  pod 'RxCocoa', '~> 5.1.0'
  pod 'RxSwift', '~> 5.1.0'
  pod 'SwiftLint', '~> 0.31.0'
  pod 'SVProgressHUD'
  pod 'Kingfisher'
  pod 'AlamofireNetworkActivityLogger', '~> 2.4', :configurations => ['staging debug', 'production debug']
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
end
