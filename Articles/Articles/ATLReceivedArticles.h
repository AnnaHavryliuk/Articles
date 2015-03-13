//
//  ATLReceivedArticles.h
//  Articles
//
//  Created by Admin on 12.03.15.
//  Copyright (c) 2015 Anna Havrylyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATLArticle;

@interface ATLReceivedArticles : NSObject

@property (nonatomic, strong) NSMutableArray *allArticles;
@property (nonatomic, strong) ATLArticle *selectedArticle;

@end