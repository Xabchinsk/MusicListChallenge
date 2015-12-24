//
//  MLCBaseViewController.m
//  MusicListChallenge
//
//  Created by Ilya Bugaev on 23.12.15.
//  Copyright © 2015 Ilya Bugaev. All rights reserved.
//

#import "MLCBaseViewController.h"

#import <AFNetworking.h>

#import "MLCUtilities.h"

@implementation MLCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    typeof(self) __weak weakSelf = self;
    self.defaultFailureBlock = ^(NSURLSessionDataTask *task, NSError *error) {
        NSString *message;
        NSString *title;
        
#if DEBUG && SHOW_CODE
        title = [NSString stringWithFormat:@"debug: %@", error.domain];
#endif
        NSString *some = (__bridge NSString *)kCFErrorDomainCFNetwork;
        NSError *internalError = error.userInfo[@"NSUnderlyingError"];
        if ([internalError.domain isEqualToString:some]) {
            message = NSLocalizedString(@"unreachable.network", nil);
        } else if ([error localizedDescription]) {
            message = [error localizedDescription];
        } else {
            message = NSLocalizedString(@"unknown.error", nil);
        }
        
        [MLCUtilities showAlert:title message:message presenter:weakSelf];
    };
}

@end
