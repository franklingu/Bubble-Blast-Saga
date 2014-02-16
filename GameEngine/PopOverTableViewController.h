//
//  PopOverTableViewController.h
//  ps03
//
//  Created by Gu Junchao on 2/6/14.
//
//

/**
 * a tableviewcontroller functions as the content controller in popover controller
 *
 * action:
 * row selected: for loading a file and tells the delegate about the selected file name
 * row deleting: for deleting a file -- if some error happens, there is only NSLog for now,
 *                                      need suggestions on how to deal with error
 */

#import <UIKit/UIKit.h>
#import "PopOverDelegate.h"

@interface PopOverTableViewController : UITableViewController

@property (strong, nonatomic) id<PopOverDelegate> delegate;
@property (strong, nonatomic) NSArray*            fileNames;

@end
