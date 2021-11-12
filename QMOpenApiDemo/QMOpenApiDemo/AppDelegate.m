//
//  AppDelegate.m
//  QMOpenApiDemo
//
//  Created by wsz on 2021/11/12.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "SearchViewController.h"
#import "MineViewController.h"
#import "RadioViewController.h"
#import "RankViewController.h"
#import <QPlayerSDK/QPlayerSDK.h>
#import "SVProgressHUD.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //TODO: 获取IDFA是否还会卡审核？
    //TODO: 设置SDK开发模式
    [[QPAccountManager sharedInstance] configureWithQMAppID:@"12345668" appKey:@"qoJvLUGMKmSExFJdXD" callBackUrl:@"qmopenapidemo://auth"];
    [[QPAccountManager sharedInstance] configureWithWXAppID:@"wx85d9b008252f26b5" universalLink:@"https://music.qq.com/tango/"];
    [[QPAccountManager sharedInstance] configureWithQQAppID:@"101834739" universalLink:@"www.qq.com"];
   
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setBackgroundColor:UIColor.lightGrayColor];
    
    self.tabController = [[UITabBarController alloc] init];
    self.tabController.view.backgroundColor = UIColor.whiteColor;
    HomeViewController *home = [[HomeViewController alloc] init];
    home.title = @"首页";
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:home];
    
    RankViewController *rank = [[RankViewController alloc] init];
    rank.title = @"排行";
    UINavigationController *rankNav = [[UINavigationController alloc] initWithRootViewController:rank];
    
    RadioViewController *radio = [[RadioViewController alloc] init];
    radio.title = @"电台";
    UINavigationController *radioNav = [[UINavigationController alloc] initWithRootViewController:radio];
    SearchViewController *search = [[SearchViewController alloc] init];
    search.title = @"搜索";
    UINavigationController *searchNav = [[UINavigationController alloc] initWithRootViewController:search];
    MineViewController *mine = [[MineViewController alloc] init];
    mine.title = @"我的";
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mine];
    
    [self.tabController setViewControllers:@[homeNav,rankNav,radioNav,searchNav,mineNav]];
    self.tabController.tabBar.items[0].image = [UIImage systemImageNamed:@"music.note.house" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:14 weight:UIImageSymbolWeightRegular]];
    self.tabController.tabBar.items[1].image = [UIImage systemImageNamed:@"list.bullet.rectangle" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:14 weight:UIImageSymbolWeightRegular]];
    self.tabController.tabBar.items[2].image = [UIImage systemImageNamed:@"radio" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:14 weight:UIImageSymbolWeightRegular]];
    self.tabController.tabBar.items[3].image = [UIImage systemImageNamed:@"magnifyingglass" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:14 weight:UIImageSymbolWeightRegular]];
    self.tabController.tabBar.items[4].image = [UIImage systemImageNamed:@"person" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:14 weight:UIImageSymbolWeightRegular]];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = self.tabController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [[QPAccountManager sharedInstance] handleURL:url];
}
@end
