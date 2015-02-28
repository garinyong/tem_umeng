//
//  FeedbackCell.m
//  pp_new
//
//  Created by GaoYong on 15/2/28.
//  Copyright (c) 2015年 GaoYong. All rights reserved.
//

#import "FeedbackCell.h"
#import "UIImage+ext.h"

@implementation FeedbackCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 260, 0)];
        [self.contentView addSubview:bgImageView];
        
        contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgImageView.frame.size.width, 0)];
        contentLbl.backgroundColor = [UIColor clearColor];
        contentLbl.textColor = [UIColor colorWithRed:73/255.0f green:81/255.0f blue:101/255.0f alpha:1];
        contentLbl.font = [UIFont systemFontOfSize:14.0f];
        contentLbl.lineBreakMode = NSLineBreakByCharWrapping;
        contentLbl.numberOfLines = 0;
        [bgImageView addSubview:contentLbl];
        
        timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
        timeLbl.backgroundColor = [UIColor clearColor];
        timeLbl.font = [UIFont systemFontOfSize:12];
//        timeLbl.textColor = MAIN_TEXTCOLOR;
        timeLbl.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:timeLbl];
    }
    return self;
}

- (void) setContent:(NSString *)content time:(NSString *)time left:(BOOL)left{
    timeLbl.text = time;
    if (left) {
        bgImageView.image = [UIImage strenchImageWithImageName:@"balloon_left.png"];
        bgImageView.frame = CGRectMake(0, 0, 260, 0);
    }else{
        bgImageView.image = [UIImage strenchImageWithImageName:@"balloon_right.png"];
        bgImageView.frame = CGRectMake(self.bounds.size.width - 260, 0, 260, 0);
    }
    
    CGSize size = CGSizeMake(contentLbl.frame.size.width, 10000);
    CGSize newSize = [content sizeWithFont:contentLbl.font constrainedToSize:size lineBreakMode:contentLbl.lineBreakMode];
    bgImageView.frame = CGRectMake(bgImageView.frame.origin.x, bgImageView.frame.origin.y, bgImageView.frame.size.width, newSize.height + 20);
    if (left) {
        contentLbl.frame = CGRectMake(20, 10, bgImageView.frame.size.width - 30, newSize.height);
    }else{
        contentLbl.frame = CGRectMake(10, 10, bgImageView.frame.size.width - 30, newSize.height);
    }
    
    timeLbl.frame = CGRectMake(0, newSize.height + 20, self.bounds.size.width, 20);
    
    contentLbl.text = content;
    timeLbl.text = time;
    
}

@end
