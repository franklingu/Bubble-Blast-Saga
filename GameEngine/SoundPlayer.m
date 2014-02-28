//
//  SoundPlayer.m
//  Bubble Blast Saga
//
//  Created by Gu Junchao on 2/26/14.
//
//

#import "SoundPlayer.h"

static void playSoundFinished(SystemSoundID sound, void *data)
{
    AudioServicesPlaySystemSound(sound);
}

@implementation SoundPlayer

- (id)initWithFileName:(NSString *)fileName
{
    self = [super init];
    if (self) {
        NSString *path  = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mp3"];
        NSURL *pathURL = [NSURL fileURLWithPath:path];
        
        SystemSoundID audioEffect;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        self.musicID = audioEffect;
    }
    
    return self;
}

- (void)play
{
    NSLog(@"play");
    AudioServicesPlaySystemSound(self.musicID);
}

- (void)playInLoop
{
    [self play];
    AudioServicesAddSystemSoundCompletion(self.musicID, nil, nil, playSoundFinished, (__bridge void *)self);
}

- (void)stopPlaying
{
    AudioServicesRemoveSystemSoundCompletion(self.musicID);
    AudioServicesDisposeSystemSoundID(self.musicID);
}


@end
