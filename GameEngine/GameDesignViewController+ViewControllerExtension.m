//
//  ViewController+ViewControllerExtension.m
//  ps03
//
//  Created by Gu Junchao on 2/2/14.
//
//

#import "GameDesignViewController+ViewControllerExtension.h"

@implementation GameDesignViewController (Extension)

- (void)save
{
    NSString* fileName = [self.saveAlert textFieldAtIndex:0].text;
    if (![self isFileNameSuitable:fileName]) {
        UIAlertView* fileNameIllegalAlert = [[UIAlertView alloc] initWithTitle:@"Saving file"
                                                                 message:@"File name is not suitable."
                                                                 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [fileNameIllegalAlert show];
        return ;
    }
    if (![self.bubbleModelsManager isValidGraph]) {
        [self.invalidGraphAlert show];
        return ;
    }
    
    if ([self isFileNameExisting:fileName]) {
        [self.existingFileAlert show];
    } else {
        [self saveWithoutCheckingFileExistence];
    }
}

- (void)saveWithoutCheckingFileExistence
{
    NSString *fileName = [self.saveAlert textFieldAtIndex:0].text;
    NSString *filePathToSave = [self.resourceManager pathForUserDefinedLevel:fileName];
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data = UIImagePNGRepresentation(image);
    NSString *imagePathToSave = [self.resourceManager pathForUserDefinedLevelImage:fileName];
    [data writeToFile:imagePathToSave atomically:YES];
    
    [self.bubbleModelsManager saveToFilePath:filePathToSave];
    [self resetInputFieldInSavingAlert];
}

- (void)resetInputFieldInSavingAlert
{
    [self.saveAlert textFieldAtIndex:0].text = kEmptyString;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1 && buttonIndex == 1) {
        [self save];
    } else if (alertView.tag ==2 && buttonIndex == 1) {
        [self saveWithoutCheckingFileExistence];
    }
}

- (BOOL)isFileNameExisting:(NSString*)fileName
{
    NSArray *fileNamesInApp = [self.resourceManager fileNamesForLevelInAppDocumentDirectory];
    for (NSString* name in fileNamesInApp) {
        if ([fileName isEqualToString:name]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isFileNameSuitable:(NSString*)fileName
{
    if (!fileName) {
        return NO;
    } else if (fileName.length < kMinimumLengthOfLevelName || fileName.length > kMaximumLengthOfLevelName) {
        return NO;
    } else if ([fileName rangeOfString:kDotString].location != NSNotFound) {
        return NO;
    } else if (fileName.length > kMinimumLengthOfLevelName &&
               [[fileName substringWithRange:NSMakeRange(0, kMinimumLengthOfLevelName + 1)] isEqualToString:kPredefinePrefix]) {
        return NO;
    }else {
        return YES;
    }
}

- (void)load
{
    PopOverTableViewController *controller = (PopOverTableViewController*)self.loadPopOverController.contentViewController;
    controller.fileNames = [self.resourceManager fileNamesForLevelInAppDocumentDirectory];
    [controller.tableView reloadData];
    [self.loadPopOverController presentPopoverFromRect:self.loadButton.bounds
                                                inView:self.loadButton permittedArrowDirections:UIPopoverArrowDirectionAny
                                              animated:YES];
}

- (void)reset
{
    [self.bubbleModelsManager resetAllBubbles];
    [self.bubblesGridArea reloadData];
}

@end
