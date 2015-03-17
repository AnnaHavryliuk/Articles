//
//  ATLReceivedArticles.m
//  Articles
//
//  Created by Admin on 12.03.15.
//  Copyright (c) 2015 Anna Havrylyuk. All rights reserved.
//

#import "ATLDatabaseManager.h"
#import "ATLArticle.h"
#import "ATLArticleCategory.h"

static ATLDatabaseManager *shared = nil;

@interface ATLDatabaseManager ()

@end

@implementation ATLDatabaseManager

+ (ATLDatabaseManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super allocWithZone:NULL] init];
    });
    return shared;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return shared;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _subcategories = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)receiveAllArticlesWithcompletionHandler:(void(^)(BOOL))handler
{
    NSURL *categoriesUrl = [NSURL URLWithString:@"http://figaro.service.yagasp.com/article/categories"];
    NSURLRequest *categoriesRequest = [NSURLRequest requestWithURL:categoriesUrl];
    [NSURLConnection sendAsynchronousRequest:categoriesRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length > 0 && !connectionError)
        {
            [ATLArticleCategory deleteAllCategoriesFromDatabase];
            NSArray *dataFromUrl = [NSArray arrayWithArray:[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]];
            for (NSDictionary *receivedCategories in  dataFromUrl)
            {
                for (NSDictionary *receivedcategory in [receivedCategories objectForKey:@"subcategories"])
                {
                    ATLArticleCategory *category = [ATLArticleCategory createNewCategory:receivedcategory];
                    if ([category.ranking doubleValue] >= 100 && [category.ranking doubleValue] < 200)
                    {
                        [self.subcategories addObject:category];
                    }
                    [self receiveArticlesByCategory:category WithComplitonHandler:^(BOOL success) {
                        if (category == self.selectedSubcategory)
                        {
                            handler(success);
                        }
                    }];
                }
            }
            self.selectedSubcategory = [self.subcategories objectAtIndex:0];
        }
        else
        {
            [self changeSubcategories:0];
            handler(NO);
        }
    }];
}

- (void)receiveArticlesByCategory:(ATLArticleCategory *)category WithComplitonHandler:(void(^)(BOOL))handler;
{
    NSString *stringForUrl = [NSString stringWithFormat:@"http://figaro.service.yagasp.com/article/header/%@", category.identifier];
    NSURL *articlesUrl = [NSURL URLWithString:stringForUrl];
    NSURLRequest *articlesRequest = [NSURLRequest requestWithURL:articlesUrl];
    [NSURLConnection sendAsynchronousRequest:articlesRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length > 0 && !connectionError)
        {
            NSArray *dataFromUrl = [NSArray arrayWithArray:[[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL] objectAtIndex:1]];
            for (NSDictionary *receivedArticle in dataFromUrl)
            {
                ATLArticle *article = [ATLArticle createNewArticle:receivedArticle OfCategory:category];
                [self receiveImageOfArticle:article ByUrl:[[receivedArticle objectForKey:@"thumb"] objectForKey:@"link"]];
                handler(YES);
                [self receiveDetailsOfArticle:article];
            }
        }
    }];
}

- (void) receiveDetailsOfArticle:(ATLArticle *)article
{
    NSString *stringForUrl = [NSString stringWithFormat:@"http://figaro.service.yagasp.com/article/%@", article.identifier];
    NSURL *detailsUrl = [NSURL URLWithString:stringForUrl];
    NSURLRequest *detailsRequest = [NSURLRequest requestWithURL:detailsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    [NSURLConnection sendAsynchronousRequest:detailsRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length > 0 && !connectionError)
        {
            NSDictionary *dataFromUrl = [NSDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]];
            if([[dataFromUrl objectForKey:@"author"] isKindOfClass:[NSString class]])
            {
                article.author = [dataFromUrl objectForKey:@"author"];
            }
            NSMutableString *content = [NSMutableString stringWithFormat:@"<html><body>%@</body></html>", [dataFromUrl objectForKey:@"content"]];
            NSRange videoRange = [content rangeOfString:@"<video md5=\"" options:NSLiteralSearch];
            while (videoRange.location != NSNotFound)
            {
                videoRange.length += 37;
                [content deleteCharactersInRange:videoRange];
                videoRange = [content rangeOfString:@"<video md5=\"" options:NSLiteralSearch];
            }
            article.content = content;
        }
    }];
}

- (void)receiveImageOfArticle:(ATLArticle *)article ByUrl:(NSString *)url
{
    NSString *stringForUrl = [url stringByReplacingOccurrencesOfString:@"%dx%d" withString:@"300x300"];
    NSURL *imageUrl = [NSURL URLWithString:stringForUrl];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:imageUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    [NSURLConnection sendAsynchronousRequest:imageRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length > 0 && !connectionError)
        {
            article.image = data;
            [self.delegate reloadArticlesTableData];
        }
    }];
}

- (void) changeSubcategories:(NSInteger)index
{
    NSNumber *minimumRanking = [NSNumber numberWithInteger:(index+1)*100];
    NSNumber *maximumRanking = [NSNumber numberWithInteger:(index+2)*100];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ranking >= %@) && (ranking < %@)", minimumRanking, maximumRanking];
    _subcategories = [NSMutableArray arrayWithArray:[ATLArticleCategory fetchCategoriesFromDatabase:predicate]];
    self.selectedSubcategory = [self.subcategories objectAtIndex:0];
}

@end
