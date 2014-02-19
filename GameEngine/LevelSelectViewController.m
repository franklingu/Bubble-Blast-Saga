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
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    UIImage* backgroundImage = [UIImage imageNamed:@"background.png"];
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
    self.levelInfoView.layer.zPosition = 1;
    self.returnButton.layer.zPosition = 1;
    self.playButton.layer.zPosition = 1;
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

- (NSArray*)fileNamesInAppDirectory
{
    static NSString *plistExtension = @".plist";
    NSArray *files = [self filesInAppDocumentDirectory];
    NSMutableArray *fileNames = [[NSMutableArray alloc] init];
    
    for (NSString* file in files) {
        NSRange range = [file rangeOfString:plistExtension options:NSBackwardsSearch];
        NSString* fileName = [file substringWithRange:NSMakeRange(0, range.location)];
        [fileNames addObject:fileName];
    }
    
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
    
    @try {
        NSString* fileName = self.fileNames[indexPath.row];
        cell.textLabel.text = fileName;
    }
    @catch (NSException *exception) {
        NSLog(@"loading row for table view:\n%@", exception.description);
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
        //[self.delegate selectedFileName:selectedFileName];
        NSLog(@"%@", selectedFileName);
    }
    @catch (NSException *exception) {
        NSLog(@"selecting row in table view:\n%@", exception.description);
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
@end
