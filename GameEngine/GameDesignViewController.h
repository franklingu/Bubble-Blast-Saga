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
#import "PopOverDelegate.h"
#import "GameBubblesController.h"
#import "PopOverTableViewController.h"

@interface GameDesignViewController : UIViewController <UIPopoverControllerDelegate, PopOverDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *gameArea;
@property (strong, nonatomic) IBOutlet UIView *palette;
@property (strong, nonatomic) IBOutlet UICollectionView *bubbleGridArea;
@property (strong, nonatomic) IBOutlet UIButton *loadButton;

@property (strong, nonatomic)          UIAlertView* saveAlert;
@property (strong, nonatomic)          UIAlertView* existingFileAlert;
@property (strong, nonatomic)          GameBubblesController* gameBubblesController;
@property (strong, nonatomic)          UIPopoverController* loadPopOverController;

- (IBAction)buttonPressed:(id)sender;
// MODIFIES: self or loadPopOverController.contentController
// EFFECTS: this will be triggered by pressing play/reset/save/load and responds to the event
//          Save button--save alert shows up
//          Reset button--reset all the cells
//          Load button--loadPopOverController shows up

- (IBAction)colorSelectorPressed:(id)sender;
// MODIFIES: gameBubbleController
// EFFECTS: respond to the pressing on palette and changes the current selected color

- (NSArray*)filesInAppDocumentDirectory;
// EFFECTS: search in the app document directory and return an array of all the file
//          names with extension

- (NSArray*)fileNamesInAppDirectory;
// EFFECTS: return an array of all the file names in app document directory

@end
