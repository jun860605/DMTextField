//
//  SecondViewController.m
//  DMBaseComponent
//
//  Created by 郑军 on 2017/9/20.
//  Copyright © 2017年 郑军. All rights reserved.
//

#import "SecondViewController.h"
#import "DMTextField.h"
@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"第二级视图" ;
    DMTextField *testFieldOne = ({
        DMTextField *field = [[DMTextField alloc] initWithFrame:CGRectMake(30, 100, 200, 40)] ;
        field.placeholder = @"测试输入文字" ;
        field.backgroundColor = [UIColor redColor] ;
        field ;
    }) ;
    [self.view addSubview:testFieldOne] ;
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
