//
//  ViewController.m
//  emojiKeyBoard
//
//  Created by 柴东鹏 on 15/8/13.
//  Copyright (c) 2015年 柴东鹏. All rights reserved.
//

#import "ViewController.h"
#import "CDPEmojiKeyBoard.h"

@interface ViewController () <CDPEmojiKeyboardDelegate> {
    UITextField *_textField;//输入视图,textField或者textView
    CDPEmojiKeyBoard *emojiKeyBoard;//emoji键盘
    UIButton *button;//切换键盘按钮
    NSInteger _currentKeyboardMode;//当前表情键盘的模式
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建输入视图
    _textField=[[UITextField alloc] initWithFrame:CGRectMake(20,100,200,50)];
    _textField.backgroundColor=[UIColor cyanColor];
    _textField.textColor=[UIColor redColor];
    [self.view addSubview:_textField];
    
    //设置键盘模式(0或1)
    _currentKeyboardMode=1;
    
    //创建emoji键盘
    emojiKeyBoard=[[CDPEmojiKeyBoard alloc] initWithInputView:_textField andSuperView:self.view yOfScreenBottom:self.view.bounds.size.height keyboardMode:_currentKeyboardMode];
    emojiKeyBoard.delegate=self;
    
    //切换键盘按钮
    button=[[UIButton alloc] initWithFrame:CGRectMake(20,160,24,24)];
    [button setImage:[UIImage imageNamed:@"btn_face"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(emojiButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20,200,self.view.bounds.size.width-40,150)];
    label.numberOfLines=0;
    label.text=@"CDPEmojiKeyBoard分为两种模式,两种模式主要区别为部分的用户体验不同,详情在.h文件里说明。\nCDPEmojiKeyboard集成到自己的输入栏很简单,demo中写了很多注释,看就能明白了。\n如果想换成自己的表情包可自行修改";
    [self.view addSubview:label];
}

//切换键盘button点击
-(void)emojiButtonClick{
    if (emojiKeyBoard.isAppear==NO) {
        //emoji键盘出现
        [emojiKeyBoard keyboardAppear];
    }
    else{
        //切换为系统键盘出现
        if(_currentKeyboardMode==0){
            //第一种模式
            [emojiKeyBoard keyboardDisAppear];
            [_textField becomeFirstResponder];
        }
        else{
            //第二种模式
            [_textField becomeFirstResponder];
        }
    }
}
//点击视图空白处
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //emoji键盘消失
    [emojiKeyBoard keyboardDisAppear];
    //结束输入状态
    [self.view endEditing:YES];

}

#pragma mark CDPEmojiKeyboardDelegate
//emoji键盘出现
-(void)didWhenKeyboardAppear{
    [button setImage:[UIImage imageNamed:@"btn_keyboard"] forState:UIControlStateNormal];
}
//emoji键盘消失
-(void)didWhenKeyboardDisappear{
    [button setImage:[UIImage imageNamed:@"btn_face"] forState:UIControlStateNormal];
}
#pragma mark 模式2情况下才会执行的方法(可选)
//系统键盘出现
-(void)didWhenSystemKeyboardAppear:(NSNotification *)notification{
    [button setImage:[UIImage imageNamed:@"btn_face"] forState:UIControlStateNormal];
    NSLog(@"系统键盘出现");
}
//系统键盘消失
-(void)didWhenSystemKeyboardDisappear:(NSNotification *)notification{
    NSLog(@"系统键盘消失");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
