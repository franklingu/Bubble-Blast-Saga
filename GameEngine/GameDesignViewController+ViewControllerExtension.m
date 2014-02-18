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
    // REQUIRES: game in designer mode
    // EFFECTS: game state (grid) is saved by calling another method
    //          or saving will not happen because of invalid file name
    //          or ask for overwriting confirmation
    
    static NSString *plistExtension = @".plist";
    NSString* fileName = [[self.saveAlert textFieldAtIndex:0].text stringByAppendingString:plistExtension];
    if (![self isFileNameSuitable:fileName]) {
        UIAlertView* fileNameIllegalAlert = [[UIAlertView alloc] initWithTitle:@"Saving file"
                                                                 message:@"File name is not suitable."
                                                                 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [fileNameIllegalAlert show];
        return ;
    }
    if (![self.bubbleModelsManager isValidGraph]) {
        UIAlertView* invalidGraphAlert = [[UIAlertView alloc] initWithTitle:@"Saving file"
                                                                    message:@"Current design is not valid"
                                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [invalidGraphAlert show];
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
    // EFFECTS: the current game grid will be saved. overwriting may happen if this is
    //          called after user agrees to overwrite
    //          and reset the input field in saveAlert
    
    static NSString *plistExtension = @".plist";
    NSString* fileName = [[self.saveAlert textFieldAtIndex:0].text stringByAppendingString:plistExtension];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString* filePathToSave = [documentsPath stringByAppendingPathComponent:fileName];
    [self.bubbleModelsManager saveToFilePath:filePathToSave];
    [self resetInputFieldInSavingAlert];
}

- (void)resetInputFieldInSavingAlert
{
    // EFFECTS: the input field in saveAlert will be set to empty string
    
    NSString* emptyString = @"";
    [self.saveAlert textFieldAtIndex:0].text = emptyString;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // EFFECTS: if current alertView is saveAlert and user pressed the second button
    //              call save for further checking and processing
    //          else if current alertView is existingFileAlert and user pressed the second button
    //              call saveWithoutCheckingFileExistence to overwrite
    
    if (alertView.tag == 1 && buttonIndex == 1) {
        [self save];
    } else if (alertView.tag ==2 && buttonIndex == 1) {
        [self saveWithoutCheckingFileExistence];
    }
}

- (BOOL)isFileNameExisting:(NSString*)fileName
{
    // EFFECTS: returns YES if fileName exists in app document directory
    
    NSArray* filePaths = [self filesInAppDocumentDirectory];
    for (NSString* path in filePaths) {
        if ([fileName isEqualToString:path]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isFileNameSuitable:(NSString*)fileName
{
    // EFFECTS: returns NO if fileName is too long or to short
    //          (other checking may be added)
    
    static int maximumLengthOfString = 20;
    if (!fileName) {
        return NO;
    } else if (fileName.length<=6 || fileName.length>=maximumLengthOfString) {
        return NO;
    } else {
        return YES;
    }
}

- (void)load
{
    // MODIFIES: self (game bubbles in the grid)
    // REQUIRES: game in designer mode
    // EFFECTS: loadPopOverController will show up
    
    PopOverTableViewController *controller = (PopOverTableViewController*)self.loadPopOverController.contentViewController;
    controller.fileNames = [self fileNamesInAppDirectory];
    [controller.tableView reloadData];
    [self.loadPopOverController presentPopoverFromRect:self.loadButton.bounds inView:self.loadButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)reset
{
    // MODIFIES: self (game bubbles in the grid)
    // REQUIRES: game in designer mode
    // EFFECTS: current game bubbles in the grid are deleted
    
    [self.bubbleModelsManager resetAllBubbles];
    [self.bubblesGridArea reloadData];
}

@end
