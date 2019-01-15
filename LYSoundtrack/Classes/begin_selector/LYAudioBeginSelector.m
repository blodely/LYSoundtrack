//
//	LYAudioBeginSelector.m
//	LYSoundtrack
//
//	CREATED BY LUO YU ON 2019-01-15.
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

#import "LYAudioBeginSelector.h"
#import <LYSoundtrack/LYSoundtrack.h>
#import <LYCategory/LYCategory.h>
#import <Masonry/Masonry.h>


@interface LYAudioBeginSelector () <UIScrollViewDelegate> {
	__weak UIScrollView *svCont;
	__weak UIImageView *ivHighlight;
	__weak UIImageView *ivNormal;
	
	float widthPerSecond;
	LYCCompletion blockRelocated;
}
@end

@implementation LYAudioBeginSelector

- (instancetype)init {
	if (self = [super init]) {
		[self initial];
	}
	return self;
}

- (void)initial {
	
	{
		_selectedColor = [UIColor orangeColor];
		_color = [UIColor lightGrayColor];
		widthPerSecond = 0;
	}
	
	{
		UIScrollView *scroll = [[UIScrollView alloc] init];
		[self addSubview:scroll];
		svCont = scroll;
		
		svCont.backgroundColor = [UIColor clearColor];
		svCont.showsHorizontalScrollIndicator = NO;
		svCont.showsVerticalScrollIndicator = NO;
		svCont.bounces = NO;
		svCont.delegate = self;
		
		[scroll mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self);
		}];
	}
	
	{
		UIImageView *view = [[UIImageView alloc] init];
		[svCont addSubview:view];
		ivNormal = view;
		
		view.frame = (CGRect){0, 0, WIDTH, 100};
		view.contentMode = UIViewContentModeTopLeft;
		view.clipsToBounds = YES;
	}
	
	{
		UIImageView *view = [[UIImageView alloc] init];
		[svCont addSubview:view];
		ivHighlight = view;
		
		view.frame = (CGRect){0, 0, WIDTH, 100};
		view.contentMode = UIViewContentModeTopLeft;
		view.clipsToBounds = YES;
	}
}

// MARK: - METHOD

- (void)setupAudioVisual {
	// SETUP AUDIO VISUAL IMAGES
	svCont.contentSize = _size;
	ivNormal.frame = (CGRect){0, 0, _size.width, _size.height};
	ivHighlight.frame = (CGRect){0, 0, 0, _size.height};
	
	[[LYSoundtrack kit] generateAudioAsset:_asset exportSize:_size backgroundColor:_color highlightColor:_selectedColor equalizerImages:^(UIImage *highlighted, UIImage *background) {
		ivNormal.image = background;
		ivHighlight.image = highlighted;
	}];
}

- (void)updateCursor:(float)second {
	if (second < _begin || second > _end) {
		NSLog(@"NOT ALLOW");
		return;
	}
	
	ivHighlight.frame = (CGRect){0, 0, second * widthPerSecond, _size.height};
}

- (void)relocatedBeginning:(void (^)(void))action {
	blockRelocated = action;
}

// MARK: PROPERTY

- (void)setAsset:(AVAsset *)asset {
	_asset = asset;
	
	_fileDuration = CMTimeGetSeconds(_asset.duration);
	
	if (_fileDuration > 0) {
		widthPerSecond = round(_size.width / _fileDuration * 1000) * 0.001;
	}
}

/*
- (void)setFileDuration:(float)fileDuration {
	_fileDuration = fileDuration;
	
	if (_fileDuration > 0) {
		widthPerSecond = round(_size.width / _fileDuration * 1000) * 0.001;
	}
}
*/

- (void)setSize:(CGSize)size {
	_size = size;
	
	if (_fileDuration > 0) {
		widthPerSecond = round(_size.width / _fileDuration * 1000) * 0.001;
	}
}

// MARK: - DELEGATE

// MARK: UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	float offsetx = scrollView.contentOffset.x;
	
	_begin = round(offsetx / _size.width * _fileDuration * 1000) * 0.001;
	_end = round((offsetx + svCont.frame.size.width) / _size.width * _fileDuration * 1000) * 0.001;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (decelerate == NO) {
		[self changedEvent];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self changedEvent];
}

- (void)changedEvent {
	
	ivHighlight.frame = (CGRect){0, 0, _begin * widthPerSecond, _size.height};
	
	if (blockRelocated != nil) {
		blockRelocated();
	}
	
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
