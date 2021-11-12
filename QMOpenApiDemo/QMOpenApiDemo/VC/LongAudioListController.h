//
//  LongAudioListController.h
//  QPlayerSDKDemo
//
//  Created by maczhou on 2021/10/30.
//

#import <UIKit/UIKit.h>
#import <QPlayerSDK/QPlayerSDK.h>
NS_ASSUME_NONNULL_BEGIN

@interface LongAudioListController : UIViewController
- (instancetype)initWithCategory:(QPCategory *)category subCategory:(QPCategory *)subCategory;
@end

NS_ASSUME_NONNULL_END
