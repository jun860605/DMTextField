//
//  DMAccessoryView.h
//  DMTextField
//
//  Created by 郑军 on 2017/9/22.
//  Copyright © 2017年 郑军. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DMAccessoryViewDelegate ;
@interface DMAccessoryView : UIToolbar
@property (nonatomic ,weak) id<DMAccessoryViewDelegate> accessoryDelegate ;
- (instancetype)initWithDelegate:(id<DMAccessoryViewDelegate>)delegate ;
- (instancetype)initWithDelegate:(id<DMAccessoryViewDelegate>)delegate
                     cancelTitle:(NSString *)cancelTitle
                       doneTitle:(NSString *)doneTitle ;
@end
@protocol DMAccessoryViewDelegate <NSObject>
@optional
- (void)accessoryViewDidPressedCancelButton:(DMAccessoryView *)view ;
- (void)accessoryViewDidPressedDoneButton:(DMAccessoryView *)view ;
@end
