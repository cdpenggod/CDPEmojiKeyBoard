//
//  CDPEmojiKeyboard.h
//  emojiKeyBoard
//
//  Created by 柴东鹏 on 15/8/13.
//  Copyright (c) 2015年 柴东鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum{
    //mode1和mode2最大区别为在emoji键盘出现后,点击inputView(textField\textView)时emoji键盘是否换为系统键盘,总的来说就是用户体验的部分不同
    //mode1为不替换为系统键盘,mode2为替换为系统键盘
    CDPEmojiKeyboardMode1=0,
    CDPEmojiKeyboardMode2,//(用此模式需遵守CDPEmojiKeyboardMode2Delegate)
};
typedef NSInteger CDPEmojiKeyboardMode;//emoji键盘模式




//代理协议
@protocol CDPEmojiKeyboardDelegate <NSObject>

//emoji键盘出现时执行
-(void)didWhenKeyboardAppear;

//emoji键盘退出时执行
-(void)didWhenKeyboardDisappear;

@end



//专门为模式2提供的代理,只有CDPEmojiKeyboardMode2时才会调用
//当mode为CDPEmojiKeyboardMode2时必须遵守
@protocol CDPEmojiKeyboardMode2Delegate <NSObject>

//系统键盘出现
-(void)didWhenSystemKeyboardAppear:(NSNotification *)notification;

//系统键盘消失
-(void)didWhenSystemKeyboardDisappear:(NSNotification *)notification;

@end





@interface CDPEmojiKeyBoard : NSObject <UIGestureRecognizerDelegate,UIScrollViewDelegate>

//用来判断emoji键盘是否弹出(只读)
@property (nonatomic,assign,readonly) BOOL isAppear;

//emoji键盘高度(默认为183,如要更改,尽量不要设太小的值,否则表情可能放不下)
@property (nonatomic,assign) NSInteger keyboardHeight;

//代理
@property (nonatomic,weak) id <CDPEmojiKeyboardDelegate> delegate;

//当mode为CDPEmojiKeyboardMode2时必须遵守的代理
@property (nonatomic,weak) id <CDPEmojiKeyboardMode2Delegate> delegateForMode2;

//初始化并设置相关参数
//mode默认为CDPEmojiKeyboardMode1
//superView为inputView所在viewController的主视图,即self.view,为CDPEmojiKeyboardMode2提供
//y为CDPEmojiKeyboardMode2模式下表情键盘未出现时位于屏幕最底部的y值

-(id)initWithInputView:(UIView *)inputView andSuperView:(UIView *)superView yOfScreenBottom:(NSInteger)y keyboardMode:(CDPEmojiKeyboardMode)mode;

//弹出键盘(CDPEmojiKeyboardMode1情况下会与输入视图进行绑定)
//此方法自带收回系统键盘
-(void)keyboardAppear;

//退出键盘(CDPEmojiKeyboardMode1情况下会与输入视图解除绑定)
-(void)keyboardDisAppear;


@end
