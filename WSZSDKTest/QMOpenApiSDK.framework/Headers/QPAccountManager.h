//
//  QPAccountManager.h
//  QMOpenApiSDK
//
//  Created by maczhou on 2021/9/29.
//

#import <Foundation/Foundation.h>
#import "QPUserInfo.h"

//注意监听此通知，并使用- (BOOL)isLogin判断当前的登录状态的实时变化
FOUNDATION_EXPORT NSNotificationName _Nonnull const QPOpenIDServiceLoginStatusChanged;

NS_ASSUME_NONNULL_BEGIN

@interface QPAccountManager : NSObject
@property (nonatomic) QPUserInfo  *userInfo;

+ (instancetype)sharedInstance;

/**
 * @return 返回当前登录态
 */
- (BOOL)isLogin;

/**
 * 登出
 * @note 登出操作将会清除所有的用户信息、登陆态
 */
- (void)logout;

/**
 * 配置QQ音乐认证，建议尽早调用（比如didFinishLaunchingWithOptions中）
 * @param qmAppID QQ音乐分配的AppID
 * @param qmAppKey QQ音乐分配的AppKey
 * @param callBackUrl 由shcemeURL和://auth组合而成，例如在info.plist中配置URL scheme为qmopenapidemo（工程名小写）
 * 则callBackUrl为qmopenapidemo://auth
 * @return 返回配置结果
 *
 * @note 1:本方法必须在configureWithWXAppID和configureWithQQAppID 之前配置
 * @note 2:无论是否使用QQ音乐认证，都必须首先要配置本方法，否则单独配置微信和QQ认证都可能无效。
 */
- (BOOL)configureWithQMAppID:(NSString *)qmAppID appKey:(NSString *)qmAppKey callBackUrl:(NSString *)callBackUrl;

/**
 * 配置微信认证，建议尽早调用（比如didFinishLaunchingWithOptions中）
 * @param wxAppID 微信分配的AppID
 * @param universalLink 微信分配的universalLink
 * @return 返回配置结果
 * @note wxAppID和universalLink必需和微信后台配置保持一致，否则将可能认证不成功
 */
- (BOOL)configureWithWXAppID:(NSString *)wxAppID universalLink:(NSString *)universalLink;

/**
 * 配置QQ认证，配置微信认证，建议尽早调用（比如didFinishLaunchingWithOptions中）
 * @param qqAppID QQ分配的AppID
 * @param universalLink QQ分配的universalLink
 * @return 返回配置结果
 */
- (BOOL)configureWithQQAppID:(NSString *)qqAppID universalLink:(NSString *)universalLink;

/**
 * QQ音乐认证
 * @param completion 认证结果回调，success:标识位 msg:详细信息
 * @note msg中包含了认证成功/失败的详细信息，请重视。
 */
- (void)startQQMusicAuthenticationWithCompletion:(void(^)(BOOL success, NSString *msg))completion;

/**
 * 微信认证
 * @param completion 认证结果回调，success:标识位 msg:详细信息
 * @note msg中包含了认证成功/失败的详细信息，请重视。
 */
- (void)startWXMiniAppAuthenticationWithCompletion:(void(^)(BOOL success, NSString *msg))completion;

/**
 * QQ认证
 * @param completion 认证结果回调，success:标识位 msg:详细信息
 * @note msg中包含了认证成功/失败的详细信息，请重视。
 */
- (void)startQQMiniAppAuthenticationWithCompletion:(void(^)(BOOL success, NSString *msg))completion;

/**
 * SDK版本
 * @return SDK版本
 */
- (NSString *)version;

/**
 * 打开AppStore的QQ音乐界面
 */
- (void)showQQMusicAppStore;

/**
 * 上传日志接口
 * @return 返回一个随机整数，用以标记上传用户
 * @note 1:建议给用户提的按钮控件触发上传日志操作
 * @note 2:返回值是标记日志的唯一手段，务必展示给用户，
 * 用户上传日志之后，需要提供此返回值（可用UIAlertController展示并截图保存）
 */
- (NSInteger)uploadSDKLog;


/**
 
 */
- (BOOL)handleURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
