//
//  AppDelegate.m
//  GHFINCAS
//
//  Created by jose ramon delgado on 25/01/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import "AppDelegate.h"

#import <Parse/Parse.h>

#import <Bolts/Bolts.h>
 
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
  [Parse setApplicationId:@"mUj7ENzNhD4hm6o8ENhPqa5ZHAlM3QAjGnRgJu2V"
                  clientKey:@"AFxz2VqXFvSVsa6UFwGe3QRKBVC7EdwHMgjiBbfN"];
    
    
    
      int screenHeight = [UIScreen mainScreen].bounds.size.height;
      NSLog(@"Screen Height is %i", screenHeight);
    
    // grab correct storyboard depending on screen height
    UIStoryboard *storyboard = [self grabStoryboard];
    
    // display storyboard
    self.window.rootViewController = [storyboard instantiateInitialViewController];
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
}


- (UIStoryboard *)grabStoryboard {
    
    // determine screen size
    int screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIStoryboard *storyboard;
    
    switch (screenHeight) {
            
            // iPhone 4s
        case 480:
            storyboard = [UIStoryboard storyboardWithName:@"Main-4s" bundle:nil];
            break;
            
            // iPhone 5s
        case 568:
            storyboard = [UIStoryboard storyboardWithName:@"Main-5s" bundle:nil];
            break;
            
            // iPhone 6
        case 667:
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            break;
            
            // iPhone 6 Plus
        case 736:
            storyboard = [UIStoryboard storyboardWithName:@"Main-6-Plus" bundle:nil];
            break;
            
        default:
            // it's an iPad
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            break;
    }
    
    return storyboard;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////PARSE//////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////
// Uncomment this method if you want to use Push Notifications with Background App Refresh
///////////////////////////////////////////////////////////
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    if (application.applicationState == UIApplicationStateInactive) {
//        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
//    }
//}
@end
