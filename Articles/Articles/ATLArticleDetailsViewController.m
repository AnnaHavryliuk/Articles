//
//  ATLArticleDetailsViewController.m
//  Articles
//
//  Created by Admin on 12.03.15.
//  Copyright (c) 2015 Anna Havrylyuk. All rights reserved.
//

#import "ATLArticleDetailsViewController.h"
#import "ATLDatabaseManager.h"
#import "ATLArticle.h"
#import "ATLArticleCategory.h"
#import "ATLArticleTableViewCell.h"

@interface ATLArticleDetailsViewController ()

@property (strong, nonatomic) ATLDatabaseManager *articlesManager;
@property (weak, nonatomic) IBOutlet UITableView *articleInfo;
@property (weak, nonatomic) IBOutlet UITextView *articleSubtitle;
@property (weak, nonatomic) IBOutlet UIWebView *articleContent;

@end

@implementation ATLArticleDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.articlesManager = [ATLDatabaseManager sharedManager];
    self.articleSubtitle.text = [self.articlesManager.selectedArticle subtitle];
    [self.articleContent loadHTMLString:[self.articlesManager.selectedArticle content] baseURL:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ATLArticle *article = self.articlesManager.selectedArticle;
    ATLArticleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"TitleAuthorDate"];
    cell.articleTitle.text = article.title;
    NSDateFormatter *formatterOfDate = [[NSDateFormatter alloc] init];
    formatterOfDate.dateFormat = @"dd.MM.yyyy";
    NSMutableString *text = [NSMutableString stringWithString:[formatterOfDate stringFromDate:article.date]];
    if(article.author)
    {
        [text appendFormat:@" %@", article.author];
    }
    cell.articleSubtitle.text = text;
    cell.articleImage.image = [UIImage imageWithData:article.image];
    return cell;
}

- (IBAction)goToNextArticle:(UISwipeGestureRecognizer *)sender
{
//    if ([self.articlesControl currentPage] < [self.articlesControl numberOfPages]-1)
//    {
//        ++self.articlesControl.currentPage;
//        NSInteger selectedPage = [self.articlesControl currentPage];
//        self.articlesManager.selectedArticle = [[[self.articlesManager.selectedSubcategory articles] allObjects] objectAtIndex:selectedPage];
//        [self.articleInfo reloadData];
//        self.articleSubtitle.text = [self.articlesManager.selectedArticle subtitle];
//        [self.articleContent loadHTMLString:[self.articlesManager.selectedArticle content] baseURL:nil];
//    }
}

- (IBAction)goToPreviousArticle:(UISwipeGestureRecognizer *)sender
{
//    if (self.articlesControl.currentPage > 0)
//    {
//        --self.articlesControl.currentPage;
//        NSInteger selectedPage = [self.articlesControl currentPage];
//        self.articlesManager.selectedArticle = [[[self.articlesManager.selectedSubcategory articles] allObjects] objectAtIndex:selectedPage];
//        [self.articleInfo reloadData];
//        self.articleSubtitle.text = [self.articlesManager.selectedArticle subtitle];
//        [self.articleContent loadHTMLString:[self.articlesManager.selectedArticle content] baseURL:nil];
//    }
}


@end
