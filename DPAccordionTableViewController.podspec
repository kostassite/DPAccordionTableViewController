#
# Be sure to run `pod lib lint DPAccordionTableViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DPAccordionTableViewController'
  s.version          = '2.3'
  s.summary          = 'UITableView with Accordion support on sections'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This library allows to have a UITableView that has accordion support and be able to open and close sections.
DESC

  s.homepage         = 'https://github.com/kostassite/DPAccordionTableViewController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kostas Antonopoulos' => 'kostas@devpro.gr' }
  s.source           = { :git => 'https://github.com/kostassite/DPAccordionTableViewController.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'DPAccordionTableViewController/Classes/**/*'
  
  # s.resource_bundles = {
  #   'DPAccordionTableViewController' => ['DPAccordionTableViewController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
