//
//  StackPopupViewConfig.m
//  fTalk
//
//  Created by chenshenglong on 2020/8/31.
//  Copyright © 2020 北京畅聊天下科技有限公司版权所有. All rights reserved.
//

#import "StackPopupViewConfig.h"

@interface StackPopupViewConfigManager()

@property (nonatomic,strong)NSMutableDictionary *configDict;

@end

@implementation StackPopupViewConfigManager

- (NSMutableDictionary *)configDict{
    if (!_configDict) {
        _configDict = [NSMutableDictionary dictionaryWithCapacity:40];
    }
    return _configDict;
}

static StackPopupViewConfigManager *CONFIG;
+ (instancetype)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CONFIG = [[self alloc]init];
    });
    return CONFIG;
}

- (BOOL)calibrateAndSetupData:(NSData *)respondData{
    
    if (respondData == nil && respondData.length <= 0) {
        return NO;
    }
    NSDictionary * recvDict = [NSJSONSerialization JSONObjectWithData:respondData options:NSJSONReadingAllowFragments error:nil];
    int status = [[recvDict objectForKey:@"status"]intValue];
    if (status == 100) {
        
        NSDictionary *dataDict = recvDict[@"data"];
        NSArray *keys = [dataDict allKeys];
        for (int i = 0; i < keys.count; ++i) {
            NSString *key = keys[i];
            NSDictionary *configDict = [dataDict objectForKey:key];
            StackPopupViewConfig *config = [[StackPopupViewConfig alloc]init];
            if (configDict[@"discard_time"]) {
                config.discardTime = [configDict[@"discard_time"]integerValue];
            }
            if(configDict[@"is_save"]){
                config.isSave = [configDict[@"is_save"]boolValue];
            }
            if(configDict[@"priority"]){
                config.priority = [configDict[@"priority"]integerValue];
            }
            if (configDict[@"remove_current_when_higher"]) {
                config.removeCurrentWhenHigher = [configDict[@"remove_current_when_higher"]boolValue];
            }
            if (configDict[@"be_remove_when_lower"]) {
                config.beRemoveWhenLower = [configDict[@"be_remove_when_lower"]boolValue];
            }
            [self.configDict setObject:config forKey:key];
        }
        return YES;
    }
    return NO;
}

- (StackPopupViewConfig *)getConfigWithClassName:(NSString *)clsName{
    if (!clsName || clsName.length <= 0) {
        return nil;
    }
    return [self.configDict objectForKey:clsName];
}

@end


@implementation StackPopupViewConfig

- (instancetype)init{
    if (self = [super init]) {
        self.removeCurrentWhenHigher = YES;
        self.beRemoveWhenLower = YES;
        self.discardTime = INT_MAX;
        self.isSave = NO;
        self.priority = 1;
    }
    return self;
}

@end
