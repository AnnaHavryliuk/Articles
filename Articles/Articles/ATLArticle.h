//
//  ATLArticle.h
//  Articles
//
//  Created by Admin on 12.03.15.
//  Copyright (c) 2015 Anna Havrylyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATLArticle : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSData *image;
@property (nonatomic, strong) NSString *text;

@end
