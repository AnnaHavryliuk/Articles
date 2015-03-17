//
//  ATLArticleCategory.m
//  Articles
//
//  Created by Admin on 14.03.15.
//  Copyright (c) 2015 Anna Havrylyuk. All rights reserved.
//

#import "ATLArticleCategory.h"
#import "ATLArticle.h"
#import "ATLAppDelegate.h"

@implementation ATLArticleCategory

@dynamic identifier;
@dynamic name;
@dynamic ranking;
@dynamic articles;

+ (ATLArticleCategory *)createNewCategory:(NSDictionary *)data
{
    ATLAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    ATLArticleCategory *newCategory = [NSEntityDescription insertNewObjectForEntityForName:@"ATLArticleCategory"
                                                                    inManagedObjectContext:context];
    newCategory.identifier = [data objectForKey:@"id"];
    newCategory.name = [data objectForKey:@"name"];
    newCategory.ranking = [data objectForKey:@"ranking"];
    NSError *error;
    [context save:&error];
    return newCategory;
}

+ (NSArray *)fetchCategoriesFromDatabase:(NSPredicate *)predicate
{
    ATLAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest new];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"ATLArticleCategory"
                inManagedObjectContext:context];
    request.entity = entity;
    request.predicate = predicate;
    NSArray *temp = [context executeFetchRequest:request error:&error];
    return temp;

}

+ (void)deleteAllCategoriesFromDatabase
{
    ATLAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest new];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"ATLArticleCategory"
                inManagedObjectContext:context];
    request.entity = entity;
    NSArray *allCategories = [context executeFetchRequest:request error:&error];
    for (ATLArticleCategory *category in allCategories)
    {
        [context deleteObject:category];
    }
    [context save:&error];
}

@end
