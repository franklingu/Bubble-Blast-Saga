//
//  GraphDelegate.h
//  ps04
//
//  Created by Gu Junchao on 2/13/14.
//
//

#import <Foundation/Foundation.h>

@protocol GraphDelegate <NSObject>

// remove the display in cell
- (void)removeCellAtItem:(NSInteger)item;

// drop the display in cell
- (void)dropCellAtItem:(NSInteger)item;

// add display to cell based on given colorType
- (void)addCellAtItem:(NSInteger)item withColorType:(NSInteger)colorType;

// update the bubble view represented by "identifier" to the given position
- (void)updateGameBubbleViewWithIdentifier:(id)identifier toPosition:(CGPoint)position;

// remove/stop displaying the bubble view "identifier" to the given position
- (void)removeGameBubbleViewWithIdentifier:(id)identifier;

// return the item number based on given location
- (NSInteger)indexPathItemForLocation:(CGPoint)location;

- (void)fireBubble;

@end
