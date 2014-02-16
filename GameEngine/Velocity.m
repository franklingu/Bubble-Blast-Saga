//
//  Velocity.m
//  ps04
//
//  Created by Gu Junchao on 2/11/14.
//
//

#import "Velocity.h"

@implementation Velocity

- (id)initWithXVelocity:(CGFloat)xVelocity YVelocity:(CGFloat)yVelocity
{
    self = [super init];
    if (self) {
        self.xVelocity = xVelocity;
        self.yVelocity = yVelocity;
    }
    
    return self;
}

@end
