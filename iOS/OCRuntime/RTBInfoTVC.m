//
//  RTBInfoTVC.m
//  OCRuntime
//
//  Created by Nicolas Seriot on 11.06.09.
//  Copyright 2009 Sen:te. All rights reserved.
//

#import "RTBInfoTVC.h"
#import "RTBAppDelegate.h"
#import "GCDWebServer.h"

@interface RTBInfoTVC ()

@property (nonatomic, retain) IBOutlet UILabel *webServerStatusLabel;

@property (nonatomic, retain) IBOutlet UISwitch *showOCRuntimeClassesSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *addCommentForBlocksSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *toggleWebServerSwitch;

@end

@implementation RTBInfoTVC

- (void)updateWebServerStatus {
    RTBAppDelegate *appDelegate = (RTBAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *serverURL = [NSString stringWithFormat:@"http://%@:%d/", [appDelegate myIPAddress], [appDelegate serverPort]];
    _webServerStatusLabel.text = [[appDelegate webServer] isRunning] ? serverURL : @"";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_showOCRuntimeClassesSwitch setOn:[[[NSUserDefaults standardUserDefaults] valueForKey:@"RTBShowOCRuntimeClasses"] boolValue]];
    [_addCommentForBlocksSwitch setOn:[[[NSUserDefaults standardUserDefaults] valueForKey:@"RTBAddCommentsForBlocks"] boolValue]];
    [_toggleWebServerSwitch setOn:[[[NSUserDefaults standardUserDefaults] valueForKey:@"RTBEnableWebServer"] boolValue]];
    
    [self updateWebServerStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"About", nil);
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissModalView:)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    NSURL *url = [NSURL URLWithString:@"https://github.com/nst/RuntimeBrowser/"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Open URL" message:@"The URL can't be opened." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    self.webServerStatusLabel = nil;
}

- (IBAction)showOCRuntimeClassesAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:((UISwitch *)sender).isOn forKey:@"RTBShowOCRuntimeClasses"];
}

- (IBAction)addBlockCommentsAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:((UISwitch *)sender).isOn forKey:@"RTBAddCommentsForBlocks"];
}

- (IBAction)toggleWebServerAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:((UISwitch *)sender).isOn forKey:@"RTBEnableWebServer"];
    
    RTBAppDelegate *appDelegate = (RTBAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(((UISwitch *)sender).isOn) {
        [appDelegate startWebServer];
    } else {
        [appDelegate stopWebServer];
    }
    
    [self updateWebServerStatus];
}

@end
