//
//  BubbleGameAreaViewLayout.h
//  ps03
//
//  Created by Gu Junchao on 2/1/14.
//
//

/**
 * this class is subclassed from UICollectionViewLayout to make a customizable
 * layout for cells. basically this is gonna set the cells in rect of 
 * (width/12)*(width/12) and try to organize the cells at the next row with special
 * indent--following triangular shape
 *
 * some more efforts are needed to make this more generic
 */

#import <UIKit/UIKit.h>

@interface BubbleGameAreaViewLayout : UICollectionViewLayout

@property (nonatomic) NSInteger numberOfItems;

@end
