//
//  RecipeBasicCell.h
//  
//
//  Created by zhaoyou on 5/11/15.
//
//

#import <UIKit/UIKit.h>

@interface RecipeBasicCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *brief;
@property (strong, nonatomic) IBOutlet UIImageView *recipeImage;

@end
