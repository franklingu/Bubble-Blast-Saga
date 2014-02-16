//
//  ObjectBody.m
//  ps04
//
//  Created by Gu Junchao on 2/11/14.
//
//

#import "ObjectBody.h"

@implementation ObjectBody

- (id)initWithPosition:(CGPoint)position mass:(CGFloat)mass
{
    self = [super init];
    if (self) {
        self.position = position;
        self.mass = mass;
    }
    
    return self;
}

@end
