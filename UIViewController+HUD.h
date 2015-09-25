//
//  UIViewController+HUD.h
//  HUDDemo
//
//  Created by LXJ on 15/9/23.
//  Copyright © 2015年 GOME. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

//显示加载菊花的Hud
- (void)showHudInView:(UIView *)view text:(NSString *)text;
//只显示文本
- (void)showHudTextOnlyInView:(UIView *)view text:(NSString *)text;
//隐藏Hud
- (void)hideHud;

@end
