//
//  FeaturedCell.m
//  TalkNic
//
//  Created by Talknic on 15/10/29.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import "FeaturedCell.h"
#import "Featured.h"
#import "UIImageView+WebCache.h"
@interface FeaturedCell()

@property (weak, nonatomic) IBOutlet UIImageView *groundView;

@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeofWork;



@end
@implementation FeaturedCell

-(void)setFeatured:(Featured *)featured
{
    _featured = featured;
    [self.headView sd_setImageWithURL:[NSURL URLWithString:featured.user_pic] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    self.nameLabel.text = featured.username;
    self.typeofWork.text = featured.praise;
    self.topicLabel.text = featured.topic;
    self.groundView.image = [UIImage imageNamed:@"discover_avatar_outline.png"];
}


@end
