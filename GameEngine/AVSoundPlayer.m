//
//  AVSoundPlayer.m
//  Bubble Blast Saga
//
//  Created by Gu Junchao on 2/28/14.
//
//

#import "AVSoundPlayer.h"

@interface AVSoundPlayer ()

@property (strong, nonatomic) AVAudioPlayer *player;

@end

@implementation AVSoundPlayer

- (id)initWithFileName:(NSString *)fileName
{
    self = [super init];
    if (self) {
        NSError *soundError;
        NSString *path  = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mp3"];
        NSURL *pathURL = [NSURL fileURLWithPath:path];
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:pathURL error:&soundError];
        self.player.delegate = self;
    }
    
    return self;
}

- (void)play
{
    [self.player prepareToPlay];
    [self.player play];
}

- (void)playInLoop
{
    self.player.numberOfLoops = -1;
    [self play];
}

- (void)stop
{
    [self.player stop];
}

- (void)pause
{
    [self.player pause];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        NSLog(@"did finish playing");
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"error: %@", [error localizedDescription]);
}

@end
