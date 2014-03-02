//
//  LevelSelectViewController.m
//  Bubble Blast Saga
//
//  Created by Gu Junchao on 2/17/14.
//
//

#import "LevelSelectViewController.h"

@interface LevelSelectViewController ()
@property (strong, nonatomic) NSArray *fileNames;
@property (strong, nonatomic) NSString *selectedFileName;
@property (strong, nonatomic) UIView *selecteLevelView;
@property (strong, nonatomic) GameResourcesManager *resourceManager;
@end

@implementation LevelSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIImage* backgroundImage = [UIImage imageNamed:@"blue-sky.png"];
    UIImageView* background = [[UIImageView alloc] initWithImage:backgroundImage];
    CGFloat gameViewWidth = self.view.frame.size.width;
    CGFloat gameViewHeight = self.view.frame.size.height;
    background.frame = CGRectMake(0, 0, gameViewWidth, gameViewHeight);
    [self.view addSubview:background];
    [self.view sendSubviewToBack:background];
    
    [self.levelsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:LevelTabelViewCellIdentifier];
    self.levelsTableView.delegate = self;
    self.levelsTableView.dataSource = self;
    self.levelsTableView.layer.zPosition = 1;
    self.levelsTableView.backgroundColor = [UIColor clearColor];
    self.levelInfoView.layer.zPosition = 1;
    self.returnButton.layer.zPosition = 1;
    self.playButton.layer.zPosition = 1;
    self.playButton.alpha = 0.5;
    self.playButton.userInteractionEnabled = NO;
    
    self.resourceManager = [[GameResourcesManager alloc] init];
    self.fileNames = [self fileNamesForLevels];
}

- (IBAction)returnPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"playSceneSegue"]) {
        AnimateViewController *playViewController = segue.destinationViewController;
        NSString *filePath = nil;
        if (self.selectedFileName.length > kMinimumLengthOfLevelName
            && [[self.selectedFileName substringWithRange:NSMakeRange(0, kMinimumLengthOfLevelName + 1)] isEqualToString:kPredefinePrefix]) {
            filePath = [self.resourceManager pathForPredifinedLevel:self.selectedFileName];
        } else {
            filePath = [self.resourceManager pathForUserDefinedLevel:self.selectedFileName];
        }
        [playViewController configureLoadingFilePath:filePath];
    }
}

- (NSArray*)fileNamesForLevels
{
    NSMutableArray *fileNames = [NSMutableArray new];
    [fileNames addObjectsFromArray:[self.resourceManager fileNamesForLevelInAppDocumentDirectory]];
    [fileNames addObjectsFromArray:[self.resourceManager fileNamesForPredefinedLevels]];
    
    return fileNames;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fileNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LevelTabelViewCellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    @try {
        NSString* fileName = self.fileNames[indexPath.row];
        cell.textLabel.text = fileName;
    }
    @catch (NSException *exception) {
        NSLog(@"loading row failure for table view:\n%@", exception.description);
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        NSString* selectedFileName = self.fileNames[indexPath.row];
        [self selectionInTableViewWithSelectedFileName:selectedFileName];
    }
    @catch (NSException *exception) {
        NSLog(@"selecting row failure in table view: %@", exception.description);
    }
}

- (void)selectionInTableViewWithSelectedFileName:(NSString *)selectedFileName
{
    self.selectedFileName = selectedFileName;
    UIView *previousSelectedView = self.selecteLevelView;
    UIImage* levelImage;
    if (self.selectedFileName.length > kMinimumLengthOfLevelName
        && [[self.selectedFileName substringWithRange:NSMakeRange(0, kMinimumLengthOfLevelName + 1)] isEqualToString:kPredefinePrefix]) {
        levelImage = [UIImage imageWithContentsOfFile:[self.resourceManager pathForPredifinedLevelImage:selectedFileName]];
    } else {
        levelImage = [UIImage imageWithContentsOfFile:[self.resourceManager pathForUserDefinedLevelImage:selectedFileName]];
    }
    UIImageView* levelImageView = [[UIImageView alloc] initWithImage:levelImage];
    CGRect frame = CGRectMake(0, 0,
                              self.levelInfoView.frame.size.width,
                              self.levelInfoView.frame.size.height);
    levelImageView.frame = frame;
    self.selecteLevelView = levelImageView;
    [self.levelInfoView addSubview:levelImageView];
    self.playButton.alpha = 1;
    self.playButton.userInteractionEnabled = YES;
    if (previousSelectedView) {
        [previousSelectedView removeFromSuperview];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
@end
