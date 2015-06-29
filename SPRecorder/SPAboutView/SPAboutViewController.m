//
//  SPAboutViewController.m
//  SPRecorder
//
//  Created by Roselifeye on 2015-06-28.
//  Copyright © 2015 roselife. All rights reserved.
//

#import "SPAboutViewController.h"

@interface SPAboutViewController ()

@end

@implementation SPAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavBarItem:@"关于" leftBtn:BAR_BTN_MENU rightBtn:BAR_BTN_NONE];
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
