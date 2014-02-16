//
//  PopOverDelegate.h
//  ps03
//
//  Created by Gu Junchao on 2/6/14.
//
//

#import <Foundation/Foundation.h>

@protocol PopOverDelegate <NSObject>
@required
- (void)selectedFileName:(NSString*)fileName;
- (void)deletedFileName:(NSString*)fileName;
@end
