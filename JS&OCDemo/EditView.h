//
//  EditView.h
//  JS&OCDemo
//
//  Created by guokai on 2018/11/27.
//  Copyright © 2018年 guokai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditViewDelegate <NSObject>
- (void)cancleBtnClick;
- (void)sureBtnClick;
@end

@interface EditView : UIView
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic, weak) id<EditViewDelegate>delegate;
@end
