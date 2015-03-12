//
//  ViewController.m
//  Articles
//
//  Created by Admin on 12.03.15.
//  Copyright (c) 2015 Anna Havrylyuk. All rights reserved.
//

#import "ArticlesListViewController.h"
#import "ArticleTableViewCell.h"

@interface ArticlesListViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *categoriesControl;
- (IBAction)changeSelectedCategory:(UISegmentedControl *)sender;

@property (weak, nonatomic) IBOutlet UIPageControl *subcategoriesControl;

@end

@implementation ArticlesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"Article"];
    return cell;
}

- (IBAction)changeSelectedCategory:(UISegmentedControl *)sender {
}
@end
