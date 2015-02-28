//
//  FeedbackCell.h
//  pp_new
//
//  Created by GaoYong on 15/2/28.
//  Copyright (c) 2015年 GaoYong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackCell : UITableViewCell{
@private
    UIImageView *bgImageView;
    UILabel *timeLbl;
    UILabel *contentLbl;
}
- (void) setContent:(NSString *)content time:(NSString *)time left:(BOOL)left;
@end
