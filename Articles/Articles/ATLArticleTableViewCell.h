//
//  ArticleTableViewCell.h
//  Articles
//
//  Created by Admin on 12.03.15.
//  Copyright (c) 2015 Anna Havrylyuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATLArticleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@property (weak, nonatomic) IBOutlet UILabel *articleSubtitle;

@end
