//
//  JMHeaderView.h
//  JS&OCDemo
//
//  Created by guokai on 2018/11/23.
//  Copyright © 2018年 guokai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMHeaderViewDelegate <NSObject>
- (void)finishBtnClick;
- (void)resignBtnClick;
@end

@interface JMHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *signIdLabel;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@property (nonatomic, weak) id<JMHeaderViewDelegate>delegate;

@end
