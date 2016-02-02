//
//  ComunidadViewController.h
//  GHFINCAS
//
//  Created by jose ramon delgado on 30/01/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import <UIKit/UIKit.h>
//para la circularProgress:

#import "KVNProgress.h"

@interface ComunidadViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webview;

//para la circularProgress:
@property (nonatomic) KVNProgressConfiguration *basicConfiguration;

@end
