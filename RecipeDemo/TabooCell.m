//
//  TabooCell.m
//  RecipeDemo
//
//  Created by zhaoyou on 12/10/15.
//  Copyright © 2015 zhaoyou. All rights reserved.
//

#import "TabooCell.h"
#import "Masonry.h"


@interface TabooCell()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation TabooCell

- (void)awakeFromNib {
    // Initialization code
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.title = [UILabel new];
        self.title.numberOfLines = 1;
        self.title.lineBreakMode = NSLineBreakByTruncatingTail;
        self.title.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        [self.contentView addSubview:self.title];
        
        self.names = [UILabel new];
        self.names.lineBreakMode = NSLineBreakByTruncatingTail;
        self.names.numberOfLines = 3;
        self.names.textColor= [UIColor grayColor];
        self.names.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        [self.contentView addSubview:self.names];
        
        self.picView = [UIImageView new];
        self.picView.layer.cornerRadius = 4.0f;
        self.picView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.picView];
        
    }
    
    return self;
}

-(void) updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10.0f);
            make.right.equalTo(self.contentView).offset(-10.0f);
            make.top.equalTo(self.contentView).offset(10.0f);
        }];
        
        [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.mas_bottom).offset(10.0f);
            make.left.equalTo(self.contentView).offset(10.0f);
            make.right.equalTo(self.names.mas_left).offset(-10.f);
            make.size.mas_equalTo(CGSizeMake(80.0f, 80.0f));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.0f).priority(749);

        }];
        
        [self.names mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.mas_bottom).offset(10.0f);
            make.left.equalTo(self.picView.mas_right).offset(10.0f);
            make.right.equalTo(self.contentView).offset(-10.0f);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.0f).priority(751);
        }];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.title.preferredMaxLayoutWidth = CGRectGetWidth(self.title.frame);
    self.names.preferredMaxLayoutWidth = CGRectGetWidth(self.names.frame);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
