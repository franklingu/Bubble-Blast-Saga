//
//  MovableObjectBody.h
//  ps04
//
//  Created by Gu Junchao on 2/12/14.
//
//

/**
 * ObjectBody that can move--so velocity are added. If force is considered later, add it here.
 */

#import "ObjectBody.h"
#import "Velocity.h"

@interface MovableObjectBody : ObjectBody

@property (strong, nonatomic) Velocity *velocity;

- (void)update;

@end
