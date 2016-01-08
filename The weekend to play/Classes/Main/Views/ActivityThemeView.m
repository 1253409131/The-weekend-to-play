//
//  ActivityThemeView.m
//  The weekend to play
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "ActivityThemeView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ActivityThemeView ()
//保存上一个图片底部的高度
{
    CGFloat _previousImageBottom;
    CGFloat _lastLabelBottom;
}
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIScrollView *mainScrollerView;
@end

@implementation ActivityThemeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //自定义视图
        [self configView];
    }
    return self;
}
#pragma mark ------------- 自定义视图
//自定义视图
- (void)configView{
    [self addSubview:self.mainScrollerView];
    [self.mainScrollerView addSubview:self.headImageView];
}
#pragma mark ------------- setDataDic
//在set方法中赋值
- (void)setDataDic:(NSDictionary *)dataDic{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"image"]] placeholderImage:nil];
    //活动详情
    [self drawContentWithArray:dataDic[@"content"]];
}

- (void)drawContentWithArray:(NSArray *)contentArray{
    for (NSDictionary *dic in contentArray) {
        //获取每一段活动信息的文本高度
        CGFloat height = [HWTool getTextHeightWithBigest:dic[@"description"] bigerSize:CGSizeMake(kWidth, 1000) textFont:15.0];
        //CGFloat height = [HWTool getTextHeightWithText:dic[@"description"] WithBigiestSize:CGSizeMake(kWidth, 1000) fontText:15.0];
        CGFloat y;
        if (_previousImageBottom > 186) {
            //当第一个活动详情显示，label先从保留的图片底部的坐标开始
            y = 186 + _previousImageBottom - 186;
        }else{
            //当第二个开始时，要加上上面控件的高度
            y = 186 + _previousImageBottom;
        }
        NSString *title = dic[@"title"];
        //如果标题存在,标题高度应该是上次图片的高度的底部高度
        if (title !=nil) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kWidth - 20, 30)];
            titleLabel.text = title;
            [self.mainScrollerView addSubview:titleLabel];
            //下边详细信息label显示的时候，高度的坐标应该再加30，也就是标题的高度。
            y += 30;
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, y, kWidth- 10, height)];
        label.text = dic[@"description"];
        label.font = [UIFont systemFontOfSize:15.0];
        label.numberOfLines = 0;
        [self.mainScrollerView addSubview:label];
        //保留最后一个label的高度，+64是下边tableBar的高度
        _lastLabelBottom = label.bottom + 10 + 64;
        NSArray *urlArray = dic[@"urls"];
        //当某一段落没有图片的时候，上次图片的高度用上次label的高度+10
        if (urlArray == nil) {
            _previousImageBottom = label.bottom + 10;
        }else{
            CGFloat lastImgbottom = 0.0;
            for (NSDictionary *urlDic in urlArray) {
                CGFloat imagY;
                if (urlArray.count > 1) {
                    //图片不止一张的情况
                    if (lastImgbottom == 0.0) {
                        if (title != nil) {  //有title的算上title的30像素
                            imagY = _previousImageBottom + label.height + 30 + 5;
                        } else{
                            imagY = _previousImageBottom + label.height + 5;
                        }
                    } else {
                        imagY = lastImgbottom + 10;
                        
                    }
                } else{
                    //单张图片
                    imagY = label.bottom;
                }
                CGFloat width = [urlDic[@"width"] integerValue];
                CGFloat imageHeight = [urlDic[@"height"] integerValue];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, imagY, kWidth - 10, (kWidth - 10) / width * imageHeight)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:urlDic[@"url"]] placeholderImage:nil];
                [self.mainScrollerView addSubview:imageView];
                //每一次都保留图片底部的高度
                _previousImageBottom = imageView.bottom + 5;
                if (urlArray.count > 1) {
                    lastImgbottom = imageView.bottom;
                }
                
            }
        }
    }
    self.mainScrollerView.contentSize = CGSizeMake(kWidth, _lastLabelBottom );
}





#pragma mark ------------- mainScrollerView
- (UIScrollView *)mainScrollerView{
    if (_mainScrollerView == nil) {
        self.mainScrollerView = [[UIScrollView alloc] initWithFrame:self.frame];
        
    }
    return _mainScrollerView;
}

#pragma mark ------------- headImageView
- (UIImageView *)headImageView{
    if (_headImageView == nil) {
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 186)];
    }
    return _headImageView;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
