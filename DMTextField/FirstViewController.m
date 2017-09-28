//
//  FirstViewController.m
//  DMBaseComponent
//
//  Created by 郑军 on 2017/9/20.
//  Copyright © 2017年 郑军. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "DMTextField.h"
#import "DMTextFieldUnit.h"
@interface FirstViewController () {
    DMTextFieldUnit *_textUnit ;
}
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"第一级视图" ;
    self.view.backgroundColor = [UIColor whiteColor] ;
    DMTextField *testField = ({
        DMTextField *field = [[DMTextField alloc] initWithFrame:CGRectMake(30, 100, 200, 40)] ;
        field.placeholder = @"测试输入文字" ;
        field.textMaxLenght = 3 ;
        field.backgroundColor = [UIColor redColor] ;
        [field setTextChange:^(DMTextField *textField) {
            NSLog(@"new value is%@",textField.text) ;
        }] ;
        [field setTextConfirm:^(DMTextField *textField) {
            NSLog(@"confirm is %@",textField.text) ;
        }] ;
        [field setTextMax:^{
            NSLog(@"最大了") ;
        }] ;
        field ;
    }) ;
    [self.view addSubview:testField] ;
    
    UIButton *button = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [btn setTitle:@"测试" forState:UIControlStateNormal] ;
        btn.frame = CGRectMake(30, 160, 200, 40) ;
        btn.backgroundColor = [UIColor redColor] ;
        [btn addTarget:self action:@selector(testTheKeyBoard) forControlEvents:UIControlEventTouchUpInside] ;
        btn ;
    }) ;
    [self.view addSubview:button] ;
    
    DMTextFieldUnit *textUnit = [[DMTextFieldUnit alloc] initWithFrame:CGRectMake(40, 240, 200, 40) unit:@"万"] ;
    textUnit.backgroundColor = [UIColor greenColor] ;
//    textUnit.unit = @"的方法" ;
    [self.view addSubview:textUnit];
    _textUnit = textUnit ;
}

- (void)testTheKeyBoard {
    NSLog(@"test!!") ;
//    NSLog(@"%@",_textUnit.text) ;
    SecondViewController *secondCtr = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:secondCtr animated:YES] ;
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
