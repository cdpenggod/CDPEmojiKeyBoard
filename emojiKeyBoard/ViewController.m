//
//  ViewController.m
//  emojiKeyBoard
//
//  Created by Wolonge on 15/8/13.
//  Copyright (c) 2015年 Wolonge. All rights reserved.
//

#import "ViewController.h"
#import "CDPEmojiKeyBoard.h"

@interface ViewController () <CDPEmojiKeyBoardDelegate> {
    UITextField *_textField;//输入视图,textField或者textView
    CDPEmojiKeyBoard *emojiKeyBoard;//emoji键盘
    UIButton *button;//切换键盘按钮
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
    
    //创建emoji键盘
    emojiKeyBoard=[[CDPEmojiKeyBoard alloc] initWithInputView:_textField andSuperView:self.view keyBoardMode:1];
    //设置代理,非必要,是否设置看个人需求
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

-(void)emojiButtonClick{
    if (emojiKeyBoard.isAppear==NO) {
        //键盘出现
        [emojiKeyBoard keyboardAppear];
    }
    else{
        //键盘消失
        [emojiKeyBoard keyboardDisAppear];
        //进入输入状态,系统键盘出现
        [_textField becomeFirstResponder];
    }
}
//点击视图空白处
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //键盘消失
    [emojiKeyBoard keyboardDisAppear];
    //结束输入状态
    [self.view endEditing:YES];

}
#pragma mark CDPEmojiKeyBoardDelegate
-(void)didWhenKeyboardAppear{
    NSLog(@"emoji键盘出现了");
    [button setImage:[UIImage imageNamed:@"btn_keyboard"] forState:UIControlStateNormal];
}
-(void)didWhenKeyboardDisAppear{
    NSLog(@"emoji键盘消失了");
    [button setImage:[UIImage imageNamed:@"btn_face"] forState:UIControlStateNormal];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
