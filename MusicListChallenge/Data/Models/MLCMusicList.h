//
//  MLCMusicList.h
//  MusicListChallenge
//
//  Created by Ilya Bugaev on 22.12.15.
//  Copyright © 2015 Ilya Bugaev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FEMMapping.h>

#import "MLCMelody.h"

@interface MLCMusicList : NSObject

@property (nonatomic, retain) NSMutableArray<MLCMelody*> *melodies;

@end

@interface MLCMusicList (Mapping)

+ (FEMMapping *)defaultMapping;

@end
