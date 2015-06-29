//
//  SPBaseViewController.h
//  SPRecorder
//
//  Created by Roselifeye on 2015-06-28.
//  Copyright © 2015 roselife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RESideMenu.h>
#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, BAR_BTN_TYPE){
    BAR_BTN_BACK,       //返回按钮
    BAR_BTN_BACKALERT,  //待提示的返回按钮
    BAR_BTN_BACKCUSTOM, //返回按钮自定义函数
    BAR_BTN_MENU,       //菜单按钮
    BAR_BTN_NONE,       //无按钮
    BAR_BTN_RIGHT,     //右侧按钮
    BAR_BTN_SEND       //发送按钮
};

@interface SPBaseViewController : UIViewController <UIAlertViewDelegate> {
    BOOL mark;
    float angle_mark;
    UIButton *headBtn;
    
}

- (void)initBeginView;

// This function is the custome define of UINavigationItem.
- (void)addNavBarItem:(NSString *)title leftBtn:(BAR_BTN_TYPE)leftBtnType rightBtn:(BAR_BTN_TYPE)rightBtnType;

// This uses to show UIAlertMessage and includes button 'OK'.
- (void)showAlertWithMessage:(NSString *)message;


// This uses to show Alert Lable and will disappear in 3 seconds.
- (void)showAnimationLabelWithMessage:(NSString *)message;

@end
