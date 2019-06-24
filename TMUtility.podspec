#
# Be sure to run `pod lib lint BZUtility.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TMUtility'
  s.version          = '1.0'
  s.summary          = 'An iOS utility library.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = 'This library contains some utility tools, such as FileManager, KVO Receptionist,
                        DeviceInfo.'

  s.homepage         = 'https://github.com/Tovema-iOS/TMUtility'
  s.license          = 'MIT'
  s.author           = { 'CodingPub' => 'lxb_0605@qq.com' }
  s.source           = { :git => 'https://github.com/Tovema-iOS/TMUtility.git', :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.default_subspec = 'Core'

  s.subspec 'Core' do |ss|
    ss.source_files = 'Pod/Classes/Core/**/*'

    ss.dependency 'GBDeviceInfo'
  end

  s.subspec 'ThreadSafeArray' do |ss|
    ss.source_files = 'Pod/Classes/ThreadSafeArray/*'
    ss.dependency 'YYModel', '~> 1.0'
  end

  s.subspec 'NSObject+Plist' do |ss|
    ss.source_files = 'Pod/Classes/NSObject+Plist/*'
    ss.dependency 'YYModel', '~> 1.0'
  end

end
