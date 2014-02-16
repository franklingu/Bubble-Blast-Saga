//
//  GameBubbleCell.m
//  ps04
//
//  Created by Gu Junchao on 2/10/14.
//
//

#import "GameBubbleCell.h"

@implementation GameBubbleCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = 32.0f;
    }
    return self;
}

- (void)setBubbleImage:(UIImageView *)image
{
    // EFFECTS: change the backgroundview for the cell based on given image and border
    
    if (image) {
        self.backgroundView = image;
    } else {
        self.backgroundView = nil;
    }
}

@end
