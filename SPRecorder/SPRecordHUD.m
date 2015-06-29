//
//  SPRecordHUD.m
//  SPRecorder
//
//  Created by Roselifeye on 2015-06-28.
//  Copyright © 2015 roselife. All rights reserved.
//

#import "SPRecordHUD.h"
#import "SPRecordDataModel.h"

@interface SPRecordHUD () {
    /**
     *  Music Play
     */
    AVAudioRecorder *audioRecorder;
    NSURL *pathURL;
    
    BOOL recording;
    NSTimer *peakTimer;
    NSTimeInterval _timeLen;
    
    UILabel *timeLabel;
    CGRect hudRect;
    
    int soundMeters[SOUND_METER_COUNT];
}

@end

@implementation SPRecordHUD

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        for(int i=0; i<SOUND_METER_COUNT; i++) {
            soundMeters[i] = SILENCE_VOLUME;
        }
        
        self.backgroundColor = [UIColor clearColor];
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
        timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:35];
        [timeLabel setTextColor:[UIColor whiteColor]];
        timeLabel.center = CGPointMake(frame.size.width / 2.0 + 2, frame.size.height - 20);
        [timeLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:timeLabel];
        
        hudRect = CGRectMake(self.center.x - (HUD_SIZE / 2), self.center.y - (HUD_SIZE / 2), HUD_SIZE, HUD_SIZE);
    }
    return self;
}


/**
 *  Audio Record
 *
 *  @param sender Clicked Record Button
 */
- (void)recordStart:(UIButton *)sender {
    if(recording)
        return;
    recording=YES;
    
    /*
    NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithFloat:8000],AVSampleRateKey,
                            [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                            [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                            [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                            [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                            [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                            [NSNumber numberWithInt:AVAudioQualityLow],AVEncoderAudioQualityKey,
                            nil];
     */
    NSDictionary *settings = @{AVFormatIDKey : @(kAudioFormatLinearPCM),
                               AVEncoderBitRateKey : @(16),
                               AVEncoderAudioQualityKey : @(AVAudioQualityMax),
                               AVSampleRateKey : @(8000.0),
                               AVNumberOfChannelsKey : @(1)};
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
    NSString *fileName = [NSString stringWithFormat:@"rec_%@.wav",[dateFormater stringFromDate:now]];
    NSString *fullPath = [[[ChatCacheFileUtil sharedInstance] userDocPath] stringByAppendingPathComponent:fileName];
    NSURL *url = [NSURL fileURLWithPath:fullPath];
    pathURL = url;
    
    NSError *error;
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:pathURL settings:settings error:&error];
    audioRecorder.delegate = self;
    
    [audioRecorder prepareToRecord];
    [audioRecorder setMeteringEnabled:YES];
    [audioRecorder peakPowerForChannel:0];
    [audioRecorder recordForDuration:MAX_RECORD_DURATION];
    //[audioRecorder record];
    
    peakTimer = [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY target:self selector:@selector(updatePeak:) userInfo:nil repeats:YES];
    [peakTimer fire];
    
    if ([_delegate respondsToSelector:@selector(recordTouchBegin:)]) {
        [_delegate recordTouchBegin:sender];
    }
}

- (void)updatePeak:(NSTimer*)timer {
    [audioRecorder updateMeters];
    _timeLen = audioRecorder.currentTime;
    if(_timeLen>=MAX_RECORD_DURATION)
        [self recordStop:nil];

    [timeLabel setText:[NSString stringWithFormat:@"%.0fs", _timeLen]];
    if ([audioRecorder averagePowerForChannel:0] < -SILENCE_VOLUME) {
        [self addSoundMeterItem:SILENCE_VOLUME];
        return;
    }
    [self addSoundMeterItem:[audioRecorder averagePowerForChannel:0]];
}

- (void)addSoundMeterItem:(int)lastValue{
    for(int i=0; i<SOUND_METER_COUNT - 1; i++) {
        soundMeters[i] = soundMeters[i+1];
    }
    soundMeters[SOUND_METER_COUNT - 1] = lastValue;
    
    [self setNeedsDisplay];
}

- (void)recordStop:(UIButton *)sender {
    if(!recording)
        return;
    [peakTimer invalidate];
    peakTimer = nil;
    
    _timeLen = audioRecorder.currentTime;
    [audioRecorder stop];
    NSString *amrPath = [VoiceConverter wavToAmr:pathURL.path];
    
    [[ChatCacheFileUtil sharedInstance] deleteWithContentPath:pathURL.path];
    NSString *fileName = [[amrPath lastPathComponent] copy];
    SPRecordDataModel *recordData = [[SPRecordDataModel alloc] init];
    recordData.recordAddr = fileName;
    recordData.recordAuthor = @"Deng";
    recordData.recordDate = [NSString stringWithFormat:@"%@", [NSDate date]];
    recordData.recordLenth = [NSString stringWithFormat:@"%f", _timeLen];
    [[SPGlobalData shareInstance].dbManager insertRecordInfo:recordData];
    recording = NO;
    
    _timeLen = 0.f;
    [timeLabel setText:[NSString stringWithFormat:@"%.0fs", _timeLen]];
    
    if ([_delegate respondsToSelector:@selector(recordTouchStop:)]) {
        [_delegate recordTouchStop:sender];
    }
}

- (void)recordCancel:(UIButton *)sender {
    if(!recording)
        return;
    [audioRecorder stop];
    [peakTimer invalidate];
    peakTimer = nil;
    recording = NO;
    
    if ([_delegate respondsToSelector:@selector(recordTouchCancel:)]) {
        [_delegate recordTouchCancel:sender];
    }
}

#pragma mark - Drawing operations
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    int baseLine = 250;
    static int multiplier = 1;
    int maxLengthOfWave = 45;
    int maxValueOfMeter = 400;
    int yHeights[6];
    float segement[6] = {0.05, 0.2, 0.35, 0.25, 0.1, 0.05};
    
    [RGBA(55, 180, 262, 1) set];
//    [[UIColor colorWithRed:55/255.0 green:180/255.0 blue:252/255.0 alpha:1] set];
    CGContextSetLineWidth(context, 2.0);
    
    
    for(int x = SOUND_METER_COUNT - 1; x >= 0; x--) {
        int multiplier_i = ((int)x % 2) == 0 ? 1 : -1;
        CGFloat y = ((maxValueOfMeter * (maxLengthOfWave - abs(soundMeters[(int)x]))) / maxLengthOfWave);
        yHeights[SOUND_METER_COUNT - 1 - x] = multiplier_i * y * segement[SOUND_METER_COUNT - 1 - x]  * multiplier+ baseLine;
    }
    [self drawLinesWithContext:context BaseLine:baseLine HeightArray:yHeights lineWidth:2.0 alpha:0.8 percent:1.0 segementArray:segement];
    [self drawLinesWithContext:context BaseLine:baseLine HeightArray:yHeights lineWidth:1.0 alpha:0.4 percent:0.66 segementArray:segement];
    [self drawLinesWithContext:context BaseLine:baseLine HeightArray:yHeights lineWidth:1.0 alpha:0.2 percent:0.33 segementArray:segement];
    multiplier = -multiplier;
}

- (void)drawLinesWithContext:(CGContextRef)context BaseLine:(float)baseLine HeightArray:(int*)yHeights lineWidth:(CGFloat)width alpha:(CGFloat)alpha percent:(CGFloat)percent segementArray:(float *)segement{
    
    CGFloat start = 0;
    [RGBA(55, 180, 262, 1) set];
//    [[UIColor colorWithRed:55/255.0 green:180/255.0 blue:252/255.0 alpha:1] set];
    CGContextSetLineWidth(context, width);
    
    for (int i = 0; i < 6; i++) {
        if (i % 2 == 0) {
            CGContextMoveToPoint(context, start, baseLine);
            
            CGContextAddCurveToPoint(context, HUD_SIZE *segement[i] / 2 + start, (yHeights[i] - baseLine)*percent + baseLine, HUD_SIZE *segement[i] + HUD_SIZE *segement[i + 1] / 2 + start, (yHeights[i + 1] - baseLine)*percent + baseLine,HUD_SIZE *segement[i] + HUD_SIZE *segement[i + 1] + start , baseLine);
            start += HUD_SIZE *segement[i] + HUD_SIZE *segement[i + 1];
        }
    }
    
    CGContextStrokePath(context);
}


@end
