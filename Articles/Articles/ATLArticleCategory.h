//
//  ATLArticleCategory.h
//  Articles
//
//  Created by Admin on 14.03.15.
//  Copyright (c) 2015 Anna Havrylyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ATLArticle;

@interface ATLArticleCategory : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * ranking;
@property (nonatomic, retain) NSSet *articles;

+ (ATLArticleCategory *)createNewCategory:(NSDictionary *)data;
+ (NSArray *)fetchCategoriesFromDatabase:(NSPredicate *)predicate;
+ (void)deleteAllCategoriesFromDatabase;

@end

@interface ATLArticleCategory (CoreDataGeneratedAccessors)

- (void)addArticlesObject:(ATLArticle *)value;
- (void)removeArticlesObject:(ATLArticle *)value;
- (void)addArticles:(NSSet *)values;
- (void)removeArticles:(NSSet *)values;

@end
