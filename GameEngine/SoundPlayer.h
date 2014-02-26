//
//  SoundPlayer.h
//  Bubble Blast Saga
//
//  Created by Gu Junchao on 2/26/14.
//
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SoundPlayer : NSObject

@property (nonatomic) SystemSoundID musicID;

- (id)initWithFileName:(NSString *)fileName;

- (void)play;

- (void)playInLoop;

- (void)stopPlaying;

@end
