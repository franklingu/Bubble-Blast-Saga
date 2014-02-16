//
//  CircleShape.m
//  ps04
//
//  Created by Gu Junchao on 2/10/14.
//
//

#import "CircleShape.h"

@implementation CircleShape

- (id)initWithObjectBody:(ObjectBody *)objectBody radius:(CGFloat)radius uniqueIdentifier:(id)identifier
{
    if (radius <= 0) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.objectBody = objectBody;
        self.objectBody.delegate = self;
        self.center = objectBody.position;
        self.radius = radius;
        self.identifier = identifier;
    }
    
    return self;
}

- (BOOL)isCollidingWithCircleShape:(CircleShape *)circle
{
    CGFloat distanceSquare = pow((self.center.x - circle.center.x), 2) + pow((self.center.y - circle.center.y), 2);
    CGFloat radiusesSquare = pow((self.radius + circle.radius), 2);
    
    if (distanceSquare < radiusesSquare) {
        return YES;
    }
    return distanceSquare < radiusesSquare;
}

- (void)update
{
    if ([self.objectBody isKindOfClass:[MovableObjectBody class]]) {
        MovableObjectBody *movableObject = (MovableObjectBody *)self.objectBody;
        [movableObject update];
    }
}

- (void)objectBody:(ObjectBody *)object positionUpdated:(BOOL)updated
{
    if (updated) {
        self.center = self.objectBody.position;
        [self.delegate circleShape:self positionUpdated:YES];
    }
}

- (CGFloat)timeInterval
{
    return [self.delegate timeInterval];
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[CircleShape class]]) {
        CircleShape *circle = (CircleShape *)object;
        return [self.identifier isEqual:circle.identifier];
    }
    
    return NO;
}

@end
