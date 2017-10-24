//
//  ViewController.m
//  TARefreshControlDemo
//
//  Created by zoxuner on 16/7/30.
//  Copyright © 2016年 zuoxunhudong. All rights reserved.
//

#import "ViewController.h"
#import "TARefreshControl.h"

static NSString * const identifier = @"identifier";
static NSInteger rowCount = 20;

@interface ViewController () <UITableViewDataSource>
@property(nonatomic, weak) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)dealloc {
    
}

- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    tableView.dataSource = self;
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    
    __weak typeof(self) weakSelf = self;
    tableView.ta_header = [TARefreshControlHeader refreshViewWithBlock:^{
        NSLog(@"<%d>--%s", __LINE__, __PRETTY_FUNCTION__);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            rowCount = 20;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.ta_header endRefreshing];
        });
    }];
    
    tableView.ta_footer = [TARefreshControlFooter refreshViewWithBlock:^{
        NSLog(@"<%d>--%s", __LINE__, __PRETTY_FUNCTION__);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            rowCount += 20;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.ta_footer endRefreshing];
        });
    }];
    [self.tableView.ta_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellId = @"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%zdrow--%zd", indexPath.row, arc4random_uniform(1000)];
    return cell;
}

@end
