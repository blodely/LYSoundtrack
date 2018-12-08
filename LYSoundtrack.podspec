# Created by Luo Yu(blodely, indie.luo@gmail.com)
# Friday, December 7, 2018

Pod::Spec.new do |s|
	s.name             = 'LYSoundtrack'
	s.version          = '1.0.0'
	s.summary          = 'LYSoundtrack lib.'

	s.description      = <<-DESC
LYSoundtrack library.
Sound visual lib.
                       DESC

	s.homepage         = 'https://github.com/blodely/LYSoundtrack'
	# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
	s.license          = { :type => 'MIT', :file => 'LICENSE' }
	s.author           = { 'Luo Yu(blodely)' => 'indie.luo@gmail.com' }
	s.source           = { :git => 'https://github.com/blodely/LYSoundtrack.git', :tag => s.version.to_s }
	s.social_media_url = 'https://weibo.com/blodely'

	s.ios.deployment_target = '8.0'

	s.source_files = 'LYSoundtrack/Classes/range_slider/*', 'LYSoundtrack/Classes/*'
  
	# s.resource_bundles = {
	#   'LYSoundtrack' => ['LYSoundtrack/Assets/*.png']
	# }

	# s.public_header_files = 'Pod/Classes/**/*.h'
  
	s.frameworks = 'UIKit', 'AVFoundation'
	
	s.dependency 'LYCategory'
	s.dependency 'Masonry'
	s.dependency 'EZAudio'
	
end
