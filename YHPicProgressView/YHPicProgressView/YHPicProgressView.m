//
//  YHPicProgressView.m
//  YHPicProgressView
//
//  Created by zhouxf on 16/8/17.
//  Copyright © 2016年 busap. All rights reserved.
//

#import "YHPicProgressView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define degressToRadius(ang) (M_PI*(ang)/180.0f) //把角度转换成PI的方式

@implementation YHPicProgressView
{
    CAShapeLayer *_progressLayer;
    BOOL _isAnimation;
    double _form;
    double _to;
    NSTimer *_timer;
    CGFloat _lineWidth;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        _lineWidth = 1;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self gradentWith:rect];
}

- (void)gradentWith:(CGRect)frame{
    //设置贝塞尔曲线
    UIBezierPath *path = [self pathWithProgress:1.0 withFrame:frame];
    
    //底层
    CAShapeLayer * shape = [CAShapeLayer layer];
    shape.frame = self.bounds;
    shape.fillColor = [UIColor clearColor].CGColor;
    shape.strokeColor = [UIColor whiteColor].CGColor;
    shape.lineCap = kCALineCapButt;
    shape.lineWidth = _lineWidth;
    shape.path = path.CGPath;
    shape.strokeEnd = 1.0f;
    [self.layer addSublayer:shape];
    
    //遮罩层
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor=[UIColor redColor].CGColor;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = _lineWidth;
    _progressLayer.path = path.CGPath;
    
    //渐变图层
    CALayer * grain = [CALayer layer];
    grain.backgroundColor = [UIColor orangeColor].CGColor;
    
    // 颜色渐变
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width/2 - 5, self.bounds.size.height);
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[[UIColor orangeColor] CGColor],(id)[[UIColor orangeColor] CGColor], nil]];
    [gradientLayer setLocations:@[@0.1,@0.9,@1]];
    [gradientLayer setStartPoint:CGPointMake(0.5, 1)];
    [gradientLayer setEndPoint:CGPointMake(0.5, 0)];
    [grain addSublayer:gradientLayer];
    
    CAGradientLayer * gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(CGRectGetMaxX(gradientLayer.frame), 0, self.bounds.size.width-CGRectGetMaxX(gradientLayer.frame), self.bounds.size.height);
    [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[[UIColor orangeColor] CGColor],(id)[[UIColor orangeColor] CGColor], nil]];
    [gradientLayer1 setLocations:@[@0.1,@0.9,@1]];
    [gradientLayer1 setStartPoint:CGPointMake(0.5, 1)];
    [gradientLayer1 setEndPoint:CGPointMake(0.5, 0)];
    [grain addSublayer:gradientLayer1];
    
    //用progressLayer来截取渐变层 遮罩
    [grain setMask:_progressLayer];
    
    [self.layer addSublayer:grain];
    
    // 挡住中间的重叠
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = self.backgroundColor;
    [self addSubview:view];
    CGFloat vw = frame.size.width * 3 / 44.0;
    view.frame = CGRectMake((frame.size.width - vw) / 2, frame.size.width - vw / 2, vw, vw);
}

- (UIBezierPath *)pathWithProgress:(double)progress withFrame:(CGRect)frame {
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat left = frame.size.width * 10.0 / 44.0;
    CGPathMoveToPoint(path, NULL, left, frame.size.height / 2);
    CGPathAddLineToPoint(path, NULL, left + (frame.size.width - 2 * left) * progress, frame.size.height / 2);
    
    CGMutablePathRef path2 = CGPathCreateMutable();
    CGPathMoveToPoint(path2, NULL, left, frame.size.height / 2);
    CGPathAddArc(path2, NULL, frame.size.width / 2, frame.size.height / 2, (frame.size.width - 2 * left) / 2, M_PI, M_PI * (1 - progress), true);
    
    CGPathAddPath(path, NULL, path2);
    
    left = frame.size.width * 6.5 / 44.0;
    CGFloat radius = frame.size.width / 2 - _lineWidth;
    double p = progress;
    if (p > 0.1) {
        p = 0.1;
    }
    p = p / 0.1;
    CGMutablePathRef path3 = CGPathCreateMutable();
    CGPathMoveToPoint(path3, NULL, left, frame.size.height);
    double startAngle = 225;
    double endAngle = startAngle + (270 - startAngle) * p;
    CGPathAddArc(path3, NULL, _lineWidth + radius, _lineWidth + radius * 3, radius, degressToRadius(startAngle), degressToRadius(endAngle), false);
    
    if (progress > 0.1) {
        p = progress;
        if (p > 0.9) {
            p = 0.9;
        }
        p = (p - 0.1) / 0.8;
        startAngle = 90;
        endAngle = startAngle + (450 - startAngle) * p;
        CGPathMoveToPoint(path3, NULL, frame.size.width / 2, radius * 2);
        CGPathAddArc(path3, NULL, _lineWidth + radius, _lineWidth + radius, radius, degressToRadius(startAngle), degressToRadius(endAngle), false);
    }
    
    if (progress > 0.9) {
        p = progress;
        if (p > 1) {
            p = 1;
        }
        p = (p - 0.9) / 0.1;
        startAngle = 270;
        endAngle = startAngle + (315 - startAngle) * p;
        CGPathMoveToPoint(path3, NULL, frame.size.width / 2, radius * 2);
        CGPathAddArc(path3, NULL, _lineWidth + radius, _lineWidth + radius * 3, radius, degressToRadius(startAngle), degressToRadius(endAngle), false);
    }
    
    CGPathAddPath(path, NULL, path3);
    
    return [UIBezierPath bezierPathWithCGPath:path];
}

- (void)setProgress:(double)progress {
    if (_progress == progress) {
        return;
    }
    
    if (progress < 0) {
        progress = 0;
    }
    
    if (progress > 1) {
        progress = 1;
    }
    
    [_timer invalidate];
    _timer = nil;
    
    _form = !_isAnimation ? _progress : _to;
    _progress = progress;
    _to = _form;
    
    _timer = [NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(changePregressWithAnime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)changePregressWithAnime {
    BOOL isAdd = _form < _progress;
    if ((!isAdd && _to <= _progress)
        || (isAdd && _to >= _progress)) {
        [_timer invalidate];
        _timer = nil;
        _isAnimation = NO;
        return;
    }
    
    _isAnimation = YES;
    BOOL cw = YES;
    if (isAdd) {
        _to += 0.01;
    } else {
        _to -= 0.01;
        cw = NO;
    }
    
    
    UIBezierPath *path = [self pathWithProgress:_to withFrame:self.frame];
    _progressLayer.path = path.CGPath;
}

- (CAKeyframeAnimation *)keyframeAniamtion:(CGPathRef)path durTimes:(float)time Rep:(float)repeatTimes {
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    animation.path=path;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.autoreverses=NO;
    animation.duration=time;
    animation.repeatCount=repeatTimes;
    
    return animation;
}

@end
