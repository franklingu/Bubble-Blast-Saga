//
//  PhysicsSpace.m
//  ps04
//
//  Created by Gu Junchao on 2/10/14.
//
//

#import "PhysicsSpace.h"

@interface PhysicsSpace ()

@property (strong, nonatomic) NSMutableArray* movableShapes;
@property (strong, nonatomic) NSMutableArray* positionChangedShapes;

@end

@implementation PhysicsSpace

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.movableShapes = [NSMutableArray new];
        self.positionChangedShapes = [NSMutableArray new];
        self.positionUpdating = NO;
    }
    
    return self;
}

- (void)addCircleShape:(CircleShape *)shape
{
    if ([shape.objectBody isKindOfClass:[MovableObjectBody class]]) {
        [self.movableShapes addObject:shape];
        shape.delegate = self;
    } else {
        NSLog(@"Shape err: %@", shape);
    }
}

- (void)destroyCircleShape:(CircleShape *)shape
{
    if (!shape) {
        return;
    }
    if ([shape.objectBody isKindOfClass:[MovableObjectBody class]]) {
        [self.movableShapes removeObject:shape];
    }
}

- (void)destroyCircleShapeWithIdentifier:(id)identifier
{
    [self destroyCircleShape:[self circleShapeWithIdentifier:identifier]];
}

- (CircleShape *)circleShapeWithIdentifier:(id)identifier
{
    for (CircleShape *circle in self.movableShapes) {
        if ([circle.identifier isEqual:identifier]) {
            return circle;
        }
    }
    
    return nil;
}

- (void)update
{
    for (CircleShape *circle in self.movableShapes) {
        [circle update];
    }
    [self checkCollisionForPositionChangedShapes];
}

- (void)circleShape:(CircleShape *)shape positionUpdated:(BOOL)updated
{
    if (updated) {
        [self.delegate circleShape:shape positionUpdated:YES];
        [self.positionChangedShapes addObject:shape];
    }
}

- (void)checkCollisionForPositionChangedShapes
{
    if ([self.positionChangedShapes count] == 0) {
        self.positionUpdating = NO;
        return ;
    } else {
        self.positionUpdating = YES;
    }
    
    for (CircleShape *circle in self.positionChangedShapes) {
        for (CircleShape *movableCircle in self.movableShapes) {
            // do not check for self
            if ([circle isEqual:movableCircle]) {
                continue;
            }
            if ([circle isCollidingWithCircleShape:movableCircle]) {  // the physical engine is not full--
                                                                      // so it is not going to solve this anyway
                [self handleShape:circle collideWithShape:movableCircle];
                break;
            }
        }
        
        MovableObjectBody *movable = (MovableObjectBody *)circle.objectBody;
        if (circle.objectBody.position.x < self.frame.origin.x+circle.radius) {
            BOOL result = [self.delegate collisionDetectedBetweeenCircleShape:circle andWall:kLeftWallNumber];
            if (result) {
                movable.velocity.xVelocity = -movable.velocity.xVelocity;
            }
        }
        if (circle.objectBody.position.x > self.frame.origin.x+self.frame.size.width-circle.radius) {
            BOOL result = [self.delegate collisionDetectedBetweeenCircleShape:circle andWall:kRightWallNumber];
            if (result) {
                movable.velocity.xVelocity = -movable.velocity.xVelocity;
            }
        }
        if (circle.objectBody.position.y > self.frame.origin.y+self.frame.size.height-circle.radius) {
            BOOL result = [self.delegate collisionDetectedBetweeenCircleShape:circle andWall:kBottomWallNumber];
            if (result) {
                movable.velocity.yVelocity = -movable.velocity.yVelocity;
            }
        }
        if (circle.objectBody.position.y < self.frame.origin.y+circle.radius) {
            BOOL result = [self.delegate collisionDetectedBetweeenCircleShape:circle andWall:kUpperWallNumber];
            if (result) {
                movable.velocity.yVelocity = -movable.velocity.yVelocity;
            }
        }
    }
    
    [self.positionChangedShapes removeAllObjects];
}

- (void)handleShape:(CircleShape *)shapeA collideWithShape:(CircleShape *)shapeB
{
    [self.delegate collisionDetectedBetweenCircleShape:shapeA andCircleShape:shapeB];
}

@end
