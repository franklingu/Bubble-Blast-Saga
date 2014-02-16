//
//  MovableObjectBody.m
//  ps04
//
//  Created by Gu Junchao on 2/12/14.
//
//

#import "MovableObjectBody.h"

@implementation MovableObjectBody

- (void)update
{
    if (self.mass == 0) {
        return;
    }
    
    CGFloat xDistance = self.velocity.xVelocity * [self.delegate timeInterval];
    CGFloat yDistance = self.velocity.yVelocity * [self.delegate timeInterval];
    if (xDistance != 0 || yDistance != 0) {
        self.position = CGPointMake(self.position.x + xDistance, self.position.y + yDistance);
        [self.delegate objectBody:self positionUpdated:YES];
    }
}

@end
