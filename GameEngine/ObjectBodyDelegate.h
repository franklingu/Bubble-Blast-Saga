//
//  ObjectBodyDelegate.h
//  ps04
//
//  Created by Gu Junchao on 2/11/14.
//
//

#import <Foundation/Foundation.h>

@class ObjectBody;

@protocol ObjectBodyDelegate <NSObject>

// inform about the changing of objectBody's position
- (void)objectBody:(ObjectBody*)object positionUpdated:(BOOL)updated;

// return timerInterval for position updating calculation
- (CGFloat)timeInterval;

@end
