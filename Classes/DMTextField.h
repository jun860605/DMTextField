//
//  DMTextField.h
//  DMTextField
//
//  Created by 郑军 on 2017/9/22.
//  Copyright © 2017年 郑军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DMTextField : UITextField
//最大输入长度
@property (nonatomic, assign) NSInteger textMaxLenght ;
//是否需要禁掉emoj表情
@property (nonatomic , assign) BOOL emojEnabled ;
//设置回收键盘时的block事件
- (void)setTextConfirm:(void(^)(DMTextField *textField))confirmBlock ;
//设置内容改变时的block事件
- (void)setTextChange:(void(^)(DMTextField *textField))changeBlock ;
//设置超出最大文字时的回调
- (void)setTextMax:(void(^)())maxBlock ;
@end

@protocol DMTextFieldDelegate <NSObject , UITextFieldDelegate>
@optional
//点击键盘上面的“取消”按钮
- (void)textFieldDidCancelEditing:(DMTextField *)textField ;
//点击键盘上面的“确认”按钮
- (void)textFieldDidFinishEditing:(DMTextField *)textField ;
@end
