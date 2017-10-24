//
//  SecondViewController.m
//  DMBaseComponent
//
//  Created by 郑军 on 2017/9/20.
//  Copyright © 2017年 郑军. All rights reserved.
//

#import "SecondViewController.h"
#import "DMTextField.h"
@interface SecondViewController ()<UITableViewDataSource , UITableViewDelegate>
@property (nonatomic , strong) UITableView *tableView ;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"第二级视图" ;
    self.view.autoresizesSubviews = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone; //视图控制器，四条边不指定
    self.automaticallyAdjustsScrollViewInsets = NO;
//    DMTextField *testFieldOne = ({
//        DMTextField *field = [[DMTextField alloc] initWithFrame:CGRectMake(30, 100, 200, 40)] ;
//        field.placeholder = @"测试输入文字" ;
//        field.backgroundColor = [UIColor redColor] ;
//        field ;
//    }) ;
//    [self.view addSubview:testFieldOne] ;
    
    [self.view addSubview:self.tableView] ;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] ;
        _tableView.dataSource = self ;
        _tableView.delegate = self ;
        if ([_tableView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {
            [_tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever] ;
        }
    }
    return _tableView ;
}

#pragma mark - tableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"] ;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"] ;
        DMTextField *textField = [[DMTextField alloc] initWithFrame:CGRectMake(80, 0,  [UIScreen mainScreen].bounds.size.width - 180, 44)] ;
        textField.backgroundColor = [UIColor greenColor] ;
        textField.tag = 101 ;
        [cell addSubview:textField] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    }
    DMTextField *textField = (DMTextField *)[cell viewWithTag:101] ;
    textField.placeholder = [NSString stringWithFormat:@"请输入%ld",indexPath.row] ;
    return cell ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
