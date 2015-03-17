//
//  ViewController.h
//  Articles
//
//  Created by Admin on 12.03.15.
//  Copyright (c) 2015 Anna Havrylyuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATLDatabaseManager.h"

@interface ATLArticlesListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ReloadArticlesDataDelegate>

@end

