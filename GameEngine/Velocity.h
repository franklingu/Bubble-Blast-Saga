//
//  Velocity.h
//  ps04
//
//  Created by Gu Junchao on 2/11/14.
//
//

#import <Foundation/Foundation.h>
@interface Velocity : NSObject

@property (nonatomic) CGFloat xVelocity;
@property (nonatomic) CGFloat yVelocity;

- (id)initWithXVelocity:(CGFloat)xVelocity YVelocity:(CGFloat)yVelocity;

@end
