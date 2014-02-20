//
//  Label.h
//  KidsABC
//
//  Created by Jesper on 07/01/14.
//  Copyright (c) 2014 Jesper. All rights reserved.
//

#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@interface Label : NSObject
-(CCLabelTTF *) createLabel:(NSString *)text atPos:(int)positionX atPosY:(int)positionY color:(ccColor3B)color;
-(CCLabelTTF *) createLabel:(NSString *)text atPos:(int)positionX atPosY:(int)positionY color:(ccColor3B)color fontSize:(int)fontSize;
@end
