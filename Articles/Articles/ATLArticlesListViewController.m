//
//  ViewController.m
//  Articles
//
//  Created by Admin on 12.03.15.
//  Copyright (c) 2015 Anna Havrylyuk. All rights reserved.
//

#import "ATLArticlesListViewController.h"
#import "ATLArticle.h"
#import "ATLArticleCategory.h"
#import "ATLArticleTableViewCell.h"

@interface ATLArticlesListViewController ()

@property (strong, nonatomic) ATLDatabaseManager *articlesManager;
@property (strong, nonatomic) NSArray *filteredArticles;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mainCategoriesControl;
@property (weak, nonatomic) IBOutlet UILabel *subcategoryName;
@property (weak, nonatomic) IBOutlet UITableView *tableOfArticles;
@property (weak, nonatomic) IBOutlet UIPageControl *subcategoriesControl;

- (IBAction)changeSelectedMainCategory:(UISegmentedControl *)sender;
- (IBAction)goToNextSubcategory:(UISwipeGestureRecognizer *)sender;
- (IBAction)goToPreviousSubcategory:(UISwipeGestureRecognizer *)sender;

@end

@implementation ATLArticlesListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.articlesManager = [ATLDatabaseManager sharedManager];
    self.articlesManager.delegate = self;
    self.filteredArticles = [[NSArray alloc] init];
    [self.articlesManager receiveAllArticlesWithcompletionHandler:^(BOOL success) {
        self.filteredArticles = self.articlesManager.selectedSubcategory.articles.allObjects;
        self.subcategoryName.text = self.articlesManager.selectedSubcategory.name;
        self.subcategoriesControl.numberOfPages = self.articlesManager.subcategories.count;
        [self.tableOfArticles reloadData];
    }];
    [self.tableOfArticles setSeparatorInset:UIEdgeInsetsZero];
    [self.tableOfArticles setLayoutMargins:UIEdgeInsetsZero];
}

#pragma mark - ATLReloadArticlesDataDelegate methods

- (void)reloadArticlesTableData
{
    [self.tableOfArticles reloadData];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filteredArticles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ATLArticleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"Article"];
    ATLArticle *article = [self.filteredArticles objectAtIndex:indexPath.row];
    cell.articleTitle.text = article.title;
    cell.articleSubtitle.text = article.subtitle;
    cell.articleImage.image = [UIImage imageWithData:article.image];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ATLArticle *selectedArticle = [self.filteredArticles objectAtIndex:indexPath.row];
    self.articlesManager.selectedArticle = selectedArticle;
}

#pragma mark - UISegmentedControl: segment value changed method

- (IBAction)changeSelectedMainCategory:(UISegmentedControl *)sender
{
    [self.articlesManager changeSubcategories:sender.selectedSegmentIndex];
    self.filteredArticles = self.articlesManager.selectedSubcategory.articles.allObjects;
    self.subcategoryName.text = self.articlesManager.selectedSubcategory.name;
    self.subcategoriesControl.numberOfPages = self.articlesManager.subcategories.count;
    self.subcategoriesControl.currentPage = 0;
    [self.tableOfArticles reloadData];
}

#pragma mark - Swipe methods

- (IBAction)goToNextSubcategory:(UISwipeGestureRecognizer *)sender
{
    if (self.subcategoriesControl.currentPage < self.subcategoriesControl.numberOfPages-1)
    {
        ++self.subcategoriesControl.currentPage;
        NSInteger selectedPage = self.subcategoriesControl.currentPage;
        self.articlesManager.selectedSubcategory = [self.articlesManager.subcategories objectAtIndex:selectedPage];
        self.filteredArticles = self.articlesManager.selectedSubcategory.articles.allObjects;
        self.subcategoryName.text = self.articlesManager.selectedSubcategory.name;
        [self.tableOfArticles reloadData];
    }
}

- (IBAction)goToPreviousSubcategory:(UISwipeGestureRecognizer *)sender
{
    if (self.subcategoriesControl.currentPage > 0)
    {
        --self.subcategoriesControl.currentPage;
        NSInteger selectedPage = self.subcategoriesControl.currentPage;
        self.articlesManager.selectedSubcategory = [self.articlesManager.subcategories objectAtIndex:selectedPage];
        self.filteredArticles = self.articlesManager.selectedSubcategory.articles.allObjects;
        self.subcategoryName.text = self.articlesManager.selectedSubcategory.name;
        [self.tableOfArticles reloadData];
    }
}

@end
