//
//  MainModel.m
//  The weekend to play
//
//  Created by scjy on 16/1/5.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//


#import "MainModel.h"

@implementation MainModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.type = dict[@"type"];
        if ([self.type integerValue] == 1) {
            //如果是推荐活动
            self.price = dict[@"price"];
            NSLog(@"self.price = %@",self.price);
            self.lat = [dict[@"lat"] floatValue];
            self.lng = [dict[@"lng"] floatValue];
            self.address = dict[@"address"];
            self.counts = dict[@"counts"];
            self.startTime = dict[@"startTime"];
            self.endTime = dict[@"endTime"];
        }else{
            //如果是推荐专题
            self.activityDescription = dict[@"description"];
        }
        
        self.image_big = dict[@"image_big"];
        self.title = dict[@"title"];
        NSLog(@"self.title = %@",self.title);
        self.activityId = dict[@"id"];
       
        
    }
    return self;
}




@end
