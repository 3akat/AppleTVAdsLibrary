#
# Be sure to run `pod lib lint ZiggeoMediaSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |spec|
  spec.name             = 'AppleTVAds'
  spec.version          = '0.0.1'
  spec.summary          = 'AppleTVAds'
  spec.description      = 'AppleTV pausable Ads'

  spec.homepage         = 'http://ziggeo.com'
  spec.license          = { :type => 'Confidential',  :text => 'Ziggeo Inc. 2016' }
  spec.author           = { 'Ziggeo Inc' => 'support@ziggeo.com' }
  spec.source           = { :git => 'https://github.com/3akat/AppleTVAdsLibrary.git', :tag => spec.version.to_s }
  
  spec.platform         = :tvos, "16.4"
  spec.dependency       'GoogleAds-IMA-tvOS-SDK', '4.9.2'
  spec.swift_versions   = '4.2'

  spec.tvos.deployment_target  = '16.4'
  spec.vendored_frameworks    = 'AppleTVAds/AppleTVAds.framework'
  spec.source_files = "AppleTVAds/*.*"
end
