//
//  BubbleModel.h
//  ps03
//
//  Created by Gu Junchao on 2/2/14.
//
//

/**
 * This class is a model storing infomation of all the bubbles
 *
 * To extend the behaviour of the game bubble model, just subclass
 * it and add more properties for game engine--velocity and so on.
 * Right now center and radius is not stored since we have not come
 * to the stage where center and raius will be that useful--but for
 * game engine, storing that info for calculation is very important.
 */

#import <Foundation/Foundation.h>

typedef enum {
    kNoDisplayColorType,
    
} GameBubbleColorType;

static const NSInteger kNumberOfBubbleModelKinds = 9;
static const NSInteger kNumberOfBubbleModelKindsCanBeFired = 4;
static const NSString *kKeyItem = @"Item";
static const NSString *kKeyColorType = @"Color Type";
static const NSString *kKeyCenterX = @"Center X";
static const NSString *kKeyCenterY = @"Center Y";
static const NSString *kKeyRadius = @"radius";

static NSString *kBlueImageName = @"bubble-blue.png";
static NSString *kRedImageName = @"bubble-red.png";
static NSString *kOrangeImageName = @"bubble-orange.png";
static NSString *kGreenImageName = @"bubble-green.png";
static NSString *kStarImageName = @"bubble-star.png";
static NSString *kBombImageName = @"bubble-bomb.png";
static NSString *kLightningImageName = @"bubble-lightning.png";
static NSString *kIndestructibleImageName = @"bubble-indestructible.png";

@interface BubbleModel : NSObject

@property (nonatomic) NSInteger item;
@property (nonatomic) CGPoint center;
@property (nonatomic) CGFloat radius;
@property (nonatomic) NSInteger colorType;

- (id)initWithIndexPathItem:(NSInteger)item colorType:(NSInteger)colorType center:(CGPoint)center
                     radius:(CGFloat)radius;
// EFFECTS: init a bubbleModel based on given indexPathItem and colorType

+ (id)bubbleModelFromDic:(NSDictionary*)dic;
// REQUIRES: the given dic should be in correct format
// EFFECTS: factory method and init a bubbleModel with give dic

- (NSDictionary*)modelData;
// EFFECTS: export the modelData in the form of dictionary

@end
