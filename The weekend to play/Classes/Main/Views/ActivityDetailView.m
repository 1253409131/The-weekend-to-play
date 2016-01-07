//
//  ActivityDetailView.m
//  The weekend to play
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "ActivityDetailView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ActivityDetailView ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (weak, nonatomic) IBOutlet UILabel *activityTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *activityFavouriteLable;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLable;

@property (weak, nonatomic) IBOutlet UILabel *activityAdress;

@property (weak, nonatomic) IBOutlet UILabel *activityPhoneNumLable;

@end
@implementation ActivityDetailView

- (void)awakeFromNib{
    self.mainScrollView.contentSize = CGSizeMake(kWidth, 1000);
}



- (void)setDataDic:(NSDictionary *)dataDic{

    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"image"]] placeholderImage:nil];
    
    self.activityTitleLable.text = dataDic[@"title"];
    self.activityFavouriteLable.text = [NSString stringWithFormat:@"%@喜欢的人数", dataDic[@"fav"]];
    self.activityPriceLable.text = dataDic[@"pricedesc"];
    self.activityAdress.text = dataDic[@"address"];
    self.activityPhoneNumLable.text = dataDic[@"tel"];
    
    

}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
