//
//  ProveedoresTableViewController.h
//  GHFINCAS
//
//  Created by Jose Ramon MBP on 02/02/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProveedoresTableViewController : UITableViewController<UITableViewDataSource,UITableViewDataSource,NSURLConnectionDelegate>

{
    
     NSMutableData *_responseData;
}


@end
