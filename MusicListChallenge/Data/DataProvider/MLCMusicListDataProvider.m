//
//  MLCMusicListDataProvider.m
//  MusicListChallenge
//
//  Created by Ilya Bugaev on 22.12.15.
//  Copyright © 2015 Ilya Bugaev. All rights reserved.
//

#import "MLCMusicListDataProvider.h"

#import <FEMMapping.h>
#import <FEMDeserializer.h>

#import "MLCMusicList.h"

@implementation MLCMusicListDataProvider

static NSString * const kMLCMelodiesListURL = @"marketplaces/1/tags/10/melodies";

- (void)melodies:(NSUInteger)limit offset:(NSUInteger)offset success:(void (^)(MLCMusicList *))success failure:(FailureBlock)failure {
    NSDictionary *parameters = @{@"limit":@(limit), @"from":@(offset)};
    [self GET:kMLCMelodiesListURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        FEMMapping *mapping = [MLCMusicList defaultMapping];
        MLCMusicList *list = [FEMDeserializer objectFromRepresentation:responseObject mapping:mapping];
        if (success)
            success (list);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure)
            failure(task, error);
    }];
}

@end
