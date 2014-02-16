//
//  BubbleGrid.m
//  ps03
//
//  Created by Gu Junchao on 2/1/14.
//
//

#import "BubbleCell.h"

@interface BubbleCell ()
@end

@implementation BubbleCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.cornerRadius = 32.0f;
        self.layer.borderWidth = 1.5f;
    }
    return self;
}

- (void)setBubbleImage:(UIImageView *)image
{
    // EFFECTS: change the backgroundview for the cell based on given image and border
    
    if (image) {
        self.backgroundView = image;
        self.layer.borderWidth = 0;
    } else {
        self.backgroundView = nil;
        self.layer.borderWidth = 1.5f;
    }
}

@end
