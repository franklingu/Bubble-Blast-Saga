//
//  PhysicsSpaceDelegate.h
//  ps04
//
//  Created by Gu Junchao on 2/12/14.
//
//

#import <Foundation/Foundation.h>

@class CircleShape;

@protocol PhysicsSpaceDelegate <NSObject>

// ask about whether the simulation should continue or not, if no, stop current simulation
- (BOOL)collisionDetectedBetweenCircleShape:(CircleShape *)shapeA andCircleShape:(CircleShape *)shapeB;

// ask about whether the simulation should continue or not, if YES, then continue simulation
- (BOOL)collisionDetectedBetweeenCircleShape:(CircleShape *)shape andWall:(NSInteger)wallNumber;

// inform about position-change of the circleShape
- (void)circleShape:(CircleShape *)shape positionUpdated:(BOOL)updated;

@end
