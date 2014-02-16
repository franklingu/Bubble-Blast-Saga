//
//  BubbleModel.m
//  ps03
//
//  Created by Gu Junchao on 2/2/14.
//
//

#import "BubbleModel.h"

@interface BubbleModel ()
@end

@implementation BubbleModel

- (id)initWithIndexPathItem:(NSInteger)item colorType:(NSInteger)colorType center:(CGPoint)center radius:(CGFloat)radius
{
    // EFFECTS: init a bubbleModel based on given indexPathItem and colorType
    
    self = [super init];
    if (self) {
        self.item = item;
        self.colorType = colorType;
        self.center = center;
        self.radius = radius;
    }
    return self;
}

+ (id)bubbleModelFromDic:(NSDictionary *)dic
{
    int indexPathItem = [(NSString *)[dic objectForKey:kKeyItem] intValue];
    int colorType = [(NSString *)[dic objectForKey:kKeyColorType] intValue];
    CGFloat x = [(NSString *)[dic objectForKey:kKeyCenterX] floatValue];
    CGFloat y = [(NSString *)[dic objectForKey:kKeyCenterY] floatValue];
    CGFloat radius = [(NSString *)[dic objectForKey:kKeyRadius] floatValue];
    
    return [[BubbleModel alloc] initWithIndexPathItem:indexPathItem colorType:colorType center:CGPointMake(x, y)
                                               radius:radius];
}

- (NSDictionary*)modelData
{
    NSMutableDictionary *modelDic = [[NSMutableDictionary alloc] init];
    NSString *objItem = [NSString stringWithFormat:@"%d", (int)self.item];
    NSString *objColorType = [NSString stringWithFormat:@"%d", (int)self.colorType];
    NSString *objCenterX = [NSString stringWithFormat:@"%f", (float)self.center.x];
    NSString *objCenterY = [NSString stringWithFormat:@"%f", (float)self.center.y];
    NSString *objRadius = [NSString stringWithFormat:@"%f", (float)self.radius];
    [modelDic setObject:objItem forKey:kKeyItem];
    [modelDic setObject:objColorType forKey:kKeyColorType];
    [modelDic setObject:objCenterX forKey:kKeyCenterX];
    [modelDic setObject:objCenterY forKey:kKeyCenterY];
    [modelDic setObject:objRadius forKey:kKeyRadius];
    
    return modelDic;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[BubbleModel class]]) {
        BubbleModel *model = (BubbleModel *)object;
        return (self.item == model.item) && (self.colorType == model.colorType);
    }
    
    return NO;
}

@end
