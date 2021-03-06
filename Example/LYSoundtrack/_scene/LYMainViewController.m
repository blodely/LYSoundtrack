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
	__weak UILabel *lblValues;
	
	__weak LYAudioPrefixSlider *trimmer;
	
	__weak LYAudioBeginSelector *selector;
	__weak UILabel *lblSelValues;
	float cursor;
}
@end

@implementation LYMainViewController

// MARK: - ACTION

- (void)updateValues:(id)sender {
	lblValues.text = [NSString stringWithFormat:@"BEGIN=%@ END=%@", @(slider.beginSeconds), @(slider.endSeconds)];
	lblSelValues.text = [NSString stringWithFormat:@"BEGIN=%@ END=%@", @(selector.begin), @(selector.end)];
}

// MARK: - VIEW LIFE CYCLE

- (void)loadView {
	[super loadView];
	
	{
		self.navigationItem.title = @"LYSoundtrack";
	}
	
	{
		LYAudioRangeSlider *view = [[LYAudioRangeSlider alloc] init];
		[self.view addSubview:view];
		slider = view;
		
		[slider addTarget:self action:@selector(updateValues:) forControlEvents:UIControlEventValueChanged];
		
		[view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(100);
			make.left.equalTo(self.view).offset(10);
			make.right.equalTo(self.view).offset(-10);
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
	
	{
		UILabel *label = [[UILabel alloc] init];
		[self.view addSubview:label];
		lblValues = label;
		
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self->slider.mas_bottom).offset(15);
			make.leading.trailing.equalTo(self->slider);
		}];
	}
	
	{
		LYAudioPrefixSlider *view = [[LYAudioPrefixSlider alloc] init];
		[self.view addSubview:view];
		trimmer = view;
		
		[view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self->lblValues.mas_bottom).offset(15);
			make.left.equalTo(self.view).offset(10);
			make.right.equalTo(self.view).offset(-10);
			make.height.mas_equalTo(140);
		}];
	}
	
	{
		LYAudioBeginSelector *view = [[LYAudioBeginSelector alloc] init];
		[self.view addSubview:view];
		selector = view;
		
		[view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self->trimmer.mas_bottom).offset(15);
			make.left.equalTo(self.view);
			make.right.equalTo(self.view);
			make.height.mas_equalTo(100);
		}];
		
//		[selector addTarget:self action:@selector(updateValues:) forControlEvents:UIControlEventValueChanged];
		
		[selector relocatedBeginning:^{
			self->cursor = self->selector.begin;
			[self performSelector:@selector(play) withObject:nil afterDelay:0.1];
		}];
	}
	
	{
		UILabel *label = [[UILabel alloc] init];
		[self.view addSubview:label];
		lblSelValues = label;
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self->selector.mas_bottom).offset(15);
			make.left.equalTo(self.view).offset(15);
		}];
	}
	
	[trimmer border1Px];
	[selector border1Px];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"20098215197535" ofType:@"mp3"]]];

	slider.size = trimmer.size = (CGSize){WIDTH - 20, 140};

	selector.fileDuration = CMTimeGetSeconds(asset.duration);
	selector.size = (CGSize){floor(CMTimeGetSeconds(asset.duration) * (WIDTH / 16.0)), 100};

	slider.asset = trimmer.asset = selector.asset = asset;
	
	slider.minimumRange = 16;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[slider setupAudioVisual];
	[trimmer setupAudioVisual];
	[selector setupAudioVisual];
	[self updateValues:nil];
}

- (void)play {
	
	cursor = cursor + 0.1;
	if (cursor > selector.end) {
		// BREAK
		cursor = selector.begin;
	}
	
	[selector updateCursor:cursor];
	[self performSelector:@selector(play) withObject:nil afterDelay:0.1];
}

@end
