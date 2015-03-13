//
//  ATLCategoryOfArticles.h
//  Articles
//
//  Created by Admin on 12.03.15.
//  Copyright (c) 2015 Anna Havrylyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATLCategoryOfArticles : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *ranking;
@property (nonatomic) BOOL *isMainCategory;
@property (nonatomic, strong) NSMutableArray *articles;

@end
