//
//  LYSoundtrack.m
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

#import "LYSoundtrack.h"
#import <AVFoundation/AVFoundation.h>
#import <LYCategory/LYCategory.h>


@implementation LYSoundtrack

// MARK: - INIT

- (instancetype)init {
	if (self = [super init]) {
	}
	return self;
}

+ (instancetype)kit {
	
	static LYSoundtrack *sharedLYSoundtrack;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedLYSoundtrack = [[LYSoundtrack alloc] init];
	});
	
	return sharedLYSoundtrack;
}

// MARK: - METHOD

- (AVAsset *)assetFromFile:(NSString *)filepath {
	
	// INPUT CHECK
	if (filepath == nil
		|| [filepath isKindOfClass:[NSString class]] == NO
		|| [filepath isEqualToString:@""]
		|| [[NSFileManager defaultManager] fileExistsAtPath:filepath] == NO) {
		NSLog(@"LYSoundtrack - ERROR - filepath=%@", filepath);
		return nil;
	}
	
	return [AVAsset assetWithURL:[NSURL URLWithString:filepath]];
}

- (void)generateAudioAsset:(AVAsset *)asset exportSize:(CGSize)size backgroundColor:(UIColor *)bgcolor highlightColor:(UIColor *)highlightedColor equalizerImages:(void (^)(UIImage *, UIImage *))complete {
	
	if (asset == nil || [asset isKindOfClass:[AVAsset class]] == NO) {
		NSLog(@"LYSoundtrack - ERROR - ASSET");
		return;
	}
	
	if (size.width <= 0 || size.height <= 0) {
		NSLog(@"LYSoundtrack - ERROR - SIZE ZERO");
		return;
	}
	
	if (complete == nil) {
		NSLog(@"LYSoundtrack - WARNING - COMPLETE NOT FOUND");
		return;
	}
	
	CGFloat width = 6;
	CGFloat radius = width * 0.5;
	CGFloat padding = 4;
	NSUInteger count = (NSUInteger)(size.width / (width + padding));
	NSMutableArray<NSNumber *> *heights = [NSMutableArray arrayWithCapacity:1];
	for (NSInteger i = 0; i < count; i++) {
		[heights addObject:@([NSNumber randomIntBetween:radius * 2 + 1 and:(size.height - padding - padding)])];
	}
	
	// BEGIN DRAWING
	UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, bgcolor.CGColor);
	CGContextSetStrokeColorWithColor(context, bgcolor.CGColor);
	
	for (NSInteger i = 0; i < count; i++) {
		NSInteger height = heights[i].integerValue;
		CGFloat top = (size.height - height) * 0.5 - radius + padding;
		CGFloat left = padding + i * (width + padding);
		
		CGContextMoveToPoint(context, left, top);
		CGContextAddArc(context, left + radius, top, radius, M_PI, 0, 0);
		CGContextAddLineToPoint(context, left + width, top + height - radius * 2);
		CGContextAddArc(context, left + radius, top + height - radius * 2, radius, 0, M_PI, 0);
		CGContextClosePath(context);
		
		CGContextFillPath(context);
	}
	
	UIImage *bgimg = UIGraphicsGetImageFromCurrentImageContext();
	// END DRAWING
	UIGraphicsEndImageContext();
	
	
	// BEGIN DRAWING
	UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	CGContextRef fcontext = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(fcontext, highlightedColor.CGColor);
	CGContextSetStrokeColorWithColor(fcontext, highlightedColor.CGColor);
	
	for (NSInteger i = 0; i < count; i++) {
		NSInteger height = heights[i].integerValue;
		CGFloat top = (size.height - height) * 0.5 - radius + padding;
		CGFloat left = padding + i * (width + padding);
		
		CGContextMoveToPoint(fcontext, left, top);
		CGContextAddArc(fcontext, left + radius, top, radius, M_PI, 0, 0);
		CGContextAddLineToPoint(fcontext, left + width, top + height - radius * 2);
		CGContextAddArc(fcontext, left + radius, top + height - radius * 2, radius, 0, M_PI, 0);
		CGContextClosePath(fcontext);
		
		CGContextFillPath(fcontext);
	}
	
	UIImage *fgimg = UIGraphicsGetImageFromCurrentImageContext();
	// END DRAWING
	UIGraphicsEndImageContext();
	
	// RETURN
	complete(fgimg, bgimg);
}

- (void)generateAudioAsset:(AVAsset *)asset exportSize:(CGSize)size backgroundColor:(UIColor *)bgcolor highlightColor:(UIColor *)highlightedColor sliderEqualizerImages:(void (^)(UIImage *, UIImage *, UIImage *))complete {
	
	[self generateAudioAsset:asset exportSize:size backgroundColor:bgcolor highlightColor:highlightedColor equalizerImages:^(UIImage *highlighted, UIImage *background) {
		// BEGIN DRAWING
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, size.height), NO, 0);
		UIImage *thumbImg = UIGraphicsGetImageFromCurrentImageContext();
		// END DRAWING
		UIGraphicsEndImageContext();
		
		// RETURN
		complete(highlighted, background, thumbImg);
	}];
}

@end
