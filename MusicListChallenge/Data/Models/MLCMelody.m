//
//  MLCMelody.m
//  MusicListChallenge
//
//  Created by Ilya Bugaev on 22.12.15.
//  Copyright © 2015 Ilya Bugaev. All rights reserved.
//

#import "MLCMelody.h"

@implementation MLCMelody

@end

@implementation MLCMelody (Mapping)

- (NSUInteger)hash {
    return [[NSString stringWithFormat:@"%li %@ %@ %@ %@", (long)self.identifier, self.title, self.artist, self.picUrl, self.demoUrl] hash];
}

- (BOOL)isEqual:(id)object {
    if (self == object)
        return YES;
    
    if (![object isKindOfClass:[self class]])
        return NO;
    
    return (((MLCMelody*)object).identifier == self.identifier &&
            [[object title] isEqualToString:self.title] &&
            [[object artist] isEqualToString:self.artist] &&
            [[object picUrl] isEqualToString:self.picUrl] &&
            [[object demoUrl] isEqualToString:self.demoUrl]);
    
}

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[self class]];
    [mapping addAttributesFromArray:@[@"title", @"artist", @"picUrl", @"demoUrl"]];
    [mapping addAttributesFromDictionary:@{@"identifier": @"id"}];
    
    return mapping;
}

@end