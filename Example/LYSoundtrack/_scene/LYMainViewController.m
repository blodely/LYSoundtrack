//
//  LYMainViewController.m
//  LYSoundtrack
//
//	CREATED BY LUO YU ON 2018-12-07.
//	COPYRIGHT © 2018 LUO YU <INDIE.LUO@GMAIL.COM>. ALL RIGHTS RESERVED.
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

#import "LYMainViewController.h"
#import <LYSoundtrack/LYSoundtrack.h>
#import <Masonry/Masonry.h>
#import <LYCore/LYCore.h>


@interface LYMainViewController () {
	
	__weak LYAudioRangeSlider *slider;
}
@end

@implementation LYMainViewController

- (void)loadView {
	[super loadView];
	
	{
		self.navigationItem.title = @"LYSoundtrack";
	}
	
	{
		LYAudioRangeSlider *view = [[LYAudioRangeSlider alloc] init];
		[self.view addSubview:view];
		slider = view;
		[slider border1Px];
		
		[view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(100);
			make.left.right.equalTo(self.view);
			make.height.mas_equalTo(140);
		}];
		
		UILabel *label = [[UILabel alloc] init];
		label.text = @"Audio Range Slider ↓";
		[self.view addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.equalTo(self->slider.mas_leading).offset(15);
			make.bottom.equalTo(self->slider.mas_top).offset(-5);
		}];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	slider.size = (CGSize){WIDTH, 140};
	slider.asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"20098215197535" ofType:@"mp3"]]];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[slider setupAudioVisual];
}

@end
