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
@property (weak, nonatomic) IBOutlet UITextView *textOutput;
@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)subscribeUser:(id)sender {
    [EverlyticPush subscribeUserWithEmail:_emailAddress.text completionHandler:nil];
    
    [self.view endEditing:YES];
}

- (IBAction)notificationHistory:(id)sender {
    [EverlyticPush notificationHistoryWithCompletionListener:^(NSArray<EverlyticNotification *> *notifications) {

        if ([notifications count] < 1) {
            NSLog(@"[SANDBOX APP][HISTORY] Notification history is empty");
        }

        for (EverlyticNotification *notification in notifications) {
            NSLog(@"[SANDBOX APP][HISTORY] %@", notification);
        }
    }];
}

@end
