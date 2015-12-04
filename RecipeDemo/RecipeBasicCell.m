//
//  RecipeBasicCell.m
//  
//
//  Created by zhaoyou on 5/11/15.
//
//

#import "RecipeBasicCell.h"
#import "Masonry.h"

@interface RecipeBasicCell()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation RecipeBasicCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier: reuseIdentifier];
    
    if (self) {
        self.title = [UILabel new];
        self.title.numberOfLines = 1;
        self.title.lineBreakMode = NSLineBreakByTruncatingTail;
        self.title.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        [self.contentView addSubview:self.title];
        
        self.brief = [UILabel new];
        self.brief.numberOfLines = 0;
        self.brief.lineBreakMode = NSLineBreakByTruncatingTail;
        self.brief.textColor= [UIColor grayColor];
        self.brief.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        [self.contentView addSubview:self.brief];
        
        self.recipeImage = [UIImageView new];
        self.recipeImage.layer.cornerRadius = 3.0f;
        self.recipeImage.layer.masksToBounds = YES;
        
        [self.contentView addSubview:self.recipeImage];
        
    }
    
    return self;
}

-(void) updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.recipeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15.0f);
            make.top.equalTo(self.contentView).with.offset(10.0f);
            make.right.equalTo(self.title.mas_left).with.offset(-15.0f);
            make.size.mas_equalTo(CGSizeMake(80.0f, 80.0f));

        }];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(10).priority(751);
            make.right.equalTo(self.contentView).with.offset(-15);
            //make.bottom.equalTo(self.brief.mas_top).with.offset(-space_v);
        }];
        
        [self.brief mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.mas_bottom).offset(10);
            make.left.equalTo(self.title);
            make.right.equalTo(self.title);
            make.bottom.equalTo(self.contentView).with.offset(-10).priority(749);
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
    self.brief.preferredMaxLayoutWidth = CGRectGetWidth(self.brief.frame);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
