//
//  DMTextField.m
//  DMTextField
//
//  Created by 郑军 on 2017/9/22.
//  Copyright © 2017年 郑军. All rights reserved.
//

#import "DMTextField.h"
#import "DMAccessoryView.h"
//textfield内容改变时的回调
typedef void (^TextChangeBlock)(DMTextField *textField) ;
//textfield点击确认时的回调
typedef void (^TextConfirmBlock)(DMTextField *textField);
//textfield超出最大限制时的回调
typedef void (^TextMaxBlock)();
@interface DMTextField() <DMTextFieldDelegate ,DMAccessoryViewDelegate> {
    float _currentY ;
    //ctr对应的view
    UIScrollView *_scrollView ;
}
//成为第一响应者时的默认数据
@property (nonatomic , strong) UIView *baseView ;
@property (nonatomic , assign) CGRect  baseViewFrame ;
@property (nonatomic , copy) NSString * defaultStr ;
@property (nonatomic , strong) TextChangeBlock changeBlock ;
@property (nonatomic , strong) TextConfirmBlock confirmBlock ;
@property (nonatomic , strong) TextMaxBlock maxBlock ;
@end

@implementation DMTextField
- (void)dealloc {
    self.defaultStr = nil ;
    [self removeObserver:self forKeyPath:@"text" ];
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero] ;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:nil];
        DMAccessoryView *accessoryView = [[DMAccessoryView alloc] initWithDelegate:self] ;
        self.inputAccessoryView = accessoryView ;
        self.font = [UIFont systemFontOfSize:14] ;
        self.textMaxLenght = NSIntegerMax ;
        //默认不能输入emoj表情
        self.emojEnabled = NO ;
        self.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1.0] ;
        self.delegate = self ;
    }
    return self ;
}


/**
 键盘出现的回调方法

 @param notification 通知
 */
- (void)_keyboardWillShow:(NSNotification *)notification{
    //先计算键盘高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _currentY = 0 ;
    float currentY = [self getCurrentY:self] ;
    NSLog(@"%f",self.frame.size.height) ;
    if (currentY + self.frame.size.height > keyboardRect.origin.y) {
        //遮挡
        float distance = currentY + self.frame.size.height - keyboardRect.origin.y ;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect windowFrame = _baseView.frame ;
            windowFrame.origin.y -= distance ;
            _baseView.frame = windowFrame ;
        }] ;
        
        if (currentY + self.frame.size.height > [UIScreen mainScreen].bounds.size.height && _scrollView) {
            float contentY = currentY + self.frame.size.height - [UIScreen mainScreen].bounds.size.height ;
            CGPoint oldPoint = _scrollView.contentOffset ;
            oldPoint.y += contentY ;
            [_scrollView setContentOffset:oldPoint] ;
        }
    }
}

- (float)getCurrentY:(UIView *)view {
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view ;
        _currentY = _currentY + view.frame.origin.y - scrollView.contentOffset.y ;
        _scrollView = scrollView ;
    }else {
        _currentY += view.frame.origin.y ;
    }
    UIView *superView = view.superview ;
    if ([superView isKindOfClass:[UIWindow class]]) {
        _baseView = view ;
        _baseViewFrame = view.frame ;
        return _currentY ;
    }else {
        [self getCurrentY:superView] ;
    }
    return _currentY ;
}

/**
 恢复视图的大小
 */
- (void)_keyboardWillHide{
    [UIView animateWithDuration:0.3 animations:^{
         self.baseView.frame = self.baseViewFrame ;
    }] ;
}

- (void)_keyboardDidHide {
//    self.keyboardIsVisble = NO ;
}

/**
 * 设置回收键盘时的block事件
 */
- (void)setTextConfirm:(void(^)(DMTextField *textField))confirmBlock {
    self.confirmBlock = confirmBlock ;
}

/**
 * 设置内容改变时的block事件
 */
- (void)setTextChange:(void(^)(DMTextField *textField))changeBlock {
    self.changeBlock = changeBlock ;
}

/**
 * 设置超出最大文字时的回调
 */
- (void)setTextMax:(void(^)())maxBlock {
    self.maxBlock = maxBlock ;
}

static SEL extracted() {
    return @selector(textFieldContentDidChanged:);
}

/**
 * 调起键盘时的回调 ，成为第一响应者的回调方法
 */
- (BOOL)becomeFirstResponder {
    if (!_defaultStr) {
        self.defaultStr = self.text ;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:extracted()
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil] ;
    return [super becomeFirstResponder] ;
}


/**
 * 回收键盘时的回调
 */
- (BOOL)resignFirstResponder {
    if (_defaultStr) {
        _defaultStr = nil ;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.baseView.frame = self.baseViewFrame ;
    }] ;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:nil] ;
    return [super resignFirstResponder] ;
}


/**
 *  改变输入框内容的回调
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (self.changeBlock) {
        self.changeBlock(self) ;
    }
}

/**
 * 如果在这个地方回调changeblock，那么有种情况会出现问题，，如果是直接点击键盘上方的表情或者英文时不会调用changblock。所以需要加入一个监控textfield的text的observer
 */
- (void)textFieldContentDidChanged:(NSNotification *)notif {
    if (_textMaxLenght != 0 && self.text.length > _textMaxLenght && self.markedTextRange == nil) {
        if (self.maxBlock) {
            self.maxBlock() ;
        }
        self.text = [self.text substringToIndex:_textMaxLenght] ;
    }
}

#pragma mark - UITextFieldDelegate
/**
 * 兼容ios7.0  ,并移除keywindow上的别的视图(如 ：pickview)
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!(textField.window.isKeyWindow)) {
        [textField.window makeKeyAndVisible] ;
    }
    //回收除textfield之外的别的视图
    NSArray *subViews = [UIApplication sharedApplication].keyWindow.subviews ;
    if (subViews.count > 0) {
        [subViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             UIView *currentView = obj ;
            if ([obj isKindOfClass:[UIPickerView class]]) {
                UIView *tempView = obj ;
                [UIView animateWithDuration:0.25 animations:^{
                    tempView.frame = CGRectMake(tempView.frame.origin.x,[UIScreen mainScreen].bounds.size.height, tempView.frame.size.width, tempView.frame.size.height) ;
                }completion:^(BOOL finished) {
                    [tempView removeFromSuperview] ;
                }] ;
            }
            //主要针对DMBasePickView
            if ([currentView respondsToSelector:@selector(removeThePickView)]) {
                [currentView performSelector:@selector(removeThePickView) withObject:nil afterDelay:0] ;
            }
        }] ;
    }
}

- (void)removeThePickView {
    
}
/**
 * 结束编辑时的回调 （跟点击确认时的回调一样）
 */
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.confirmBlock) {
        self.confirmBlock(self) ;
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_emojEnabled) {
        return YES ;
    }
    // 不让输入表情
    if ([textField isFirstResponder]) {
        if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
            return NO;
        }
        //禁止输入emoji表情
        if([self isNineKeyBoard:string]) {
            return YES ;
        }else{
            if([self stringContainsEmoji:string]) {
                return NO;
            }
        }
    }
    return YES;
}

/**
 判断是不是九宫格
 @param string  输入的字符
 @return YES(是九宫格拼音键盘)
 */
-(BOOL)isNineKeyBoard:(NSString *)string
{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++)
    {
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}

/**
 * 判断是否输入了emoji 表情
 */
- (BOOL)stringContainsEmoji:(NSString *)string{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
     
                               options:NSStringEnumerationByComposedCharacterSequences
     
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }else if (hs == 0x200d){
                                        returnValue = YES;
                                    }
                                }
                            }];
    return returnValue;
}



#pragma mark - DMAccessoryViewDelegate
- (void)accessoryViewDidPressedCancelButton:(DMAccessoryView *)view {
    self.text = self.defaultStr ;
    [self resignFirstResponder] ;
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDidCancelEditing:)]) {
        [self.delegate performSelector:@selector(textFieldDidCancelEditing:) withObject:self];
    }
}

- (void)accessoryViewDidPressedDoneButton:(DMAccessoryView *)view {
    [self resignFirstResponder] ;
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDidFinishEditing:)]) {
        [self.delegate performSelector:@selector(textFieldDidFinishEditing:) withObject:self];
    }
}


@end
