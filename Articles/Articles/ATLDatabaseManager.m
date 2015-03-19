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
#import "ATLAppDelegate.h"

static ATLDatabaseManager *shared = nil;

@interface ATLDatabaseManager ()

@property (readonly, strong, nonatomic) NSManagedObjectContext *context;

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
        ATLAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _context = [appDelegate managedObjectContext];
    }
    return self;
}

- (void)changeSubcategories:(NSInteger)index
{
    NSNumber *minimumRanking = [NSNumber numberWithInteger:(index+1)*100];
    NSNumber *maximumRanking = [NSNumber numberWithInteger:(index+2)*100];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ranking >= %@) && (ranking < %@)", minimumRanking, maximumRanking];
    NSArray *fetchedResults = [ATLArticleCategory fetchCategoriesFromDatabase:predicate];
    id mySort = ^(ATLArticle *object1, ATLArticle *object2){
        NSNumber *first = object1.ranking;
        NSNumber *second = object2.ranking;
        if ([first integerValue] > [second integerValue])
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([first integerValue] < [second integerValue])
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    self.subcategories = [[fetchedResults sortedArrayUsingComparator:mySort] mutableCopy];
    self.selectedSubcategory = [self.subcategories objectAtIndex:0];
}

#pragma mark - Methods of receiving all articles from server and saving in DB

- (void)receiveAllArticlesWithcompletionHandler:(void(^)(BOOL))handler
{
    NSURL *categoriesUrl = [NSURL URLWithString:@"http://figaro.service.yagasp.com/article/categories"];
    NSURLRequest *categoriesRequest = [NSURLRequest requestWithURL:categoriesUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:3.0];
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
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else
        {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
            {
                [self changeSubcategories:0];
            }
            handler(NO);
        }
    }];
}

- (void)receiveArticlesByCategory:(ATLArticleCategory *)category WithComplitonHandler:(void(^)(BOOL))handler;
{
    NSString *stringForUrl = [NSString stringWithFormat:@"http://figaro.service.yagasp.com/article/header/%@", category.identifier];
    NSURL *articlesUrl = [NSURL URLWithString:stringForUrl];
    NSURLRequest *articlesRequest = [NSURLRequest requestWithURL:articlesUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:3.0];
    [NSURLConnection sendAsynchronousRequest:articlesRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length > 0 && !connectionError)
        {
            NSArray *dataFromUrl = [NSArray arrayWithArray:[[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL] objectAtIndex:1]];
            for (NSDictionary *receivedArticle in dataFromUrl)
            {
                ATLArticle *article = [ATLArticle createNewArticle:receivedArticle OfCategory:category];
                handler(YES);
                [self receiveImageOfArticle:article ByUrl:[[receivedArticle objectForKey:@"thumb"] objectForKey:@"link"]];
                [self receiveDetailsOfArticle:article];
            }
        }
    }];
}

- (void) receiveDetailsOfArticle:(ATLArticle *)article
{
    NSString *stringForUrl = [NSString stringWithFormat:@"http://figaro.service.yagasp.com/article/%@", article.identifier];
    NSURL *detailsUrl = [NSURL URLWithString:stringForUrl];
    NSURLRequest *detailsRequest = [NSURLRequest requestWithURL:detailsUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:100.0];
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
                videoRange.length += 36;
                [content deleteCharactersInRange:videoRange];
                videoRange = [content rangeOfString:@"<video md5=\"" options:NSLiteralSearch];
            }
            videoRange = [content rangeOfString:@"<br />" options:NSLiteralSearch];
            while (videoRange.location != NSNotFound)
            {
                [content deleteCharactersInRange:videoRange];
                videoRange = [content rangeOfString:@"<br />" options:NSLiteralSearch];
            }
            article.content = content;
            NSError *error;
            [self.context save:&error];
        }
    }];
}

- (void)receiveImageOfArticle:(ATLArticle *)article ByUrl:(NSString *)url
{
    NSString *stringForUrl = [url stringByReplacingOccurrencesOfString:@"%dx%d" withString:@"300x200"];
    NSURL *imageUrl = [NSURL URLWithString:stringForUrl];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:imageUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:120.0];
    [NSURLConnection sendAsynchronousRequest:imageRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length > 0 && !connectionError)
        {
            article.image = data;
            [self.delegate reloadArticlesTableData];
            NSError *error;
            [self.context save:&error];
        }
    }];
}

@end
