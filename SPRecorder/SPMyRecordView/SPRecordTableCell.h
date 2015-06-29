//
//  SPRecordTableCell.h
//  SPRecorder
//
//  Created by Roselifeye on 2015-06-28.
//  Copyright © 2015 roselife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPRecordTableCell : UITableViewCell

@property (nonatomic, assign) NSObject *delegate;
@property (nonatomic, assign) SEL		didTouch;

@property (nonatomic, weak) IBOutlet UIButton *playBtn;

@property (nonatomic, weak) IBOutlet UILabel *audioNameLabel;

@end
