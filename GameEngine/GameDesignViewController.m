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
@property (nonatomic) NSInteger numberOfRows;
@property (nonatomic) NSInteger currentFillingType;
@end

@implementation GameDesignViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeAttributes];
    [self setUpMainViews];
}

- (IBAction)buttonPressed:(id)sender
{
    static NSString *saveLabel = @"Save";
    static NSString *resetLabel = @"Reset";
    static NSString *loadLabel = @"Load";
    static NSString *returnLabel = @"Return";
    UIButton *button = (UIButton*)sender;
    
    if ([button.titleLabel.text isEqualToString:saveLabel]) {
        [self.saveAlert show];
    } else if ([button.titleLabel.text isEqualToString:resetLabel]) {
        [self reset];
    } else if ([button.titleLabel.text isEqualToString:loadLabel]) {
        [self load];
    } else if ([button.titleLabel.text isEqualToString:returnLabel]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)colorSelectorPressed:(id)sender
{
    UIButton* colorSelectorButton = (UIButton*)sender;
    for (int i=0; i<kNumberOfBubbleModelKinds; i++) {
        UIButton* button = (UIButton*)[self.palette viewWithTag:i];
        button.alpha = 0.5;
    }
    colorSelectorButton.alpha = 1;
    self.currentFillingType = colorSelectorButton.tag % kNumberOfBubbleModelKinds;
}

- (void)initializeAttributes
{
    self.currentFillingType = 1;
    self.numberOfRows = 13;
    self.bubbleModelsManager = [[BubbleModelsManager alloc] init];
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
                                                 message:@"Enter a name for the current level"
                                                 delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    saveAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [saveAlert setTag:1];
    self.saveAlert = saveAlert;
    UIAlertView* existingFileAlert = [[UIAlertView alloc] initWithTitle:@"Saving file"
                                                          message:@"File with the same name exists\nOverwrite existing file?"
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
    [self.bubblesGridArea registerClass:[BubbleCell class] forCellWithReuseIdentifier:@"bubbleCell"];
    [self.bubblesGridArea setDataSource:self];
    [self.bubblesGridArea setDelegate:self];
    self.bubblesGridArea.layer.zPosition = 1;
    [self createGesturesRecognizers];
}

- (void)createGesturesRecognizers
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(handleTapGesture:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.bubblesGridArea addGestureRecognizer:tapRecognizer];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc]
                                                         initWithTarget:self
                                                         action:@selector(handleLongPressGesture:)];
    longPressRecognizer.minimumPressDuration = 0.5f;
    [self.bubblesGridArea addGestureRecognizer:longPressRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(handlePanGesture:)];
    panRecognizer.minimumNumberOfTouches = 1;
    panRecognizer.maximumNumberOfTouches = 1;
    [self.bubblesGridArea addGestureRecognizer:panRecognizer];
}

- (void)handleTapGesture:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [gesture locationInView:self.bubblesGridArea];
        NSIndexPath *indexPath = [self.bubblesGridArea indexPathForItemAtPoint:location];
        if (!indexPath) {
            return ;
        }
        NSInteger colorType = [self.bubbleModelsManager colorTypeForBubbleAtItem:indexPath.item];
        if (colorType == kNoDisplayColorType) {
            return ;
        }
        colorType = (colorType+1)%kNumberOfBubbleModelKinds;
        if (colorType == kNoDisplayColorType) {
            colorType++;
        }
        [self.bubbleModelsManager setColorType:colorType forBubbleModelAtItem:indexPath.item];
        [self setColorType:colorType forCellAtItem:indexPath.item];
    }
}

- (void)handleLongPressGesture:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [gesture locationInView:self.bubblesGridArea];
        NSIndexPath *indexPath = [self.bubblesGridArea indexPathForItemAtPoint:location];
        if (!indexPath) {
            return ;
        }
        [self.bubbleModelsManager setColorType:kNoDisplayColorType forBubbleModelAtItem:indexPath.item];
        [self setColorType:kNoDisplayColorType forCellAtItem:indexPath.item];
    }
}

- (void)handlePanGesture:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged
        || gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [gesture locationInView:self.bubblesGridArea];
        NSIndexPath *indexPath = [self.bubblesGridArea indexPathForItemAtPoint:location];
        if (!indexPath) {
            return ;
        }
        [self.bubbleModelsManager setColorType:self.currentFillingType forBubbleModelAtItem:indexPath.item];
        [self setColorType:self.currentFillingType forCellAtItem:indexPath.item];
    }
}

- (UIImage *)imageWithColorType:(NSInteger)colorType
{
    UIImage *image;
    switch ((int)colorType) {
        case 0:
            image = nil;
            break;
        case 1:
            image = [UIImage imageNamed:kBlueImageName];
            break;
        case 2:
            image = [UIImage imageNamed:kRedImageName];
            break;
        case 3:
            image = [UIImage imageNamed:kOrangeImageName];
            break;
        case 4:
            image = [UIImage imageNamed:kGreenImageName];
            break;
        case 5:
            image = [UIImage imageNamed:kStarImageName];
            break;
        case 6:
            image = [UIImage imageNamed:kBombImageName];
            break;
        case 7:
            image = [UIImage imageNamed:kLightningImageName];
            break;
        case 8:
            image = [UIImage imageNamed:kIndestructibleImageName];
            break;
        default:
            image = nil;
            break;
    }
    
    return image;
}

- (void)setColorType:(NSInteger)colorType forCellAtItem:(NSInteger)item
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    BubbleCell *cell = (BubbleCell *)[self.bubblesGridArea cellForItemAtIndexPath:indexPath];
    UIImage *image = [self imageWithColorType:colorType];
    if (image) {
        [cell setBubbleImage:[[UIImageView alloc] initWithImage:image]];
    } else {
        [cell setBubbleImage:nil];
    }
}

- (void)setColorType:(NSInteger)colorType forCell:(BubbleCell *)cell
{
    UIImage *image = [self imageWithColorType:colorType];
    if (image) {
        [cell setBubbleImage:[[UIImageView alloc] initWithImage:image]];
    } else {
        [cell setBubbleImage:nil];
    }
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
    [self.bubbleModelsManager loadFromFilePath:filePath];
    [self.bubblesGridArea reloadData];
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
    
    BubbleModel *bubble = [self.bubbleModelsManager bubbleAtItem:indexPath.item];
    if (bubble) {
        [self setColorType:bubble.colorType forCell:(BubbleCell *)cell];
    } else {
        UICollectionViewLayoutAttributes *attr = [self.bubblesGridArea.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
        CGPoint center = CGPointMake(attr.center.x, attr.center.y+25);
        [self.bubbleModelsManager addBubbleAtItem:indexPath.item colorType:kNoDisplayColorType center:center radius:32];
    }
    
    return cell;
}

@end
