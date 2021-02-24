//
//  StackPopupViewManager.h
//  StackPopupViewProject
//
//  Created by chenshenglong on 2020/8/28.
//  Copyright © 2020 chenshenglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class StackPopupModel;

#define STACK_POPUP_MANAGER [StackPopupViewManager share]

NS_ASSUME_NONNULL_BEGIN

@interface StackPopupViewManager : NSObject

+ (instancetype)share;

/**
 添加一个弹窗
 */
- (void)addPopupViewModel:(StackPopupModel *)viewModel;

/**
 移除一个弹窗
 */
- (BOOL)removePopupViewModel:(StackPopupModel *)viewModel;

/**
 移除某种弹窗
 */
- (BOOL)removePopupViewWithCls:(Class)cls;

/**
 移除某个View弹窗
 */
- (BOOL)removePopupView:(UIView *)view;

/**
 移除第一个弹窗
 */
- (BOOL)removeFirstPopupViewModel;

/**
 把某种弹窗移到最上面
 */
- (BOOL)bringPopupViewToFront:(Class)cls;

/**
 某种弹窗是否弹出
 */
- (BOOL)clsViewDidPopup:(Class)cls;

/**
 某个弹窗是否弹出
 */
- (BOOL)viewDidPopup:(UIView *)view;

/**
 某种弹窗是否在队列中
 */
- (BOOL)clsViewInQueueUp:(Class )cls;

/**
 某个弹窗是否在队列中
 */
- (BOOL)viewInQueueUp:(UIView *)view;

/**
 清除弹窗队列
 # 会移除当前已弹出的弹窗
 */
- (void)cleanPoupupQueue;

/**
 通过某个弹窗获取弹窗信息
 */
- (StackPopupModel *)getPopupModelWithView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
