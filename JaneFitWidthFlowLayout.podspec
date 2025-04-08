Pod::Spec.new do |s|

  s.name         = "JaneFitWidthFlowLayout"
  s.version      = "0.0.1"
  s.summary      = "自适应宽度瀑布流列表布局"
  s.homepage     = "https://github.com/Jane1in99/JaneFitWidthFlowLayout"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "janelin99" => "864927438@qq.com" }

  s.platform     = :ios
  s.ios.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/Jane1in99/JaneFitWidthFlowLayout.git", :tag => "#{s.version}" }

  s.source_files  = "JaneWaterFlowLayout/JaneFitWidthFlowLayout/*.{h,m}"

  s.requires_arc = true

  s.pod_target_xcconfig = {
  'CODE_SIGNING_ALLOWED' => 'NO', 
  'CODE_SIGNING_REQUIRED' => 'NO',
  'ENABLE_BITCODE' => 'NO'
  }

  # 如果是动态框架需要添加
  s.user_target_xcconfig = { 
  'ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES' => '$(inherited)' 
  }

  # 明确声明框架类型
  s.static_framework = true

end
