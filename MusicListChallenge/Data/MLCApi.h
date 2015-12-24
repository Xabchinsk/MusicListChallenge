//
//  MLCApi.h
//  MusicListChallenge
//
//  Created by Ilya Bugaev on 22.12.15.
//  Copyright © 2015 Ilya Bugaev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MLCMusicList.h"

typedef void (^FailureBlock) (NSURLSessionDataTask *task, NSError *error);

@protocol MLCApi <NSObject>

@optional
- (void)melodies:(NSUInteger)limit offset:(NSUInteger)offset success:(void (^) (MLCMusicList *list))success failure:(FailureBlock)failure;

@end
