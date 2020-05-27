//
//  lwTotas.m
//  lwplugin
//
//  Created by LWQ on 2020/5/26.
//

#import "lwTotas.h"
#import <Masonry/Masonry.h>
@implementation lwTotas

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}
- (void)confiUI
{
    _lable = [UILabel new];
    _lable.textColor = UIColor.whiteColor;
    _lable.backgroundColor = UIColor.grayColor;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _lable.textAlignment = NSTextAlignmentCenter;
    _lable.numberOfLines = 3;
    [window addSubview:_lable];
    [_lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(50);
        make.width.mas_lessThanOrEqualTo(window.frame.size.width - 20);
        make.centerX.mas_equalTo(window.mas_centerX);
        make.centerY.mas_equalTo(window.mas_centerY);
    }];
}

- (void)show:(NSString *)msg
{
    if (self.lable) {
        return;
    }
    [self dimiss];
    [self confiUI];
    
    _lable.text = msg;
    [UIView animateWithDuration:0.25 animations:^{
        self.lable.alpha = 1;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dimiss];
    });
}

- (void)dimiss
{
    [self.lable removeFromSuperview];
    _lable = nil;
}

@end
