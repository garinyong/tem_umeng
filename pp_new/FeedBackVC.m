//
//  FeedBackVC.m
//  pp_new
//
//  Created by GaoYong on 15/2/28.
//  Copyright (c) 2015年 GaoYong. All rights reserved.
//

#import "FeedBackVC.h"
#import "FeedbackCell.h"

@interface FeedBackVC ()
@property (nonatomic,assign) float scrollY;
@end

@implementation FeedBackVC

@synthesize delegate;
@synthesize scrollY;

- (void)dealloc {
    umFeedback.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"用户反馈";
    
    // list
    feedbackList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 45) style:UITableViewStylePlain];
    feedbackList.delegate = self;
    feedbackList.dataSource = self;
    feedbackList.backgroundColor = [UIColor clearColor];
    feedbackList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:feedbackList];
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    feedbackList.tableHeaderView = tableHeaderView;
    
    // 输入框
    inputView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 45, self.view.bounds.size.width, 45)];
    inputView.image = [UIImage imageNamed:@"bg-table-hover.png"];
    inputView.userInteractionEnabled = YES;
    [self.view addSubview:inputView];
    
    UIImageView *inputBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, self.view.bounds.size.width - 90, 31)];
    inputBg.image = [UIImage imageNamed:@"search_bg.png"];
    [inputView addSubview:inputBg];
    inputBg.userInteractionEnabled = YES;
    
    inputField = [[UITextField alloc] initWithFrame:CGRectMake(4, 0, inputBg.frame.size.width - 8, inputBg.frame.size.height)];
    inputField.delegate = self;
    inputField.borderStyle = UITextBorderStyleNone;
    inputField.placeholder = @"留下您的宝贵意见";
    inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputField.font = [UIFont systemFontOfSize:14.0f];
    inputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [inputBg addSubview:inputField];
    
    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(self.view.bounds.size.width - 70, 8, 60, 28);
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:sendBtn];
    
    sendBtn.enabled = NO;
    
    // 获取所有评论
    umFeedback = [UMFeedback sharedInstance];
    [umFeedback setAppkey:UMENG_APPKEY delegate:self];
//    [self.view startCustomLoading];
    [umFeedback get];
    
    
    // 绑定键盘消息
    [self handleKeyboard];
}

- (void)handleKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark -
#pragma mark keyboard notification

- (void)keyboardWillShow:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         feedbackList.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 45 - keyboardHeight);
                         inputView.frame = CGRectMake(0, self.view.bounds.size.height - 45 - keyboardHeight, self.view.bounds.size.width, 45);
                     }
                     completion:^(BOOL finished) {
                         [self scrollToBottom];
                     }
     ];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView beginAnimations:@"bottomBarDown" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    feedbackList.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 45);
    inputView.frame = CGRectMake(0, self.view.bounds.size.height - 45, self.view.bounds.size.width, 45);
    
    [UIView commitAnimations];
}

- (void)scrollToBottom {
    if ([feedbackList numberOfRowsInSection:0] > 1) {
        long lastRowNumber = [feedbackList numberOfRowsInSection:0] - 1;
        NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
        [feedbackList scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *tagStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    tagStr = [tagStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(tagStr && tagStr.length > 0){
        sendBtn.enabled = YES;
    }else{
        sendBtn.enabled = NO;
    }
    return YES;
}

- (BOOL) textFieldShouldClear:(UITextField *)textField{
    sendBtn.enabled = NO;
    return YES;
}


#pragma mark -
#pragma mark UIScrollViewDelegate
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.scrollY = scrollView.contentOffset.y;
}
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.scrollY - scrollView.contentOffset.y > 10) {
        [inputField resignFirstResponder];
    }
    
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (umFeedback.topicAndReplies) {
        return umFeedback.topicAndReplies.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"FeedbackCell";
    FeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell =  [[FeedbackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    NSDictionary *dict = [umFeedback.topicAndReplies objectAtIndex:indexPath.row];
    NSString *content = [NSString stringWithFormat:@"%@",[dict objectForKey:@"content"]];
    NSTimeInterval datetime = [[dict objectForKey:@"created_at"] doubleValue]/1000;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:datetime];
    
    NSString *dateString = [self stringFromDate:date];
    
    if ([@"dev_reply" isEqualToString:[dict objectForKey:@"type"]]){
        [cell setContent:content time:dateString left:YES];
    }else{
        [cell setContent:content time:dateString left:NO];
    }
    return cell;
}

- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [umFeedback.topicAndReplies objectAtIndex:indexPath.row];
    NSString *content = [dict objectForKey:@"content"];
    
    CGSize size = CGSizeMake(260 - 30, 10000);
    CGSize newSize = [content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    
    return newSize.height + 20 + 20;
}

- (void) sendBtnClick:(id)sender{
    if ([inputField.text length]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:inputField.text forKey:@"content"];
        
        [umFeedback post:dictionary];
        [inputField resignFirstResponder];
    }
}

#pragma mark -
#pragma mark UMFeedbackDataDelegate
- (void)getFinishedWithError: (NSError *)error{
    if (umFeedback.topicAndReplies.count == 0) {
        [inputField becomeFirstResponder];
    }
    
//    [self.view endCustomLoading];
    [feedbackList reloadData];
    [self scrollToBottom];
    
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    // 保存Feedback数量
//    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setValue:[NSNumber numberWithInt:0] forKey:USERDEFAULT_FEEDBACKNUM];
//    [userDefaults synchronize];
    
    if ([delegate respondsToSelector:@selector(feedbackNumChanged)]) {
        [delegate feedbackNumChanged];
    }
}

- (void)postFinishedWithError:(NSError *)error{
    inputField.text = @"";
    [umFeedback get];
}
@end