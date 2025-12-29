//
//  DrawNativeAdViewController.m
//  WindMillDemo
//
//  Created by Codi on 2023/2/8.
//

#import "DrawNativeAdViewController.h"
#import "AWMDrawTableViewCell.h"

@interface DrawNativeAdViewController ()<UITableViewDelegate, UITableViewDataSource, WindMillNativeAdViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;
@end

@implementation DrawNativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    } else {
        self.view.backgroundColor = UIColor.whiteColor;
    }
    self.title = @"Draw视频信息流";
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.pagingEnabled = YES;
    self.tableView.scrollsToTop = NO;
#if defined(__IPHONE_11_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
    if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
#else
    self.automaticallyAdjustsScrollViewInsets = NO;
#endif
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView registerClass:[AWMDrawNormalTableViewCell class] forCellReuseIdentifier:@"DrawNormalTableViewCell"];
    [self.tableView registerClass:[AWMDrawAdTableViewCell class] forCellReuseIdentifier:@"DrawAdTableViewCell"];
    
    NSMutableArray *datas = [NSMutableArray array];
    [datas addObjectsFromArray:self.adList];
    for (NSInteger i =0 ; i <= 15; i++) {
        [datas addObject:@"App tableViewcell"];
    }
    self.dataSource = [datas copy];
    [self.tableView reloadData];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(13, 34, 30, 30);
    [btn setImage:[UIImage imageNamed:@"back1.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:btn];
    [self.view addSubview:btn];
    btn.accessibilityIdentifier = @"draw_back";
}

- (void)closeVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- tableView dataSource&delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = indexPath.row;
    id model = self.dataSource[index];
    if ([model isKindOfClass:[WindMillNativeAd class]]) {
        WindMillNativeAd *nativeAd = (WindMillNativeAd *)model;
        NSString *cellIdentifier = [NSString stringWithFormat:@"exp-cell-%ld%ld", (long)[indexPath section], (long)[indexPath row]];
        ///cell不能复用
        AWMDrawAdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[AWMDrawAdTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell refreshUIWithModel:nativeAd rootViewController:self delegate:self.delegateVC];
        return cell;
    }else{
        AWMDrawNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DrawNormalTableViewCell" forIndexPath:indexPath];
        cell.videoId = index;
        [cell refreshUIAtIndex:index];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [AWMDrawBaseTableViewCell cellHeight];
}

@end
