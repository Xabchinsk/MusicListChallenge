//
//  MLCMusicListViewController.m
//  MusicListChallenge
//
//  Created by Ilya Bugaev on 22.12.15.
//  Copyright © 2015 Ilya Bugaev. All rights reserved.
//

#import "MLCMusicListViewController.h"

#import "MLCMelody.h"
#import "MLCMusicList.h"

#import "MLCMusicListDataProvider.h"

#import "MLCMelodyCell.h"
#import "MLCLoadingCell.h"
#import "MLCPlayerViewController.h"

#import <UIImageView+AFNetworking.h>

@interface MLCMusicListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSMutableArray<MLCMelody*> *melodies;
@property (nonatomic, assign) BOOL isMoreAvaliable;
@property (nonatomic, assign) NSUInteger offset;

@property (nonatomic, assign) BOOL isLoadingNow;

@property (nonatomic, retain) MLCMelody *selectedMelody;

@property (nonatomic, retain) UIRefreshControl *refreshControl;

@end

@implementation MLCMusicListViewController

static const NSUInteger kMLCMelodiesBatchLoadCount = 10;

static NSString * const kMLCPlayerSegueIdentifier = @"PlayerSegueIdentifier";

#pragma mark - LifeCycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.melodies = [NSMutableArray array];
    self.isMoreAvaliable = YES;
    
    self.title = NSLocalizedString(@"music.list.title", nil);
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
}

#pragma mark - Private -

- (void)refreshData {
    [self.refreshControl endRefreshing];

    self.isMoreAvaliable = YES;
    self.offset = 0;
    [self loadNextBatch];
}

- (void)loadNextBatch {
    if (self.isLoadingNow) {
        return;
    }
    
    self.isLoadingNow = YES;
    [[MLCMusicListDataProvider new] melodies:kMLCMelodiesBatchLoadCount offset:self.offset success:^(MLCMusicList *list) {
        self.isLoadingNow = NO;
        
        NSMutableOrderedSet *newMelodies = [[NSMutableOrderedSet alloc] initWithArray:list.melodies];
        NSOrderedSet *loadedMelodies = [[NSOrderedSet alloc] initWithArray:self.melodies];
        
        [newMelodies minusOrderedSet:loadedMelodies];
        
        [self.melodies addObjectsFromArray:[newMelodies array]];
        self.offset = self.melodies.count;
        
        if (list.melodies.count == 0) {
            self.isMoreAvaliable = NO;
        }
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.defaultFailureBlock (task, error);
        
        self.isLoadingNow = NO;
        self.isMoreAvaliable = NO;
        [self.tableView reloadData];
    }];
}

- (NSUInteger)getCellsCount {
    NSUInteger count = self.melodies.count;
    if (self.isMoreAvaliable) {
        count++;
    }
    
    return count;
}

- (MLCMelody*)getMelodyByIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.row < self.melodies.count) {
        return [self.melodies objectAtIndex:indexPath.row];
    }
    
    return nil;
}

#pragma mark - UITableView -

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.5f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reqSysVer = @"8.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending) {
        return UITableViewAutomaticDimension;
    }
    
    static MLCMelodyCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [tableView dequeueReusableCellWithIdentifier:[MLCMelodyCell reuseIdentifier]];
    });
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGFloat height = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    return height + 1.0f / [UIScreen mainScreen].scale;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getCellsCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger cellsCount = [self getCellsCount];
    if (indexPath.row < self.melodies.count) {
        MLCMelodyCell *cell = [tableView dequeueReusableCellWithIdentifier:[MLCMelodyCell reuseIdentifier]];
        float leftOffset = (indexPath.row == self.melodies.count - 1) && self.isMoreAvaliable ? 0.0f : 60.0f;
        cell.separatorInset = UIEdgeInsetsMake(0, leftOffset, 0, 0);
        cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);

        MLCMelody *melody = [self getMelodyByIndexPath:indexPath];
        cell.titleLabel.text = melody.title;
        cell.detailLabel.text = melody.artist;
        
        [cell.albumCoverView setImage:[UIImage imageNamed:@"music-placeholder"]];
        
        if (melody.picUrl) {
            [cell.albumCoverView setImageWithURL:[NSURL URLWithString:melody.picUrl]];
        }
        
        return cell;
    } else if (indexPath.row == cellsCount - 1 && self.isMoreAvaliable) {
        MLCLoadingCell *cell = [tableView dequeueReusableCellWithIdentifier:[MLCLoadingCell reuseIdentifier]];
        
        [cell.activitiIndicator startAnimating];
        
        return cell;
    }
    
    NSLog(@"Something goes wrong. Music list cell error");
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[MLCLoadingCell class]]) {
        [self loadNextBatch];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.melodies.count) {
        MLCMelody *melody = [self getMelodyByIndexPath:indexPath];
        self.selectedMelody = melody;
        [self performSegueWithIdentifier:kMLCPlayerSegueIdentifier sender:self];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

#pragma mark - Navigation -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kMLCPlayerSegueIdentifier]) {
        MLCPlayerViewController *vc = segue.destinationViewController;
        vc.melody = self.selectedMelody;
    }
}

@end
