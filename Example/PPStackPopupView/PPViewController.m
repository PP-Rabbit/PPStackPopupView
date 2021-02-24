//
//  PPViewController.m
//  PPStackPopupView
//
//  Created by PP-Rabbit on 02/24/2021.
//  Copyright (c) 2021 PP-Rabbit. All rights reserved.
//

#import "PPViewController.h"
#import "StackPopupViewHeader.h"
@interface PPViewController ()

@end

@implementation PPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [view it_stackPopupViewShow];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [view it_stackPopupViewHide];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        view.backgroundColor = [UIColor blueColor];
        [view it_stackPopupViewShowWithClick:^{
            [view it_stackPopupViewHide];
        }];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
