//
//  AnimateViewController.h
//  ps04
//
//  Created by Gu Junchao on 2/10/14.
//
//

#import <UIKit/UIKit.h>
#import "GameGraph.h"

static const CGFloat kOriginXOfNextFiringBubble = 25;
static const CGFloat kMaximumYReplacement = -20;
static const CGFloat kAlphaChangeForRemoving = 0.1;
static const CGFloat kExpandingRateForRemoving = 2.5;
static const CGFloat kAlphaChangeForDroping = 0.05;
static const CGFloat kDropingRateForDroping = 10;
static NSString *kBlueImageName = @"bubble-blue.png";
static NSString *kRedImageName = @"bubble-red.png";
static NSString *kOrangeImageName = @"bubble-orange.png";
static NSString *kGreenImageName = @"bubble-green.png";

@interface AnimateViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, GraphDelegate>
@property (strong, nonatomic) IBOutlet UIView *gameArea;
@property (strong, nonatomic) IBOutlet UICollectionView *bubbleGridArea;
@end