//
//  DMAdaptionLabel.m
//  DMTextField
//
//  Created by 郑军 on 2017/9/25.
//  Copyright © 2017年 郑军. All rights reserved.
//

#import "DMAdaptionLabel.h"
#import "Masonry.h"
@implementation DMAdaptionLabel
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"text" ];
    [self removeObserver:self forKeyPath:@"font"];
}

- (id)init {
    return [self initWithMaxWidth:FLT_MAX withHeight:FLT_MAX] ;
}

- (id)initWithMaxWidth:(float)maxWidth {
    return [self initWithMaxWidth:maxWidth withHeight:FLT_MAX] ;
}

- (id)initWithMaxWidth:(float)maxWidth withHeight:(float)fixationHeight {
    self = [super init];
    if(self) {
        _isFixation = YES;
        _maxWidth = maxWidth;
        _fixationHeight = fixationHeight;
        self.text = @"";
        self.font = [UIFont systemFontOfSize:12];
        [self setNumberOfLines:0];
        [self addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:nil];
        [self addObserver:self forKeyPath:@"font" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:nil];
        
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    UIFont *font = self.font;
    CGSize size = CGSizeMake(_maxWidth, 20000.0f);
    //默认会有个0.2的行距.
    NSMutableAttributedString *attributed = [self attributedStringFromStingWithFont:font withLineSpacing:0.4];
    size = [attributed boundingRectWithSize:size
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                    context:nil].size;//实用与ios7前后。
    NSLog(@"%f",size.height);
    NSLog(@"%f",_maxWidth);
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        if(!_isFixation) {
            make.height.mas_equalTo(size.height);
        }else {
            if(size.height > _fixationHeight)
                make.height.mas_equalTo(_fixationHeight);
            else
                make.height.mas_equalTo(size.height);
        }
        make.width.mas_equalTo(size.width + 1);
    }];
    self.widthView = size.width + 1 ;
    self.heightView = size.height ;
}

-(NSMutableAttributedString *)attributedStringFromStingWithFont:(UIFont *)font
                                                withLineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName:font}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [self.text length])];
    return attributedStr;
}

@end
