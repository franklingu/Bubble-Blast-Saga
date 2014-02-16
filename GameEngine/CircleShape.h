//
//  CircleShape.h
//  ps04
//
//  Created by Gu Junchao on 2/10/14.
//
//

/**
 * the physical shape of the physical object--in this case, circle. so property radius is added
 */

#import <Foundation/Foundation.h>
#import "ObjectBody.h"
#import "MovableObjectBody.h"
#import "ObjectBodyDelegate.h"
#import "CircleShapeDelegate.h"

@interface CircleShape : NSObject <ObjectBodyDelegate>

@property (nonatomic) ObjectBody* objectBody;
@property (nonatomic) id identifier;
@property (weak, nonatomic) id<CircleShapeDelegate> delegate;
@property (nonatomic) CGPoint center;
@property (nonatomic) CGFloat radius;

- (id)initWithObjectBody:(ObjectBody *)objectBody radius:(CGFloat)radius uniqueIdentifier:(id)identifier;

- (BOOL)isCollidingWithCircleShape:(CircleShape*)circle;

- (void)update;

@end
