//
//  AppDelegate.h
//  GameEngine
//
//  Created by Gu Junchao on 2/10/14.
//
//

#import <UIKit/UIKit.h>
#import "SoundPlayer.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SoundPlayer *bgSoundPlayer;

@end
