//
//  EditView.m
//  JS&OCDemo
//
//  Created by guokai on 2018/11/27.
//  Copyright © 2018年 guokai. All rights reserved.
//

#import "EditView.h"

@implementation EditView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cancleBtn.layer.cornerRadius = 5.0f;
    self.sureBtn.layer.cornerRadius = 5.0f;
}

- (IBAction)cancleBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cancleBtnClick)]) {
        [self.delegate cancleBtnClick];
    }
}

- (IBAction)sureBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sureBtnClick)]) {
        [self.delegate sureBtnClick];
    }
}

@end
