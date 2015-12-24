//
//  MLCUtilities.m
//  MusicListChallenge
//
//  Created by Ilya Bugaev on 24.12.15.
//  Copyright © 2015 Ilya Bugaev. All rights reserved.
//

#import "MLCUtilities.h"

@implementation MLCUtilities

+ (void)showAlert:(NSString*)title message:(NSString*)message presenter:(UIViewController*)presenter {
    NSString *reqSysVer = @"8.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title ? title : NSLocalizedString(@"common.error", nil)
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *closeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"common.close", nil)
                                                              style:UIAlertActionStyleDefault
                                                            handler:nil];
        [alertController addAction:closeAction];
        
        [presenter presentViewController:alertController animated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title ? title : NSLocalizedString(@"common.error", nil)
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"common.close", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
    }

}

@end
