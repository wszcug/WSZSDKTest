//
//  PlayerViewController.m
//  QPlayerSDKDemo
//
//  Created by maczhou on 2021/10/14.
//

#import "PlayerViewController.h"
#import <QPlayerSDK/QPlayerSDK.h>
#import "Masonry.h"
#import "SDWebImage.h"
#import "SVProgressHUD.h"
#import "PlaylistViewController.h"
#import "CustomSlider.h"

@interface PlayerViewController ()<QPlayerManagerDelegate>
@property (nonatomic) NSArray<QPSongInfo *> *songList;
@property (nonatomic) NSInteger currentPlayIndex;
@property (nonatomic) BOOL autoPlay;
@property (nonatomic) QPSongInfo *currentSong;
@property (nonatomic) UIImageView *coverImageView;

@property (nonatomic) CustomSlider *slider;
@property (nonatomic) UIButton *playButton;
@property (nonatomic) UIButton *modeButton;
@property (nonatomic) UIButton *nextButton;
@property (nonatomic) UIButton *previousButton;
@property (nonatomic) UILabel *cacheLabel;
@property (nonatomic) UILabel *beginTimeLabel;
@property (nonatomic) UILabel *endTimeLabel;
@property (nonatomic) BOOL sliderDragged;
@property (nonatomic) NSTimer *timer;

@end

@implementation PlayerViewController

- (instancetype)initWithSongList:(NSArray<QPSongInfo *> *)songList index:(NSInteger)index autoPlay:(BOOL)autoPlay {
    self = [super init];
    if (self) {
        self.songList = songList;
        self.currentPlayIndex = index;
        self.autoPlay = autoPlay;
    }
    return self;
}

- (void)reloadWithData:(NSArray<QPSongInfo *> *)songList index:(NSInteger)index autoPlay:(BOOL)autoPlay {
    self.songList = songList;
    self.currentPlayIndex = index;
    self.autoPlay = autoPlay;
    
    if (self.autoPlay) {
        [[QPlayerManager sharedInstance] playSongs:self.songList index:self.currentPlayIndex];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
    [self setupConstraints];
}

- (void)dealloc {
    [self.timer invalidate];
    [QPlayerManager sharedInstance].delegate = nil;
}

#pragma mark: - commonInit
- (void)commonInit {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"chevron.down" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:16 weight:UIImageSymbolWeightBold]] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"list.bullet" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:16 weight:UIImageSymbolWeightBold]] style:UIBarButtonItemStylePlain target:self action:@selector(listButtonPressed)];
    
    self.coverImageView = [[UIImageView alloc] init];
    
    self.slider = [[CustomSlider alloc] init];
    [self.slider addTarget:self action:@selector(onSliderValChanged:forEvent:) forControlEvents:UIControlEventValueChanged];
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton addTarget:self action:@selector(playButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.playButton setImage:[UIImage systemImageNamed:@"play.circle" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:70 weight:UIImageSymbolWeightRegular]] forState:UIControlStateNormal];
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextButton addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton setImage:[UIImage systemImageNamed:@"forward.end" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:50 weight:UIImageSymbolWeightRegular]] forState:UIControlStateNormal];
    
    self.previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.previousButton setImage:[UIImage systemImageNamed:@"backward.end" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:50 weight:UIImageSymbolWeightRegular]] forState:UIControlStateNormal];
    [self.previousButton addTarget:self action:@selector(previousButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.modeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.modeButton addTarget:self action:@selector(modeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self updateModeButton];
    
    self.beginTimeLabel = [[UILabel alloc] init];
    self.beginTimeLabel.textColor = UIColor.grayColor;
    self.beginTimeLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    self.beginTimeLabel.text = @"00:00";
    self.beginTimeLabel.textAlignment = NSTextAlignmentLeft;
    
    self.endTimeLabel = [[UILabel alloc] init];
    self.endTimeLabel.textColor = UIColor.grayColor;
    self.endTimeLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    self.endTimeLabel.text = @"00:00";
    self.endTimeLabel.textAlignment = NSTextAlignmentRight;
    
    self.cacheLabel = [[UILabel alloc] init];
    self.cacheLabel.textColor = UIColor.blackColor;
    self.cacheLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    self.cacheLabel.text = [NSString stringWithFormat:@"缓存大小:%@",[self sizeOfFolder:[self pathForTemporaryFile:@"qqmusic/playingCache"]]];
    self.cacheLabel.textAlignment = NSTextAlignmentRight;
    
    [self.view addSubview:self.coverImageView];
    [self.view addSubview:self.slider];
    [self.view addSubview:self.modeButton];
    [self.view addSubview:self.playButton];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.previousButton];
    [self.view addSubview:self.beginTimeLabel];
    [self.view addSubview:self.cacheLabel];
    [self.view addSubview:self.endTimeLabel];
    
    [QPlayerManager sharedInstance].delegate = self;
    
    if (self.autoPlay) {
        [[QPlayerManager sharedInstance] playSongs:self.songList index:self.currentPlayIndex];
    }
}

- (void)setupConstraints{
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).with.offset(20);
        make.leading.mas_equalTo(self.view.mas_leading).with.offset(40);
        make.trailing.mas_equalTo(self.view.mas_trailing).with.offset(-40);
        make.height.mas_equalTo(self.coverImageView.mas_width);
    }];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.coverImageView.mas_leading);
        make.trailing.mas_equalTo(self.coverImageView.mas_trailing);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.coverImageView.mas_bottom).with.offset(60);
    }];
    [self.beginTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.coverImageView.mas_leading);
        make.top.mas_equalTo(self.slider.mas_bottom).with.offset(18);
    }];
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.coverImageView.mas_trailing);
        make.top.mas_equalTo(self.slider.mas_bottom).with.offset(18);
    }];
    [self.modeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading).with.offset(40);
        make.top.mas_equalTo(self.beginTimeLabel.mas_bottom).with.offset(50);
    }];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-60);
    }];
    [self.cacheLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.modeButton.mas_centerY);
        make.trailing.mas_equalTo(self.endTimeLabel.mas_trailing);
    }];
    [self.previousButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.playButton.mas_centerY);
        make.trailing.mas_equalTo(self.playButton.mas_leading).with.offset(-40);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.playButton.mas_centerY);
        make.leading.mas_equalTo(self.playButton.mas_trailing).with.offset(40);
    }];
}

- (void)updateUI:(QPSongInfo *)songInfo {
    self.currentSong = songInfo;
    [self.coverImageView sd_setImageWithURL:self.currentSong.bigCoverURL placeholderImage:[UIImage imageNamed:@"default_album"]];
    self.title = self.currentSong.name;
    self.beginTimeLabel.text = @"00:00";
    self.endTimeLabel.text = [self timeFormatted:self.currentSong.duration];
    self.slider.maximumValue = self.currentSong.duration;
    self.cacheLabel.text = [NSString stringWithFormat:@"缓存大小:%@",[self sizeOfFolder:[self pathForTemporaryFile:@"qqmusic/playingCache"]]];
}

#pragma mark: - Actions
- (void)modeButtonPressed{
    if ([QPlayerManager sharedInstance].playMode == QPlaybackMode_ListCircle) {
        [QPlayerManager sharedInstance].playMode = QPlaybackMode_SingleCircle;
        [SVProgressHUD showInfoWithStatus:@"已切换至 单曲循环"];
    }
    else if ([QPlayerManager sharedInstance].playMode == QPlaybackMode_SingleCircle){
        [QPlayerManager sharedInstance].playMode = QPlaybackMode_Random;
        [SVProgressHUD showInfoWithStatus:@"已切换至 随机播放"];
    }
    else if ([QPlayerManager sharedInstance].playMode == QPlaybackMode_Random){
        [QPlayerManager sharedInstance].playMode = QPlaybackMode_ListCircle;
        [SVProgressHUD showInfoWithStatus:@"已切换至 列表循环"];
    }
    [self updateModeButton];
}

- (void)cancelButtonPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)listButtonPressed{
    PlaylistViewController *vc = [[PlaylistViewController alloc] init];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)playButtonPressed {
    [[QPlayerManager sharedInstance] togglePlayPause];
}

- (void)nextButtonPressed {
    [[QPlayerManager sharedInstance] next];
}

- (void)previousButtonPressed{
    [[QPlayerManager sharedInstance] previous];
}

- (void)onSliderValChanged:(UISlider*)slider forEvent:(UIEvent*)event {
    UITouch *touchEvent = [[event allTouches] anyObject];
    switch (touchEvent.phase) {
        case UITouchPhaseBegan:
            self.sliderDragged = YES;
            break;
        case UITouchPhaseMoved:
            self.beginTimeLabel.text = [self timeFormatted:slider.value];
            break;
        case UITouchPhaseEnded:
            [[QPlayerManager sharedInstance] seek:slider.value];
            self.sliderDragged = NO;
            break;
        default:
            break;
    }
}

#pragma mark:-QPlayerManagerDelegate
- (void)playbackStatusChanged:(QPlaybackStatus)status{
    if ([QPlayerManager sharedInstance].isPlaying) {
        __weak __typeof(self) weakSelf = self;
        self.timer = [NSTimer timerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (!weakSelf.sliderDragged) {
                weakSelf.beginTimeLabel.text = [weakSelf timeFormatted:[QPlayerManager sharedInstance].currentUITime];
                weakSelf.slider.value = [QPlayerManager sharedInstance].currentUITime;
            }
        }];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [self.playButton setImage:[UIImage systemImageNamed:@"pause.circle" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:70 weight:UIImageSymbolWeightRegular]] forState:UIControlStateNormal];
    }else {
        [self.playButton setImage:[UIImage systemImageNamed:@"play.circle" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:70 weight:UIImageSymbolWeightRegular]] forState:UIControlStateNormal];
        [self.timer invalidate];
    }
    
}
- (void)currentSongChanged:(QPSongInfo *)songInfo{
    [self updateUI:songInfo];
}
- (void)seekFinished{
    
}

- (void)errorOccurred:(NSError *)error{
    NSString *message = error.userInfo[@"message"];
    if (message) {
        [SVProgressHUD showErrorWithStatus:message];
    }
}

#pragma mark:- Helpers
- (NSString *)timeFormatted:(NSTimeInterval)total {
    int totalSeconds = (int)total;
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    if (!hours) {
        return [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
    }
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes,seconds];
}

- (void)updateModeButton {
    if ([QPlayerManager sharedInstance].playMode == QPlaybackMode_ListCircle) {
        [self.modeButton setImage:[UIImage systemImageNamed:@"repeat.circle" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:30 weight:UIImageSymbolWeightRegular]] forState:UIControlStateNormal];
    }
    else if ([QPlayerManager sharedInstance].playMode == QPlaybackMode_SingleCircle){
        [self.modeButton setImage:[UIImage systemImageNamed:@"repeat.1.circle" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:30 weight:UIImageSymbolWeightRegular]] forState:UIControlStateNormal];
    }
    else if ([QPlayerManager sharedInstance].playMode == QPlaybackMode_Random){
        [self.modeButton setImage:[UIImage systemImageNamed:@"shuffle.circle" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:30 weight:UIImageSymbolWeightRegular]] forState:UIControlStateNormal];
    }
}

-(NSString *)sizeOfFolder:(NSString *)folderPath
{
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *contentsEnumurator = [contents objectEnumerator];

    NSString *file;
    unsigned long long int folderSize = 0;

    while (file = [contentsEnumurator nextObject]) {
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:file] error:nil];
        folderSize += [[fileAttributes objectForKey:NSFileSize] intValue];
    }

    //This line will give you formatted size from bytes ....
    NSString *folderSizeStr = [NSByteCountFormatter stringFromByteCount:folderSize countStyle:NSByteCountFormatterCountStyleFile];
    return folderSizeStr;
}

- (NSString *)pathForTemporaryFile:(NSString *)filename {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
}

@end
