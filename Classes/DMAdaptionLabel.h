//
//  DMAdaptionLabel.h
//  DMTextField
//
//  Created by 郑军 on 2017/9/25.
//  Copyright © 2017年 郑军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMAdaptionLabel : UILabel
@property float maxWidth ;
@property (nonatomic,assign) BOOL isFixation ;
@property (nonatomic,assign) float fixationHeight;
@property (nonatomic , assign) float widthView ;
@property (nonatomic , assign) float heightView ;
- (id)initWithMaxWidth:(float)maxWidth;
- (id)initWithMaxWidth:(float)maxWidth withHeight:(float)fixationHeight;
@end
