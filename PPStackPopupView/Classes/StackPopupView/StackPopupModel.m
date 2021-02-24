//
//  StackPopupModel.m
//  StackPopupViewProject
//
//  Created by chenshenglong on 2020/8/28.
//  Copyright © 2020 chenshenglong. All rights reserved.
//

#import "StackPopupModel.h"

@implementation StackPopupModel

- (instancetype)init{
    if (self = [super init]) {
        [self parmInit];
    }
    return self;
}

- (void)parmInit{
    self.beRemoveWhenLower = YES;
    self.removeCurrentWhenHigher = YES;
    self.state = POPUP_STATE_WAIT;
    self.priority = POPUP_PRIORITY_1;
}

+ (StackPopupModel *)createWithClickBgBlock:(void(^)(void))clickCB bgColor:(UIColor *)bgColor{
  
    StackPopupModel *model = [[self alloc]init];
    model.clickBGBlock = clickCB;
    model.bgColor = bgColor;
    return model;
}

@end
