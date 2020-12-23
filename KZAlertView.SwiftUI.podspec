Pod::Spec.new do |s|
  s.name             = 'KZAlertView.SwiftUI'
  s.version          = '1.5.0'
  s.summary          = 'KZAlertView, UI基于 FCAlertView'
  
  s.module_name      = 'KZAlertView'
  
  s.description      = <<-DESC
  KZAlertView, UI基于 FCAlertView, 使用Swift 重构 FCAlertView. 适配系统黑暗模式
  DESC
  
  s.homepage         = 'https://github.com/kagenZhao/KZAlertView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '赵国庆' => 'kagen@kagenz.com' }
  s.source           = { :git => 'https://github.com/kagenZhao/KZAlertView.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '13.0'
  
  s.swift_version = '5.0'
  
  s.source_files = 'KZAlertView/Classes/SwiftUI/**/*'
  
  s.resource_bundles = {
    'KZAlertView' => ['KZAlertView/Assets/*.png']
  }
  s.frameworks = 'SwiftUI'
  s.dependency 'Introspect'
end
