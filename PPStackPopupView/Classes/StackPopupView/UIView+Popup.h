//
//  UIView+Popup.h
//  StackPopupViewProject
//
//  Created by chenshenglong on 2020/8/28.
//  Copyright © 2020 chenshenglong. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "StackPopupModel.h"
#import "StackPopupViewManager.h"
#define kHideAllStatckPopupView @"kHideAllStatckPopupView"
#define kStackPopupViewShowNoti @"kStackPopupViewShowNoti"
#define kStackPopupViewHideNoti @"kStackPopupViewHideNoti"
#define kDefaultMaskColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]
#define KDefaultMaskImage [UIImage imageNamed:@"ITPopupViewMaskView.png"]

@class StackPopupBoxView,StackPopupModel;
NS_ASSUME_NONNULL_BEGIN

@interface UIView (Popup)

#pragma mark - 新接口 START 推荐使用新接口

- (void)it_stackPopupWithModel:(StackPopupModel *)popupModel;

#pragma mark - 新接口 END

+ (BOOL)it_didPopupOrQueueUp;

+ (BOOL)it_hasPopupView;

+ (BOOL)it_bringToTop;

-(StackPopupModel *)it_stackPopupViewShowWithClick:(nullable void(^)(void))block
                                              mask:(nullable UIColor *)mask
                                          priority:(POPUP_PRIORITY)priority;

-(StackPopupModel *)it_stackPopupViewShow;
-(StackPopupModel *)it_stackPopupViewShowWithClick:(nullable void (^)(void))block;

-(StackPopupModel *)it_stackPopupViewShowWithClick:(nullable void (^)(void))block
                                          withMask:(nullable UIColor*)mask;

-(StackPopupModel *)it_stackPopupViewShowWithClick:(nullable void (^)(void))block
                                        withFinish:(nullable void (^)(void))finish;

-(StackPopupModel *)it_stackPopupViewShowWithClick:(nullable void (^)(void))block
                                        withFinish:(nullable void (^)(void))finish
                                          withMask:(nullable UIColor*)mask;

-(StackPopupModel *)it_stackPopupViewShowWithClick:(nullable void (^)(void))block
                                        withFinish:(nullable void (^)(void))finish
                                         withImage:(nullable UIImage*)image;

-(StackPopupModel *)it_stackPopupViewShowWithClick:(nullable void (^)(void))block
                                        withFinish:(nullable void (^)(void))finish
                                         withImage:(nullable UIImage*)image
                                        removeView:(nullable void (^)(void))removeView;

-(StackPopupModel *)it_stackPopupViewShowWithClick:(nullable void (^)(void))block
                                        withFinish:(nullable void (^)(void))finish
                                              back:(nullable void (^)(void))back
                                             close:(nullable void (^)(void))close;

- (StackPopupModel *)it_stackPopupViewWithClick:(nullable void (^)(void))clickBGBlock
                            withClickCloseBlock:(nullable void (^)(void))clickCloseBlock
                                  WithBackBlock:(nullable void (^)(void))backBlock
                                    removeBlock:(nullable void (^)(void))removeBlock
                                    finishBlock:(nullable void (^)(void))finishBlock
                                    withBGColor:(nullable UIColor *)bgColor
                                    withBGImage:(nullable UIImage *)bgImage
                                       priority:(POPUP_PRIORITY)priority;

-(void)it_stackPopupViewHide;

-(void)it_stackPopupViewHideForce;

-(void)it_setStackViewPriority:(int)priority;

// 自定义显示动画
- (void)showWithBoxView:(StackPopupBoxView *)boxView completion:(void (^)(BOOL finish))completion;

// 自定义隐藏动画
- (void)hideWithBoxView:(StackPopupBoxView *)boxView completion:(void (^)(BOOL finish))completion;

- (void)popupWillAppear;

- (void)popupDidAppear;

- (void)popupWillDisAppear;

- (void)popupDidDisAppear;

@end

NS_ASSUME_NONNULL_END
