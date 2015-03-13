//
//  ViewController.m
//  Articles
//
//  Created by Admin on 12.03.15.
//  Copyright (c) 2015 Anna Havrylyuk. All rights reserved.
//

#import "ATLArticlesListViewController.h"
#import "ATLArticleTableViewCell.h"

@interface ATLArticlesListViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *categoriesControl;
- (IBAction)changeSelectedCategory:(UISegmentedControl *)sender;

@property (weak, nonatomic) IBOutlet UIPageControl *subcategoriesControl;

@end

@implementation ATLArticlesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ATLArticleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"Article"];
    return cell;
}

- (IBAction)changeSelectedCategory:(UISegmentedControl *)sender {
}
@end
