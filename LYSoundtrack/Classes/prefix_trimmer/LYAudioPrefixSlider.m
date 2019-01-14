//
//	LYAudioPrefixSlider.m
//  LYSoundtrack
//
//	CREATED BY LUO YU ON 2019-01-14.
//	COPYRIGHT © 2018-2019 LUO YU <INDIE.LUO@GMAIL.COM>. ALL RIGHTS RESERVED.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "LYAudioPrefixSlider.h"
#import <LYSoundtrack/LYSoundtrack.h>


@implementation LYAudioPrefixSlider

- (instancetype)init {
	if (self = [super init]) {
		_selectedColor = [UIColor orangeColor];
		_color = [UIColor lightGrayColor];
	}
	return self;
}

- (void)setupAudioVisual {
	// SETUP AUDIO VISUAL IMAGES
	[[LYSoundtrack kit] generateAudioAsset:_asset exportSize:_size backgroundColor:_color highlightColor:_selectedColor sliderEqualizerImages:^(UIImage *highlighted, UIImage *background, UIImage *thumb) {
		[self setMinimumTrackImage:[background resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 0)] forState:UIControlStateNormal];
		[self setMaximumTrackImage:[highlighted resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 15)] forState:UIControlStateNormal];
		[self setThumbImage:thumb forState:UIControlStateNormal];
	}];
}

@end
