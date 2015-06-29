//
//  SPBaseViewController.m
//  SPRecorder
//
//  Created by Roselifeye on 2015-06-28.
//  Copyright © 2015 roselife. All rights reserved.
//

#import "SPBaseViewController.h"

@interface SPBaseViewController ()

@end

@implementation SPBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBeginView];
}

- (void)initBeginView {
    UIImage *bgImage = [UIImage imageNamed:@"LeftMenuBG"];
    self.view.layer.contents = (id) bgImage.CGImage;
}

- (void)addNavBarItem:(NSString *)title
              leftBtn:(BAR_BTN_TYPE)leftBtnType
             rightBtn:(BAR_BTN_TYPE)rightBtnType {
    [self.navigationItem setItemWithTitle:title textColor:RGBA(78, 78, 78, 1) fontSize:20 itemType:center];
    if (leftBtnType == BAR_BTN_MENU) {
        CustomBarItem *leftItem = [self.navigationItem setItemWithImage:@"backHome" size:CGSizeMake(30, 30) itemType:left];
        [leftItem addTarget:self selector:@selector(menuShow) event:(UIControlEventTouchUpInside)];
    }
    
    if (leftBtnType == BAR_BTN_BACK || leftBtnType == BAR_BTN_BACKALERT || leftBtnType == BAR_BTN_BACKCUSTOM) {
        
        CustomBarItem *leftItem = [self.navigationItem setItemWithImage:@"backBtn" size:CGSizeMake(30, 30) itemType:left];
        if (leftBtnType == BAR_BTN_BACK) {
            [leftItem addTarget:self selector:@selector(goBack) event:(UIControlEventTouchUpInside)];
        } else if (leftBtnType == BAR_BTN_BACKALERT) {
            [leftItem addTarget:self selector:@selector(goBackWithAlert) event:(UIControlEventTouchUpInside)];
        } else {
            [leftItem addTarget:self selector:@selector(goBackWithCustom) event:(UIControlEventTouchUpInside)];
        }
    }
    
    if (rightBtnType == BAR_BTN_RIGHT) {
        
        CustomBarItem *rightItem = [self.navigationItem setItemWithImage:@"addBtn" size:CGSizeMake(30, 30) itemType:right];
        [rightItem setOffset:10];//设置item偏移量(正值向左偏，负值向右偏)
        [rightItem addTarget:self selector:@selector(rightBtnAction) event:(UIControlEventTouchUpInside)];
    }
    
    if (rightBtnType == BAR_BTN_SEND) {
        
        CustomBarItem *rightItem = [self.navigationItem setItemWithImage:@"SendButton" size:CGSizeMake(30, 30) itemType:right];
        [rightItem setOffset:10];//设置item偏移量(正值向左偏，负值向右偏)
        [rightItem addTarget:self selector:@selector(rightBtnAction) event:(UIControlEventTouchUpInside)];
    }
}

- (void)menuShow {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goBackWithAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"是否放弃编辑？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = TAG_CANCEL_EDIT_ALERT;
    [alert show];
}

- (void)goBackWithCustom {
    
}

- (void)rightBtnAction {
    // ReWrite in Child ViewController
}

#pragma mark -
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == TAG_APP_UPDATA_ALERT
        && buttonIndex == alertView.firstOtherButtonIndex) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if (alertView.tag == TAG_CANCEL_EDIT_ALERT
        && buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//Alert弹出定义
- (void)showAlertWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)showAnimationLabelWithMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    hud.detailsLabelFont = [UIFont systemFontOfSize:13.0f];
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3.0];
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
