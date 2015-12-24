//
//  MLCPlayerViewController.m
//  MusicListChallenge
//
//  Created by Ilya Bugaev on 23.12.15.
//  Copyright © 2015 Ilya Bugaev. All rights reserved.
//

#import "MLCPlayerViewController.h"

#import <AVFoundation/AVFoundation.h>

#import <UIImageView+AFNetworking.h>

#import "MLCUtilities.h"

@interface MLCPlayerViewController () <AVAudioPlayerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *albumLogoImageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *albumLogoHeightConstraint;

@property (nonatomic, weak) IBOutlet UISlider *songSlider;
@property (nonatomic, weak) IBOutlet UIButton *playButton;

@property (nonatomic, weak) IBOutlet UILabel *currentTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *elapsedTimeLabel;

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) NSTimer *timer;

@property (nonatomic, assign) BOOL albumLogoAdjusted;

@end

@implementation MLCPlayerViewController

#pragma mark - Lifecycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.albumLogoAdjusted = NO;
    self.songSlider.minimumValue = 0.0f;
    self.songSlider.maximumValue = 0.0f;
    self.songSlider.enabled = NO;;
    self.playButton.enabled = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self preparePlayer];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.albumLogoImageView setImageWithURL:[NSURL URLWithString:self.melody.picUrl]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!self.albumLogoAdjusted) {
        self.albumLogoHeightConstraint.constant = CGRectGetWidth(self.albumLogoImageView.frame);
        self.albumLogoAdjusted = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.audioPlayer stop];
    [self.timer invalidate];
}

#pragma mark - Public -

#pragma mark - Private -

- (void)updateSlider {
    NSInteger durationMinutes = [self.audioPlayer duration] / 60;
    NSInteger durationSeconds = [self.audioPlayer duration]  - durationMinutes * 60;
    
    NSInteger currentTimeMinutes = [self.audioPlayer currentTime] / 60;
    NSInteger currentTimeSeconds = [self.audioPlayer currentTime] - currentTimeMinutes * 60;
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%i:%02i", (int)currentTimeMinutes, (int)currentTimeSeconds];
    self.elapsedTimeLabel.text = [NSString stringWithFormat:@"-%i:%02i", (int)(durationMinutes - currentTimeMinutes), (int)(durationSeconds - currentTimeSeconds)];
    
    self.songSlider.minimumValue = 0.0;
    self.songSlider.maximumValue = [self.audioPlayer duration];
    
    [self.songSlider setValue:[self.audioPlayer currentTime] animated:NO];
}

- (void)updatePlayButton {
    NSString *buttonTitle = [self.audioPlayer isPlaying] ? @"Pause" : @"Play";
    [self.playButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.playButton setNeedsLayout];
    [self.playButton layoutIfNeeded];
}

#pragma mark - Action -

- (IBAction)closeButtonTapped:(id)sender {
    [self.audioPlayer stop];
    [self.timer invalidate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sliderValueChanged:(id)sender {
    float position = self.songSlider.value;
    [self.audioPlayer setCurrentTime:position];
    
    [self updateSlider];
}

- (IBAction)playPause:(id)sender {
    if ([self.audioPlayer isPlaying]) {
        [self pause];
    } else {
        [self play];
    }
}

#pragma mark - Player -

- (void)preparePlayer {
    NSString* resourcePath = self.melody.demoUrl;
    NSData *rawData = [NSData dataWithContentsOfURL:[NSURL URLWithString:resourcePath]];
    NSError *error;
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:rawData error:&error];
    self.audioPlayer.numberOfLoops = 0;
    self.audioPlayer.volume = 1.0f;
    [self.audioPlayer prepareToPlay];
    
    self.audioPlayer.delegate = self;
    
    if (self.audioPlayer == nil) {
        NSLog(@"%@", [error description]);
        [MLCUtilities showAlert:nil message:NSLocalizedString(@"music.player.download.error", nil) presenter:self];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.songSlider.enabled = YES;
            self.playButton.enabled = YES;
            
            [self updateSlider];
        });
        
        [self play];
    }
}

- (void)play {
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
            [self updatePlayButton];
        });
    }
}

- (void)pause {
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer pause];
        [self.timer invalidate];
        self.timer = nil;
        
        [self updatePlayButton];
    }
}

#pragma mark - AVAudioPlayerDelegate -

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        [self.timer invalidate];
        self.timer = nil;
        
        [self updatePlayButton];
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    
}

@end
