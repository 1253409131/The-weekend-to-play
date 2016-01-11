//
//  HotActivityModel.h
//  The weekend to play
//
//  Created by scjy on 16/1/10.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotActivityModel : NSObject
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *counts;
@property (nonatomic, copy) NSString *hotId;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
