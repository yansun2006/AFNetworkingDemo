//
//  CommonViewController.m
//  TaoZhiHuiProj
//
//  Created by 焱 孙 on 15/12/26.
//  Copyright © 2015年 visionet. All rights reserved.
//

#import "CommonViewController.h"
#import "SNUIBarButtonItem.h"
#import "UIColor+SNFoundation.h"

@interface CommonViewController ()
{
    UIButton *backButton;
    UILabel *lblTitle;
}

@end

@implementation CommonViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initCommonConifg];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        [self initCommonConifg];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self initCommonConifg];
    }
    return self;
}

- (void)initCommonConifg
{
    self.isNeedBackItem = YES;
    self.hasNav = YES;
    self.bSupportPanUI = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bFirstAppear = YES;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationItem hidesBackButton];
    
    if (self.isNeedBackItem)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self getLeftButtonWithColor]];
    }
    else
    {
        
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.bFirstAppear = NO;
}

//设置status bar 颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    [self setTitleColor:[UIColor whiteColor]];
}

- (void)setTitleImage:(UIImage *)image
{
    [super setTitle:@""];
    
    UIImageView *imgViewIcon = [[UIImageView alloc]initWithImage:image];
    self.navigationItem.titleView = imgViewIcon;
}

- (void)setTitleColor:(UIColor *)color
{
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-Bold" size:20],UITextAttributeFont,nil]];
}

- (UIBarButtonItem *)leftBtnItemWithTitle:(NSString *)name
{
    if (!_leftBtnItem)
    {
        _leftBtnItem = [SNUIBarButtonItem itemWithTitle:name Style:SNNavItemStyleDone target:self action:@selector(leftButtonClick)];
    }
    return _leftBtnItem;
}

- (UIBarButtonItem *)leftBtnItemWithImage:(NSString *)strImageName
{
    if (!_leftBtnItem)
    {
        _leftBtnItem = [SNUIBarButtonItem itemWithImage:strImageName style:SNNavItemStyleDone target:self action:@selector(leftButtonClick)];
    }
    return _leftBtnItem;
}

- (UIBarButtonItem *)rightBtnItemWithTitle:(NSString *)name
{
    if (!_rightBtnItem)
    {
        _rightBtnItem = [SNUIBarButtonItem itemWithTitle:name Style:SNNavItemStyleDone target:self action:@selector(rightButtonClick)];
        _rightBtnItem.tintColor = [UIColor whiteColor];
    }
    return _rightBtnItem;
}

- (UIBarButtonItem *)rightBtnItemWithImage:(NSString *)strImageName
{
    if (!_rightBtnItem)
    {
        _rightBtnItem = [SNUIBarButtonItem itemWithImage:strImageName style:SNNavItemStyleDone target:self action:@selector(rightButtonClick)];
    }
    return _rightBtnItem;
}

//返回按钮响应
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//右边按钮响应
- (void)rightButtonClick
{
    
}

- (void)setBackButtonColor:(UIColor *)color
{
    self.colorBack = color;
}

- (UIButton *)getLeftButtonWithColor
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor clearColor];
    [btn setImage:[UIImage imageNamed:@"nav_back_white"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 44, 44);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    [btn addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    btn.tintColor = [UIColor whiteColor];;
    return btn;
}

@end
