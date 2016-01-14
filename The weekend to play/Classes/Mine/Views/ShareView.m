//
//  ShareView.m
//  The weekend to play
//
//  Created by scjy on 16/1/14.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "ShareView.h"

@interface ShareView ()
@property(nonatomic, strong) UIView *blackView;
@property(nonatomic, strong) UIView *shareView;
@end

@implementation ShareView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configShareView];
    }
    return self;
}

- (void)configShareView{
    UIWindow *window = [[UIApplication sharedApplication ].delegate window];
    self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kWidth, kHeight)];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha =0.0;
    [window addSubview:self.blackView];
    
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0,400, kWidth, 200)];
    self.shareView.backgroundColor = [UIColor whiteColor];
    [window addSubview:self.shareView];

}

- (void)removeBtn{
    [UIView animateWithDuration:1.0 animations:^{
        self.blackView.alpha = 0.0;
        self.shareView.alpha = 0.0;
    }];
    [self.blackView removeAllSubviews];
    [self.shareView removeAllSubviews];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
