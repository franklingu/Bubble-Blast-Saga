//
//  ObjectBody.h
//  ps04
//
//  Created by Gu Junchao on 2/11/14.
//
//

/**
 * ObjectBody represents the "heart" of the physics object. Mass and position are stored here. If the engine
 * scales up and more properties like elasticity, torque and so on are added in, they will be here.
 */

#import <Foundation/Foundation.h>
#import "ObjectBodyDelegate.h"

@interface ObjectBody : NSObject

@property (nonatomic)         CGPoint position;
@property (nonatomic)         CGFloat mass;
@property (weak, nonatomic)   id<ObjectBodyDelegate> delegate;

- (id)initWithPosition:(CGPoint)position mass:(CGFloat)mass;

@end
