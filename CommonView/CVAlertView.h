//
//  CVAlertView.h
//  CommonView
//
//  Created by Jadenhu on 15/10/28.
//  Copyright © 2015年 CVTE. All rights reserved.
//

/*
 *  CVAlertView，可自定义title，内容视图，背景色以及button
 *
 */

#import <UIKit/UIKit.h>

typedef void (^ButtonAction)();


@interface CVAlertView : UIView

/**
 *  提醒框背景颜色
 */
@property (nonatomic,strong) UIColor *alertViewBackgroundColor;

/**
 *  主题颜色 默认为R：255 G：141 B：4
 */
@property (nonatomic,strong) UIColor *buttonNormalColor;

/**
 *  button选中后颜色 默认为R：212 G：117 B：4
 */
@property (nonatomic,strong) UIColor *buttonHighlitedColor;


/**
 *  默认是NO，如果为YES点击界面中出alertview以外的任何位置，alertview消失
 */
@property (nonatomic,assign) BOOL closeWhenTocuh;

/**
 *  标题颜色
 */
@property (nonatomic,assign) UIColor *titleColor;

/**
 *  标题字体
 */
@property (nonatomic,strong) UIFont *titleFont;

/**
 *  内容颜色，在未设置customView的时候有效
 */
@property (nonatomic,strong) UIColor *contentColor;

/**
 *  内容字体，在未设置customView的时候有效
 */
@property (nonatomic,strong) UIFont  *contentFont;


/**
 *  自定义内容视图,如果不为nil则contentLabel为nil
 */
@property (nonatomic,strong) UIView *customView;

#pragma -mark 构造函数 

/**
 *  @param title             提醒框标题
 *  @param message           提醒框内容
 *  @param cancelButtonTitle 取消按钮名称
 *  @param otherButtonTitle  其他按钮名称
 *  @param action            另一个按钮需要执行的事件
 *
 *  @return CVAlertView
 */
- (nonnull instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitle:(nullable NSString *)otherButtonTitle otherButtonAction:(nullable ButtonAction)action;

/**
 *
 *
 *  @param title              提醒框标题
 *  @param message            提醒框内容
 *  @param cancelButtonTitle  取消按钮名称
 *  @param otherButtonTitles  其他按钮名称数组
 *  @param actions            其他按钮名称动作数组
 *
 *  @return CVAlertView
 */
- (nonnull instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSArray *)otherButtonTitles otherButtonActions:(nullable NSArray *) actions;



/**
 *  显示CVAlertView
 */
- (void)showAlertView;

@end
