//
//  BubbleModels.h
//  Bubble Blast Saga
//
//  Created by Gu Junchao on 2/18/14.
//
//

#import <Foundation/Foundation.h>
#import "BubbleModel.h"

@interface BubbleModelsManager : NSObject

- (id)initWithFilePath:(NSString *)filePath;

- (void)saveToFilePath:(NSString *)filePath;

- (void)loadFromFilePath:(NSString *)filePath;

- (void)addBubbleAtItem:(NSInteger)item colorType:(NSInteger)colorType center:(CGPoint)center radius:(CGFloat)radius;

- (BubbleModel *)bubbleAtItem:(NSInteger)item;

- (NSArray *)bubblesShouldBeDisplayed;

- (NSInteger)colorTypeForBubbleAtItem:(NSInteger)item;

- (void)setColorType:(NSInteger)colorType forBubbleModelAtItem:(NSInteger)item;

- (void)resetAllBubbles;

- (BOOL)isValidGraph;

- (NSArray *)bubblesToDrop;

- (NSArray *)toBeRemovedBubblesStartingFromItem:(NSInteger)item;

- (NSInteger)numberOfVisibleBubbles;

@end
