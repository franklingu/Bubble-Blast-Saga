//
//  ViewController.h
//  Game
//
//  Created by Gu Junchao on 1/28/14.
//
//

#import <UIKit/UIKit.h>
#import "PopOverTableViewController.h"
#import "AnimateViewController.h"
#import "BubbleModelsManager.h"
#import "GameResourcesManager.h"
#import "PopOverDelegate.h"

@interface GameDesignViewController : UIViewController <UIPopoverControllerDelegate, PopOverDelegate,
UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *palette;
@property (strong, nonatomic) IBOutlet UICollectionView *bubblesGridArea;
@property (strong, nonatomic) IBOutlet UIButton *loadButton;

@property (strong, nonatomic)          UIAlertView *saveAlert;
@property (strong, nonatomic)          UIAlertView *invalidGraphAlert;
@property (strong, nonatomic)          UIAlertView *existingFileAlert;
@property (strong, nonatomic)          UIPopoverController* loadPopOverController;
@property (strong, nonatomic)          BubbleModelsManager *bubbleModelsManager;
@property (strong, nonatomic)          GameResourcesManager *resourceManager;

- (IBAction)buttonPressed:(id)sender;

- (IBAction)colorSelectorPressed:(id)sender;

@end
