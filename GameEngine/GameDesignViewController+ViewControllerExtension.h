//
//  ViewController+ViewControllerExtension.h
//  ps03
//
//  Created by Gu Junchao on 2/2/14.
//
//

#import "GameDesignViewController.h"

@interface GameDesignViewController (Extension)

- (void)save;
// REQUIRES: game in designer mode
// EFFECTS: game state (grid) is saved by calling another method
//          or saving will not happen because of invalid file name
//          or ask for overwriting confirmation

- (void)load;
// MODIFIES: self (game bubbles in the grid)
// REQUIRES: game in designer mode
// EFFECTS: loadPopOverController will show up

- (void)reset;
// MODIFIES: self (game bubbles in the grid)
// REQUIRES: game in designer mode
// EFFECTS: current game bubbles in the grid are deleted

@end
