//
//  CVAlertView.m
//  CommonView
//
//  Created by Jadenhu on 15/10/28.
//  Copyright © 2015年 CVTE. All rights reserved.
//

#import "CVAlertView.h"

#define CornerRadius 5.0
#define LeftRightMargin 25.0
#define AlertViewMaxWidth 290
#define buttonHeight 38.0
#define buttonHorizonMargin 10.0
#define buttonVerticalMargin 12.0
#define AlertViewMaxHeight 400
#define AlertViewVerticalMargin 100
#define CancelBorderColor [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1]
#define CancelHightedColor [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1]
#define CancelTitleColor  [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]
#define DefaultButtonNormalColor  [UIColor colorWithRed:255/255.0 green:141/255.0 blue:4/255.0 alpha:1]
#define DefaultButtonHighlitedColor [UIColor colorWithRed:217/255.0 green:112/255.0 blue:4/255.0 alpha:1]


@interface CVAlertView()

/**
 *  普通内容信息
 */
@property (nonatomic,strong) NSString *contentMessage;

/**
 * 带attributed修饰的内容信息
 */
@property (nonatomic,strong) NSAttributedString *attributedMessage;

/**
 *  提醒框标题
 */
@property (nonatomic,strong) NSString *title;


/**
 *  标题label
 */
@property (nonatomic,strong) UILabel *titleLabel;

/**
 *  内容label,如果其不为nil则customView为nil
 */
@property (nonatomic,strong) UILabel *contentLabel;



/**
 *  按钮集合
 */
@property (nonatomic,strong) NSMutableArray *buttonTitles;

/**
 *  需要执行的操作
 */
@property (nonatomic,strong) NSMutableArray *actions;

/**
 *  取消按钮的名称
 */
@property (nonatomic,strong) NSString *cancelTitle;

/**
 *  window
 */
@property (nonatomic,strong) UIWindow *parentWindow;

/**
 *  底部button集合
 */
@property (nonatomic,strong) NSMutableArray *buttonMutableArray;

/**
 *  当内容高度过高时，需要通过scrollview来控制
 */
@property (nonatomic,strong) UIScrollView *scrollView;


@end

@implementation CVAlertView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        self.contentMode     = UIViewContentModeRedraw;
        self.backgroundColor = [UIColor clearColor];
        self.alertViewBackgroundColor = [UIColor colorWithWhite:1 alpha:1];
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        self.buttonMutableArray = [NSMutableArray array];
        self.buttonHighlitedColor = DefaultButtonHighlitedColor;
        self.buttonNormalColor = DefaultButtonNormalColor;
        self.closeWhenTocuh    = NO;
        self.titleColor        = [UIColor blackColor];
        self.contentColor      = [UIColor blackColor];
        self.titleFont         = [UIFont systemFontOfSize:16];
        self.contentFont         = [UIFont systemFontOfSize:16];
        _buttonTitles = [NSMutableArray array];
        _actions      = [NSMutableArray array];
        //增加转屏监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChanged) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}


- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitle:(nullable NSString *)otherButtonTitle otherButtonAction:(nullable ButtonAction)action{
    self = [super init];
    if (self) {
        self.title = title;
        self.contentMessage = message;
        self.cancelTitle = cancelButtonTitle;
        if (self.cancelTitle) {
            [_buttonTitles addObject:self.cancelTitle];
            [_actions addObject:^{}];
        }
        if (otherButtonTitle) {
            [_buttonTitles addObject:otherButtonTitle];
        }
        if (action) {
            [self.actions addObject:action];
        }
    }
    return self;
}

- (nonnull instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSArray *)otherButtonTitles otherButtonActions:(nullable NSArray *) actions {
    self = [super init];
    if (self) {
        self.title = title;
        self.contentMessage = message;
        self.cancelTitle = cancelButtonTitle;
        if (self.cancelTitle) {
            [_buttonTitles addObject:self.cancelTitle];
            [_actions addObject:^{}];
        }
        if (otherButtonTitles) {
            [_buttonTitles addObjectsFromArray:otherButtonTitles];
        }
        if (actions) {
            [self.actions addObjectsFromArray:actions];
        }
    }
    return self;
}

- (UIColor *)alertViewBackgroundColor {
    if (!_alertViewBackgroundColor) {
        _alertViewBackgroundColor = [UIColor colorWithWhite:1 alpha:0.95];
    }
    return _alertViewBackgroundColor;
}

- (UILabel *)titleLabel {
    if (self.title&&!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font          = self.titleFont;
        _titleLabel.textColor     = self.titleColor;
        _titleLabel.text          = self.title;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (self.contentMessage&&!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font          = self.titleFont;
        _contentLabel.textColor     = self.titleColor;
        _contentLabel.text          = self.contentMessage;
    }
    return _contentLabel;
}

-(void)setCloseWhenTocuh:(BOOL)closeWhenTocuh {
    _closeWhenTocuh = closeWhenTocuh;
    if (_closeWhenTocuh) {
        [self.parentWindow addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWindow:)]];
    }
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:CornerRadius];
    if (_alertViewBackgroundColor) {
        [_alertViewBackgroundColor setFill];
    }
    [path fill];
}

- (void)showAlertView {
    UIView *superView = self.parentWindow.rootViewController.view;
    [self calculateLayout];
    [superView insertSubview:self atIndex:0];
    [self updateLayout];
    self.alpha = 0.0f;
    self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    _parentWindow.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
        self.parentWindow.hidden = NO;
        self.alpha = 1.0f;
        self.transform = CGAffineTransformIdentity;
        _parentWindow.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
    } completion:^(BOOL finished){
        
    }];
}


- (UIWindow *)parentWindow {
    if (!_parentWindow) {
        _parentWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _parentWindow.rootViewController = [[UIViewController alloc] init];
    }
    return _parentWindow;
}


- (void)calculateLayout {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    CGRect rect = [UIScreen mainScreen].bounds;
    rect = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(0, LeftRightMargin, 0,LeftRightMargin));
    rect.size.width = MIN(AlertViewMaxWidth, rect.size.width);
    CGSize size = rect.size;
    CGFloat contentMaxWidth = rect.size.width - 2 * LeftRightMargin;
    rect.origin.x   = LeftRightMargin;
    rect.size.width = contentMaxWidth;
    
    //计算各个view的大小及所有view加入后整个view的大小
    //titileLabel
    if (self.titleLabel) {
        [self.titleLabel removeFromSuperview];
        rect.origin.y     = CGRectGetMinY(rect)+15.0;
        rect.size.height  = [self.titleLabel sizeThatFits:CGSizeMake(contentMaxWidth, CGFLOAT_MAX)].height+0.0;
        self.titleLabel.frame = rect;
        rect.origin.y     = CGRectGetMaxY(rect);
        [self addSubview:self.titleLabel];
    }
    
    if (self.contentLabel) {
        [self.contentLabel removeFromSuperview];
        //内容
        rect.origin.y    = CGRectGetMinY(rect)+15.0;
        rect.size.height = [self.contentLabel sizeThatFits:CGSizeMake(contentMaxWidth, CGFLOAT_MAX)].height + 5.0f;
        self.contentLabel.frame = rect;
        [self addSubview:self.contentLabel];
        rect.origin.y    = CGRectGetMaxY(rect);
    }else {
        //自定义视图
        if (_customView) {
            rect.origin.y    = CGRectGetMinY(rect)+10.0;
            //customView的width是否小于最大宽度，需要重新判断
            rect.size.height = _customView.bounds.size.height + 10.0f;
            _customView.frame = rect;
            [self addSubview:_customView];
            rect.origin.y    = CGRectGetMaxY(rect);
        }
    }
    int numOfButtons    = (int)_buttonTitles.count;
    CGFloat buttonWidth = contentMaxWidth/numOfButtons;
    rect.origin.y       = CGRectGetMinY(rect)+5.0f;
    rect.origin.x       = (size.width - contentMaxWidth)/2.0;
    rect.size.width     = buttonWidth;
    rect.size.height    = buttonHeight+2*buttonVerticalMargin;
    
    for (int i=0; i<numOfButtons; i++) {
        CGRect buttonRect   = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(buttonVerticalMargin, buttonHorizonMargin, buttonVerticalMargin, buttonHorizonMargin));
        UIButton *bottomButton;
    
        if (numOfButtons==1) { //底边只有一个button
            bottomButton = [self createButton:self.buttonTitles[i] frame:buttonRect
                               backroundColor:self.buttonNormalColor highlightedColor:self.buttonHighlitedColor borderColor:nil];
           [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else { //底边有多个button
            
            if(i==0){
                bottomButton = [self createButton:self.buttonTitles[i] frame:buttonRect
                                   backroundColor:[UIColor clearColor] highlightedColor:CancelHightedColor borderColor:CancelBorderColor];
                [bottomButton setTitleColor:CancelTitleColor forState:UIControlStateNormal];
                
            }else {
                bottomButton = [self createButton:self.buttonTitles[i] frame:buttonRect
                                backroundColor:self.buttonNormalColor highlightedColor:self.buttonHighlitedColor borderColor:nil];
            }
        }
        bottomButton.frame = buttonRect;
        rect.origin.x +=buttonWidth;
        [self.buttonMutableArray addObject:bottomButton];
        [self addSubview:bottomButton];
    }
    super.frame = CGRectMake(0, 0, size.width, CGRectGetMaxY(rect));
}

- (void)updateLayout {
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat height = MIN(AlertViewMaxHeight, rect.size.height-2*AlertViewVerticalMargin);
    if (height<self.frame.size.height) {//超过最大高度，通过scrollview控制
        CGFloat relativeHeight = self.frame.size.height-height;//超出的高度
        UIView *contentView;
        if (_contentLabel) {
            contentView = _contentLabel;
        }else if(_customView) {
            contentView = _customView;
        }
        CGRect scrollViewRect = (CGRect){contentView.frame.origin,CGSizeMake(contentView.frame.size.width, contentView.frame.size.height - relativeHeight)};
        _scrollView = [[UIScrollView alloc] initWithFrame:scrollViewRect];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = contentView.frame.size;
        [contentView removeFromSuperview];
        [_scrollView addSubview:contentView];
        contentView.frame = contentView.bounds;
        [self addSubview:_scrollView];
        //更新下层button的位置
        for (UIButton *button in _buttonMutableArray) {
            button.frame = (CGRect){CGPointMake(button.frame.origin.x, button.frame.origin.y-relativeHeight),button.frame.size};
        }
        self.frame = (CGRect){self.frame.origin,CGSizeMake(self.frame.size.width, self.frame.size.height-relativeHeight)};
    }
    CGFloat x   = (rect.size.width - self.frame.size.width)/2;
    CGFloat y   = (rect.size.height - self.frame.size.height)/2;
    self.frame  =  CGRectMake(x, y, self.frame.size.width, self.frame.size.height);
}

- (void)close {
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        self.alpha = 0;
        _parentWindow.alpha  = 0;
        self.window.alpha = 0;
    } completion:^(BOOL finished) {
        _parentWindow.hidden = YES;
        self.window.hidden  = YES;
        self.window.alpha = 1.0f;
        [self removeFromSuperview];
        [_parentWindow removeFromSuperview];
    }];
}


- (UIButton *)createButton:(NSString *)title frame:(CGRect)rect backroundColor:(UIColor *)backgroundColor  highlightedColor:(UIColor *) highlitedColor borderColor:(UIColor *)borderColor {
    UIButton *button =  [[UIButton alloc] initWithFrame:rect];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBottomButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:backgroundColor];
    [button setBackgroundImage:[self imageWithColor:highlitedColor] forState:UIControlStateHighlighted];
    button.layer.cornerRadius = CornerRadius;
    button.layer.masksToBounds = YES;
    if (borderColor) {
        [button.layer setBorderColor:borderColor.CGColor];
        [button.layer setBorderWidth:1.0f];
    }
    return button;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, color.CGColor);
    CGContextFillRect(contextRef, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (void)touchBottomButton:(id)sender {
    if (sender) {
        for (int i=0; i<self.buttonMutableArray.count; i++) {
            if (sender==self.buttonMutableArray[i]) {
                ButtonAction action = self.actions[i];
                action();
                [self close];
                break;
            }
        }
    }
    
}

- (void)tapWindow:(id)sender {
    if (_closeWhenTocuh) {
        UITapGestureRecognizer *tap  = (UITapGestureRecognizer *)sender;
        CGPoint tapPoint = [tap locationInView:self.parentWindow.rootViewController.view];
        if (!CGRectContainsPoint(self.frame, tapPoint)){
            [self close];
        }
    }
}

//支持转屏
- (void)orientationDidChanged {
    //UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    //if (orientation == UIInterfaceOrientationLandscapeRight) {//home键在右边
    //}
    [self.buttonMutableArray removeAllObjects];
    self.hidden = YES;
    [self calculateLayout];
    [self updateLayout];
    self.hidden = NO;
    
}


@end
