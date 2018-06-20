//
//  DKFavoriteButton.m
//  DKFavoriteButton
//
//  Created by drinking on 2018/6/20.
//

#import "DKFavoriteButton.h"


@implementation DKFavoriteButton {
    
    CAKeyframeAnimation *_circleTransform;
    CAKeyframeAnimation *_circleMaskTransform;
    CAKeyframeAnimation *_lineStrokeStart;
    CAKeyframeAnimation *_lineStrokeEnd;
    CAKeyframeAnimation *_lineOpacity;
    CAKeyframeAnimation *_imageTransform;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        _circleColor = [UIColor colorWithRed:1 green:172.f/255.f blue:51.f/255.f alpha:1.0];
        _lineColor = [UIColor colorWithRed:250.f/255.f green:120.f/255.f blue:68.f/255.f alpha:1.0];
        _imageColorOn = [UIColor colorWithRed:197.f/255.f green:159.f/255.f blue:97.f/255.f alpha:1.0];
        _imageColorOff = [UIColor colorWithRed:136.f/255.f green:153.f/255.f blue:166.f/255.f alpha:1.0];
        _duration = 1.0;
        
        _circleTransform = [CAKeyframeAnimation  animationWithKeyPath:@"transform"];
        _circleMaskTransform = [CAKeyframeAnimation  animationWithKeyPath:@"transform"];
        _lineStrokeStart = [CAKeyframeAnimation  animationWithKeyPath:@"strokeStart"];
        _lineStrokeEnd = [CAKeyframeAnimation  animationWithKeyPath:@"strokeEnd"];
        _lineOpacity = [CAKeyframeAnimation  animationWithKeyPath:@"opacity"];
        _imageTransform = [CAKeyframeAnimation  animationWithKeyPath:@"transform"];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image {
    self = [self initWithFrame:frame];
    if(self) {
        _image = image;
        [self createLayers:image];
        [self addTargets];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self createLayers:image];
}

- (void)setCircleColor:(UIColor *)circleColor {
    _circleColor = circleColor;
    self.circleShape.fillColor = circleColor.CGColor;
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    for (CAShapeLayer *line in self.lines) {
        line.strokeColor = lineColor.CGColor;
    }
}

- (void)setImageColorOn:(UIColor *)imageColorOn {
    _imageColorOn = imageColorOn;
    if(self.isSelected) {
        self.imageShape.fillColor = imageColorOn.CGColor;
    }
}

- (void)setImageColorOff:(UIColor *)imageColorOff {
    _imageColorOff = imageColorOff;
    if(!self.isSelected) {
        self.imageShape.fillColor = imageColorOff.CGColor;
    }
}

- (void)setDuration:(CGFloat)duration {
    _duration = duration;
    _circleTransform.duration = 0.333 * duration; // 0.0333 * 10
    _circleMaskTransform.duration = 0.333 * duration; // 0.0333 * 10
    _lineStrokeStart.duration = 0.6 * duration; //0.0333 * 18
    _lineStrokeEnd.duration = 0.6 * duration; //0.0333 * 18
    _lineOpacity.duration = 1.0 * duration; //0.0333 * 30
    _imageTransform.duration = 1.0 * duration; //0.0333 * 30
}

- (void)setSelected:(BOOL)selected {
    if (self.selected != selected) {
        if(selected) {
            self.imageShape.fillColor = self.imageColorOn.CGColor;
        }else {
            [self deselect];
        }
    }
    [super setSelected:selected];
}

- (void)select {
    
    [super setSelected:YES];
    _imageShape.fillColor = self.imageColorOn.CGColor;
    [CATransaction begin];
    [_circleShape addAnimation:_circleTransform forKey:@"transform"];
    [_circleMask addAnimation:_circleMaskTransform forKey:@"transform"];
    [_imageShape addAnimation:_imageTransform forKey:@"transform"];
    
    for (CALayer *line in self.lines) {
        [line addAnimation:_lineStrokeStart forKey: @"strokeStart"];
        [line addAnimation:_lineStrokeEnd forKey: @"strokeEnd"];
        [line addAnimation:_lineOpacity forKey: @"opacity"];
    }
    [CATransaction commit];
}

- (void)deselect {
    
    [super setSelected:NO];
    self.imageShape.fillColor = self.imageColorOff.CGColor;
    [self.circleShape removeAllAnimations];
    [self.circleMask removeAllAnimations];
    [self.imageShape removeAllAnimations];
    [self.lines[0] removeAllAnimations];
    [self.lines[1] removeAllAnimations];
    [self.lines[2] removeAllAnimations];
    [self.lines[3] removeAllAnimations];
    [self.lines[4] removeAllAnimations];
    
}

- (void)createLayers:(UIImage *)image {
    
    self.layer.sublayers = nil;
    
    CGFloat width = self.frame.size.width/2;
    CGFloat height = self.frame.size.height/2;
    CGRect imageFrame = CGRectMake(width/2, height/2, width, height);
    CGPoint imgCenterPoint = CGPointMake(CGRectGetMidX(imageFrame), CGRectGetMidY(imageFrame));
    CGRect lineFrame = CGRectMake(imageFrame.origin.x-imageFrame.size.width/4, imageFrame.origin.y-imageFrame.size.height/4, imageFrame.size.width*1.5, imageFrame.size.height*1.5);
    
    //===============
    // circle layer
    //===============
    _circleShape = [CAShapeLayer new];
    _circleShape.bounds = imageFrame;
    _circleShape.position = imgCenterPoint;
    _circleShape.path = [UIBezierPath bezierPathWithOvalInRect:imageFrame].CGPath;
    _circleShape.fillColor = self.circleColor.CGColor;
    _circleShape.transform = CATransform3DMakeScale(0.0, 0.0, 1.0);
    [self.layer addSublayer:_circleShape];
    
    _circleMask = [CAShapeLayer new];
    _circleMask.bounds = imageFrame;
    _circleMask.position = imgCenterPoint;
    _circleMask.fillRule = kCAFillRuleEvenOdd;
    _circleShape.mask = _circleMask;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:imageFrame];
    [maskPath addArcWithCenter:imgCenterPoint radius:0.1 startAngle:0.0 endAngle:M_PI*2 clockwise:YES];
    _circleMask.path = maskPath.CGPath;
    
    //===============
    // line layer
    //===============
    NSMutableArray *lines = [NSMutableArray new];
    for (NSInteger i = 0; i<5; i++) {
        CAShapeLayer *line = [CAShapeLayer new];
        line.bounds = lineFrame;
        line.position = imgCenterPoint;
        line.masksToBounds = YES;
        line.actions = @{@"strokeStart": [NSNull null], @"strokeEnd": [NSNull null]};
        line.strokeColor = [self.lineColor CGColor];
        line.lineWidth = 1.25;
        line.miterLimit = 1.25;
        line.lineCap = kCALineCapRound;
        line.lineJoin = kCALineJoinRound;
        line.strokeStart = 0.0;
        line.strokeEnd = 0.0;
        line.opacity = 0.0;
        line.transform = CATransform3DMakeRotation(M_PI / 5 * (i * 2 + 1), 0.0, 0.0, 1.0);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, nil, CGRectGetMidX(lineFrame), CGRectGetMidY(lineFrame));
        CGPathAddLineToPoint(path, nil, lineFrame.origin.x + lineFrame.size.width/2, lineFrame.origin.y);
        line.path = path;
        [self.layer addSublayer:line];
        [lines addObject:line];
    }
    self.lines = lines;
    
    //===============
    // image layer
    //===============
    _imageShape = [CAShapeLayer new];
    _imageShape.bounds = imageFrame;
    _imageShape.position = imgCenterPoint;
    _imageShape.path = [UIBezierPath bezierPathWithRect:imageFrame].CGPath;
    _imageShape.fillColor = self.imageColorOff.CGColor;
    _imageShape.actions = @{@"fillColor": [NSNull null]};
    [self.layer addSublayer:_imageShape];
    
    _imageShape.mask = [CALayer new];
    _imageShape.mask.contents = CFBridgingRelease(self.image.CGImage);
    _imageShape.mask.bounds = imageFrame;
    _imageShape.mask.position = imgCenterPoint;
    
    //==============================
    // circle transform animation
    //==============================
    _circleTransform.duration = 0.333; // 0.0333 * 10
    _circleTransform.values = @[
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0,  0.0,  1.0)],    //  0/10
                              [NSValue valueWithCATransform3D: CATransform3DMakeScale(0.5,  0.5,  1.0)],    //  1/10
                              [NSValue valueWithCATransform3D: CATransform3DMakeScale(1.0,  1.0,  1.0)],    //  2/10
                              [NSValue valueWithCATransform3D: CATransform3DMakeScale(1.2,  1.2,  1.0)],    //  3/10
                              [NSValue valueWithCATransform3D: CATransform3DMakeScale(1.3,  1.3,  1.0)],    //  4/10
                              [NSValue valueWithCATransform3D: CATransform3DMakeScale(1.37, 1.37, 1.0)],    //  5/10
                              [NSValue valueWithCATransform3D: CATransform3DMakeScale(1.4,  1.4,  1.0)],    //  6/10
                              [NSValue valueWithCATransform3D: CATransform3DMakeScale(1.4,  1.4,  1.0)]     // 10/10
                              ];
    
    _circleTransform.keyTimes = @[
                               @(0.0),    //  0/10
                               @(0.1),    //  1/10
                               @(0.2),    //  2/10
                               @(0.3),    //  3/10
                               @(0.4),    //  4/10
                               @(0.5),    //  5/10
                               @(0.6),    //  6/10
                               @(1.0)     // 10/10
                               ];
    
    _circleMaskTransform.duration = 0.333; // 0.0333 * 10
    _circleMaskTransform.values = @[
                                  [NSValue valueWithCATransform3D: CATransform3DIdentity],                                                              //  0/10
                                  [NSValue valueWithCATransform3D: CATransform3DIdentity],                                                              //  2/10
                                  [NSValue valueWithCATransform3D: CATransform3DMakeScale(imageFrame.size.width * 1.25,  imageFrame.size.height * 1.25,  1.0)],   //  3/10
                                  [NSValue valueWithCATransform3D: CATransform3DMakeScale(imageFrame.size.width * 2.688, imageFrame.size.height * 2.688, 1.0)],   //  4/10
                                  [NSValue valueWithCATransform3D: CATransform3DMakeScale(imageFrame.size.width * 3.923, imageFrame.size.height * 3.923, 1.0)],   //  5/10
                                  [NSValue valueWithCATransform3D: CATransform3DMakeScale(imageFrame.size.width * 4.375, imageFrame.size.height * 4.375, 1.0)],   //  6/10
                                  [NSValue valueWithCATransform3D: CATransform3DMakeScale(imageFrame.size.width * 4.731, imageFrame.size.height * 4.731, 1.0)],   //  7/10
                                  [NSValue valueWithCATransform3D: CATransform3DMakeScale(imageFrame.size.width * 5.0,   imageFrame.size.height * 5.0,   1.0)],   //  9/10
                                  [NSValue valueWithCATransform3D: CATransform3DMakeScale(imageFrame.size.width * 5.0,   imageFrame.size.height * 5.0,   1.0)]    // 10/10
                                   ];
    
    _circleMaskTransform.keyTimes = @[
                                    @(0.0),    //  0/10
                                    @(0.2),    //  2/10
                                    @(0.3),    //  3/10
                                    @(0.4),    //  4/10
                                    @(0.5),    //  5/10
                                    @(0.6),    //  6/10
                                    @(0.7),    //  7/10
                                    @(0.9),    //  9/10
                                    @(1.0)     // 10/10
                                    ];
    
    //==============================
    // line stroke animation
    //==============================
    _lineStrokeStart.duration = 0.6; //0.0333 * 18
    _lineStrokeStart.values = @[
                              @(0.0),    //  0/18
                              @(0.0),    //  1/18
                              @(0.18),   //  2/18
                              @(0.2),    //  3/18
                              @(0.26),   //  4/18
                              @(0.32),   //  5/18
                              @(0.4),    //  6/18
                              @(0.6),    //  7/18
                              @(0.71),   //  8/18
                              @(0.89),   // 17/18
                              @(0.92)    // 18/18
                              ];
    
    _lineStrokeStart.keyTimes = @[
                                @(0.0),    //  0/18
                                @(0.056),  //  1/18
                                @(0.111),  //  2/18
                                @(0.167),  //  3/18
                                @(0.222),  //  4/18
                                @(0.278),  //  5/18
                                @(0.333),  //  6/18
                                @(0.389),  //  7/18
                                @(0.444),  //  8/18
                                @(0.944),  // 17/18
                                @(1.0),    // 18/18
                                ];
    
    _lineStrokeEnd.duration = 0.6; //0.0333 * 18
    _lineStrokeEnd.values = @[
                            @(0.0),    //  0/18
                            @(0.0),    //  1/18
                            @(0.32),   //  2/18
                            @(0.48),   //  3/18
                            @(0.64),   //  4/18
                            @(0.68),   //  5/18
                            @(0.92),   // 17/18
                            @(0.92)    // 18/18
                            ];
    
    _lineStrokeEnd.keyTimes = @[
                              @(0.0),    //  0/18
                              @(0.056),  //  1/18
                              @(0.111),  //  2/18
                              @(0.167),  //  3/18
                              @(0.222),  //  4/18
                              @(0.278),  //  5/18
                              @(0.944),  // 17/18
                              @(1.0),    // 18/18
                              ];
    

    _lineOpacity.duration = 1.0; //0.0333 * 30
    _lineOpacity.values = @[
                          @(1.0),    //  0/30
                          @(1.0),    // 12/30
                          @(0.0)     // 17/30
                          ];
    _lineOpacity.keyTimes = @[
                            @(0.0),    //  0/30
                            @(0.4),    // 12/30
                            @(0.567)   // 17/30
                            ];
    
    //==============================
    // image transform animation
    //==============================
    _imageTransform.duration = 1.0; //0.0333 * 30
    _imageTransform.values = @[
                             [NSValue valueWithCATransform3D:  CATransform3DMakeScale(0.0,   0.0,   1.0)],  //  0/30
                             [NSValue valueWithCATransform3D:  CATransform3DMakeScale(0.0,   0.0,   1.0)],  //  3/30
                             [NSValue valueWithCATransform3D:  CATransform3DMakeScale(1.2,   1.2,   1.0)],  //  9/30
                             [NSValue valueWithCATransform3D:  CATransform3DMakeScale(1.25,  1.25,  1.0)],  // 10/30
                             [NSValue valueWithCATransform3D:  CATransform3DMakeScale(1.2,   1.2,   1.0)],  // 11/30
                             [NSValue valueWithCATransform3D:  CATransform3DMakeScale(0.9,   0.9,   1.0)],  // 14/30
                             [NSValue valueWithCATransform3D:  CATransform3DMakeScale(0.875, 0.875, 1.0)],  // 15/30
                             [NSValue valueWithCATransform3D:  CATransform3DMakeScale(0.875, 0.875, 1.0)],  // 16/30
                             [NSValue valueWithCATransform3D:  CATransform3DMakeScale(0.9,   0.9,   1.0)],  // 17/30
                             [NSValue valueWithCATransform3D:  CATransform3DMakeScale(1.013, 1.013, 1.0)],  // 20/30
                             [NSValue valueWithCATransform3D:  CATransform3DMakeScale(1.025, 1.025, 1.0)],  // 21/30
                             [NSValue valueWithCATransform3D:  CATransform3DMakeScale(1.013, 1.013, 1.0)],  // 22/30
                             [NSValue valueWithCATransform3D:  CATransform3DMakeScale(0.96,  0.96,  1.0)],  // 25/30
                             [NSValue valueWithCATransform3D:  CATransform3DMakeScale(0.95,  0.95,  1.0)],  // 26/30
                             [NSValue valueWithCATransform3D:  CATransform3DMakeScale(0.96,  0.96,  1.0)],  // 27/30
                             [NSValue valueWithCATransform3D:  CATransform3DMakeScale(0.99,  0.99,  1.0)],  // 29/30
                             [NSValue valueWithCATransform3D:  CATransform3DIdentity]                       // 30/30
                              ];
    _imageTransform.keyTimes = @[
                               @(0.0),    //  0/30
                               @(0.1),    //  3/30
                               @(0.3),    //  9/30
                               @(0.333),  // 10/30
                               @(0.367),  // 11/30
                               @(0.467),  // 14/30
                               @(0.5),    // 15/30
                               @(0.533),  // 16/30
                               @(0.567),  // 17/30
                               @(0.667),  // 20/30
                               @(0.7),    // 21/30
                               @(0.733),  // 22/30
                               @(0.833),  // 25/30
                               @(0.867),  // 26/30
                               @(0.9),    // 27/30
                               @(0.967),  // 29/30
                               @(1.0)     // 30/30
                               ];
    
}

- (void)addTargets {
    [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(touchDragExit) forControlEvents:UIControlEventTouchDragExit];
    [self addTarget:self action:@selector(touchDragEnter) forControlEvents:UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(touchCancel) forControlEvents:UIControlEventTouchCancel];
    
}

- (void)touchDown {
    self.layer.opacity = 0.4;
}

- (void)touchUpInside {
    self.layer.opacity = 1.0;
}

- (void)touchDragExit {
    self.layer.opacity = 1.0;
}

- (void)touchDragEnter {
    self.layer.opacity = 0.4;
}

- (void)touchCancel {
    self.layer.opacity = 1.0;
}

@end
