//
//  MainTableViewCell.m
//  The weekend to play
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "MainTableViewCell.h"

@interface MainTableViewCell ()
//活动图片
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
//活动名字
@property (weak, nonatomic) IBOutlet UIImageView *activityNameLable;
//活动价格
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLable;
//活动距离
@property (weak, nonatomic) IBOutlet UIButton *activityDistanceBtn;



@end

@implementation MainTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
