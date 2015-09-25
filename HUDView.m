//
//  HUDView.m
//  HUDDemo
//
//  Created by LXJ on 15/9/24.
//  Copyright © 2015年 GOME. All rights reserved.
//

#import "HUDView.h"

#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define TRANSPARENT_COLOR  RGBA(0, 0, 0, 0.8)

typedef enum {
    kHudTypeCycleLoading,
    kHudTypeDotLoading
} HUDType;


static HUDView *g_currentHUD = nil;


@interface HUDBody : UIView

@property (nonatomic, assign) HUDType type;

@end

@implementation HUDBody

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAnimationUI];
    }
    return self;
}

- (void)setType:(HUDType)type {
    if (_type != type) {
        _type = type;
        [self updateUI];
    }
}

- (void)updateUI {
    if (_type == kHudTypeCycleLoading) {
        [self setupCycleUI];
    } else if (_type == kHudTypeDotLoading ) {
        [self setupDotUI];
    }
}

- (void)setupAnimationUI {
    self.layer.cornerRadius = 6.f;
    self.layer.masksToBounds = YES;
    self.backgroundColor = TRANSPARENT_COLOR;
}

- (void)setupCycleUI {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 5;
    float ovalRadius = self.frame.size.height/2*0.8;
    layer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.frame.size.width/2 - ovalRadius, self.frame.size.height/2 - ovalRadius, ovalRadius*2, ovalRadius*2)].CGPath;
    [self.layer addSublayer:layer];
    
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @(-0.5f);
    strokeStartAnimation.toValue = @(1.0f);
    
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @(0.f);
    strokeEndAnimation.toValue = @(1.f);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 1.f;
    group.animations = [NSArray arrayWithObjects:strokeStartAnimation, strokeEndAnimation, nil];
    group.repeatCount = HUGE;
    
    [layer addAnimation:group forKey:nil];
}

- (void)setupDotUI {
    //设置replicatorLayer
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds = CGRectMake(0, 0, 20, 20);
    replicatorLayer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self.layer addSublayer:replicatorLayer];
    
    //设置小圆点一个
    CALayer *layer= [CALayer layer];
    layer.bounds = CGRectMake(0, 0, 5, 5);
    layer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 30);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.cornerRadius = 2.5f;
    [replicatorLayer addSublayer:layer];
    
    //复制15个小圆点
    //下面就来看看如何使用CAReplicatorLayer复制子Layer，并让子Layer形成一个圆形,首先对子Layer，也就是白色圆形复制了15份。然后将360°除以15份，算出每一个圆形针对它前一个圆形应该偏移的角度。最后我们用到了CATransform3DMakeRotation，它同样是CATransform3D的一个结构，含义是使Layer在X、Y、Z轴根据给定的角度旋转。这样我们复制的15份圆形就会按照我们计算的角度排列，并形成一个大圆
    replicatorLayer.instanceCount = 15;
    CGFloat angle = (2 * M_PI) / 15;
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
    
    CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnima.duration = 1.f;
    scaleAnima.fromValue = @(1.f);
    scaleAnima.toValue = @(0.1f);
    scaleAnima.repeatCount = HUGE;
    [layer addAnimation:scaleAnima forKey:nil];
    
    //1秒除以15个，这样就每个小圆点有个延迟的效果,1/15不行，必须1.0/15
    replicatorLayer.instanceDelay = 1.0/15;
    
    layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);

}

@end

@interface HUDView ()

@property (nonatomic, strong) HUDBody *bodyView;
@property (nonatomic, assign, readonly) CGPoint middlePoint;

@end

@implementation HUDView

- (CGPoint)middlePoint {
    CGRect rect = self.bounds;
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.bodyView = [[HUDBody alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.bodyView.center = self.middlePoint;
    [self addSubview:self.bodyView];
    
    self.backgroundColor = [UIColor clearColor];
    
}

+ (UIWindow *)window {
    static UIWindow *s_window = nil;
    if (!s_window) {
        s_window = [[UIApplication sharedApplication] keyWindow];
    }
    return s_window;
}

+ (HUDView *)createHUDIfNeed {
    
    if (!g_currentHUD) {
        g_currentHUD = [[HUDView alloc] initWithFrame:[self window].bounds];
        [[self window] addSubview:g_currentHUD];
    }
    
    return g_currentHUD;
}


+ (HUDView *)showCycleLoading {
    HUDView *hud = [self createHUDIfNeed];
    hud.bodyView.type = kHudTypeCycleLoading;
    return hud;
}

+ (HUDView *)showDotLoading {
    HUDView *hud = [self createHUDIfNeed];
    hud.bodyView.type = kHudTypeDotLoading;
    return hud;
}

+ (void)hide {
    [g_currentHUD removeFromSuperview];
    g_currentHUD = nil;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
