//
//  JMWebViewController.m
//  JS&OCDemo
//
//  Created by guokai on 2018/11/23.
//  Copyright © 2018年 guokai. All rights reserved.
//

#import "JMWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JMHeaderView.h"
#import "EditView.h"

#define kScreenSize [UIScreen mainScreen].bounds.size

@interface JMWebViewController ()<UIWebViewDelegate, JMHeaderViewDelegate, EditViewDelegate>
{
    NSString *_radioId;
    NSString *_inputId;
    NSString *_value;
}
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) JMHeaderView *headerView;
@property (nonatomic, strong) EditView *editView;
@property (nonatomic, strong) JSContext *context;
@end

@implementation JMWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.editView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardWillHideNotification object:nil];

}

- (void)keyboardHide {
    if (!self.editView.isHidden) {
        [self sureBtnClick];
    }
}

#pragma mark -- UITableViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak JMWebViewController * weakSelf = self;
    //选中步骤事件
    self.context[@"radioChecked"] = ^(){
        NSArray *args = [JSContext currentArguments];
        [weakSelf saveValues:args];
    };
    
    //输入框获取到焦点事件
    self.context[@"inputFocus"] = ^(){
        NSArray *args = [JSContext currentArguments];
        [weakSelf showEditView:args];
    };
    
    //单选框点击事件
    self.context[@"checkBoxClicked"] = ^(){
        NSArray *args = [JSContext currentArguments];
        NSLog(@"%@",args);
        NSString *val = [args[0] toString];
        NSString *value = [args[1] toString];
        if([value integerValue] == 1) {
            NSString *chooseName = [val integerValue] == 1 ? @"Y" : @"N";
            NSString *title = [NSString stringWithFormat:@"选择了:%@",chooseName];
            [[[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }
        
    };
    
}

- (void)showEditView:(NSArray *)args {
    
    _inputId = [args[0] toString];
    _value = [args[1] toString];
    BOOL editable = ![args[2] toBool];
    self.editView.textView.editable = editable;
    self.editView.hidden = NO;

    if(editable) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.editView.textView becomeFirstResponder];
        });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.editView.textView.text = _value;
    });

}

- (void)saveValues:(NSArray *)args {
    _radioId = args[0];
    self.headerView.signIdLabel.text = [NSString stringWithFormat:@"signID: %@",_radioId];
}

#pragma mark -- EditViewDelegate
- (void)cancleBtnClick {
    self.editView.hidden = YES;
    [self.editView.textView resignFirstResponder];
    
}

- (void)sureBtnClick {
    _value = self.editView.textView.text;
    [self.context[@"setInputValue"] callWithArguments:@[_inputId, _value]];
    self.editView.hidden = YES;
    [self.editView.textView resignFirstResponder];
    
}

#pragma mark -- JMHeaderViewDelegate
- (void)finishBtnClick {
    NSString *currentDate = [self currentDate];
    NSDictionary *values = @{
             @"redioId": _radioId ? _radioId : @"",
             @"workState": @"完工",
             @"worker": @"Jeremy",
             @"workdate": currentDate,
             @"stepStatus": @"1"
             };
    [self.context[@"setDate"] callWithArguments:@[values]];
}

- (void)resignBtnClick {
    
    NSDictionary *values = @{
                             @"redioId": _radioId,
                             @"workState": @"",
                             @"worker": @"",
                             @"workdate": @"",
                             @"stepStatus": @"0"
                             };
    [self.context[@"setDate"] callWithArguments:@[values]];
}

- (NSString *)currentDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}

#pragma mark -- getter
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 164, kScreenSize.width, kScreenSize.height-164)];
        _webView.delegate = self;
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"step" ofType:@"html"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]];
        [_webView loadRequest:request];
    }
    return _webView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"JMHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 64, kScreenSize.width, 100);
        _headerView.delegate = self;
    }
    return _headerView;
}

- (EditView *)editView {
    if (!_editView) {
        _editView = [[[NSBundle mainBundle] loadNibNamed:@"EditView" owner:nil options:nil] lastObject];
        _editView.frame = CGRectMake((kScreenSize.width-300)*0.5, (kScreenSize.height-200)*0.5, 300, 200);
        _editView.layer.cornerRadius = 5.0f;
        _editView.textView.layer.cornerRadius = 5.0f;
        _editView.textView.layer.borderWidth = 1.0f;
        _editView.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _editView.hidden = YES;
        _editView.delegate = self;
    }
    return _editView;
}

@end
