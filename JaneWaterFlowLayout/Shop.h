//
//  Shop.h
//  JaneWaterFlowLayout
//
//  Created by Jane on 2018/1/31.
//  Copyright © 2018 jane. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Shop : NSObject

@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign) CGFloat h;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *price;

@end

NS_ASSUME_NONNULL_END
