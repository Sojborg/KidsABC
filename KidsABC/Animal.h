//
//  Animal.h
//  KidsABC
//
//  Created by Jesper on 02/01/14.
//  Copyright (c) 2014 Jesper. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "cocos2d.h"

@interface Animal : NSObject
{
    NSString* name;
    CCSprite* sprite;
}

-(NSString*)name;
-(void)setName:(NSString*)input;

-(CCSprite*)sprite;
-(void)setSprite:(CCSprite*)input;

@end
