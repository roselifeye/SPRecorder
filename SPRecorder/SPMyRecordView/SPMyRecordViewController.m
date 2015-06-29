//
//  SPMyRecordViewController.m
//  SPRecorder
//
//  Created by Roselifeye on 2015-06-28.
//  Copyright © 2015 roselife. All rights reserved.
//

#import "SPMyRecordViewController.h"
#import "SPRecordTableCell.h"

#import <AVFoundation/AVFoundation.h>
#import "VoiceConverter.h"
#import "ChatCacheFileUtil.h"

@interface SPMyRecordViewController () <UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate> {
    
    NSMutableArray *audioArray;
    AVAudioPlayer *audioPlayer;
}

@end

@implementation SPMyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavBarItem:@"我的录音" leftBtn:BAR_BTN_MENU rightBtn:BAR_BTN_NONE];
    audioArray = [[NSMutableArray alloc] initWithArray:[[SPGlobalData shareInstance].dbManager queryAllRecordInfos]];
}

#pragma mark - 
#pragma mark - UITableViewDateSource
- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [audioArray count];
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SPRecordTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    SPRecordDataModel *data = [audioArray objectAtIndex:indexPath.row];
    [cell.audioNameLabel setText:data.recordDate];
    
    cell.playBtn.tag = indexPath.row;
    cell.didTouch = @selector(playBtnClicked:);
    cell.delegate = self;
    
    return  cell;
}

- (void)playBtnClicked:(UIButton *)sender {
    if (sender.selected) {
        [self audioStop];
    } else {
        SPRecordDataModel *data = [audioArray objectAtIndex:sender.tag];
        [self audioPlay:data.recordAddr];
    }
    sender.selected = !sender.selected;
}

- (BOOL)tableView:(nonnull UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(nonnull UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        SPRecordDataModel *data = [audioArray objectAtIndex:indexPath.row];
        [[SPGlobalData shareInstance].dbManager deleteRecordInfoWithAddr:data.recordAddr];
        [audioArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark Audio

- (void)sensorStateChange:(NSNotificationCenter *)notification; {
    if ([[UIDevice currentDevice] proximityState] == YES) {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

- (void)initPlayer{
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:sessionCategory error:nil];
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    
    [audioSession overrideOutputAudioPort:audioRouteOverride error:nil];
    
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    audioSession = nil;
}

- (void)audioPlay:(NSString *)voiceName {
    NSString *fullPath = [[[ChatCacheFileUtil sharedInstance] userDocPath] stringByAppendingPathComponent:voiceName];
    
    NSString *wavPath = [VoiceConverter amrToWav:fullPath];
    NSError *error=nil;
    [self audioStop];
    
    [self initPlayer];
    audioPlayer = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:wavPath] error:&error];
    
    [[ChatCacheFileUtil sharedInstance] deleteWithContentPath:wavPath];
    if (error) {
        error=nil;
    }
    [audioPlayer setVolume:1];
    [audioPlayer prepareToPlay];
    [audioPlayer setDelegate:self];
    [audioPlayer play];
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
}

- (void)audioStop {
    [audioPlayer stop];
}

#pragma mark -
#pragma mark - AVAudioDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
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
