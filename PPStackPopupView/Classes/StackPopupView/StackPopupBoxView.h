//
//  StackPopupBoxView.h
//  StackPopupViewProject
//
//  Created by chenshenglong on 2020/8/28.
//  Copyright © 2020 chenshenglong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StackPopupModel;
NS_ASSUME_NONNULL_BEGIN

@interface StackPopupBoxView : UIView

+ (instancetype)createBoxView:(StackPopupModel *)model;

- (void)showCompletion:(void (^)(BOOL finish))completion;

- (void)hideCompletion:(void (^)(BOOL finish))completion;

@end

NS_ASSUME_NONNULL_END
