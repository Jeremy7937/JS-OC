//
//  JMHeaderView.m
//  JS&OCDemo
//
//  Created by guokai on 2018/11/23.
//  Copyright © 2018年 guokai. All rights reserved.
//

#import "JMHeaderView.h"

@implementation JMHeaderView

- (IBAction)finishBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(finishBtnClick)]) {
        [self.delegate finishBtnClick];
    }
}

- (IBAction)reSignBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(resignBtnClick)]) {
        [self.delegate resignBtnClick];
    }
}

@end
