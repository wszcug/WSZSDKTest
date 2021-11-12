//
//  FolderCollectionCell.h
//  QPlayerSDKDemo
//
//  Created by maczhou on 2021/10/27.
//

#import <UIKit/UIKit.h>
#import <QPlayerSDK/QPFolder.h>
NS_ASSUME_NONNULL_BEGIN

@interface FolderCollectionCell : UICollectionViewCell
- (void)updateCellWithFolder:(QPFolder *)folder;
@end

NS_ASSUME_NONNULL_END
