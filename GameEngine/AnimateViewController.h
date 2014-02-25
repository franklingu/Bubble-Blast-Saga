//
//  AnimateViewController.h
//  ps04
//
//  Created by Gu Junchao on 2/10/14.
//
//

#import <UIKit/UIKit.h>
#import "GameEngine.h"

static const CGFloat kOriginXOfNextFiringBubble = 25;
static const CGFloat kMaximumYReplacement = -20;
static const CGFloat kExpandingRate = 8;
static const CGFloat kDropingDistance = 100;
static const CGFloat kAnimationDuration = 0.2;

@interface AnimateViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, GraphDelegate>
@property (strong, nonatomic) IBOutlet UIView *gameArea;
@property (strong, nonatomic) IBOutlet UICollectionView *bubbleGridArea;

- (void)configureLoadingFilePathByFileName:(NSString *)fileName;
@end
