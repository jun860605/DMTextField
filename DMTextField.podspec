Pod::Spec.new do |s|
  s.name         = "DMTextField"
  s.version      = "0.0.2"
  s.summary      = "A textfield for daima"
  s.description  = <<-DESC
                        A textfield that contain cancle button and done button
                   DESC

  s.homepage     = "https://github.com/jun860605/DMTextField"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "郑军" => "junzheng3@creditease.cn" }
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/jun860605/DMTextField.git", :tag => s.version }
  s.source_files  = "Classes/*.{h,m}"
end
