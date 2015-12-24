//
//  MLCBaseDataProvider.m
//  MusicListChallenge
//
//  Created by Ilya Bugaev on 22.12.15.
//  Copyright © 2015 Ilya Bugaev. All rights reserved.
//

#import "MLCBaseDataProvider.h"

@implementation MLCBaseDataProvider

static NSString * const kMLCBaseURL = @"https://api-content-beeline.intech-global.com/public/";

#pragma mark - Private -

- (void)configure {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer  = [AFJSONRequestSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    securityPolicy.validatesDomainName = YES;
    securityPolicy.allowInvalidCertificates = NO;
#if DEBUG
    securityPolicy.allowInvalidCertificates = YES;
#endif
    self.securityPolicy = securityPolicy;
}

#pragma mark - Initialization -

- (instancetype)init {
    self = [self initWithBaseURL:[NSURL URLWithString:kMLCBaseURL]];
    return self;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        [self configure];
    }
    return self;
}

@end
