//
//  DMTextFieldUnit.h
//  DMTextField
//
//  Created by 郑军 on 2017/9/25.
//  Copyright © 2017年 郑军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMTextField.h"
@interface DMTextFieldUnit : UIView
//单位
@property (nonatomic , copy) NSString *unit ;
//最大输入长度
@property (nonatomic, assign) NSInteger textMaxLenght ;
//是否需要禁掉emoj表情
@property (nonatomic , assign) BOOL emojEnabled ;
//输入框内容
@property (nonatomic , copy ,getter=getMyText) NSString *text ;
@property (nonatomic , strong) DMTextField *textField ;
- (instancetype)initWithFrame:(CGRect)frame unit:(NSString *)unit ;
@end
