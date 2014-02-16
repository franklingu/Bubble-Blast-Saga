//
//  PhysicsSpace.h
//  ps04
//
//  Created by Gu Junchao on 2/10/14.
//
//

#import <Foundation/Foundation.h>
#import "CircleShape.h"
#import "ObjectBody.h"
#import "MovableObjectBody.h"
#import "CircleShapeDelegate.h"
#import "PhysicsSpaceDelegate.h"

static const NSInteger kLeftWallNumber = 0;
static const NSInteger kRightWallNumber = 1;
static const NSInteger kUpperWallNumber = 2;
static const NSInteger kBottomWallNumber = 3;

@interface PhysicsSpace : NSObject <CircleShapeDelegate>

@property (nonatomic) CGRect frame;
@property (nonatomic) CGFloat timeInterval;
@property (nonatomic) BOOL positionUpdating;
@property (weak, nonatomic) id<PhysicsSpaceDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;

- (void)addCircleShape:(CircleShape *)shape;

- (void)destroyCircleShape:(CircleShape *)shape;

- (void)destroyCircleShapeWithIdentifier:(id)identifier;

- (CircleShape *)circleShapeWithIdentifier:(id)identifier;

- (void)update;

@end
