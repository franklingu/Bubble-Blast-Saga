//
//  GameResourcesManager.m
//  Bubble Blast Saga
//
//  Created by Gu Junchao on 2/28/14.
//
//

#import "GameResourcesManager.h"

@implementation GameResourcesManager

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (NSArray *)fullFileNamesForLevelInAppDocumentDirectory
{
    NSError *readingFilesError = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:paths[0] error:&readingFilesError];
    if (readingFilesError) {
        NSLog(@"error in reading files: %@", readingFilesError);
    }
    
    return files;
}

- (NSArray *)fileNamesForLevelInAppDocumentDirectory
{
    static NSString *plistExtension = @".plist";
    NSArray *files = [self fullFileNamesForLevelInAppDocumentDirectory];
    NSMutableArray *fileNames = [[NSMutableArray alloc] init];
    
    for (NSString* file in files) {
        NSRange range = [file rangeOfString:plistExtension options:NSBackwardsSearch];
        if (range.location < file.length) {
            NSString* fileName = [file substringWithRange:NSMakeRange(0, range.location)];
            [fileNames addObject:fileName];
        }
    }
    
    return fileNames;
}

- (NSArray *)fileNamesForPredefinedLevels
{
    NSMutableArray *predefinedLevels = [NSMutableArray new];
    [predefinedLevels addObject:@"Level-1"];
    [predefinedLevels addObject:@"Level-2"];
    [predefinedLevels addObject:@"Level-3"];
    
    return predefinedLevels;
}

- (NSString *)pathForPredifinedLevel:(NSString *)levelName
{
    return nil;
}

- (NSString *)pathForUserDefinedLevel:(NSString *)levelName
{
    return nil;
}

- (NSString *)pathForPredifinedLevelImage:(NSString *)levelName
{
    return nil;
}

- (NSString *)pathForUserDefinedLevelImage:(NSString *)levelName
{
    return nil;
}

- (NSString *)pathForBackgroundMusic:(NSString *)fileName
{
    return nil;
}

- (NSString *)imageNameForColorType:(NSInteger)colorType
{
    return nil;
}

@end
