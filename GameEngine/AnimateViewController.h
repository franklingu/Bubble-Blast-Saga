//
//  AnimateViewController.h
//  ps04
//
//  Created by Gu Junchao on 2/10/14.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GameEngine.h"
#import "AVSoundPlayer.h"
#import "GameResourcesManager.h"

@interface AnimateViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate, GameEngineDelegate>
@property (strong, nonatomic) IBOutlet UIView *gameArea;
@property (strong, nonatomic) IBOutlet UICollectionView *bubbleGridArea;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *scoreGained;
@property (strong, nonatomic) IBOutlet UISlider *shotsLeftSlider;

- (void)configureLoadingFilePath:(NSString *)filePath;
- (IBAction)backButtonPressed:(UIButton *)sender;

@end
