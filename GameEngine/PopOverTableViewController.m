//
//  PopOverTableViewController.m
//  ps03
//
//  Created by Gu Junchao on 2/6/14.
//
//

#import "PopOverTableViewController.h"

@interface PopOverTableViewController ()

@end

@implementation PopOverTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.fileNames = nil;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:PopOverTableViewCellIdentifier];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSInteger estimatedCellHeight = 50;
    NSInteger contentWidth = 100;
    NSInteger contentHeight = [self.fileNames count]*estimatedCellHeight;
    self.preferredContentSize = CGSizeMake(contentWidth, contentHeight);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.fileNames) {
        return [self.fileNames count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PopOverTableViewCellIdentifier forIndexPath:indexPath];
    
    @try {
        NSString* fileName = self.fileNames[indexPath.row];
        cell.textLabel.text = fileName;
    }
    @catch (NSException *exception) {
        NSLog(@"loading row for table view:\n%@", exception.description);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        NSString* deletedFileName = self.fileNames[indexPath.row];
        [self.delegate deletedFileName:deletedFileName];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    @catch (NSException *exception) {
        NSLog(@"deleting row in table view:\n%@", exception.description);
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        NSString* selectedFileName = self.fileNames[indexPath.row];
        [self.delegate selectedFileName:selectedFileName];
    }
    @catch (NSException *exception) {
        NSLog(@"selecting row in table view:\n%@", exception.description);
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

@end
