//
//  JingXuanModel.m
//  The weekend to play
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "JingXuanModel.h"

@implementation JingXuanModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.title = dict[@"title"];
        self.image = dict[@"image"];
        self.age = dict[@"age"];
        self.counts = dict[@"counts"];
        self.price = dict[@"price"];
        self.activityId = dict[@"id"];
        self.type = dict[@"type"];
        self.address = dict[@"adress"];
        QJZLog(@"self.================price = %@",self.price);
    }
    return self;
}




@end
