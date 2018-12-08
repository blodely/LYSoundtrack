//
//  LYAudioRangeSlider.m
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

#import "LYAudioRangeSlider.h"
#import <LYCategory/LYCategory.h>
#import <Masonry/Masonry.h>
#import "LYSoundtrack.h"


@interface LYAudioRangeSlider () {
	
	__weak UIImageView *ivBgLeft;
	__weak UIImageView *ivBgRight;
	__weak UIImageView *ivHighlighted;
}
@end

@implementation LYAudioRangeSlider

// MARK: - ACTION

// MARK: - INIT

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self initial];
	}
	return self;
}

- (void)initial {
	
	{
		self.backgroundColor = [UIColor clearColor];
		
		_minimumSeconds = 0;
		_maximumSeconds = 3;
		_minimumRange = 1;
		_beginSeconds = 0;
		_endSeconds = 1;
		_selectedColor = [UIColor orangeColor];
		_color = [UIColor lightGrayColor];
	}
	
	{
		// MARK: FOREGROUND IMAGE
		UIImageView *imageview = [[UIImageView alloc] init];
		[self addSubview:imageview];
		ivHighlighted = imageview;
		
		[imageview mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self);
		}];
	}
	
	{
		// MARK: BACKGROUND IMAGE LEFT
		UIImageView *imageview = [[UIImageView alloc] init];
		[self addSubview:imageview];
		ivBgLeft = imageview;
		
		[imageview mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.bottom.equalTo(self);
			make.left.equalTo(self);
		}];
	}
	
	{
		// MARK: BACKGROUND IMAGE RIGHT
		UIImageView *imageview = [[UIImageView alloc] init];
		[self addSubview:imageview];
		ivBgRight = imageview;
		
		[imageview mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.bottom.equalTo(self);
			make.right.equalTo(self);
		}];
	}
	
	{
		// MARK: SLIDER VIEW
		UIView *view = [[UIView alloc] init];
		view.backgroundColor = [UIColor clearColor];
		[self addSubview:view];
		_slider = view;
		
		[view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.bottom.equalTo(self);
			make.leading.equalTo(self->ivBgLeft.mas_trailing);
			make.trailing.equalTo(self->ivBgRight.mas_leading);
			make.width.mas_greaterThanOrEqualTo(self->_minimumRange);
		}];
	}
}

// MARK: - METHOD

- (void)setupAudioVisual {
	// SETUP AUDIO VISUAL IMAGES
	[[LYSoundtrack kit] generateAudioAsset:_asset exportSize:_size backgroundColor:_color highlightColor:_selectedColor equalizerImages:^(UIImage *highlighted, UIImage *background) {
		
		self->ivBgLeft.image = background;
		self->ivBgRight.image = background;
		self->ivHighlighted.image = highlighted;
	}];
}

// MARK: OVERRIDE

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
}

- (void)setFrame:(CGRect)frame {
	_size = frame.size;
	[super setFrame:frame];
}

// MARK: PROPERTY

- (void)setMinimumRange:(NSUInteger)minimumRange {
	_minimumRange = minimumRange;
	
	[_slider mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.equalTo(self);
		make.leading.equalTo(self->ivBgLeft.mas_trailing);
		make.trailing.equalTo(self->ivBgRight.mas_leading);
		make.width.mas_greaterThanOrEqualTo(self->_minimumRange);
	}];
}

// MARK: PRIVATE METHOD

// MARK: - DELEGATE

// MARK:

// MARK: - NOTIFICATION


@end
