//
//  CDPEmojiKeyBoard.m
//  emojiKeyBoard
//
//  Created by Wolonge on 15/8/13.
//  Copyright (c) 2015年 Wolonge. All rights reserved.
//

#import "CDPEmojiKeyBoard.h"
#define SHeight [UIScreen mainScreen].bounds.size.height
#define SWidth [UIScreen mainScreen].bounds.size.width

@implementation CDPEmojiKeyBoard{
    UIView *_inputView;//输入视图
    UIView *_superView;//输入视图所在的viewController主视图
    NSArray *_emojiArr;//表情包
    BOOL _isRun;//是否可执行
    UIPageControl *_pageControl;//页码控制器
    CDPEmojiKeyBoardMode _mode;
    UIScrollView *_backgroundScrollView;
    
    NSInteger _cursorPosition;//CDPEmojiKeyBoardMode2下光标位置

}

//初始化并设置相关参数
-(id)initWithInputView:(UIView *)inputView andSuperView:(UIView *)superView keyBoardMode:(CDPEmojiKeyBoardMode)mode{
    if (self=[super init]) {
        _isAppear=NO;
        _keyBoardHeight=183;
        _superView=superView;
        if (!mode) {
            mode=CDPEmojiKeyBoardMode1;
        }
        else{
            _mode=mode;
        }
        if (inputView.class!=UITextField.class&&inputView.class!=UITextView.class) {
            NSLog(@"输入视图不是textField或者textView");
            _isRun=NO;
        }
        else{
            _isRun=YES;
            _inputView=inputView;
            
            [self createData];
            
            [self createUI];
            
        }
        
    }
    
    return self;
}
//设置键盘高度
-(void)setKeyBoardHeight:(NSInteger)keyBoardHeight{
    
    _keyBoardHeight=keyBoardHeight;
    
    if (_mode==CDPEmojiKeyBoardMode1) {
        _backgroundView.frame=CGRectMake(0,0,SWidth,_keyBoardHeight);
    }
    if (_mode==CDPEmojiKeyBoardMode2) {
        _backgroundView.frame=CGRectMake(0,SHeight,SWidth,_keyBoardHeight);
    }
    _backgroundScrollView.frame=CGRectMake(0,0,SWidth,_keyBoardHeight);
    _backgroundScrollView.contentSize=CGSizeMake(SWidth*8,_backgroundScrollView.bounds.size.height);
}
#pragma mark 创建数据及UI
//数据
-(void)createData{
    NSDictionary *emojiDict=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"EmojisList" ofType:@"plist"]];
    _emojiArr=[emojiDict objectForKey:@"People"];
}
//UI
-(void)createUI{
    //背景视图
    _backgroundView=[[UIView alloc] initWithFrame:CGRectMake(0,0,SWidth,_keyBoardHeight)];
    _backgroundView.backgroundColor=[UIColor colorWithRed:246/255.f green:246/255.f blue:246/255.f alpha:1];
    
    if (_mode==CDPEmojiKeyBoardMode2) {
        if (!_superView) {
            NSLog(@"superView不存在,mode变为CDPEmojiKeyBoardMode1");
            _mode=CDPEmojiKeyBoardMode1;
        }
        else{
            //监听系统键盘出现(主要为CDPEmojiKeyBoardMode2提供)
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemKeyBoardWillShow) name:UIKeyboardWillShowNotification object:nil];
            
            _backgroundView.frame=CGRectMake(0,SHeight,SWidth,_keyBoardHeight);
            [_superView addSubview:_backgroundView];
        }
    }
    
    //判断页数
    NSInteger pageNum=24*(_emojiArr.count/24)>=_emojiArr.count?_emojiArr.count/24:_emojiArr.count/24+1;
    
    _backgroundScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0,0,SWidth,_keyBoardHeight)];
    _backgroundScrollView.pagingEnabled=YES;
    _backgroundScrollView.showsHorizontalScrollIndicator=NO;
    _backgroundScrollView.backgroundColor=[UIColor clearColor];
    _backgroundScrollView.delegate=self;
    _backgroundScrollView.contentSize=CGSizeMake(SWidth*pageNum,_backgroundScrollView.bounds.size.height);
    [_backgroundView addSubview:_backgroundScrollView];
    //添加emoji表情
    for (int j=0; j<_emojiArr.count; j++) {
        //两个表情x的位置差
        CGFloat width=(SWidth-(30*8+10))/7+30;
        
        //表情所在行数、列数、页数
        NSInteger row,col,pageIdx;
        row=(j/8 ) %3;
        col=(j+1) % 8 ==0? 8: (j +1 )%8;
        pageIdx=j/24;
        
        UILabel *emojiLabel=[[UILabel alloc]initWithFrame:CGRectMake(5+(col-1)*width+pageIdx*SWidth,15+row*39,30,30)];
        [emojiLabel setFont:[UIFont systemFontOfSize:30]];
        emojiLabel.text=_emojiArr[j];
        emojiLabel.userInteractionEnabled=YES;
        [_backgroundScrollView addSubview:emojiLabel];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectEmoji:)];
        tap.delegate=self;

        [emojiLabel addGestureRecognizer:tap];
        
    }
    
    UIButton *backspaceButton=[[UIButton alloc] initWithFrame:CGRectMake(SWidth-41,135,32,32)];
    [backspaceButton setImage:[UIImage imageNamed:@"emoji_backspace"] forState:UIControlStateNormal];
    [backspaceButton addTarget:self action:@selector(backspaceClick) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:backspaceButton];
    
    //页码控制器
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(50,135,SWidth-100,36)];
    _pageControl.numberOfPages=pageNum;
    _pageControl.currentPage=0;
    _pageControl.userInteractionEnabled=NO;
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:85/255.f green:85/255.f blue:85/255.f alpha:1];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:170/255.f green:170/255.f blue:170/255.f alpha:1];
    [_backgroundView addSubview:_pageControl];
    
}
#pragma mark 键盘点击事件
//退格
-(void)backspaceClick{
    if (_isRun==NO) {
        NSLog(@"输入视图不是textField或者textView");
        return;
    }
    //模式判断
    switch (_mode) {
        case CDPEmojiKeyBoardMode1:{
            if (_inputView.class==UITextField.class) {
                
                UITextField *textField=(UITextField *)_inputView;
                [textField deleteBackward];
            }
            if (_inputView.class==UITextView.class) {
                UITextView *textView=(UITextView *)_inputView;
                [textView deleteBackward];
            }
            
        }
            break;
        case CDPEmojiKeyBoardMode2:{
            if (_inputView.class==UITextField.class) {
                UITextField *textField=(UITextField *)_inputView;
                if ([textField.text isEqual:@""]) {
                    return;
                }
                NSString *str=[NSString stringWithString:textField.text];
                textField.text=[NSString stringWithFormat:@"%@",[self judgeTheText:str]];
            }
            if (_inputView.class==UITextView.class) {
                UITextView *textView=(UITextView *)_inputView;
                if ([textView.text isEqual:@""]) {
                    return;
                }
                NSString *str=[NSString stringWithString:textView.text];
                textView.text=[NSString stringWithFormat:@"%@",[self judgeTheText:str]];
            }
            
        }
            break;
        default:
            break;
    }
    
}
//CDPEmojiKeyBoardMode2情况下退格字符判断
-(NSString *)judgeTheText:(NSString *)text{
    NSMutableString *str=[NSMutableString stringWithString:text];
    if (_cursorPosition==0) {
        return str;
    }
    if (str.length==1) {
        [str deleteCharactersInRange:NSMakeRange(_cursorPosition-1,1)];
        _cursorPosition=_cursorPosition-1;
        return str;
    }
    NSString *deleteStr=[str substringWithRange:NSMakeRange(_cursorPosition-2,2)];
    
    for (NSString *emojiStr in _emojiArr) {
        if ([emojiStr isEqualToString:deleteStr]) {
            [str deleteCharactersInRange:NSMakeRange(_cursorPosition-2,2)];
            _cursorPosition=_cursorPosition-2;
            return str;
        }
    }
    
    [str deleteCharactersInRange:NSMakeRange(_cursorPosition-1,1)];
    _cursorPosition=_cursorPosition-1;
    return str;
}
//点击选择表情
-(void)didSelectEmoji:(UITapGestureRecognizer*)tap{
    if (_isRun==NO) {
        NSLog(@"输入视图不是textField或者textView");
        return;
    }
    //模式判断
    switch (_mode) {
        case CDPEmojiKeyBoardMode1:{
            if (tap.state==UIGestureRecognizerStateEnded) {
                
                UILabel *emojiLabel=(UILabel*)[tap view];
                
                if (_inputView.class==UITextField.class) {
                    UITextField *textField=(UITextField *)_inputView;
                    [textField insertText:emojiLabel.text];
                }
                if (_inputView.class==UITextView.class) {
                    UITextView *textView=(UITextView *)_inputView;
                    [textView insertText:emojiLabel.text];
                }
            }
            
        }
            break;
        case CDPEmojiKeyBoardMode2:{
            if (tap.state==UIGestureRecognizerStateEnded) {
                
                UILabel *emojiLabel=(UILabel*)[tap view];
                
                if (_inputView.class==UITextField.class) {
                    UITextField *textField=(UITextField *)_inputView;
                    NSMutableString *str=[NSMutableString stringWithString:textField.text];
                    [str insertString:emojiLabel.text atIndex:_cursorPosition];
                    textField.text=[NSString stringWithFormat:@"%@",str];
                    _cursorPosition=_cursorPosition+2;
                }
                if (_inputView.class==UITextView.class) {
                    UITextView *textView=(UITextView *)_inputView;
                    NSMutableString *str=[NSMutableString stringWithString:textView.text];
                    [str insertString:emojiLabel.text atIndex:_cursorPosition];
                    textView.text=[NSString stringWithFormat:@"%@",str];
                    _cursorPosition=_cursorPosition+2;
                }
            }
        }
            break;
        default:
            break;
    }

    
}
#pragma mark UIScrollViewDelegate
//滑动事件
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int pageNumber=scrollView.contentOffset.x/SWidth;
    
    _pageControl.currentPage=pageNumber;
}
#pragma mark 与输入视图的绑定操作
//弹出键盘(CDPEmojiKeyBoardMode1情况下会与输入视图进行绑定)
-(void)keyboardAppear{
    if (_isRun==NO) {
        NSLog(@"输入视图不是textField或者textView");
        return;
    }
    
    _isAppear=YES;
    //模式判断
    switch (_mode) {
        case CDPEmojiKeyBoardMode1:{
            [_inputView resignFirstResponder];
            
            if (_inputView.class==UITextField.class) {
                UITextField *textField=(UITextField *)_inputView;
                textField.inputView=_backgroundView;
            }
            if (_inputView.class==UITextView.class) {
                UITextView *textView=(UITextView *)_inputView;
                textView.inputView=_backgroundView;
            }
            
            [_inputView becomeFirstResponder];
        }
            break;
        case CDPEmojiKeyBoardMode2:{
            //获取光标位置
            if (_inputView.class==UITextField.class) {
                UITextField *textField=(UITextField *)_inputView;
                _cursorPosition=[textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
            }
            if (_inputView.class==UITextView.class) {
                UITextView *textView=(UITextView *)_inputView;
                _cursorPosition=[textView offsetFromPosition:textView.beginningOfDocument toPosition:textView.selectedTextRange.start];
            }
            
            [_inputView resignFirstResponder];

            [UIView animateWithDuration:0.3 animations:^{
                _backgroundView.transform=CGAffineTransformMakeTranslation(0,-_keyBoardHeight);
                
            }];
        }
            break;
        default:
            break;
    }
    [self.delegate didWhenKeyboardAppear];
}
//退出键盘(CDPEmojiKeyBoardMode1情况下会与输入视图解除绑定)
-(void)keyboardDisAppear{
    if (_isRun==NO) {
        NSLog(@"输入视图不是textField或者textView");
        return;
    }
    
    _isAppear=NO;
    //模式判断
    switch (_mode) {
        case CDPEmojiKeyBoardMode1:{
            [_inputView resignFirstResponder];
            
            if (_inputView.class==UITextField.class) {
                UITextField *textField=(UITextField *)_inputView;
                textField.inputView=nil;
            }
            if (_inputView.class==UITextView.class) {
                UITextView *textView=(UITextView *)_inputView;
                textView.inputView=nil;
            }

        }
            break;
        case CDPEmojiKeyBoardMode2:{
            
            [UIView animateWithDuration:0.3 animations:^{
                _backgroundView.transform=CGAffineTransformMakeTranslation(0,0);
                
            }];
        }
            break;
        default:
            break;
    }
    [self.delegate didWhenKeyboardDisAppear];
}
#pragma mark 监听系统键盘
//系统键盘出现
-(void)systemKeyBoardWillShow{
    if (_mode==CDPEmojiKeyBoardMode2) {
        [self keyboardDisAppear];
    }
}



-(void)dealloc{
    if (_mode==CDPEmojiKeyBoardMode2) {
        //取消监听系统键盘
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    }
}





@end
