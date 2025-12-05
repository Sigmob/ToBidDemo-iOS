//
//  NativeAdTableViewController.m
//  Demo_OC
//
//  Created by Codi on 2025/11/12.
//

#import "NativeAdTableViewController.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import <WindMillSDK/WindMillSDK.h>
#import "NativeAdViewModel.h"
#import "FeedNormalCell.h"
#import "NativeAdCell.h"
#import "FeedNormalModel.h"


@interface NativeAdTableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) NativeAdViewModel *viewModel;
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation NativeAdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"原生广告列表页";
    self.viewModel = [[NativeAdViewModel alloc] init];
    self.viewModel.viewController = self;
    [self setupTableView];
    self.viewModel.placementId = self.placementId;
    self.viewModel.tableView = self.tableView;
    [self.viewModel initDataSources];
    [self.tableView reloadData];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.tableView registerClass:FeedNormalTitleCell.class forCellReuseIdentifier:@"FeedNormalTitleCell"];
    [self.tableView registerClass:FeedNormalTitleImgCell.class forCellReuseIdentifier:@"FeedNormalTitleImgCell"];
    [self.tableView registerClass:FeedNormalBigImgCell.class forCellReuseIdentifier:@"FeedNormalBigImgCell"];
    [self.tableView registerClass:FeedNormalThreeImgsCell.class forCellReuseIdentifier:@"FeedNormalThreeImgsCell"];
    
    MJRefreshFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self.viewModel refreshingAction:NSSelectorFromString(@"loadNextPage")];
    self.tableView.mj_footer = footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *data = [self.viewModel.datas objectAtIndex:indexPath.row];
    if ([data isKindOfClass:[FeedNormalModel class]]) {
        return ((FeedNormalModel *)data).height;
    }
    if ([data isKindOfClass:[WindMillNativeAd class]]) {
        WindMillNativeAd *nativeAd = (WindMillNativeAd *)data;
        if (nativeAd.feedADMode != WindMillFeedADModeNativeExpress) {
            return 120 + 0.5625 * self.view.bounds.size.width;
        }
        NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)nativeAd.hash];
        NSValue *value = [self.viewModel.heights objectForKey:key];
        return value.CGSizeValue.height;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *data = [self.viewModel.datas objectAtIndex:indexPath.row];
    if ([data isKindOfClass:[FeedNormalModel class]]) {
        FeedNormalModel *model = (FeedNormalModel *)data;
        FeedNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:model.cellForClassName forIndexPath:indexPath];
        [cell refresh:model];
        return cell;
    }
    if ([data isKindOfClass:[WindMillNativeAd class]]) {
        NSString *reuseIdentifier = [NSString stringWithFormat:@"id_%ld", (long)indexPath.row];
        WindMillNativeAd *nativeAd = (WindMillNativeAd *)data;
        NativeAdCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[NativeAdCell alloc] initWithNativeAd:nativeAd style:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        [cell refresh:nativeAd viewController:self delegate:self.viewModel];
        return cell;
    }
    return  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"none"];
}
@end
