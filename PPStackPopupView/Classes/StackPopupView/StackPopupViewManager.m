//
//  StackPopupViewManager.m
//  StackPopupViewProject
//
//  Created by chenshenglong on 2020/8/28.
//  Copyright © 2020 chenshenglong. All rights reserved.
//

#import "StackPopupViewManager.h"
#import "StackPopupModel.h"
#import "StackPopupViewConfig.h"
#define SYSTEM_TIME (NSInteger)CACurrentMediaTime() * 0.001
@interface StackPopupViewManager ()

@property (nonatomic,strong)NSMutableArray <StackPopupModel *>*popupQueue;
@property (nonatomic,weak)StackPopupModel *currentPopup;
@property (nonatomic,strong)StackPopupModel *removeingPopup;
@property (nonatomic,assign)BOOL showing;//显示中
@property (nonatomic,assign)BOOL hideing;//隐藏中

@end

static StackPopupViewManager *POPUP_VIEW_MANAGER;

@implementation StackPopupViewManager{
    
    NSArray *NeedReservePopViewName;
}

- (NSMutableArray<StackPopupModel *> *)popupQueue{
    if (!_popupQueue) {
        
        _popupQueue = [NSMutableArray arrayWithCapacity:5];
    }
    return _popupQueue;
}

+ (instancetype)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        POPUP_VIEW_MANAGER = [[self alloc]init];
        POPUP_VIEW_MANAGER->NeedReservePopViewName = @[
            @"MayKnowView",
            @"FriendListPhoneComingPop",
            @"FriendListNewFriendComingPop",
            @"FriendListSelfComingPop",
            @"MoreEventPopupView",
            @"ITInviteJoinCheckPopView",
            @"ITGoddessGiftFamilySendPopView",
            @"ITGoddessGiftFamilySpGiftPopView",
            @"FGInvitePopView",
        ];
    });
    return POPUP_VIEW_MANAGER;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addNoti];
    }
    return self;
}

- (void)dealloc{
}

- (void)addNoti{
    
    
}

- (void)handleSysNoti:(NSNotification *)noti{

    
}

- (void)viewControllerPop{
    
    [self checkPopupShow];
}

/**
 加工弹窗model
 */
- (StackPopupModel *)processPopupModel:(StackPopupModel *)viewModel{
    NSString *clsName = NSStringFromClass([viewModel.contentView class]);
    if ([NeedReservePopViewName containsObject:clsName]) {//本地配置
        viewModel.backHold = YES;
    }
    StackPopupViewConfig *config = [[StackPopupViewConfigManager share]getConfigWithClassName:clsName];
    if (config) { // 网络配置
        viewModel.backHold = config.isSave;
        viewModel.priority = (POPUP_PRIORITY)config.priority;
        viewModel.invalidTime = SYSTEM_TIME + config.discardTime;
        viewModel.beRemoveWhenLower = config.beRemoveWhenLower;
        viewModel.removeCurrentWhenHigher = config.removeCurrentWhenHigher;
    }
    return viewModel;
}

- (void)addPopupViewModel:(StackPopupModel *)viewModel{
    
    viewModel = [self processPopupModel:viewModel];
    BOOL didInsert = NO;
    for (int i = 0; i < self.popupQueue.count; ++i) {
        StackPopupModel *model = self.popupQueue[i];
        if (viewModel.priority >= model.priority) {
            if (viewModel.removeCurrentWhenHigher && model.beRemoveWhenLower) {
                [self.popupQueue insertObject:viewModel atIndex:i];
            }else{
                int insertIndex = i+1;
                if(insertIndex < self.popupQueue.count){
                    [self.popupQueue insertObject:viewModel atIndex:insertIndex];
                }else{
                    [self.popupQueue addObject:viewModel];
                }
            }
            didInsert = YES;
            break;
        }
    }
    if (!didInsert) {
        [self.popupQueue addObject:viewModel];
    }
    [self checkPopupShow];
}

- (BOOL)bringPopupViewToFront:(Class)cls{
    
    StackPopupModel *popupModel = [self getPopupModelWithClass:cls];
    if (!popupModel) {
        return NO;
    }
    if (self.currentPopup == popupModel) {
        return YES;
    }
    if (self.currentPopup && self.currentPopup.beRemoveWhenLower == NO) {
        return NO;
    }
    popupModel.priority = POPUP_PRIORITY_BRING_FRONT;
    [self.popupQueue removeObject:popupModel];
    [self.popupQueue insertObject:popupModel atIndex:0];
    [self checkPopupShow];
    return YES;
}

- (BOOL)removePopupViewWithCls:(Class)cls{
    StackPopupModel *popupModel = [self getPopupModelWithClass:cls];
    if (!popupModel) {
        return NO;
    }
    [self removePopupViewModel:popupModel];
    return YES;
}

- (BOOL)removePopupViewModel:(StackPopupModel *)viewModel{
    return [self removePopupView:viewModel.contentView];
}

- (BOOL)removePopupView:(UIView *)view{
    for (int i = 0; i < self.popupQueue.count; ++i) {
        StackPopupModel *model = self.popupQueue[i];
        if (model.contentView == view) {
            if (model == self.currentPopup && model.state == POPUP_STATE_SHOW) {
                [self removeDidPopupView:self.popupQueue[i]];
            }else if(view.superview && view.superview.superview && [view.superview isKindOfClass:[StackPopupBoxView class]]){
                [view.superview removeFromSuperview];
            }
            [self.popupQueue removeObjectAtIndex:i];
            return YES;
        }
    }

    if (view && view.superview && view.superview.superview && [view.superview isKindOfClass:[StackPopupBoxView class]]) {
        [view.superview removeFromSuperview];
    }
    return NO;
}

- (void)cleanPoupupQueue{
    
    [self removePopupViewModel:self.currentPopup];
    [self.popupQueue removeAllObjects];
}

- (BOOL)removeFirstPopupViewModel{
    if (self.popupQueue.count > 0) {
        [self removeDidPopupView:self.popupQueue[0]];
        [self.popupQueue removeObjectAtIndex:0];
        return YES;
    }
    return NO;
}

- (void)removeDidPopupView:(StackPopupModel *)popupModel{
    
    if (popupModel.boxView.superview) {
        self.hideing = YES;
        self.removeingPopup = popupModel;
        StackPopupBoxView *boxView = popupModel.boxView;
        __weak typeof(boxView) weak_boxView = boxView;
        __weak typeof(self)weak_self = self;
        [boxView hideCompletion:^(BOOL finish) {
            __strong typeof(weak_boxView)strong_boxView = weak_boxView;
            __strong typeof(weak_self)strong_self = weak_self;
            [strong_boxView removeFromSuperview];
            strong_self.removeingPopup = nil;
            strong_self.currentPopup = nil;
            strong_self.hideing = NO;
            [strong_self checkPopupShow];
        }];
    }
}

- (BOOL)clsViewDidPopup:(Class)cls{
    
    UIView *contentView = self.currentPopup.contentView;
    if ([contentView isKindOfClass:cls] && self.currentPopup.boxView.superview) {
        return YES;
    }
    return NO;
}

- (BOOL)viewDidPopup:(UIView *)view{
    UIView *contentView = self.currentPopup.contentView;
    if ([contentView isEqual:view] && self.currentPopup.boxView.superview) {
        return YES;
    }
    return NO;
}


- (StackPopupModel *)getPopupModelWithClass:(Class)cls{
    for (int i = 0; i < self.popupQueue.count; ++i) {
        StackPopupModel *model = self.popupQueue[i];
        if ([model.contentView isKindOfClass:cls] && model.boxView.superview == nil) {
            return model;
        }
    }
    return nil;
}

- (StackPopupModel *)getPopupModelWithView:(UIView *)view{
    for (int i = 0; i < self.popupQueue.count; ++i) {
        StackPopupModel *model = self.popupQueue[i];
        if (model.contentView == view) {
            return model;
        }
    }
    return nil;
}



- (BOOL)clsViewInQueueUp:(Class )cls{
    for (int i = 0; i < self.popupQueue.count; ++i) {
        StackPopupModel *model = self.popupQueue[i];
        if ([model.contentView isKindOfClass:cls] && model.boxView.superview == nil) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)viewInQueueUp:(UIView *)view{
    for (int i = 0; i < self.popupQueue.count; ++i) {
        StackPopupModel *model = self.popupQueue[i];
        if (model.contentView == view && model.boxView.superview == nil) {
            return YES;
        }
    }
    return NO;
}

- (UIViewController *)fetchCurTopViewController
{
    UINavigationController *navVc = [UIApplication sharedApplication].keyWindow.rootViewController.navigationController;
    return [navVc.viewControllers firstObject];
}

- (void)checkPopupShow{

    if(self.hideing || self.showing){
        return;
    }
    NSMutableArray *invalidArr = [NSMutableArray array];
    for (int i = 0; i < self.popupQueue.count; ++i) {
        StackPopupModel *model = self.popupQueue[i];
        if ( model.invalidTime > 0 && SYSTEM_TIME > model.invalidTime) {
            [invalidArr addObject:model];
            continue;
        }
        UIWindow *windom = [self getWindom:model.contentView];
        POPUP_STATE state = model.state;
        switch (state) {
            case POPUP_STATE_SHOW:{
                return;
            }
                break;
            case POPUP_STATE_HOLD:{
                UIViewController *topVc = [self fetchCurTopViewController];
                if (topVc == model.showVC) {
                    [windom addSubview:model.boxView];
                    self.showing = YES;
                    model.state = POPUP_STATE_SHOW;
                    __weak typeof(self)weak_self = self;
                    [model.boxView showCompletion:^(BOOL finish) {
                        __strong typeof(weak_self)strong_self = weak_self;
                        strong_self.currentPopup = model;
                        strong_self.showing = NO;
                        [strong_self checkPopupShow];
                    }];
                    model.showVC = nil;
                    return;
                }
            }
                break;
            case POPUP_STATE_WAIT:{
                if(self.currentPopup && self.currentPopup.state == POPUP_STATE_SHOW){
                    self.hideing = YES;
                    __weak typeof(self)weak_self = self;
                    [self.currentPopup.boxView hideCompletion:^(BOOL finish) {
                        __strong typeof(weak_self)strong_self = weak_self;
                        
                        strong_self.hideing = NO;
                        strong_self.currentPopup.state = POPUP_STATE_WAIT;
                        [windom addSubview:model.boxView];
                        strong_self.showing = YES;
                        model.state = POPUP_STATE_SHOW;
                        [model.boxView showCompletion:^(BOOL finish) {
                            __strong typeof(weak_self)strong_self = weak_self;
                            strong_self.currentPopup = model;
                            strong_self.showing = NO;
                            [strong_self checkPopupShow];
                        }];
                        
                        self.currentPopup = model;
                    }];
                }else{
                    [windom addSubview:model.boxView];
                    self.showing = YES;
                    model.state = POPUP_STATE_SHOW;
                    __weak typeof(self)weak_self = self;
                    [model.boxView showCompletion:^(BOOL finish) {
                        __strong typeof(weak_self)strong_self = weak_self;
                        strong_self.currentPopup = model;
                        strong_self.showing = NO;
                        [strong_self checkPopupShow];
                    }];
                    
                }
                return;
                break;
            }
            default:
                break;
        }
    }
    if (invalidArr.count > 0) {
        [self.popupQueue removeObjectsInArray:invalidArr];
    }
}

- (UIWindow *)getWindom:(UIView *)contentView{
    return  [[UIApplication sharedApplication].windows firstObject];
}

@end
