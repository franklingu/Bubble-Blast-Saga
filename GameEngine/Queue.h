//
//  Queue.h
//  CS3217-PS1
//
//  Copyright (c) 2013 NUS CS3217. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int kQueueSizeOfEmptyQueue = 0;
static const int kQueueStartingIndexOfArray = 0;

@interface Queue : NSObject {
}

@property(nonatomic, readonly) NSMutableArray* elements;

+ (Queue *)queue;

- (void)enqueue:(id)obj;

- (id)dequeue;

- (id)peek;

- (NSUInteger)count;

- (void)removeAllObjects;

@end
