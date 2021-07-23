platform :ios, '9.0'

inhibit_all_warnings!

target 'FUAlgorithmDemo' do
    pod 'SVProgressHUD'
    pod 'Masonry'
#    pod 'Nama'
    pod 'CWLateralSlide', '~> 1.6.3'
    pod 'MJExtension'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
        end
    end
end

