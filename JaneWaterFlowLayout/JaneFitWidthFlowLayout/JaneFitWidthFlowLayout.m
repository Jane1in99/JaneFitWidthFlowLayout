//
//  JaneFitWidthFlowLayout.m
//  JaneWaterFlowLayout
//
//  Created by Jane on 2018/2/2.
//  Copyright © 2018 jane. All rights reserved.
//

#import "JaneFitWidthFlowLayout.h"

/** 默认的行高 */
static const NSInteger JaneDefaultRowHeight = 40;

/** 每一列之间的间距 */
static const CGFloat JaneDefaultColumMargin = 10;

/** 每一行之间的间距 */
static const CGFloat JaneDefaultRowMargin = 10;

/** 边缘间距 */
static const UIEdgeInsets JaneDefaultEdgeInsets = {10, 10, 10, 10};

@interface JaneFitWidthFlowLayout()

/** 存放所有cell的布局属性 */
@property (nonatomic, strong)NSMutableArray *attributesArr;


@property (nonatomic, assign)CGFloat contentHeight;

@property (nonatomic, assign)NSInteger rowCount;

@property (nonatomic, assign)CGFloat rowWidth;

@property (nonatomic, assign)NSInteger preSection;

@property (nonatomic, assign)CGFloat supplementaryViewHeight;


- (CGFloat)rowHeight;
- (CGFloat)columnMarigin;
- (CGFloat)rowMarigin;
- (UIEdgeInsets)edgeInsets;

@end


@implementation JaneFitWidthFlowLayout


- (CGFloat)rowHeight
{
    if (_delegate && [_delegate respondsToSelector:@selector(heightForItemIn:)]) {
        return [_delegate heightForItemIn:self];
    }else{
        return JaneDefaultRowHeight;
    }
}

- (CGFloat)columnMarigin
{
    if (_delegate && [_delegate respondsToSelector:@selector(columnMariginIn:)]) {
        return [_delegate columnMariginIn:self];
    }else{
        return JaneDefaultColumMargin;
    }
}

- (CGFloat)rowMarigin
{
    if (_delegate && [_delegate respondsToSelector:@selector(rowMariginIn:)]) {
        return [_delegate rowMariginIn:self];
    }else{
        return JaneDefaultRowMargin;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if (_delegate && [_delegate respondsToSelector:@selector(edgeInsetsIn:)]) {
        return [_delegate edgeInsetsIn:self];
    }else{
        return JaneDefaultEdgeInsets;
    }
}


// 分组头部高度
- (CGFloat)heightForHeaderAt:(NSInteger)section {
    if ([_delegate respondsToSelector:@selector(flowLayout:headerHeightAt:)]) {
        return [_delegate flowLayout:self headerHeightAt:section];
    }
    return 0; // 默认无头部
}

// 分组尾部高度
- (CGFloat)heightForFooterAt:(NSInteger)section {
    if ([_delegate respondsToSelector:@selector(flowLayout:footerHeightAt:)]) {
        return [_delegate flowLayout:self footerHeightAt:section];
    }
    return 0; // 默认无尾部
}


#pragma - 懒加载
- (NSMutableArray *)attributesArr
{
    if (!_attributesArr) {
        _attributesArr = [NSMutableArray array];
    }
    return _attributesArr;
}


#pragma - collectionLayout
- (void)prepareLayout
{
    [super prepareLayout];
    
    self.preSection = 0;
    self.supplementaryViewHeight = 0;
    
    self.rowWidth = self.edgeInsets.left;
    self.rowCount = 0;
    
    self.contentHeight = 0;

    
    //清除之前所有的布局属性
//    [self.attributesArr removeAllObjects];

    @autoreleasepool {
        NSMutableArray *newAttributes = [NSMutableArray array];
        
        NSInteger sectionCount = [self.collectionView numberOfSections];

        for (NSInteger section = 0; section < sectionCount; section++) {
            
            CGFloat headerH = [self heightForHeaderAt:section];
            if (headerH > 0) {
                UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                [newAttributes addObject:attribute];
            }
            
            NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
            for (NSInteger item = 0; item < itemCount; item++) {
                //创建位置
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
                //获取indexpath相对应的布局属性
                UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
                [newAttributes addObject:attrs];
            }
            
            CGFloat footerH = [self heightForFooterAt:section];
            if (footerH > 0) {
                UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                [newAttributes addObject:attribute];
            }
        }
        
        self.attributesArr = newAttributes;
        
    }
    
    
        
}


/**
 决定所有cell的排布布局数组
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.attributesArr filteredArrayUsingPredicate:
            [NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *attrs, NSDictionary *bindings) {
                return CGRectIntersectsRect(attrs.frame, rect); // 只返回与 rect 相交的属性
            }]];
    //return self.attributesArr;
}


/**
  返回indexPath位置cell对应的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section >= [self.collectionView numberOfSections] || indexPath.item >= [self.collectionView numberOfItemsInSection:indexPath.section]) {
//        return nil;
//    }
    //创建布局
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat collectViewW = self.collectionView.frame.size.width;
    
    CGFloat h1 = self.rowHeight;
    CGFloat w1 = [self.delegate flowLayout:self widthForItemAt:indexPath];
    CGFloat offsetX = _rowWidth - collectViewW * _rowCount;
    CGFloat x1 = self.edgeInsets.left;
    if ((collectViewW - offsetX < w1 + self.edgeInsets.right) || (_preSection != indexPath.section)) {
        _rowCount += 1;
        _rowWidth = _rowCount * collectViewW + self.edgeInsets.left + w1 + self.columnMarigin;
        if (_preSection != indexPath.section) {
            _preSection = indexPath.section;
        }
    }else{
        x1 = offsetX;
        _rowWidth = _rowWidth + w1 + self.columnMarigin;
    }
    
    CGFloat y1 = _supplementaryViewHeight + self.edgeInsets.top * (indexPath.section + 1) + (h1 + self.rowMarigin) * _rowCount + (self.edgeInsets.bottom - self.rowMarigin) * indexPath.section;
    //CGFloat y1 = _supplementaryViewHeight + self.edgeInsets.top * (indexPath.section + 1) + (h1 + self.rowMarigin) * _rowCount + self.edgeInsets.bottom * indexPath.section - self.rowMarigin * indexPath.section;

    self.contentHeight = y1 + h1;
    attribute.frame = CGRectMake(x1, y1, w1, h1);
    
    return attribute;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    //创建布局
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    CGFloat collectViewW = self.collectionView.frame.size.width;
    
    CGFloat y = self.contentHeight;
    CGFloat h = [self heightForHeaderAt:indexPath.section];
    
    if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        y += self.edgeInsets.bottom;
        h = [self heightForFooterAt:indexPath.section];
    }
    
    _supplementaryViewHeight += h;
    
    self.contentHeight = y + h;
    attribute.frame = CGRectMake(0, y, collectViewW, h);

    return  attribute;
}



- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, self.contentHeight + self.edgeInsets.bottom);
}


@end
