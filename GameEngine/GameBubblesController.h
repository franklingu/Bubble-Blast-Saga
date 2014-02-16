//
//  GameBubblesController.h
//  ps03
//
//  Created by Gu Junchao on 2/3/14.
//
//

/**
 * this is the main controller for collectionview. it contains a reference to collectionview, functions as
 * delegate and datasource for the collectionview and responds to the event in collectionview. also this
 * manages all the gameBubble controller and is able to load from a file and save current grid to file
 */

#import <UIKit/UIKit.h>
#import "BubbleCell.h"

static const NSInteger kNumberOfItemsInOddRow = 12;
static const NSInteger kNumberOfItemsInEvenRow = 11;
static const NSInteger kNumberOfRows = 13;

@interface GameBubblesController : UIViewController

@property (strong, nonatomic) UICollectionView* bubbleGridArea;
@property (nonatomic)         NSInteger currentSelectedFillingType;
@property(strong, nonatomic)  NSArray* allModelDataFromFile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bubbleGridArea:(UICollectionView*)aGameGrid;
// EFFECTS: return initialized controller with a reference to bubbleGridArea

- (void)resetAllBubbles;
// EFFECTS: reset all the bubbles in the grid

- (void)saveCurrentDesignToFile:(NSString*)filePathToSave;
// REQUIRES: filePathToSave != nil
// EFFECTS: save the current design to filePathToSave

- (void)loadFromFile:(NSString*)filePathToLoad;
// REQUIRES: filePathToLoad != nil
// EFFECTS: load fro the given path

- (void)handleTapGesture:(UITapGestureRecognizer *)sender;

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender;

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender;

- (void)addGameBubbleAtIndexPathItem:(NSIndexPath *)indexPath andColorType:(NSInteger)aColorType;

- (void)setColorTypeForCell:(BubbleCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
