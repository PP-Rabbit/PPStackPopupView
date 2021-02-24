//
//  StackPopupBoxView.m
//  StackPopupViewProject
//
//  Created by chenshenglong on 2020/8/28.
//  Copyright © 2020 chenshenglong. All rights reserved.
//

#import "StackPopupBoxView.h"
#import "StackPopupModel.h"
#import "StackPopupViewHeader.h"
#import <Masonry/Masonry.h>

@interface StackPopupBoxView ()

@property (nonatomic,weak)StackPopupModel *model;
@property (nonatomic,strong)UIButton *closeBtn;
@property (nonatomic,strong)UIButton *backBtn;

@end

@implementation StackPopupBoxView{
    
    UIView *_bgView;
    UIImageView *_bgImgView;
    UIButton *_bgBtn;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        [_closeBtn setImage:[UIImage imageNamed:@"it_pop_12_13_close_bg_"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_backBtn setImage:[UIImage imageNamed:@"it_stack_popup_view_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

+ (instancetype)createBoxView:(StackPopupModel *)model{
    
    CGRect frame = [UIApplication sharedApplication].keyWindow.bounds;
    StackPopupBoxView *boxView = [[StackPopupBoxView alloc]initWithFrame:frame];
    model.boxView = boxView;
    boxView.model = model;
    [boxView addSubview:model.contentView];
    [boxView updateHierarchy];

    [model.contentView setCenter:boxView.center];
    return boxView;
}

- (void)setModel:(StackPopupModel *)model{
    _model = model;
    [self updateUI];
}

- (void)updateHierarchy{
    if (_backBtn) {
        [self bringSubviewToFront:_backBtn];
    }
}

- (void)updateUI{
    if (self.model.bgColor) {
        if (!_bgView) {
            _bgView = [[UIView alloc] initWithFrame:self.bounds];
            [self addSubview:_bgView];
        }
        if(_bgImgView){
            [_bgImgView removeFromSuperview];
        }
        _bgView.backgroundColor = self.model.bgColor;
    }else if(self.model.bgImage){
        if (!_bgImgView) {
            _bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
            [self addSubview:_bgImgView];
        }
        if (_bgView) {
            [_bgView removeFromSuperview];
        }
        _bgImgView.image = self.model.bgImage;
    }
    if (self.model.clickBGBlock) {
        if(!_bgBtn){
            _bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
            [self addSubview:_bgBtn];
            [_bgBtn addTarget:self action:@selector(clickBG) forControlEvents:UIControlEventTouchUpInside];
        }
    }

    if(self.model.clickCloseBlock || self.model.clickBackBlock){
        UIView *btnSuperView = self.model.contentView;
        if ([self.model.contentView respondsToSelector:@selector(statckPopupContentView)]) {
            btnSuperView = [self.model.contentView performSelector:@selector(statckPopupContentView)];
        }
        if(self.model.clickBackBlock){
            [self addSubview:self.backBtn];
            [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(22);
                make.top.offset(33);
                make.width.height.mas_equalTo(20);
            }];
        }
        if (self.model.clickCloseBlock) {
            [btnSuperView addSubview:self.closeBtn];
            [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(btnSuperView.mas_right).with.offset(-14);
                make.top.equalTo(btnSuperView.mas_top).with.offset(14);
                make.width.height.mas_equalTo(28);
            }];
        }
    }
}

- (void)clickBack{
    if (self.model.clickBackBlock) {
        self.model.clickBackBlock();
    }
}

- (void)clickClose{
    if (self.model.clickCloseBlock) {
        self.model.clickCloseBlock();
    }
}

- (void)clickBG{
    if (self.model.clickBGBlock) {
        self.model.clickBGBlock();
    }
}

- (void)showCompletion:(void (^)(BOOL finish))completion{
    if ([self.model.contentView respondsToSelector:@selector(showWithBoxView:completion:)]) {
        [self sendPopupWillAppear];
        __weak typeof(self)weak_self = self;
        [self.model.contentView showWithBoxView:self completion:^(BOOL finish) {
            __strong typeof(weak_self)strong_self = weak_self;
            [strong_self sendPopupDidAppear];
            if (strong_self.model.finishBlock) {
                strong_self.model.finishBlock();
            }
            if(completion){
                completion(finish);
            }
        }];
    }else{
        [self sendPopupWillAppear];
        float duration = 0.2;
        self.alpha = 0;
        UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear;
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            [self sendPopupDidAppear];
            if (self.model.finishBlock) {
                self.model.finishBlock();
            }
            if (completion) {
                completion(finished);
            }
        }];
    }
}

- (void)hideCompletion:(void (^)(BOOL finish))completion{
    
    if ([self.model.contentView respondsToSelector:@selector(hideWithBoxView:completion:)]) {
        [self sendPopupWillDisAppear];
        __weak typeof(self)weak_self = self;
        [self.model.contentView hideWithBoxView:self completion:^(BOOL finish) {
            __strong typeof(weak_self)strong_self = weak_self;
            [strong_self.model.boxView removeFromSuperview];
            [strong_self sendPopupDidDisAppear];
            if (strong_self.model.removeBlock) {
                strong_self.model.removeBlock();
            }
            if(completion){
                completion(finish);
            }
        }];
    }else{
        [self sendPopupWillDisAppear];
        float duration = 0.15;
        UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear;
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self.model.boxView removeFromSuperview];
            [self sendPopupDidDisAppear];
            if (self.model.removeBlock) {
                self.model.removeBlock();
            }
            if (completion) {
                completion(finished);
            }
        }];
    }
}

- (void)sendPopupWillAppear{
     
    if ([self.model.contentView respondsToSelector:@selector(popupWillAppear)]) {
        [self.model.contentView popupWillAppear];
    }
}

- (void)sendPopupDidAppear{
    if([self.model.contentView respondsToSelector:@selector(popupDidAppear)]){
        [self.model.contentView popupDidAppear];
    }
    if ([self.model.contentView respondsToSelector:@selector(stackPopupViewDidShow)]) {
        UIView * popupView = self.model.contentView;
        [popupView performSelector:@selector(stackPopupViewDidShow)];
    }
}

- (void)sendPopupWillDisAppear{
    if ([self.model.contentView respondsToSelector:@selector(popupWillDisAppear)]) {
        [self.model.contentView popupWillAppear];
    }
}

- (void)sendPopupDidDisAppear{
    if ([self.model.contentView respondsToSelector:@selector(popupDidDisAppear)]) {
        [self.model.contentView popupWillAppear];
    }
}

- (void)dealloc{
    
}


@end
