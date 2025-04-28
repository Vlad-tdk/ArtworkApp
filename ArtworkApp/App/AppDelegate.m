//
//  AppDelegate.m
//  ArtworkApp
//
//  Created by Vladimir Martemianov on 24. 4. 2025..
//

// AppDelegate.m
#import "AppDelegate.h"
#import "GalleryViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Используем UINavigationController для управления навигацией
    GalleryViewController *galleryVC = [[GalleryViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:galleryVC];
    
    // Настройка внешнего вида навигационной панели
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.2 alpha:1.0];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [UINavigationBar appearance].translucent = NO;
    
    self.window.rootViewController = navController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
