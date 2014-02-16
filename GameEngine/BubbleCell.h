//
//  BubbleGrid.h
//  ps03
//
//  Created by Gu Junchao on 2/1/14.
//
//

/**
 * this is subclassed from UICollectionViewCell to fulfill requirements
 * of dsiplaying circles--without the help subview
 */

#import <UIKit/UIKit.h>

@interface BubbleCell : UICollectionViewCell

- (void)setBubbleImage:(UIImageView*)image;
// EFFECTS: change the backgroundview for the cell based on given image and border

@end
