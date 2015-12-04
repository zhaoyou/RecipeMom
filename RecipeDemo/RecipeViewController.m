//
//  FirstViewController.m
//  Recipe
//
//  Created by zhaoyou on 4/8/15.
//  Copyright (c) 2015 zhaoyou. All rights reserved.
//

#import "RecipeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "RecipeBasicCell.h"

@interface RecipeViewController ()

@property (nonatomic, strong) NSArray *recipes;
@property (nonatomic, strong) NSURLSession  *session;

@property (strong, nonatomic) NSMutableDictionary *offscreenCells;


@end

static NSString * const RWBasicCellIdentifier = @"recipeId";

@implementation RecipeViewController


-(id) initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration];
        self.offscreenCells = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 112.0f;
    
    self.title = @"菜谱排行";
    
    [self.tableView registerClass:[RecipeBasicCell class] forCellReuseIdentifier:RWBasicCellIdentifier];

    [self fetchRecipe];
}



-(void) fetchRecipe
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"setting" ofType:@"plist"];
    
    NSDictionary *setting = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    // NSURL
    NSURL *downloadUrl =
        [NSURL URLWithString: [NSString stringWithFormat:@"%@api/recipes", [setting objectForKey:@"API_BASE_URL"] ] ];
    
    [[self.session dataTaskWithURL:downloadUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            
            if (res.statusCode == 200) {
                
                NSError *err;
                
                NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                
                if (!err) {
                   // NSLog(@"%@", jsonData);
                    self.recipes = jsonData;
                   // NSLog(@"recipes count %ld", [self.recipes count]);
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        [self.tableView reloadData];
                    });
                    
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"JSon Parse Error" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
            
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
    }] resume];
}


#pragma table datasource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection %ld", [self.recipes count]);
    return [self.recipes count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return cell;
    
    RecipeBasicCell *cell = [self.tableView dequeueReusableCellWithIdentifier:RWBasicCellIdentifier];
   
    [self configruationCell:cell atIndexPath:indexPath];
    
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    
    NSLog(@" cellForRowAtIndexPath: %@", indexPath);
    
    return cell;
}


-(void) configruationCell: (RecipeBasicCell*) cell atIndexPath: (NSIndexPath *) indexPath
{
    NSDictionary *item = self.recipes[indexPath.row];
    NSString *title = [item valueForKey:@"name"] ?: NSLocalizedString(@"[No Title]", nil);
    [cell.title setText:title];
    
    NSString *subtitle = [item valueForKey:@"brief"];
    
    // Some subtitles can be really long, so only display the
    // first 200 characters
    if (subtitle.length > 200) {
        subtitle = [NSString stringWithFormat:@"%@...", [subtitle substringToIndex:200]];
    }
    
    [cell.brief setText:subtitle];
    
    [cell.recipeImage setImage:nil];
    //NSLog(@"imageSrc: %@", [item valueForKey:@"imageSrc"]);
    [cell.recipeImage setImageWithURL:[NSURL URLWithString:[item valueForKey:@"imageSrc"]]];

}






- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecipeBasicCell *cell = [self.offscreenCells objectForKey:RWBasicCellIdentifier];
    
    if (!cell) {
        cell = [[RecipeBasicCell alloc] init];
        [self.offscreenCells setObject:cell forKey:RWBasicCellIdentifier];
    }
    
    [self configruationCell:cell atIndexPath:indexPath];
    
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(cell.bounds));
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    height += 1;
    
    NSLog(@"heightForRowAtIndexPath%lf, %@", height, indexPath);
    
    return height;

}



@end
