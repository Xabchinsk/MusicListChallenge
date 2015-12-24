//
//  MLCMelody.h
//  MusicListChallenge
//
//  Created by Ilya Bugaev on 22.12.15.
//  Copyright © 2015 Ilya Bugaev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FEMMapping.h>

@interface MLCMelody : NSObject

@property (nonatomic, assign) NSInteger identifier;

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *artist;
@property (nonatomic, retain) NSString *picUrl;
@property (nonatomic, retain) NSString *demoUrl;

// TODO: complete the model

@end

@interface MLCMelody (Mapping)

+ (FEMMapping *)defaultMapping;

@end
