//
//  AppDelegate.h
//  OCRuntime
//
//  Created by Nicolas Seriot on 6/14/13.
//  Copyright (c) 2013 Nicolas Seriot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDWebServer.h"

@class RTBRuntime;

extern NSString *const ShowHeaderForClassNameNotification;
extern NSString *const ShowHeaderForProtocolNotification;
extern NSString *const kClassName;
extern NSString *const kProtocol;

@interface RTBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RTBRuntime *allClasses;
@property (strong, nonatomic) GCDWebServer *webServer;

- (GCDWebServerResponse *)responseForPath:(NSString *)path;
- (NSString *)myIPAddress;
- (UInt16)serverPort;

- (void)stopWebServer;
- (void)startWebServer;

- (void)useClass:(NSString *)className;

@end
