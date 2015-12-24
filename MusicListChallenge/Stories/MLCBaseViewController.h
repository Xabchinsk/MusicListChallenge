//
//  MLCBaseViewController.h
//  MusicListChallenge
//
//  Created by Ilya Bugaev on 23.12.15.
//  Copyright © 2015 Ilya Bugaev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MLCApi.h"

@interface MLCBaseViewController : UIViewController

@property (nonatomic, copy) FailureBlock defaultFailureBlock;

@end
