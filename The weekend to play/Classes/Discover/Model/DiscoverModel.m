//
//  DiscoverModel.m
//  The weekend to play
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "DiscoverModel.h"

@implementation DiscoverModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.discoverId = dict[@"id"];
        self.discoverImage = dict[@"image"];
        self.discoverTitle = dict[@"title"];
        self.discoverUrl = dict[@"url"];
    }
    return self;
}

@end
