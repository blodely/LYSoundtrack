//
//	LYAudioBeginSelector.h
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

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface LYAudioBeginSelector : UIControl

@property (strong, nonatomic) AVAsset *asset;
@property (assign, nonatomic) CGSize size;

@property (strong, nonatomic) UIColor *selectedColor;
@property (strong, nonatomic) UIColor *color;

- (void)setupAudioVisual;


@property (nonatomic, assign) float fileDuration;
@property (nonatomic, readonly) float begin;
@property (nonatomic, readonly) float end;

- (void)updateCursor:(float)second;
- (void)relocatedBeginning:(void (^)(void))action;

- (void)reset;

@end
