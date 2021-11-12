//
//  FolderTableCell.h
//  QPlayerSDKDemo
//
//  Created by maczhou on 2021/10/13.
//

#import <UIKit/UIKit.h>
#import <QPlayerSDK/QPFolder.h>
NS_ASSUME_NONNULL_BEGIN

@interface FolderTableCell : UITableViewCell
@property (nonatomic)UIButton *collectedButton;
- (void) updateCellWithFolder:(QPFolder *)folder;
@end

NS_ASSUME_NONNULL_END
