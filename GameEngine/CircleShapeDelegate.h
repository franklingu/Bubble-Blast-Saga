//
//  PhysicsShapeDelegate.h
//  ps04
//
//  Created by Gu Junchao on 2/12/14.
//
//

#import <Foundation/Foundation.h>

@class CircleShape;

@protocol CircleShapeDelegate <NSObject>

// inform about position updating of the shape
- (void)circleShape:(CircleShape *)shape positionUpdated:(BOOL)updated;

// return time interval
- (CGFloat)timeInterval;

@end
