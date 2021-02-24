//
//  StackPopupModel.h
//  StackPopupViewProject
//
//  Created by chenshenglong on 2020/8/28.
//  Copyright © 2020 chenshenglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "StackPopupBoxView.h"
typedef enum : NSUInteger {
    POPUP_PRIORITY_1 = 1,
    POPUP_PRIORITY_2,
    POPUP_PRIORITY_3,
    POPUP_PRIORITY_4,
    POPUP_PRIORITY_5,
    
    POPUP_PRIORITY_BRING_FRONT = INT_MAX,
} POPUP_PRIORITY;

typedef enum : NSUInteger {
    POPUP_STATE_WAIT = 1,
    POPUP_STATE_SHOW = 2,
    POPUP_STATE_HOLD = 3,
} POPUP_STATE;

NS_ASSUME_NONNULL_BEGIN

@interface StackPopupModel : NSObject
/**
 父视图
 */
@property (nonatomic,strong)StackPopupBoxView *boxView;
/**
 显示的视图
 */
@property (nonatomic,strong)UIView *contentView;
/**
 背景图片
 */
@property (nonatomic,strong)UIImage *bgImage;
/**
 背景颜色
 */
@property (nonatomic,strong)UIColor *bgColor;
/**
 弹窗优先级
 */
@property (nonatomic,assign)POPUP_PRIORITY priority;
/**
 跳转页面返回是否存在
 */
@property (nonatomic,assign)BOOL backHold;

/**
 是否正在挂机
 */
@property (nonatomic,assign)POPUP_STATE state;

/**
 当前显示所在控制器
 */
@property (nonatomic,weak)UIViewController *showVC;

/**
 当自己优先级高时移除当前
 */
@property (nonatomic,assign)BOOL removeCurrentWhenHigher;

/**
 优先级低时能不能被移除
 */
@property (nonatomic,assign)BOOL beRemoveWhenLower;

/**
 排队过期时间
 */
@property (nonatomic,assign)NSInteger invalidTime;

/**
  显示回调
 */
@property (nonatomic,copy)void (^finishBlock)(void);

/**
移除回调
 */
@property (nonatomic,copy)void (^removeBlock)(void);
/**
 点击背景回调
 */
@property (nonatomic,copy)void (^clickBGBlock)(void);
/**
 点击关闭按钮回调(如果有，添加关闭按钮)
 */
@property (nonatomic,copy)void (^clickCloseBlock)(void);
/**
点击返回按钮回调(如果有，添加返回按钮)
*/
@property (nonatomic,copy)void (^clickBackBlock)(void);


+ (StackPopupModel *)createWithClickBgBlock:(void(^)(void))clickCB bgColor:(UIColor *)bgColor;

@end

NS_ASSUME_NONNULL_END
