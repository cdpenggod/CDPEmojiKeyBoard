//
//  CDPEmojiKeyBoard.h
//  emojiKeyBoard
//
//  Created by Wolonge on 15/8/13.
//  Copyright (c) 2015年 Wolonge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum{
    //mode1和mode2最大区别为在emoji键盘出现后,点击inputView(textField\textView)时键盘是否换为系统键盘,用户体验的部分不同
    //mode1为不替换为系统键盘,mode2为替换为系统键盘
    CDPEmojiKeyBoardMode1=0,
    CDPEmojiKeyBoardMode2,
};
typedef NSInteger CDPEmojiKeyBoardMode;//emoji键盘模式

//代理协议
@protocol CDPEmojiKeyBoardDelegate <NSObject>

//键盘出现时执行
-(void)didWhenKeyboardAppear;

//键盘退出时执行
-(void)didWhenKeyboardDisAppear;

@end

@interface CDPEmojiKeyBoard : NSObject <UIGestureRecognizerDelegate,UIScrollViewDelegate> {
    UIView *_backgroundView;//键盘背景视图(考虑到给键盘添加背景色或图片,这是键盘最底层的总View)

}

//键盘是否弹出
@property (nonatomic,assign) BOOL isAppear;

//键盘高度(默认为183,如要更改,尽量不要设太小的值,否则表情可能放不下)
@property (nonatomic,assign) NSInteger keyBoardHeight;

//代理
@property (nonatomic,weak) id <CDPEmojiKeyBoardDelegate> delegate;

//初始化并设置相关参数
//mode默认为CDPEmojiKeyBoardMode1
//superView为inputView所在viewController的主视图,即self.view,主要为CDPEmojiKeyBoardMode2提供
-(id)initWithInputView:(UIView *)inputView andSuperView:(UIView *)superView keyBoardMode:(CDPEmojiKeyBoardMode)mode;

//弹出键盘(CDPEmojiKeyBoardMode1情况下会与输入视图进行绑定)
-(void)keyboardAppear;

//退出键盘(CDPEmojiKeyBoardMode1情况下会与输入视图解除绑定)
-(void)keyboardDisAppear;

@end
