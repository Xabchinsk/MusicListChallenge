//
//  MLCMelodyCell.h
//  MusicListChallenge
//
//  Created by Ilya Bugaev on 23.12.15.
//  Copyright © 2015 Ilya Bugaev. All rights reserved.
//

#import "MLCBaseCell.h"

@interface MLCMelodyCell : MLCBaseCell

@property (nonatomic, weak) IBOutlet UIImageView *albumCoverView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;

@end
