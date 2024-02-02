#
# Be sure to run `pod lib lint ZiggeoMediaSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |spec|
  spec.name             = 'AppleTVAds'
  spec.version          = '0.0.3'
  spec.summary          = 'AppleTVAds'
  spec.description      = 'AppleTV pausable Ads'

  spec.homepage         = 'http://ziggeo.com'
  spec.license          = { :type => 'Confidential',  :text => 'Ziggeo Inc. 2016' }
  spec.author           = { 'Ziggeo Inc' => 'support@ziggeo.com' }
  spec.source           = { :git => 'https://github.com/3akat/AppleTVAdsLibrary.git', :tag => spec.version.to_s }
  
  spec.platform         = :ios, "11.0"
  spec.dependency       'GoogleAds-IMA-iOS-SDK', '3.19.1'
  spec.swift_versions   = '4.2'

  spec.ios.deployment_target  = '11.0'
  spec.vendored_frameworks    = 'AppleTVAds/AppleTVAds.framework'
  spec.source_files = "AppleTVAds/*.*"
end
