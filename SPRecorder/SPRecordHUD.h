//
//  SPRecordHUD.h
//  SPRecorder
//
//  Created by Roselifeye on 2015-06-28.
//  Copyright © 2015 roselife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ChatCacheFileUtil.h"
#import "VoiceConverter.h"


#define MAX_RECORD_DURATION 600.0
#define WAVE_UPDATE_FREQUENCY   0.1
#define SILENCE_VOLUME   45.0
#define SOUND_METER_COUNT  6
#define HUD_SIZE  320.0

@class SPRecordHUD;

@protocol SPRecordHUDDelegate <NSObject>

@required
/**
 *  These three function is designed for Voice Input Function.
 */
- (void)recordTouchBegin:(UIButton *)button;

- (void)recordTouchStop:(UIButton *)button;

- (void)recordTouchCancel:(UIButton *)button;

@end

@interface SPRecordHUD : UIView <AVAudioPlayerDelegate, AVAudioRecorderDelegate>

@property(nonatomic, strong) id<SPRecordHUDDelegate> delegate;

- (void)recordStart:(UIButton *)sender;

- (void)recordStop:(UIButton *)sender;

- (void)recordCancel:(UIButton *)sender;

@end
