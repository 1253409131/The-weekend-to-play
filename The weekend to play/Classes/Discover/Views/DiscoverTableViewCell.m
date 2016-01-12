//
//  DiscoverTableViewCell.m
//  The weekend to play
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "DiscoverTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DiscoverTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *LingkImageView;

@property (weak, nonatomic) IBOutlet UILabel *LinkLable;


@end

@implementation DiscoverTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setDiscoverModel:(DiscoverModel *)discoverModel{
    //图片
    [self.LingkImageView sd_setImageWithURL:[NSURL URLWithString:discoverModel.discoverImage] placeholderImage:nil];
    self.LinkLable.text = discoverModel.discoverTitle;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
