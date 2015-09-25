//
//  HUDView.h
//  HUDDemo
//
//  Created by LXJ on 15/9/24.
//  Copyright © 2015年 GOME. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUDView : UIView

+ (HUDView *)showCycleLoading;

+ (HUDView *)showDotLoading;

+ (void)hide;

@end
