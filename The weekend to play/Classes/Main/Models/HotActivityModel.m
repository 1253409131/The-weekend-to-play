//
//  HotActivityModel.m
//  The weekend to play
//
//  Created by scjy on 16/1/10.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "HotActivityModel.h"

@implementation HotActivityModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.image = dict[@"img"];
        self.counts = dict[@"counts"];
        self.hotId = dict[@"id"];
        QJZLog(@"self.counts = %@",self.counts);
    }
    return self;
}


@end
