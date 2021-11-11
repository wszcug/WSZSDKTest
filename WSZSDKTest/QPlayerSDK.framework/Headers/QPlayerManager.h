//
//  QPlayerManager.h
//  QPlayerSDK
//
//  Created by maczhou on 2021/9/29.
//

#import <Foundation/Foundation.h>
#import "QPSongInfo.h"
NS_ASSUME_NONNULL_BEGIN

extern NSNotificationName QPlayer_CurrentSongChanged;
extern NSNotificationName QPlayer_PlaybackStatusChanged;

typedef NS_ENUM(NSInteger, QPlaybackMode) {
    QPlaybackMode_ListCircle = 0, //列表循环
    QPlaybackMode_SingleCircle = 1,//单曲循环
    QPlaybackMode_Random = 2,//随机播放
};

///默认 标准品质
typedef NS_ENUM(NSInteger, QPlaybackQuality) {
    QPlaybackQuality_Smooth = 0, //流畅
    QPlaybackQuality_Standard = 1,//标准
    QPlaybackQuality_High = 2,//高品质
    QPlaybackQuality_Lossless = 3,//无损
};


typedef NS_ENUM(NSInteger, QPlaybackStatus) {
    QPlaybackStatus_Play      = 0,//播放
    QPlaybackStatus_Pause     = 1,//暂停
    QPlaybackStatus_Stop      = 2,//停止
    QPlaybackStatus_Interrupt = 3,//因为中断被暂停
    QPlaybackStatus_Buffering = 4,//播放中缓冲
};

typedef NS_ENUM(NSInteger, QPlaybackError) {
    QPlaybackError_AudioQueue = 801,//播放器异常
    QPlaybackError_AudioFile  = 802,//音频文件异常
    QPlaybackError_FileCache  = 803,//缓存音频失败
    QPlaybackError_Network    = 803,//网络异常
    QPlaybackError_Params     = 804,//传入参数异常
};

typedef NS_ENUM(NSInteger, QPlaybackCache) {
    QPlaybackCache_100MB  = 0,
    QPlaybackCache_500MB  = 1,
    QPlaybackCache_800MB  = 2,
    QPlaybackCache_1GB    = 3,
};

@protocol QPlayerManagerDelegate <NSObject>
@optional
- (void)playbackStatusChanged:(QPlaybackStatus)status;
- (void)currentSongChanged:(QPSongInfo *)songInfo;
- (void)seekFinished;
- (void)errorOccurred:(NSError *)error;
@end

@interface QPlayerManager : NSObject
@property (nonatomic,readonly) NSArray<QPSongInfo *>  *playlist;
@property (nonatomic,readonly) NSInteger currentIndex;
@property (nonatomic,readonly) QPlaybackStatus currentPlaybackStatus;
///当前歌曲播放时间
@property (nonatomic,readonly) NSTimeInterval currentTime;
///播当前UI显示用时间，包含试听音频时
@property (nonatomic,readonly) NSTimeInterval currentUITime;
@property (nonatomic,readonly,nullable) QPSongInfo *currentSong;
///歌曲总时长
@property (nonatomic,readonly) NSTimeInterval duration;
@property (nonatomic,readonly) BOOL isPlaying;
///歌曲播放模式（默认列表循环）
@property (nonatomic) QPlaybackMode playMode;
///歌曲缓存上限（默认100MB）
@property (nonatomic) QPlaybackCache playbackCache;
@property (nonatomic,weak,nullable) id<QPlayerManagerDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)setPlayQuality:(QPlaybackQuality)quality;
- (QPlaybackQuality)getPlayQuality;


- (void)play;
- (void)pause;
- (void)stop;
- (BOOL)next;
- (BOOL)previous;
- (void)seek:(NSTimeInterval)time;//单位秒
- (void)togglePlayPause;

- (void)playAtIndex:(NSInteger)index;
- (void)playSongs:(NSArray<QPSongInfo *> *)songs index:(NSInteger)index;

///清理播放缓存
- (void)clearCache;

@end

NS_ASSUME_NONNULL_END
