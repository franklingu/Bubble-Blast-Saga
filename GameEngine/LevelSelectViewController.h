//
//  LevelSelectViewController.h
//  Bubble Blast Saga
//
//  Created by Gu Junchao on 2/17/14.
//
//

#import <UIKit/UIKit.h>
#import "AnimateViewController.h"

static NSString *LevelTabelViewCellIdentifier = @"LevelTableViewCell";

@interface LevelSelectViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *levelsTableView;
@property (strong, nonatomic) IBOutlet UIView *levelInfoView;
- (IBAction)returnPressed:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *returnButton;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@end
