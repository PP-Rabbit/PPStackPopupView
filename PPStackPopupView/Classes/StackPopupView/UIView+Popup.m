//
//  UIView+Popup.m
//  StackPopupViewProject
//
//  Created by chenshenglong on 2020/8/28.
//  Copyright © 2020 chenshenglong. All rights reserved.
//

#import "UIView+Popup.h"
#import "StackPopupViewManager.h"
#import "StackPopupBoxView.h"

@implementation UIView (Popup)

+ (BOOL)it_didPopupOrQueueUp{
    
    BOOL didPopup = [[StackPopupViewManager share] clsViewDidPopup:[self class]];
    if (didPopup) {
        return YES;
    }
    BOOL inQueue = [[StackPopupViewManager share]clsViewInQueueUp:[self class]];
    if (inQueue) {
        return YES;
    }
    return NO;
}

+ (BOOL)it_hasPopupView{
    
    return [[StackPopupViewManager share]clsViewInQueueUp:[self class]];
}

+ (BOOL)it_bringToTop{
    BOOL didPopup = [[StackPopupViewManager share] clsViewDidPopup:[self class]];
    if (didPopup) {
        return YES;
    }
    BOOL inQueue = [[StackPopupViewManager share]clsViewInQueueUp:[self class]];
    if (inQueue) {
        BOOL result = [[StackPopupViewManager share] bringPopupViewToFront:[self class]];
        return result;
    }
    return NO;
}

-(StackPopupModel *)it_stackPopupViewShowWithClick:(nullable void(^)(void))block
                                              mask:(nullable UIColor *)mask
                                          priority:(POPUP_PRIORITY)priority{
    return [self it_stackPopupViewWithClick:block withClickCloseBlock:nil WithBackBlock:nil removeBlock:nil finishBlock:nil withBGColor:mask withBGImage:nil priority:priority];
}

-(StackPopupModel *)it_stackPopupViewShow{
    return [self it_stackPopupViewShowWithClick:nil];
}
-(StackPopupModel *)it_stackPopupViewShowWithClick:(nullable void (^)(void))block{
    
    return [self it_stackPopupViewShowWithClick:block withMask:nil];
}
-(StackPopupModel *)it_stackPopupViewShowWithClick:(nullable void (^)(void))block
                                          withMask:(nullable UIColor*)mask{
    return [self it_stackPopupViewShowWithClick:block withFinish:nil withMask:mask];
}
-(StackPopupModel *)it_stackPopupViewShowWithClick:(nullable void (^)(void))block
                                        withFinish:(nullable void (^)(void))finish{
    return [self it_stackPopupViewShowWithClick:block withFinish:finish withImage:nil removeView:nil];
}
-(StackPopupModel *)it_stackPopupViewShowWithClick:(nullable void (^)(void))block
                                        withFinish:(nullable void (^)(void))finish
                                          withMask:(nullable UIColor*)mask{
    return [self it_stackPopupViewWithClick:block withClickCloseBlock:nil WithBackBlock:nil removeBlock:nil finishBlock:finish withBGColor:mask withBGImage:nil priority:POPUP_PRIORITY_1];
}
-(StackPopupModel *)it_stackPopupViewShowWithClick:(nullable void (^)(void))block
                                        withFinish:(nullable void (^)(void))finish
                                         withImage:(nullable UIImage*)image{
    return [self it_stackPopupViewShowWithClick:block withFinish:finish withImage:image removeView:nil];
}
-(StackPopupModel *)it_stackPopupViewShowWithClick:(nullable void (^)(void))block
                                        withFinish:(nullable void (^)(void))finish
                                         withImage:(nullable UIImage*)image
                                        removeView:(nullable void (^)(void))removeView{
    
    return [self it_stackPopupViewWithClick:block withClickCloseBlock:nil WithBackBlock:nil removeBlock:nil finishBlock:finish withBGColor:nil withBGImage:image priority:POPUP_PRIORITY_1];
}
-(StackPopupModel *)it_stackPopupViewShowWithClick:(nullable void (^)(void))block
                                        withFinish:(nullable void (^)(void))finish
                                              back:(nullable void (^)(void))back
                                             close:(nullable void (^)(void))close{
    
    return [self it_stackPopupViewWithClick:block withClickCloseBlock:close WithBackBlock:back removeBlock:nil finishBlock:finish withBGColor:kDefaultMaskColor withBGImage:nil];
}

- (StackPopupModel *)it_stackPopupViewWithClick:(nullable void (^)(void))clickBGBlock
                             withClickCloseBlock:(nullable void (^)(void))clickCloseBlock
                                   WithBackBlock:(nullable void (^)(void))backBlock
                                     removeBlock:(nullable void (^)(void))removeBlock
                                     finishBlock:(nullable void (^)(void))finishBlock
                                     withBGColor:(nullable UIColor *)bgColor
                                     withBGImage:(nullable UIImage *)bgImage{
    return [self it_stackPopupViewWithClick:clickBGBlock withClickCloseBlock:clickCloseBlock WithBackBlock:backBlock removeBlock:removeBlock finishBlock:finishBlock withBGColor:bgColor withBGImage:bgImage priority:POPUP_PRIORITY_1];
}


- (StackPopupModel *)it_stackPopupViewWithClick:(nullable void (^)(void))clickBGBlock
                            withClickCloseBlock:(nullable void (^)(void))clickCloseBlock
                                  WithBackBlock:(nullable void (^)(void))backBlock
                                    removeBlock:(nullable void (^)(void))removeBlock
                                    finishBlock:(nullable void (^)(void))finishBlock
                                    withBGColor:(nullable UIColor *)bgColor
                                    withBGImage:(nullable UIImage *)bgImage
                                       priority:(POPUP_PRIORITY)priority{
    StackPopupModel *model = [[StackPopupModel alloc]init];
    model.state = POPUP_STATE_WAIT;
    model.contentView = self;
    model.clickBGBlock = clickBGBlock;
    model.clickCloseBlock = clickCloseBlock;
    model.clickBackBlock = backBlock;
    model.finishBlock = finishBlock;
    model.removeBlock = removeBlock;
    model.bgColor = bgColor;
    model.bgImage = bgImage;
    model.priority = priority;
    model.boxView = [StackPopupBoxView createBoxView:model];
    [[StackPopupViewManager share]addPopupViewModel:model];
    return model;
}

- (void)it_stackPopupWithModel:(StackPopupModel *)popupModel{
    popupModel.boxView = [StackPopupBoxView createBoxView:popupModel];
    popupModel.contentView = self;
    [[StackPopupViewManager share]addPopupViewModel:popupModel];
}


-(void)it_stackPopupViewHide{
    
    [[StackPopupViewManager share]removePopupView:self];
}

-(void)it_stackPopupViewHideForce{
    [[StackPopupViewManager share]removePopupView:self];
}

-(void)it_setStackViewPriority:(int)priority{
    
    StackPopupModel *model = [[StackPopupViewManager share]getPopupModelWithView:self];
    model.priority = (POPUP_PRIORITY)priority;
}

@end
