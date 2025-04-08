//
//  JaneFitWidthFlowLayout.h
//  JaneWaterFlowLayout
//
//  Created by Jane on 2018/2/2.
//  Copyright © 2018 jane. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JaneFitWidthFlowLayout;

@protocol JaneFitWidthFlowLayoutDelegate <NSObject>

@required

- (CGFloat)flowLayout:(JaneFitWidthFlowLayout *)layout widthForItemAt:(NSIndexPath *)indexPath;

@optional

- (CGFloat)heightForItemIn:(JaneFitWidthFlowLayout *)flowLayout;

- (CGFloat)columnMariginIn:(JaneFitWidthFlowLayout *)flowLayout;
- (CGFloat)rowMariginIn:(JaneFitWidthFlowLayout *)flowLayout;
- (UIEdgeInsets)edgeInsetsIn:(JaneFitWidthFlowLayout *)flowLayout;


- (CGFloat)flowLayout:(JaneFitWidthFlowLayout *)layout headerHeightAt:(NSInteger)section;
- (CGFloat)flowLayout:(JaneFitWidthFlowLayout *)layout footerHeightAt:(NSInteger)section;
//- (CGFloat)headerHeightInWaterfallFlowLayout:(JaneFitWidthFlowLayout *)flowLayout atSection:(NSInteger)section;
//- (CGFloat)footerHeightInWaterfallFlowLayout:(JaneFitWidthFlowLayout *)flowLayout atSection:(NSInteger)section;


@end


@interface JaneFitWidthFlowLayout : UICollectionViewLayout

@property (nonatomic, weak)id<JaneFitWidthFlowLayoutDelegate> delegate;

@end

