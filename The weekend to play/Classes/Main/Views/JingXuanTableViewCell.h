//
//  JingXuanTableViewCell.h
//  The weekend to play
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JingXuanModel.h"

@interface JingXuanTableViewCell : UITableViewCell

@property (nonatomic, strong) JingXuanModel *jignxuanModel;

@property (weak, nonatomic) IBOutlet UIImageView *headImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLable;
@property (weak, nonatomic) IBOutlet UIButton *loveCountButton;

@property (weak, nonatomic) IBOutlet UILabel *activityDistenceLable;

@property (weak, nonatomic) IBOutlet UIImageView *activityAge;

@property (weak, nonatomic) IBOutlet UILabel *AgeLable;




@end
