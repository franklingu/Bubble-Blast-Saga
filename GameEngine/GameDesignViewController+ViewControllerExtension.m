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
    static NSString *plistExtension = @".plist";
    NSString *fileName = [self.saveAlert textFieldAtIndex:0].text;
    NSString *fullFileName = [fileName stringByAppendingString:plistExtension];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePathToSave = [documentsPath stringByAppendingPathComponent:fullFileName];
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data = UIImagePNGRepresentation(image);
    NSString *fullImageName = [fileName stringByAppendingString:@".png"];
    NSString *imagePathToSave = [documentsPath stringByAppendingPathComponent:fullImageName];
    [data writeToFile:imagePathToSave atomically:YES];
    
    [self.bubbleModelsManager saveToFilePath:filePathToSave];
    [self resetInputFieldInSavingAlert];
}

- (void)resetInputFieldInSavingAlert
{
    NSString* emptyString = @"";
    [self.saveAlert textFieldAtIndex:0].text = emptyString;
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
    static NSString *plistExtension = @".plist";
    NSString* fileNameWithExtension = [[self.saveAlert textFieldAtIndex:0].text stringByAppendingString:plistExtension];
    NSArray* filePaths = [self fullFileNamesInAppDocumentDirectory];
    for (NSString* path in filePaths) {
        if ([fileNameWithExtension isEqualToString:path]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isFileNameSuitable:(NSString*)fileName
{
    static int maximumLengthOfString = 20;
    static int minimumLengthOfString = 4;
    
    if (!fileName) {
        return NO;
    } else if (fileName.length <= minimumLengthOfString || fileName.length >= maximumLengthOfString) {
        return NO;
    } else if ([fileName rangeOfString:@"."].location != NSNotFound) {
        return NO;
    } else if ([[fileName substringWithRange:NSMakeRange(0, 5)] isEqualToString:@"Level"]) {
        return NO;
    }else {
        return YES;
    }
}

- (void)load
{
    PopOverTableViewController *controller = (PopOverTableViewController*)self.loadPopOverController.contentViewController;
    controller.fileNames = [self fileNamesInAppDirectory];
    [controller.tableView reloadData];
    [self.loadPopOverController presentPopoverFromRect:self.loadButton.bounds inView:self.loadButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)reset
{
    [self.bubbleModelsManager resetAllBubbles];
    [self.bubblesGridArea reloadData];
}

@end
