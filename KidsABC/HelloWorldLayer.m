//
//  HelloWorldLayer.m
//  KidsABC
//
//  Created by Jesper on 02/01/14.
//  Copyright Jesper 2014. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

NSMutableArray *_animals;
CGSize *winSize;
int _selectedAnimal = 0;
NSMutableArray *_graphics;
CCLabelTTF *_label;
NSMutableArray *_labels;
NSMutableArray *_correctLabels;
int _nextLetterToSolve = 0;
CCSprite *_nextLvlDialog;
CCLabelTTF *_nextLevelText;
Label *_labelHandler;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void) loadAnimals
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGPoint animalPosition = ccp(winSize.width/2, winSize.height/2);
    
    
    CCSprite *ugle = [[CCSprite spriteWithFile:@"ugle.jpg"] retain];
    ugle.position = animalPosition;
    
    Animal *owl = [Animal alloc];
    [owl setName: @"Ugle"];
    [owl setSprite:ugle];
    [_animals addObject:owl];
    
    CCSprite *tigerSprite = [[CCSprite spriteWithFile:@"tiger.jpg"] retain];
    tigerSprite.position = animalPosition;
    
    Animal *tiger = [Animal alloc];
    [tiger setName: @"Tiger"];
    [tiger setSprite:tigerSprite];
    [_animals addObject:tiger];
    
    CCSprite *bearSprite = [[CCSprite spriteWithFile:@"bear.jpg"] retain];
    bearSprite.position = animalPosition;
    
    Animal *bear = [Animal alloc];
    [bear setName: @"Bjørn"];
    [bear setSprite:bearSprite];
    [_animals addObject:bear];
}

-(void) loadGraphics
{
//    CGSize winSize = [CCDirector sharedDirector].winSize;
//    
//    CCSprite *arrowLeft = [CCSprite spriteWithFile:@"arrow_left_brown.jpg"];
//    arrowLeft.position = ccp(50, winSize.height/2);
//    arrowLeft.tag = 1;
//    [self addChild:arrowLeft];
//    [_graphics addObject:arrowLeft];
//    
//    CCSprite *arrowRight = [CCSprite spriteWithFile:@"arrow_left_brown.jpg"];
//    arrowRight.position = ccp((winSize.width - 50), winSize.height/2);
//    arrowRight.rotation = (float)180;
//    arrowRight.tag = 2;
//    [self addChild:arrowRight];
//    [_graphics addObject:arrowRight];
    [self loadNextLevelDialog];
}

-(void) loadNextLevelDialog
{
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    
    CCLabelTTF *label = [_labelHandler createLabel:@"" atPos:winSize.width/2 atPosY:winSize.height/2 color:ccc3(0,0,0) fontSize: 10];
    label.zOrder = 99;
    [self addChild:label];
    _nextLevelText = label;
    
    CCSprite *nextLvl = [CCSprite spriteWithFile:@"nextlevel.png"];
    nextLvl.position = ccp((winSize.width/2), (winSize.height/2));
    nextLvl.visible = false;
    nextLvl.zOrder = 1;
    [self addChild:nextLvl];
    _nextLvlDialog = nextLvl;
}

-(void) showNextLevelDialog:(NSString *)dialogText
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    _nextLvlDialog.visible = true;
    
    _nextLevelText.string = dialogText;
    _nextLevelText.opacity = 0.0f;
    [_nextLevelText runAction:[CCFadeTo actionWithDuration:2.0 opacity:255.0f]];
    _nextLevelText.visible = true;
}

-(void) hideNextLevelDialog
{
    _nextLvlDialog.visible = false;
    _nextLevelText.visible = false;
    
}

-(void) selectNextAnimal
{
    if (_selectedAnimal < ([_animals count] - 1))
        _selectedAnimal++;
}

-(void) selectPrevAnimal
{
    if (_selectedAnimal > 0)
        _selectedAnimal--;
}

-(void) showCurrentAnimal
{
    Animal* animalToShow = [_animals objectAtIndex:_selectedAnimal];
    CCSprite *spriteToShow = animalToShow.sprite;
    [self addChild:spriteToShow];
    
    NSString *dazzledName = [self dazzelAnimalName:animalToShow.name];
    
    //[self showImageTitle:animalToShow.name atPos:50];
}

-(void) removeCurrentAnimal
{
    Animal *animalToRemove = [_animals objectAtIndex:_selectedAnimal];
    [self removeChild:animalToRemove.sprite];
}

-(void) removeLetters
{
    for (CCLabelTTF *l in _labels)
    {
        [self removeChild:l];
    }
}

-(void) removeCorrectLetters
{
    for (CCLabelTTF *l in _correctLabels)
    {
        [self removeChild:l];
    }
    _correctLabels = [[NSMutableArray alloc] init];
}

-(NSString *) dazzelAnimalName:(NSString *) name
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < [name length]; i++) {
        [array addObject:[NSString stringWithFormat:@"%C", [name characterAtIndex:i]]];
    }
    
    NSMutableArray *dazzeledLetters = [NSMutableArray array];
    int arraySize = [array count];
    
    for (int i = 0; i < arraySize; ++i)
    {
        int r = 0;
        if ([array count] > 1)
            r = arc4random() % ([array count] - 1);
    
        NSString *letter = [array objectAtIndex:r];
        [array removeObjectAtIndex:r];
    
        [dazzeledLetters addObject:letter];
    }
    
    
    [self showImageTitle:dazzeledLetters atPos:0];
    NSMutableString *dazzeledWord = [[NSMutableString alloc] init];
    
    return dazzeledWord;
}

-(void)clearScene
{
    [self removeCurrentAnimal];
    [self removeLetters];
    [self removeCorrectLetters];
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint location = [self convertTouchToNodeSpace: touch];
        for (CCSprite *station in _graphics)
        {
            if (CGRectContainsPoint(station.boundingBox, location))
            {
                if (station.tag == 1)
                {
                    NSLog(@"Left");
                    [self removeCurrentAnimal];
                    [self selectPrevAnimal];
                    [self showCurrentAnimal];
                }
                if (station.tag == 2)
                {
                    NSLog(@"Right");
                    [self removeCurrentAnimal];
                    [self selectNextAnimal];
                    [self showCurrentAnimal];
                }
            }
        }
        
        if (CGRectContainsPoint(_nextLvlDialog.boundingBox, location))
        {
            [self hideNextLevelDialog];
            [self selectNextAnimal];
            [self showCurrentAnimal];
            [self removeCorrectLetters];
        }
        
        for (CCLabelTTF *label in _labels)
        {
            if (CGRectContainsPoint(label.boundingBox, location))
            {
                NSLog(@"label touched!");
                
                Animal *animal = [_animals objectAtIndex:_selectedAnimal];
                NSString *startLetter = [animal.name substringWithRange:NSMakeRange(_nextLetterToSolve, 1)];
                if ([label.string isEqualToString:startLetter])
                {
                    ++_nextLetterToSolve;
                    label.color = ccc3(255, 255, 255);
                    [self drawCorrectLetter:label.string];
                    [_correctLabels addObject:_label];
                    NSLog(@"Correct!");
                    
                    if ((_nextLetterToSolve) == [animal.name length])
                    {
                        if (_selectedAnimal == ([_animals count] - 1))
                        {
                            CGSize size = [[CCDirector sharedDirector] winSize];
                            [self clearScene];
                            CCLabelTTF *victoryLabel = [_labelHandler createLabel:@"Sejr!" atPos:size.width/2 atPosY:size.height/2 color:ccc3(0, 0, 0)];
                            [self addChild:victoryLabel];
                        }
                        else
                        {
                            _nextLetterToSolve = 0;
                            [self removeCurrentAnimal];
                            [self showNextLevelDialog:@"Du vandt runden! Videre til næste?"];
                        }
                    }
                }
            }
        }
    }
}

-(void) drawCorrectLetter:(NSString *)letter
{
    int labelCount = [_correctLabels count] + 1;
    [self showTitle:letter atPos:labelCount atPosY:110 color: ccc3(101, 200, 12)];
}

-(void) showImageTitle:(NSMutableArray *)wordLetters atPos:(int)positionX
{
    [self removeLetters];
    _labels = [[NSMutableArray alloc] init];
        // create and initialize a Label
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    int i = 1;
    for (NSString *s in wordLetters)
    {
        [self showTitle:s atPos:i atPosY:size.height color:ccc3(0,0,0)];
        
        [_labels addObject:_label];
        ++i;
    }
}

-(void) showTitle:(NSString *)text atPos:(int)positionX atPosY:(int)positionY color:(ccColor3B)color
{
    CCLabelTTF *label = [CCLabelTTF labelWithString:text fontName:@"Marker Felt" fontSize:64];
    
    // ask director for the window size
	
    // position the label on the center of the screen
    label.position =  ccp( (100 * positionX) , positionY - label.contentSize.height );
    label.color = color;
    
    // add the label as a child to this Layer
    [self addChild: label];
    _label = label;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super initWithColor:ccc4(255,255,255,255)]) ) {
		[self setIsTouchEnabled:YES];
        _graphics = [[NSMutableArray alloc] init];
        _animals = [[NSMutableArray alloc] init];
        _labels = [[NSMutableArray alloc] init];
        _correctLabels = [[NSMutableArray alloc] init];
        _labelHandler = [Label alloc];
        //_selectedAnimal = 0;
        
        [self loadAnimals];
        [self loadGraphics];
        [self showCurrentAnimal];

	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
