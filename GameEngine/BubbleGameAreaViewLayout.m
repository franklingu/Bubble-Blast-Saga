//
//  BubbleGameAreaViewLayout.m
//  ps03
//
//  Created by Gu Junchao on 2/1/14.
//
//

#import "BubbleGameAreaViewLayout.h"

@implementation BubbleGameAreaViewLayout

- (void) prepareLayout
{
    [super prepareLayout];

    int numberOfSections = (int)[self.collectionView numberOfSections];
    int numberOfItems = 0;
    
    for (int i=0; i<numberOfSections; i++) {
        numberOfItems += [self.collectionView numberOfItemsInSection:i];
    }
    self.numberOfItems = numberOfItems;
}

- (CGSize)collectionViewContentSize
{
    return self.collectionView.frame.size;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static int numberOfItemsInEvenRow = 12;
    static int numberOfItemsInOddRow = 11;
    float radius = self.collectionViewContentSize.width/(float)numberOfItemsInEvenRow/2.0;
    
    UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    int rowFromIndex = (int)indexPath.row;
    int row = 0;
    int col = rowFromIndex;
    while ((row%2==0 && col>=numberOfItemsInEvenRow) || (row%2!=0 && col>=numberOfItemsInOddRow)) {
        row++;
        if (row%2 == 0) {
            col = col - numberOfItemsInOddRow;
        } else {
            col = col - numberOfItemsInEvenRow;
        }
    }
    float x_coordinate = col*2*radius + radius;
    float y_coordinate = row*radius*pow(3, 0.5f) + radius;
    if (row%2!=0) {
        x_coordinate = x_coordinate+radius;
    }
    attr.size = CGSizeMake(radius*2, radius*2);
    attr.center = CGPointMake(x_coordinate, y_coordinate);
    
    return attr;
}

- (NSArray *) layoutAttributesForElementsInRect: (CGRect) rect
{
    NSMutableArray *attributes = [NSMutableArray array];
    for (NSInteger index = 0 ; index < self.numberOfItems; index++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

@end
