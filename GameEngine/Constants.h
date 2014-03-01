//
//  Constants.h
//  Bubble Blast Saga
//
//  Created by Gu Junchao on 3/1/14.
//
//

#import <Foundation/Foundation.h>

static NSString *kBlueImageName = @"bubble-blue.png";
static NSString *kRedImageName = @"bubble-red.png";
static NSString *kOrangeImageName = @"bubble-orange.png";
static NSString *kGreenImageName = @"bubble-green.png";
static NSString *kStarImageName = @"bubble-star.png";
static NSString *kBombImageName = @"bubble-bomb.png";
static NSString *kLightningImageName = @"bubble-lightning.png";
static NSString *kIndestructibleImageName = @"bubble-indestructible.png";

static NSString *kTmpFileName = @"tmp";
static NSString *kEmptyString = @"";
static NSString *kDotString = @".";
static NSString *kPredefinePrefix = @"Level";

static const NSInteger kNumberOfItemsInOddRow = 12;
static const NSInteger kNumberOfItemsInEvenRow = 11;
static const NSInteger kNumberOfRows = 13;

static const CGFloat kTimerInterval = 1.0/60;
static const CGFloat kFiringSpeed = 900;
static const CGFloat kOriginXOfFiringBubble = 352;
static const CGFloat kOriginYOfFiringBubble = 941;
static const CGFloat kRadiusOfFiringBubble = 32;
static const NSInteger kMaximumNumberOfConnectedBubbles = 3;
static const NSInteger kInvalidItem = -1;
static const NSString *kBubbleToFireIdentifier = @"bubbleToFire";
