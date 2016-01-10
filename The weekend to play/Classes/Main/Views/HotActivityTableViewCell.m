//
//  HotActivityTableViewCell.m
//  The weekend to play
//
//  Created by scjy on 16/1/10.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "HotActivityTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface HotActivityTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageHotView;
@property (weak, nonatomic) IBOutlet UILabel *dianZanLable;


@end
@implementation HotActivityTableViewCell
- (void)awakeFromNib {
    // Initialization code
    
    self.frame = CGRectMake(0, 0, kWidth, 90);
}

#pragma mark ----------- HotActivityModel
- (void)setHotActivityModel:(HotActivityModel *)hotActivityModel{
    //图片
    [self.imageHotView sd_setImageWithURL:[NSURL URLWithString:hotActivityModel.image] placeholderImage:nil];
    //点赞
    self.dianZanLable.text = hotActivityModel.counts;
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
