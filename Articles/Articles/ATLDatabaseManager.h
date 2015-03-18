//
//  ATLReceivedArticles.h
//  Articles
//
//  Created by Admin on 12.03.15.
//  Copyright (c) 2015 Anna Havrylyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ReloadArticlesDataDelegate <NSObject>

- (void)reloadArticlesTableData;

@end

@class ATLArticleCategory;
@class ATLArticle;

@interface ATLDatabaseManager : NSObject

@property (strong, nonatomic) NSMutableArray *subcategories;
@property (strong, nonatomic) ATLArticleCategory *selectedSubcategory;
@property (strong, nonatomic) ATLArticle *selectedArticle;
@property (weak, nonatomic) id<ReloadArticlesDataDelegate>delegate;

+ (ATLDatabaseManager *)sharedManager;
- (void)receiveAllArticlesWithcompletionHandler:(void(^)(BOOL))handler;
- (void) changeSubcategories:(NSInteger)index;

@end