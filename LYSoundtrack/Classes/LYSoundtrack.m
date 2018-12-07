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

@end
