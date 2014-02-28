
//
//  AVSoundPlayer.h
//  Bubble Blast Saga
//
//  Created by Gu Junchao on 2/28/14.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AVSoundPlayer : NSObject <AVAudioPlayerDelegate>

- (id)initWithFileName:(NSString *)fileName;

- (void)play;

- (void)playInLoop;

- (void)stop;

- (void)pause;

@end
