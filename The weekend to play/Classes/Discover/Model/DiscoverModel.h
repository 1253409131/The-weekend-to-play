//
//  DiscoverModel.h
//  The weekend to play
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoverModel : NSObject
@property (nonatomic, copy) NSString *discoverId;
@property (nonatomic, copy) NSString *discoverImage;
@property (nonatomic, copy) NSString *discoverTitle;
@property (nonatomic, copy) NSString *discoverUrl;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
