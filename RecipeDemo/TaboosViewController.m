//
//  SecondViewController.m
//  Recipe
//
//  Created by zhaoyou on 4/8/15.
//  Copyright (c) 2015 zhaoyou. All rights reserved.
//

#import "TaboosViewController.h"
#import "UIImageView+AFNetworking.h"


@interface TaboosViewController ()

@property (nonatomic, strong) NSMutableArray *taboos;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation TaboosViewController

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
                    NSLog(@"taboos count: %ld", [self.taboos count]);
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
    NSLog(@"numberOfRowsInSection %ld", [self.taboos count]);
    return [self.taboos count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCustomCellID = @"tabooId";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCustomCellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:kCustomCellID];
    }
    
    NSDictionary *data = [self.taboos objectAtIndex:indexPath.row];
    cell.textLabel.text = [data valueForKey:@"title"];
    NSArray *items = (NSArray *)[data valueForKey:@"items"];
    cell.detailTextLabel.text = [items componentsJoinedByString:@","];
    
    NSURL *url = [NSURL URLWithString:[data valueForKey:@"imageSrc"]];
    
    // [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //  NSLog(@"url: %@", url);
    
    [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"db3.jpg"]];
    
    NSLog(@" tableView cellForRow...");
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
