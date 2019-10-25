#
# Be sure to run `pod lib lint sdk-objectmodel-swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'sdk-objectmodel-swift'
  s.version          = '3.0.1'
  s.summary          = 'An implementation of the XYO object model in swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This library is an implementation of the XYO object model in swift and is fully compatible with the XYO Network.
                       DESC

  s.homepage         = 'https://github.com/XYOracleNetwork/sdk-objectmodel-swift'
  s.license          = { :type => 'LGPL3', :file => 'LICENSE' }
  s.author           = { 'Carter Harrison' => 'carter@xyo.network' }
  s.source           = { :git => 'https://github.com/XYOracleNetwork/sdk-objectmodel-swift.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'
  s.source_files = 'sdk-objectmodel-swift/**/*.{swift}'

end
