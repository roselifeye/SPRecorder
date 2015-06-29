//
//  SPMainViewController.m
//  SPRecorder
//
//  Created by Roselifeye on 2015-06-28.
//  Copyright © 2015 roselife. All rights reserved.
//

#import "SPMainViewController.h"
#import "SPRecordHUD.h"

#import <JDStatusBarNotification/JDStatusBarNotification.h>

@interface SPMainViewController () <SPRecordHUDDelegate> {
    SPRecordHUD *recordView;
}

@end

@implementation SPMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavBarItem:@"开始录音" leftBtn:BAR_BTN_MENU rightBtn:BAR_BTN_NONE];
    
    recordView = [[SPRecordHUD alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 320)/2.f, 0, 320, 320)];
    [recordView setDelegate:self];
    [self.view addSubview:recordView];
}

- (IBAction)recordClicked:(UIButton *)sender {
    if (sender.selected) {
        [JDStatusBarNotification dismissAnimated:YES];
        [recordView recordStop:sender];
    } else {
        [JDStatusBarNotification showWithStatus:@"正在录音" styleName:@"JDStatusBarStyleDark"];
        [recordView recordStart:sender];
    }
    sender.selected = !sender.selected;
}

#pragma mark - 
#pragma mark - SPRecordHUD
- (void)recordTouchBegin:(UIButton *)button {
    
}

- (void)recordTouchStop:(UIButton *)button {

}

- (void)recordTouchCancel:(UIButton *)button {
    
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
