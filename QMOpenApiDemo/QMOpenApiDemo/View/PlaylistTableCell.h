//
//  PlaylistTableCell.h
//  QPlayerSDKDemo
//
//  Created by maczhou on 2021/10/26.
//

#import <UIKit/UIKit.h>
#import <QPlayerSDK/QPSongInfo.h>
NS_ASSUME_NONNULL_BEGIN

@interface PlaylistTableCell : UITableViewCell
- (void) updateCellWithSongInfo:(QPSongInfo *)songInfo isHighted:(BOOL)isHighted;
@end

NS_ASSUME_NONNULL_END
