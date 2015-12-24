//
//  MLCBaseCell.m
//  MusicListChallenge
//
//  Created by Ilya Bugaev on 23.12.15.
//  Copyright © 2015 Ilya Bugaev. All rights reserved.
//

#import "MLCBaseCell.h"

@implementation MLCBaseCell

+ (NSString*)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
