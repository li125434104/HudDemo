//
//  testViewController.m
//  HUDDemo
//
//  Created by LXJ on 15/9/24.
//  Copyright © 2015年 GOME. All rights reserved.
//

#import "testViewController.h"
#import "HUDView.h"

@interface testViewController ()

@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSelfHud];
}

#pragma 自己的Hud
- (void)setSelfHud {
//    [HUDView showLoadingInView:self.view];
    
    [HUDView showDotLoading];
    
    [self performSelector:@selector(hide) withObject:nil afterDelay:3.f];
}

- (void)hide {
    [HUDView hide];
}

- (IBAction)buttonClick:(UIButton *)sender {
    NSLog(@"我能点哈哈哈！");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
