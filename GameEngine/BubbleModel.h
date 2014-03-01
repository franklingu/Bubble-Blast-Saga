//
//  BubbleModel.h
//  ps03
//
//  Created by Gu Junchao on 2/2/14.
//
//


#import <Foundation/Foundation.h>
#import "Constants.h"

typedef enum {
    kNoDisplayColorType,
    kBlueColorType,
    kRedColorType,
    kOrangeColorType,
    kGreenColorType,
    kStarColorType,
    kBombColorType,
    kLightningColorType,
    kIndesturctibleColorType
} GameBubbleColorType;

static const NSInteger kNumberOfBubbleModelKinds = 9;
static const NSInteger kNumberOfBubbleModelKindsCanBeFired = 4;
static const NSString *kKeyItem = @"Item";
static const NSString *kKeyColorType = @"Color Type";
static const NSString *kKeyCenterX = @"Center X";
static const NSString *kKeyCenterY = @"Center Y";
static const NSString *kKeyRadius = @"radius";

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
