//
//  SecondViewController.m
//  Recipe
//
//  Created by zhaoyou on 4/8/15.
//  Copyright (c) 2015 zhaoyou. All rights reserved.
//

#import "TaboosViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TabooCell.h"


@interface TaboosViewController ()

@property (nonatomic, strong) NSMutableArray *taboos;
@property (nonatomic, strong) NSURLSession *session;
@property (strong, nonatomic) NSMutableDictionary *offscreenCells;

@end


static NSString *kCustomCellID = @"tabooId";


@implementation TaboosViewController

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration];
        _offscreenCells = [NSMutableDictionary  dictionary];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.tableView registerClass:[TabooCell class] forCellReuseIdentifier:kCustomCellID];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120.0f;
    
    
    self.navigationItem.title = @"bababa";
    [self fetchTaboos];

}


-(void) fetchTaboos
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"setting" ofType:@"plist"];
    
    NSDictionary *setting = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    // NSURL
    NSURL *downloadUrl = [NSURL URLWithString: [NSString stringWithFormat:@"%@api/taboos", [setting objectForKey:@"API_BASE_URL"]]];
    
    
    [[self.session dataTaskWithURL:downloadUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            
            if (res.statusCode == 200) {
                
                NSError *err;
                
                NSMutableArray *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                
                if (!err) {
                    //NSLog(@"taboos: %@", jsonData);
                    self.taboos = jsonData;
                    //NSLog(@"taboos count: %ld", [self.taboos count]);
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
    return [self.taboos count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TabooCell *cell = (TabooCell *)[tableView dequeueReusableCellWithIdentifier:kCustomCellID];
    
    if (cell == nil) {
        cell = [[TabooCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:kCustomCellID];
    }
    
    [self configruationCell:cell atIndexPath:indexPath];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

-(void) configruationCell: (TabooCell *)cell atIndexPath: (NSIndexPath *) indexPath
{
    
    NSDictionary *data = [self.taboos objectAtIndex:indexPath.row];
    cell.title.text = [data valueForKey:@"title"];
    NSArray *items = (NSArray *)[data valueForKey:@"items"];
    NSString *reason = [data valueForKey:@"reason"];
    [reason stringByAppendingString:[items componentsJoinedByString:@","]];
    cell.names.text = reason;//[items componentsJoinedByString:@","];
    
    NSURL *url = [NSURL URLWithString:[data valueForKey:@"imageSrc"]];
    
    [cell.picView setImage:nil];
    [cell.picView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"db3.jpg"]];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TabooCell *cell = [self.offscreenCells objectForKey:kCustomCellID];
    
    if (!cell) {
        cell = [[TabooCell alloc] init];
        [self.offscreenCells setObject:cell forKey:kCustomCellID];
    }
    
    [self configruationCell:cell atIndexPath:indexPath];
    
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(cell.bounds));
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    height += 1;
    
    //NSLog(@"heightForRowAtIndexPath%lf, %@", height, indexPath);
    
    return height;
    
}


@end
