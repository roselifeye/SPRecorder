//
//  SPRecordTableCell.m
//  SPRecorder
//
//  Created by Roselifeye on 2015-06-28.
//  Copyright © 2015 roselife. All rights reserved.
//

#import "SPRecordTableCell.h"

@implementation SPRecordTableCell

- (void)setDelegate:(NSObject *)value {
    _delegate = value;
    
    if(_delegate && _didTouch)
        [_playBtn addTarget:_delegate action:_didTouch forControlEvents:UIControlEventTouchUpInside];
}

- (void)setDidTouch:(SEL)value {
    _didTouch = value;
    if(_delegate && _didTouch)
        [_playBtn addTarget:_delegate action:_didTouch forControlEvents:UIControlEventTouchUpInside];
}

@end
