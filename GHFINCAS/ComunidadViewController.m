//
//  ComunidadViewController.m
//  GHFINCAS
//
//  Created by jose ramon delgado on 30/01/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import "ComunidadViewController.h"
//para la circularProgress:

#import "KVNProgress.h"


@interface ComunidadViewController ()

@end

@implementation ComunidadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //Creasmos el KVNPorgress
    
    self.basicConfiguration = [KVNProgressConfiguration defaultConfiguration];
    
    
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.ghfincas.es/oficina-virtual"]];
    
    [request setTimeoutInterval:6];
    
    
    
    
    
    self.webview.delegate=self;
    
    [self.webview loadRequest:request];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    
    //emepzamos la animacion
    
    [KVNProgress showProgress:0.0f
                       status:@"Loading with progress..."];
    self.basicConfiguration.backgroundType = KVNProgressBackgroundTypeSolid;
    
    [KVNProgress showWithStatus:@"Accediendo servidor seguro GHFINCAS.."];

    
    
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
    
     //paramos la animacion
    [KVNProgress dismiss];
    
    self.basicConfiguration.backgroundType = KVNProgressBackgroundTypeBlurred;
    
    
    
}

@end
