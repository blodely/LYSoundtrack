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
	
	CGFloat previousX;
}
@end

@implementation LYAudioRangeSlider

// MARK: - ACTION

- (void)sliderDragged:(UIPanGestureRecognizer *)gesture {
	
	switch (gesture.state) {
		case UIGestureRecognizerStateEnded: {
			previousX = gesture.view.frame.origin.x;
		} break;
		case UIGestureRecognizerStateBegan: {
		} break;
		case UIGestureRecognizerStateChanged: {
			CGPoint tspt = [gesture translationInView:gesture.view];
			CGPoint rtpt = _slider.center;
			rtpt.x = MAX(MIN(previousX + tspt.x, _size.width - _minimumRange * 0.5), 0 + _minimumRange * 0.5);
			_slider.center = rtpt;
		} break;
		default:
			break;
	}
	
	CGRect rect = CGRectZero;
	
	// LEFT
	rect = ivBgLeft.frame;
	rect.origin = CGPointZero;
	rect.size.width = _slider.frame.origin.x;
	ivBgLeft.frame = rect;
	
	// RIGHT
	rect = ivBgRight.frame;
	rect.origin.x = CGRectGetMaxX(_slider.frame);
	rect.origin.y = 0;
	rect.size.width = _size.width - rect.origin.x;
	ivBgRight.frame = rect;
}

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
		imageview.clipsToBounds = YES;
		[self addSubview:imageview];
		ivBgLeft = imageview;
		ivBgLeft.contentMode = UIViewContentModeTopLeft;
		
		// INITIAL FRAME
		ivBgLeft.frame = (CGRect){0, 0, 0, _size.height};
	}
	
	{
		// MARK: BACKGROUND IMAGE RIGHT
		UIImageView *imageview = [[UIImageView alloc] init];
		imageview.clipsToBounds = YES;
		[self addSubview:imageview];
		ivBgRight = imageview;
		ivBgRight.contentMode = UIViewContentModeTopRight;
		
		// INITIAL FRAME
		ivBgRight.frame = (CGRect){_minimumRange, 0, _size.width - _minimumRange, _size.height};
	}
	
	{
		// MARK: SLIDER VIEW
		UIView *view = [[UIView alloc] init];
		view.backgroundColor = [UIColor clearColor];
		[self addSubview:view];
		_slider = view;
		
		// INITIAL FRAME
		_slider.frame = (CGRect){0, 0, _minimumRange, _size.height};
		
		UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sliderDragged:)];
		[_slider addGestureRecognizer:pan];
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
	frame.size.width = MAX(_minimumRange, MIN(frame.size.width, WIDTH));
	[super setFrame:frame];
	_size = frame.size;
	
	ivBgLeft.frame = (CGRect){0, 0, 0, _size.height};
	_slider.frame = (CGRect){CGRectGetMaxX(ivBgLeft.frame), 0, _minimumRange, _size.height};
	ivBgRight.frame = (CGRect){CGRectGetMaxX(_slider.frame), 0, _size.width - CGRectGetMaxX(_slider.frame), _size.height};
}

// MARK: PROPERTY

- (void)setMinimumRange:(NSUInteger)minimumRange {
	_minimumRange = MAX(MIN(minimumRange, _size.width), 3);
	
	ivBgLeft.frame = (CGRect){0, 0, 0, _size.height};
	_slider.frame = (CGRect){CGRectGetMaxX(ivBgLeft.frame), 0, _minimumRange, _size.height};
	ivBgRight.frame = (CGRect){CGRectGetMaxX(_slider.frame), 0, _size.width - CGRectGetMaxX(_slider.frame), _size.height};
}

// MARK: PRIVATE METHOD

// MARK: - DELEGATE

// MARK:

// MARK: - NOTIFICATION


@end
