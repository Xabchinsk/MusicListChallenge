//
//  MLCMusicList.m
//  MusicListChallenge
//
//  Created by Ilya Bugaev on 22.12.15.
//  Copyright © 2015 Ilya Bugaev. All rights reserved.
//

#import "MLCMusicList.h"

@implementation MLCMusicList

@end

@implementation MLCMusicList (Mapping)

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[self class]];
    
    [mapping addToManyRelationshipMapping:[MLCMelody defaultMapping] forProperty:@"melodies" keyPath:@"melodies"];
    
    return mapping;
}

@end
