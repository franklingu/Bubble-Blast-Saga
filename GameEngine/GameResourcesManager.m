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
            if ([fileName isEqualToString:@"tmp"]) {
                continue;
            }
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
    return [[NSBundle mainBundle] pathForResource:levelName ofType:@"plist"];
}

- (NSString *)pathForUserDefinedLevel:(NSString *)levelName
{
    NSString *fullLevelName = [levelName stringByAppendingString:@".plist"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fullLevelName];
    
    return filePath;
}

- (NSString *)pathForPredifinedLevelImage:(NSString *)levelName
{
    return [[NSBundle mainBundle] pathForResource:levelName ofType:@"png"];
}

- (NSString *)pathForUserDefinedLevelImage:(NSString *)levelName
{
    NSString *fullLevelName = [levelName stringByAppendingString:@".png"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fullLevelName];
    
    return filePath;
}

- (NSString *)imageNameForColorType:(NSInteger)colorType
{
    NSString *imageName;
    switch ((int)colorType) {
        case kNoDisplayColorType:
            imageName = nil;
            break;
        case kBlueColorType:
            imageName = kBlueImageName;
            break;
        case kRedColorType:
            imageName = kRedImageName;
            break;
        case kOrangeColorType:
            imageName = kOrangeImageName;
            break;
        case kGreenColorType:
            imageName = kGreenImageName;
            break;
        case kStarColorType:
            imageName = kStarImageName;
            break;
        case kBombColorType:
            imageName = kBombImageName;
            break;
        case kLightningColorType:
            imageName = kLightningImageName;
            break;
        case kIndesturctibleColorType:
            imageName = kIndestructibleImageName;
            break;
        case kCandyRedColorType:
            imageName = kCandyRedImageName;
            break;
        case kCandyGreenColorType:
            imageName = kCandyGreenImageName;
            break;
        default:
            imageName = nil;
            break;
    }
    
    return [imageName copy];
}

@end
