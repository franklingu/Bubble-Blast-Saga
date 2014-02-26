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
    self.fileNames = [self fileNamesInAppDirectory];
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
}

- (IBAction)returnPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray*)filesInAppDocumentDirectory
{
    NSError *readingFilesError = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:paths[0] error:&readingFilesError];
    if (readingFilesError) {
        NSLog(@"error in reading files: %@", readingFilesError);
    }
    
    return files;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"playSceneSegue"]) {
        AnimateViewController *playViewController = segue.destinationViewController;
        NSString *fileName = [self.selectedFileName stringByAppendingString:@".plist"];
        [playViewController configureLoadingFilePathByFileName:fileName];
    }
}

- (NSArray*)fileNamesInAppDirectory
{
    // put in constant file
    static NSString *plistExtension = @".plist";
    NSArray *files = [self filesInAppDocumentDirectory];
    NSMutableArray *fileNames = [[NSMutableArray alloc] init];
    
    for (NSString* file in files) {
        NSRange range = [file rangeOfString:plistExtension options:NSBackwardsSearch];
        NSString* fileName = [file substringWithRange:NSMakeRange(0, range.location)];
        [fileNames addObject:fileName];
    }
    [fileNames addObject:@"Level-1"];
    [fileNames addObject:@"Level-2"];
    [fileNames addObject:@"Level-3"];
    [fileNames addObject:@"Level-4"];
    [fileNames addObject:@"Level-5"];
    
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
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        NSString* selectedFileName = self.fileNames[indexPath.row];
        self.selectedFileName = selectedFileName;
        self.playButton.alpha = 1;
        self.playButton.userInteractionEnabled = YES;
    }
    @catch (NSException *exception) {
        NSLog(@"selecting row failure in table view:\n%@", exception.description);
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
@end
