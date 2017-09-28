//
//  DMTextFieldUnit.m
//  DMTextField
//
//  Created by 郑军 on 2017/9/25.
//  Copyright © 2017年 郑军. All rights reserved.
//

#import "DMTextFieldUnit.h"
#import "DMTextField.h"
#import "Masonry.h"
#import "DMAdaptionLabel.h"
@interface DMTextFieldUnit() {
    UILabel *_unitLabel ;
}
@property (nonatomic , strong) DMTextField *textField ;
@end

@implementation DMTextFieldUnit
@synthesize text = _text ;
- (void)awakeFromNib {
    [super awakeFromNib] ;
}

- (instancetype) init {
    return [self initWithFrame:CGRectZero] ;
}

- (instancetype) initWithUnit:(NSString *)unit {
    return [self initWithFrame:CGRectZero unit:unit] ;
}

- (instancetype) initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame unit:@""] ;
}
- (instancetype)initWithFrame:(CGRect)frame unit:(NSString *)unit {
    self = [super initWithFrame:frame] ;
    if (self) {
        [self setUpTheViewUnit:unit] ;
    }
    return self ;
}

- (void)setUpTheViewUnit:(NSString *)unit {
    _unit = unit ;
    DMAdaptionLabel *unitLabel = ({
        DMAdaptionLabel *label = [[DMAdaptionLabel alloc] init];
        label.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1.0] ;
        label.font = [UIFont systemFontOfSize:15] ;
        label.text = unit ;
        label.backgroundColor = [UIColor clearColor] ;
        label.textAlignment = NSTextAlignmentRight ;
        label ;
    }) ;
    [self addSubview:unitLabel] ;
    _unitLabel = unitLabel ;
    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self) ;
        make.centerY.equalTo(self) ;
    }] ;
    
    DMTextField *textFieldContent = ({
        DMTextField *textField = [[DMTextField alloc] init] ;
        textField.font = [UIFont systemFontOfSize:15] ;
        textField.textMaxLenght = NSIntegerMax ;
        textField.textAlignment = NSTextAlignmentRight ;
        textField.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1.0] ;
        textField ;
    }) ;
    [self addSubview:textFieldContent] ;
    _textField = textFieldContent ;
    [textFieldContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self) ;
        make.right.equalTo(_unitLabel.mas_left).offset(-5);
    }] ;
}

- (void)setTextMaxLenght:(NSInteger)textMaxLenght {
    _textMaxLenght = textMaxLenght ;
    _textField.textMaxLenght = textMaxLenght ;
}

- (void)setUnit:(NSString *)unit {
    _unit = unit ;
    _unitLabel.text = _unit ;
}

- (void)setEmojEnabled:(BOOL)emojEnabled {
    _emojEnabled = emojEnabled ;
    _textField.emojEnabled = _emojEnabled ;
}

- (NSString*)getMyText {
    return _textField.text ;
}

- (void)setText:(NSString *)text {
    _text = text ;
    _textField.text = text ;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
