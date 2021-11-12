//
//  SongListViewController.h
//  QPlayerSDKDemo
//
//  Created by maczhou on 2021/10/22.
//

#import <UIKit/UIKit.h>
#import <QPlayerSDK/QPlayerSDK.h>
NS_ASSUME_NONNULL_BEGIN

@interface SongListViewController : UIViewController
- (instancetype)initWithRank:(QPRank *)rank;
- (instancetype)initWithFolder:(QPFolder *)folder;
- (instancetype)initWithAlbum:(QPAlbum *)album;
- (instancetype)initWithSinger:(QPSinger *)singer;
@end

NS_ASSUME_NONNULL_END
