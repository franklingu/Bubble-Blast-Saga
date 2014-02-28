//
//  WelcomeViewController.m
//  ps04
//
//  Created by Gu Junchao on 2/10/14.
//
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()
@end

@implementation WelcomeViewController

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
	
    UIImage* backgroundImage = [UIImage imageNamed:@"water-sky.png"];
    UIImageView* background = [[UIImageView alloc] initWithImage:backgroundImage];
    CGFloat gameViewWidth = self.welcomeView.frame.size.width;
    CGFloat gameViewHeight = self.welcomeView.frame.size.height;
    background.frame = CGRectMake(0, 0, gameViewWidth, gameViewHeight);
    [self.welcomeView addSubview:background];
    [self.welcomeView sendSubviewToBack:background];
    self.designMode.layer.zPosition = 1;
    self.playMode.layer.zPosition = 1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

@end
