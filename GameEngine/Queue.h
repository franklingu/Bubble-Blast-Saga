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

// Class method which creates and returns an empty queue.
+ (Queue *)queue;

// Adds an object to the tail of the queue.
- (void)enqueue:(id)obj;

// Removes and returns the object at the head of the queue.
// If the queue is empty, returns `nil'.
- (id)dequeue;

// Returns, but does not remove, the object at the head of the queue.
// If the queue is empty, returns `nil'.
- (id)peek;

// Returns the number of objects currently in the queue.
- (NSUInteger)count;

// Removes all objects in the queue.
- (void)removeAllObjects;

@end
