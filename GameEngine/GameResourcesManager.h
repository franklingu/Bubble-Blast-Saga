//
//  GameResourcesManager.h
//  Bubble Blast Saga
//
//  Created by Gu Junchao on 2/28/14.
//
//

#import <Foundation/Foundation.h>

@interface GameResourcesManager : NSObject
- (NSArray *)fullFileNamesForLevelInAppDocumentDirectory;

- (NSArray *)fileNamesForLevelInAppDocumentDirectory;

- (NSArray *)fileNamesForPredefinedLevels;

- (NSString *)pathForPredifinedLevel:(NSString *)levelName;

- (NSString *)pathForUserDefinedLevel:(NSString *)levelName;

- (NSString *)pathForPredifinedLevelImage:(NSString *)levelName;

- (NSString *)pathForUserDefinedLevelImage:(NSString *)levelName;

- (NSString *)pathForBackgroundMusic:(NSString *)fileName;

- (NSString *)imageNameForColorType:(NSInteger)colorType;
@end
