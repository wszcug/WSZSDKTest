//
//  LyricTableCell.h
//  QPlayerSDKDemo
//
//  Created by maczhou on 2021/10/13.
//

#import <UIKit/UIKit.h>
#import <QPlayerSDK/QPLyricInfo.h>
NS_ASSUME_NONNULL_BEGIN

@interface LyricTableCell : UITableViewCell
- (void) updateCellWithLyricInfo:(QPLyricInfo *)lyricInfo;
@end

NS_ASSUME_NONNULL_END
