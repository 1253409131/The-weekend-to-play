//
//  JingXuanTableViewCell.m
//  The weekend to play
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "JingXuanTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation JingXuanTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.frame = CGRectMake(0, 0, kWidth, 120);
    
}

#pragma mark ----------- JingXuanModel
- (void)setJignxuanModel:(JingXuanModel *)jignxuanModel{
    //图片
    [self.headImageVIew sd_setImageWithURL:[NSURL URLWithString:jignxuanModel.image] placeholderImage:nil];
    self.headImageVIew.layer.cornerRadius = 20;
    self.headImageVIew.clipsToBounds = YES;
    //标题
    self.activityTitleLable.text = jignxuanModel.title;
    //价格
    self.activityPriceLable.text = jignxuanModel.price;
    //喜欢的人数
    
    [self.loveCountButton setTitle:[NSString stringWithFormat:@"%@",jignxuanModel.counts] forState:UIControlStateNormal];
    //年龄
    self.AgeLable.text = jignxuanModel.age;
    
    
}
//@property (weak, nonatomic) IBOutlet UILabel *AgeLable;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
