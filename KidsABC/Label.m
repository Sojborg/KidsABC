//
//  Label.m
//  KidsABC
//
//  Created by Jesper on 07/01/14.
//  Copyright (c) 2014 Jesper. All rights reserved.
//

#import "Label.h"

@implementation Label

-(CCLabelTTF *) createLabel:(NSString *)text atPos:(int)positionX atPosY:(int)positionY color:(ccColor3B)color
{
    CCLabelTTF *label = [CCLabelTTF labelWithString:text fontName:@"Marker Felt"fontSize:64];
    label.position =  ccp( positionX , positionY );
    label.color = color;
    
    return label;
}

-(CCLabelTTF *) createLabel:(NSString *)text atPos:(int)positionX atPosY:(int)positionY color:(ccColor3B)color fontSize:(int)fontSize
{
    CCLabelTTF *label = [CCLabelTTF labelWithString:text fontName:@"Marker Felt"fontSize:fontSize];
    label.position =  ccp(positionX, positionY );
    label.color = color;
    
    return label;
}

@end
