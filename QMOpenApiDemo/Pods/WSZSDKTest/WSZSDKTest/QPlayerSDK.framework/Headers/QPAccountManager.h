//
//  QPAccountManager.h
//  QPlayerSDK
//
//  Created by maczhou on 2021/9/29.
//

#import <Foundation/Foundation.h>
#import "QPUserInfo.h"

FOUNDATION_EXPORT NSNotificationName _Nonnull const QPOpenIDServiceLoginStatusChanged;

NS_ASSUME_NONNULL_BEGIN

@interface QPAccountManager : NSObject
@property (nonatomic) QPUserInfo  *userInfo;

+ (instancetype)sharedInstance;

- (BOOL)isLogin;
- (void)logout;

- (BOOL)configureWithQMAppID:(NSString *)qmAppID appKey:(NSString *)qmAppKey callBackUrl:(NSString *)callBackUrl;
- (BOOL)configureWithWXAppID:(NSString *)wxAppID universalLink:(NSString *)universalLink;
- (BOOL)configureWithQQAppID:(NSString *)qqAppID universalLink:(NSString *)universalLink;

- (void)startQQMusicAuthenticationWithCompletion:(void(^)(BOOL success, NSString *msg))completion;
- (void)startWXMiniAppAuthenticationWithCompletion:(void(^)(BOOL success, NSString *msg))completion;
- (void)startQQMiniAppAuthenticationWithCompletion:(void(^)(BOOL success, NSString *msg))completion;

- (NSString *)version;
- (void)showQQMusicAppStore;
- (NSInteger)uploadSDKLog;
- (BOOL)handleURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
