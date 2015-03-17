//
//  ATLArticle.h
//  Articles
//
//  Created by Admin on 14.03.15.
//  Copyright (c) 2015 Anna Havrylyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ATLArticleCategory;

@interface ATLArticle : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSManagedObject *category;

+ (ATLArticle *)createNewArticle:(NSDictionary *)data OfCategory:(ATLArticleCategory *)category;

@end
