//
//  ATLArticleDetailsViewController.m
//  Articles
//
//  Created by Admin on 12.03.15.
//  Copyright (c) 2015 Anna Havrylyuk. All rights reserved.
//

#import "ATLArticleDetailsViewController.h"

@interface ATLArticleDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@property (weak, nonatomic) IBOutlet UILabel *articleAuthor;
@property (weak, nonatomic) IBOutlet UILabel *articleDate;
@property (weak, nonatomic) IBOutlet UILabel *articleSubtitle;
@property (weak, nonatomic) IBOutlet UITextView *articleText;

@end

@implementation ATLArticleDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
