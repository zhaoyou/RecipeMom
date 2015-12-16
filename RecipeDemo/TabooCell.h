//
//  TabooCell.h
//  RecipeDemo
//
//  Created by zhaoyou on 12/10/15.
//  Copyright © 2015 zhaoyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabooCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UILabel *title;
@property(nonatomic, strong) IBOutlet UILabel *names;
@property(nonatomic, strong) IBOutlet UIImageView *picView;

@end
