//
//  ViewController.m
//  EverlyticPushDevApp
//
//  Created by Jason Dantuma on 2019/06/18.
//  Copyright © 2019 Everlytic. All rights reserved.
//

#import "ViewController.h"
#import <EverlyticPush/EverlyticPush.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)subscribeUser:(id)sender {
    [EverlyticPush subscribeUserWithEmail:_emailAddress.text completionHandler:nil];
}

@end
