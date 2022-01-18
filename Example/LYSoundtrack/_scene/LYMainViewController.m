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
		view.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addSubview:view];
		slider = view;
		
		[slider addTarget:self action:@selector(updateValues:) forControlEvents:UIControlEventValueChanged];
		
		[view.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:100].active = YES;
		[view.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:10].active = YES;
		[view.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-10].active = YES;
		[view.heightAnchor constraintEqualToConstant:140].active = YES;
		
		UILabel *label = [[UILabel alloc] init];
		label.translatesAutoresizingMaskIntoConstraints = NO;
		label.text = @"Audio Range Slider ↓";
		[self.view addSubview:label];
		
		[label.leadingAnchor constraintEqualToAnchor:slider.leadingAnchor constant:15].active = YES;
		[label.bottomAnchor constraintEqualToAnchor:slider.topAnchor constant:-5].active = YES;
	}
	
	{
		UILabel *view = [[UILabel alloc] init];
		view.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addSubview:view];
		lblValues = view;
		
		[view.topAnchor constraintEqualToAnchor:slider.bottomAnchor constant:15].active = YES;
		[view.leadingAnchor constraintEqualToAnchor:slider.leadingAnchor].active = YES;
		[view.trailingAnchor constraintEqualToAnchor:slider.trailingAnchor].active = YES;
	}
	
	{
		LYAudioPrefixSlider *view = [[LYAudioPrefixSlider alloc] init];
		view.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addSubview:view];
		trimmer = view;
		
		[view.topAnchor constraintEqualToAnchor:lblValues.bottomAnchor constant:15].active = YES;
		[view.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:10].active = YES;
		[view.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-10].active = YES;
		[view.heightAnchor constraintEqualToConstant:140].active = YES;
	}
	
	{
		LYAudioBeginSelector *view = [[LYAudioBeginSelector alloc] init];
		view.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addSubview:view];
		selector = view;
		
		[view.topAnchor constraintEqualToAnchor:trimmer.bottomAnchor constant:15].active = YES;
		[view.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
		[view.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
		[view.heightAnchor constraintEqualToConstant:100].active = YES;
		
//		[selector addTarget:self action:@selector(updateValues:) forControlEvents:UIControlEventValueChanged];
		
		[selector relocatedBeginning:^{
			self->cursor = self->selector.begin;
			[self performSelector:@selector(play) withObject:nil afterDelay:0.1];
		}];
	}
	
	{
		UILabel *view = [[UILabel alloc] init];
		view.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addSubview:view];
		lblSelValues = view;
		
		[view.topAnchor constraintEqualToAnchor:selector.bottomAnchor constant:15].active = YES;
		[view.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:15].active = YES;
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
