//
//  DKFavoriteButton.h
//  DKFavoriteButton
//
//  Created by drinking on 2018/6/20.
//

#import <UIKit/UIKit.h>

@interface DKFavoriteButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;

@property(nonatomic,strong) UIImage *image;
@property(nonatomic,strong) CAShapeLayer *imageShape;

@property(nonatomic,strong) CAShapeLayer *circleShape;
@property(nonatomic,strong) CAShapeLayer *circleMask;
@property(nonatomic,strong) UIColor *circleColor;

@property(nonatomic,strong) NSArray<CAShapeLayer *> *lines;
@property(nonatomic,strong) UIColor *lineColor;

@property(nonatomic,strong) UIColor *imageColorOn;
@property(nonatomic,strong) UIColor *imageColorOff;

@property(nonatomic,assign) CGFloat duration;

- (void)select;

- (void)deselect;

@end
