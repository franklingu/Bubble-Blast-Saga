//
//  ViewController.h
//  Game
//
//  Created by Gu Junchao on 1/28/14.
//
//

/**
 * this is the main controller of the game designer--and the only controller
 * that is linked to outlets.
 *
 * responding to button-related events are done here.
 * changing of selected color--will update gameBubblesController about the change
 * save--will ask gameBubblesController to do the work(extension)
 * load--show user the loading view and will 
 *       assign gameBubblesController the loading(extension)
 * play--not implemented yet
 */

#import <UIKit/UIKit.h>
#import "PopOverTableViewController.h"
#import "BubbleModelsManager.h"
#import "PopOverDelegate.h"

static NSString *kBlueImageName = @"bubble-blue.png";
static NSString *kRedImageName = @"bubble-red.png";
static NSString *kOrangeImageName = @"bubble-orange.png";
static NSString *kGreenImageName = @"bubble-green.png";

@interface GameDesignViewController : UIViewController <UIPopoverControllerDelegate, PopOverDelegate,
UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *gameArea;
@property (strong, nonatomic) IBOutlet UIView *palette;
@property (strong, nonatomic) IBOutlet UICollectionView *bubblesGridArea;
@property (strong, nonatomic) IBOutlet UIButton *loadButton;

@property (strong, nonatomic)          UIAlertView* saveAlert;
@property (strong, nonatomic)          UIAlertView* existingFileAlert;
@property (strong, nonatomic)          UIPopoverController* loadPopOverController;
@property (strong, nonatomic)          BubbleModelsManager *bubbleModelsManager;

- (IBAction)buttonPressed:(id)sender;

- (IBAction)colorSelectorPressed:(id)sender;

- (NSArray*)filesInAppDocumentDirectory;

- (NSArray*)fileNamesInAppDirectory;

@end
