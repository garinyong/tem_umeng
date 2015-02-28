//
//  FeedBackVC.h
//  pp_new
//
//  Created by GaoYong on 15/2/28.
//  Copyright (c) 2015年 GaoYong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMFeedback.h"

#define UMENG_APPKEY @"54ed8fa8fd98c52f1c000abb"

@protocol FeedbackCtrlDelegate;
@interface FeedBackVC : UIViewController<UMFeedbackDataDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
@private
    UMFeedback *umFeedback;
    UITableView *feedbackList;
    UITextField *inputField;
    UIImageView *inputView;
    UIButton *sendBtn;
}
@property (nonatomic,assign) id<FeedbackCtrlDelegate> delegate;
@end


@protocol FeedbackCtrlDelegate <NSObject>

@optional
- (void) feedbackNumChanged;

@end