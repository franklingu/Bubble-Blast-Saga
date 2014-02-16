//
//  Queue.m
//  CS3217-PS1
//
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import "Queue.h"

@implementation Queue

+ (Queue *)queue {
    return [[Queue alloc] init];
}

- (id)init {
    if ((self = [super init])) {
        _elements = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)enqueue:(id)obj {
    [_elements addObject:obj];
}

- (id)dequeue {
    id elemToBeRemoved = [self peek];
    if (elemToBeRemoved == nil) {
        return nil;
    } else {
        [_elements removeObjectAtIndex:kQueueStartingIndexOfArray];
        return elemToBeRemoved;
    }
}

- (id)peek {
    if ([_elements count] == kQueueSizeOfEmptyQueue) {
        return nil;
    } else {
        return [_elements objectAtIndex:kQueueStartingIndexOfArray];
    }
}

- (NSUInteger)count {
    return [_elements count];
}

- (void)removeAllObjects {
    [_elements removeAllObjects];
}

@end
