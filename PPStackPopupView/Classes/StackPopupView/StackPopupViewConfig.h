//
//  StackPopupViewConfig.h
//  fTalk
//
//  Created by chenshenglong on 2020/8/31.
//  Copyright © 2020 北京畅聊天下科技有限公司版权所有. All rights reserved.
//

#import <Foundation/Foundation.h>


@class StackPopupViewConfig;
NS_ASSUME_NONNULL_BEGIN

@interface StackPopupViewConfigManager : NSObject

+ (instancetype)share;

- (StackPopupViewConfig *)getConfigWithClassName:(NSString *)clsName;

@end


@interface StackPopupViewConfig : NSObject

/**
 有效期
 */
@property (nonatomic,assign)int discardTime;
/**
 push页面返回是否还存在
 */
@property (nonatomic,assign)int isSave;

/**
 优先级
 */
@property (nonatomic,assign)int priority;

/**
 当自己优先级高时移除当前
 */
@property (nonatomic,assign)BOOL removeCurrentWhenHigher;

/**
 优先级低时能不能被移除
 */
@property (nonatomic,assign)BOOL beRemoveWhenLower;


@end
NS_ASSUME_NONNULL_END
