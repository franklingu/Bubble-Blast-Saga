//
//  ViewController.m
//  Game
//
//  Created by Gu Junchao on 1/28/14.
//
//

#import "GameDesignViewController.h"
#import "BubbleCell.h"
#import "GameDesignViewController+ViewControllerExtension.h"

@interface GameDesignViewController ()
@property (nonatomic)         NSInteger numberOfRows;
@end

@implementation GameDesignViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeAttributes];
    [self setUpMainViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"receive memory warning");
}

- (IBAction)buttonPressed:(id)sender
{
    static NSString *saveLabel = @"Save";
    static NSString *resetLabel = @"Reset";
    static NSString *loadLabel = @"Load";
    UIButton *button = (UIButton*)sender;
    
    if ([button.titleLabel.text isEqualToString:saveLabel]) {
        [self.saveAlert show];
    } else if ([button.titleLabel.text isEqualToString:resetLabel]) {
        [self reset];
    } else if ([button.titleLabel.text isEqualToString:loadLabel]) {
        [self load];
    }
}

- (IBAction)colorSelectorPressed:(id)sender
{
    UIButton* colorSelectorButton = (UIButton*)sender;
    self.gameBubblesController.currentSelectedFillingType = [sender tag]%5;
    for (int i=1; i<=5; i++) {
        UIButton* button = (UIButton*)[self.palette viewWithTag:i];
        button.alpha = 0.5;
    }
    colorSelectorButton.alpha = 1;
}

- (void)initializeAttributes
{
    self.gameBubblesController = [[GameBubblesController alloc] initWithNibName:nil bundle:nil
                                                                 bubbleGridArea:self.bubbleGridArea];
    self.numberOfRows = 13;
}

- (void)setUpMainViews
{
    UIImage* backgroundImage = [UIImage imageNamed:@"background.png"];
    UIImageView* background = [[UIImageView alloc] initWithImage:backgroundImage];
    CGFloat gameViewWidth = self.gameArea.frame.size.width;
    CGFloat gameViewHeight = self.gameArea.frame.size.height;
    background.frame = CGRectMake(0, 0, gameViewWidth, gameViewHeight);
    [self.gameArea addSubview:background];
    self.palette.layer.zPosition = 1;
    UIAlertView* saveAlert= [[UIAlertView alloc] initWithTitle:@"Saving file"
                                                 message:@"Do you want to save the current design"
                                                 delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    saveAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [saveAlert setTag:1];
    self.saveAlert = saveAlert;
    UIAlertView* existingFileAlert = [[UIAlertView alloc] initWithTitle:@"Saving file"
                                                          message:@"File with the same name exists"
                                                          delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [existingFileAlert setTag:2];
    self.existingFileAlert = existingFileAlert;
    
    PopOverTableViewController* table = [[PopOverTableViewController alloc] initWithStyle:UITableViewStylePlain];
    table.delegate = self;
    UIPopoverController* loadPopOver = [[UIPopoverController alloc]
                                     initWithContentViewController:table];
    loadPopOver.delegate = self;
    self.loadPopOverController = loadPopOver;
    
    [self setUpCollectionView];
}

- (void)setUpCollectionView
{
    [self.bubbleGridArea registerClass:[BubbleCell class] forCellWithReuseIdentifier:@"bubbleCell"];
    [self.bubbleGridArea setDataSource:self];
    [self.bubbleGridArea setDelegate:self];
    self.bubbleGridArea.layer.zPosition = 1;
    [self createGesturesRecognizers];
}

- (void)createGesturesRecognizers
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self.gameBubblesController action:@selector(handleTapGesture:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.bubbleGridArea addGestureRecognizer:tapRecognizer];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc]
                                                         initWithTarget:self.gameBubblesController
                                                         action:@selector(handleLongPressGesture:)];
    longPressRecognizer.minimumPressDuration = 0.5f;
    [self.bubbleGridArea addGestureRecognizer:longPressRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]
                                             initWithTarget:self.gameBubblesController action:@selector(handlePanGesture:)];
    panRecognizer.minimumNumberOfTouches = 1;
    panRecognizer.maximumNumberOfTouches = 1;
    [self.bubbleGridArea addGestureRecognizer:panRecognizer];
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

- (void)selectedFileName:(NSString *)fileName
{
    static NSString* plistExtension = @".plist";
    [self.loadPopOverController dismissPopoverAnimated:YES];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *fileWithExtension = [documentsPath stringByAppendingPathComponent:fileName];
    NSString *filePath = [fileWithExtension stringByAppendingString:plistExtension];
    [self.gameBubblesController loadFromFile:filePath];
}

- (void)deletedFileName:(NSString *)fileName
{
    static NSString* plistExtension = @".plist";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *fileWithExtension = [documentsPath stringByAppendingPathComponent:fileName];
    NSString *filePath = [fileWithExtension stringByAppendingString:plistExtension];
    NSError *deletingError = nil;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&deletingError];
    if (deletingError) {
        NSLog(@"error in deleting file:\n%@", deletingError);
    }
    PopOverTableViewController* controller = (PopOverTableViewController*)self.loadPopOverController.contentViewController;
    controller.fileNames = [self fileNamesInAppDirectory];
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return YES;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberOfDoubleRows = self.numberOfRows/2;
    NSInteger numberOfRowLeft = self.numberOfRows%2;
    return 23*(int)numberOfDoubleRows+12*(int)numberOfRowLeft;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BubbleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bubbleCell" forIndexPath:indexPath];
    if (self.gameBubblesController.allModelDataFromFile) {
        [self.gameBubblesController setColorTypeForCell:cell atIndexPath:indexPath];
    } else {
        [self.gameBubblesController addGameBubbleAtIndexPathItem:indexPath andColorType:0];
    }
    
    return cell;
}

@end
