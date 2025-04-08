//
//  ViewController.m
//  JaneWaterFlowLayout
//
//  Created by Jane on 2018/2/2.
//  Copyright © 2018 jane. All rights reserved.
//

#import "ViewController.h"
#import "JaneFitWidthFlowLayout.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "Shop.h"
#import "ShopCell.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, JaneFitWidthFlowLayoutDelegate>
@property (nonatomic, strong)NSMutableArray *shops;
@property (nonatomic, strong)UICollectionView *collectView;

@end

@implementation ViewController

static NSString * const cellId = @"shop";

- (NSMutableArray *)shops
{
    if (!_shops) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    JaneFitWidthFlowLayout *layout = [[JaneFitWidthFlowLayout alloc] init];
    layout.delegate = self;
    
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectView.delegate = self;
    collectView.dataSource = self;
    [self.view addSubview:collectView];
    
    [collectView registerClass:[ShopCell class] forCellWithReuseIdentifier:cellId];
    [collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId"];
    [collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerId"];
    
    
    self.collectView = collectView;
    
    
    [self setUpRefresh];
    
}

- (void)setUpRefresh
{
    self.collectView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(newRefresh)];
    [self.collectView.header beginRefreshing];
    
    self.collectView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addRefresh)];
    self.collectView.footer.hidden = YES;
}

- (void)newRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [Shop objectArrayWithFilename:@"1.plist"];
        [self.shops removeAllObjects];
        [self.shops addObjectsFromArray:shops];
        
        // 刷新数据
        [self.collectView reloadData];
        
        [self.collectView.header endRefreshing];
    });
    
}

- (void)addRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [Shop objectArrayWithFilename:@"1.plist"];
        
        [self.shops addObjectsFromArray:shops];
        
        // 刷新数据
        [self.collectView reloadData];
                
        [self.collectView.footer endRefreshing];
    });
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.collectView.footer.hidden = self.shops.count == 0;
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    cell.shop = self.shops[indexPath.item];
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerId" forIndexPath:indexPath];
        header.backgroundColor = [UIColor lightGrayColor];
        return header;
    } else {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footerId" forIndexPath:indexPath];
        footer.backgroundColor = [UIColor cyanColor];
        return footer;
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"==========子视图个数：%ld",self.view.subviews.count);
    if (self.view.subviews.count == 4) {
        [self.view.subviews.lastObject removeFromSuperview];
        return;
    }
    Shop *shop = self.shops[indexPath.item];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 200) / 2, ([UIScreen mainScreen].bounds.size.height - 200) / 2, 200, 200);
    [imageView sd_setImageWithURL:[NSURL URLWithString:shop.img]];
    [self.view addSubview:imageView];
    
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [imageView addGestureRecognizer:tap];
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    [tap.view removeFromSuperview];
}


- (CGFloat)heightForItemIn:(JaneFitWidthFlowLayout *)flowLayout
{
    return 50;
}

- (CGFloat)flowLayout:(JaneFitWidthFlowLayout *)layout widthForItemAt:(NSIndexPath *)indexPath
{
    Shop *shop = self.shops[indexPath.item];
    return shop.h / 3;
}

- (CGFloat)flowLayout:(JaneFitWidthFlowLayout *)layout headerHeightAt:(NSInteger)section
{
    return 50;
}

- (CGFloat)flowLayout:(JaneFitWidthFlowLayout *)layout footerHeightAt:(NSInteger)section
{
    return 25;
}

- (CGFloat)columnMariginIn:(JaneFitWidthFlowLayout *)flowLayout
{
    return 20;
}

- (CGFloat)rowMariginIn:(JaneFitWidthFlowLayout *)flowLayout
{
    return 20;
}

- (UIEdgeInsets)edgeInsetsIn:(JaneFitWidthFlowLayout *)flowLayout
{
    return UIEdgeInsetsMake(20, 10, 10, 10);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
