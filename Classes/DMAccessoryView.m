//
//  DMAccessoryView.m
//  DMTextField
//
//  Created by 郑军 on 2017/9/22.
//  Copyright © 2017年 郑军. All rights reserved.
//

#import "DMAccessoryView.h"
#define kToolBarHeight 44.0f
@implementation DMAccessoryView
- (instancetype)initWithDelegate:(id<DMAccessoryViewDelegate>)delegate {
        return  [self initWithDelegate:delegate cancelTitle:@"取消" doneTitle:@"确定"] ;
}

- (instancetype)initWithDelegate:(id<DMAccessoryViewDelegate>)delegate
                     cancelTitle:(NSString *)cancelTitle
                       doneTitle:(NSString *)doneTitle {
    self = [super init];
    if (self) {
        // Initialization code
        self.accessoryDelegate = delegate;
        self.barTintColor = [UIColor whiteColor] ;
        self.tintColor = [UIColor colorWithRed:46/255.0 green:127/255.0 blue:247/255.0 alpha:1.0] ;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , kToolBarHeight);
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:cancelTitle
                                                                         style:UIBarButtonItemStyleDone
                                                                        target:self
                                                                        action:@selector(inputCancel)];
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:nil
                                                                                       action:nil];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:doneTitle
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(inputDone)];
        
        self.items = @[cancelButton, flexibleSpace, doneButton];
        self.barStyle = UIBarStyleBlack;
        self.translucent = YES;
    }
    return self;

}


#pragma mark - DMAccessoryViewDelegate
- (void)inputCancel{
    if (_accessoryDelegate && [_accessoryDelegate respondsToSelector:@selector(accessoryViewDidPressedCancelButton:)]) {
        [_accessoryDelegate accessoryViewDidPressedCancelButton:self];
    }
}

- (void)inputDone{
    if (_accessoryDelegate && [_accessoryDelegate respondsToSelector:@selector(accessoryViewDidPressedDoneButton:)]) {
        [_accessoryDelegate accessoryViewDidPressedDoneButton:self];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
