//
//  SettingTableViewContoller.m
//  Where money run
//
//  Created by Ohlulu on 2017/6/14.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "SettingTableViewContoller.h"
#import "CategoryAddViewController.h"
#import "SelectedTiemViewController.h"
#import "OHMoneyRunContent.h"
#import <UserNotifications/UserNotifications.h>

@interface SettingTableViewContoller () <SelectedTiemViewControllerDelegate,UNUserNotificationCenterDelegate>
{
    NSUserDefaults *defaults;
    NSDateFormatter *df;
    UIColor *theTintColor;
    UNUserNotificationCenter *center;
    
}

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *notifySwitch;

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *openNotifyLabel;
@property (weak, nonatomic) IBOutlet UILabel *notifyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedBackLabel;
@property (weak, nonatomic) IBOutlet UILabel *evaluationLabel;


@end

@implementation SettingTableViewContoller


- (void)viewDidLoad {
    [super viewDidLoad];
    
    theTintColor = OHSettingViewBackgroundColor;
    
    self.view.backgroundColor = theTintColor;
    self.view.tintColor = OHSystemBrownColor;
    
    center = [UNUserNotificationCenter currentNotificationCenter];
    
    // mutiple language
    self.categoryLabel.text = NSLocalizedString(@"category", @"類別管理");
    self.openNotifyLabel.text = NSLocalizedString(@"open", @"open");
    self.notifyTimeLabel.text = NSLocalizedString(@"notifyTime", @"notifyTime");
    self.shareLabel.text = NSLocalizedString(@"share", @"");
    self.feedBackLabel.text = NSLocalizedString(@"feedback", @"");
    self.evaluationLabel.text = NSLocalizedString(@"evaluation", @"");
    
    // Date formatter
    df = [NSDateFormatter new];
    [df setDateFormat:@"HH:mm"];
    
    // UserDefaults
    defaults = [NSUserDefaults standardUserDefaults];
    
    // Navigation Bar
    self.navigationItem.title = NSLocalizedString(@"setting", @"set");
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.backgroundColor = OHCalendarGrayWhiteColor;
    self.navigationController.navigationBar.tintColor = OHSystemBrownColor;
    self.navigationController.navigationBar.clipsToBounds = NO;
    self.navigationController.navigationBar.layer.shadowColor = [UIColor grayColor].CGColor;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 2);
    self.navigationController.navigationBar.layer.shadowOpacity = 0.87f;
    
    // Navigation Itme
    UIBarButtonItem * okButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tick"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonClivk)];
    self.navigationItem.rightBarButtonItem = okButton;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    // TabBar Hidden
    self.tabBarController.tabBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_ADDBUTTON_NOTIFICATION object:nil];

    // Hidde cell
    NSLog(@"%d", [defaults boolForKey:hasNotify]);
    if (![defaults boolForKey:hasNotify]) {
        // No notify
        [self hiddenNotifyCell];
        [self.notifySwitch setOn:NO];
    } else {
        // Have notify
        [self showNotifyCell];
        [self.notifySwitch setOn:YES];
    }
    
    // set notify cell's time label
    NSDate *notifyTime = [defaults objectForKey:notityTime];
    self.timeLabel.text = [df stringFromDate:notifyTime];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.layer.cornerRadius = 15.0f;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = OHCalendarWhiteColor;
    
//    [cell.contentView.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        obj.active = NO;
//    }];
    cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView.leadingAnchor constraintEqualToAnchor:cell.leadingAnchor constant:16].active = YES;
    [cell.contentView.topAnchor constraintEqualToAnchor:cell.topAnchor constant:2].active = YES;
    [cell.contentView.trailingAnchor constraintEqualToAnchor:cell.trailingAnchor constant:-16].active = YES;
    [cell.contentView.bottomAnchor constraintEqualToAnchor:cell.bottomAnchor constant:-2].active = YES;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 16)];
    view.backgroundColor = [UIColor clearColor];
    
    switch (section) {
        case 0:
            
            break;
        case 1:
        {
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 100, 28)];
            title.text = NSLocalizedString(@"notify", @"");
            [view addSubview:title];
            break;
        }
        case 2:
        {
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 100, 28)];
            title.text = NSLocalizedString(@"about", @"");
            [view addSubview:title];
            break;
        }
        default:
            break;
    }
    
    return view;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 8)];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 1:
                [self presentTimePickerViewController];
                break;
            default:
                break;
        }
        
    } else if (indexPath.section == 2) {
        
        switch (indexPath.row) {
            case 0:
                [self shareMoneyRun];
                break;
            case 1:
                [self openFaceBookFanPage];
                break;
            case  2:
                [self rateMoneyRun];
            default:
                break;
        }
        
    }
    
    
    
}

#pragma mark - SelectedTiemViewControllerDelegate

- (void)didSelectedTime:(NSDate *)date {
    
    [defaults setObject:date forKey:notityTime];
    [defaults synchronize];
    NSLog(@"defaukts date %@",[defaults objectForKey:notityTime]);
    [self addLoacleNotificationIn:date];
    self.timeLabel.text = [df stringFromDate:date];
}


#pragma mark - Cell's Action

- (void) doneButtonClivk {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)notifySwitchDidChange:(UISwitch *)sender {
    
    if (sender.isOn) {
        [defaults setBool:YES forKey:hasNotify];
        [self registrationNotification];
        [self showNotifyCell];
    } else {
        [defaults setBool:NO forKey:hasNotify];
        [self removeNotification];
        [self hiddenNotifyCell];
    }
    // Save userdefaults right now
    [defaults synchronize];
    
}

- (void) openFaceBookFanPage {
    
    NSURL *url = [NSURL URLWithString:@"fb://profile/572696802746736"];
    if ([[UIApplication sharedApplication] canOpenURL: url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
        url = [NSURL URLWithString:@"https://www.facebook.com/OhluluTW/"];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
    
}


- (void) shareMoneyRun {
    
//    itunes.apple.com/app/id1242869090
    UIActivityViewController *activeVC = [[UIActivityViewController alloc] initWithActivityItems:@[@"Money Run!理財必備!\n輕鬆簡單記錄，錢的流向。\nhttps://appsto.re/tw/I1kfkb.i"] applicationActivities:nil];
    [self presentViewController:activeVC animated:YES completion:nil];
    
}

- (void) rateMoneyRun {
    
    NSString *appID = @"1242869090";
    NSString *rateURL = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:rateURL] options:@{} completionHandler:nil];
    
}


- (void) presentTimePickerViewController {
    
    SelectedTiemViewController *timeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"selectTimeView"];
    timeVC.modalPresentationStyle = UIModalPresentationCustom;
    timeVC.delegate = self;
    
    [self presentViewController:timeVC animated:YES completion:^{
        timeVC.view.superview.backgroundColor = [UIColor clearColor];
    }];
}



#pragma mark - Custom Function

- (void) showNotifyCell {
    [super tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]].hidden = NO;

}

- (void) hiddenNotifyCell {
    [super tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]].hidden = YES;
}


#pragma mark - Locale Notification

- (void) registrationNotification {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10特有

        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 点击允许
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSDate *date = [defaults objectForKey:notityTime];
                    [self addLoacleNotificationIn:date];
                }];
            } else {
                // 点击不允许
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"請開啟通知中心" message:@"設定->錢呢->允許通知" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"我知道了!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [defaults setBool:NO forKey:hasNotify];
                    [defaults synchronize];
                    self.notifySwitch.on = NO;
                    [self hiddenNotifyCell];
                }];
                [alert addAction:doneAction];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
        }];
    }
    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
}

- (void) addLoacleNotificationIn:(NSDate *) date {
    
    // 1. Creat a notification
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Money Runn 的貼心提醒！";
    content.body = @"該記帳囉，不然錢又跑得無影無蹤。";
    content.badge = @1;

    // 2. Set sound
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    
    // 3. Set trigger
    NSDateComponents *triggerDate = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date];
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:YES];
    
//    UNTimeIntervalNotificationTrigger *triggerOne = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
    
    // 4. Set Notification Request
    NSString *requestIdentifer = @"fixed";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
    
    // 5. Add notitfication request to cenetr
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
    
}

- (void) removeNotification {

    [center removeAllPendingNotificationRequests];

}

#pragma mark - userNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSLog(@"didreceive");
    
    completionHandler();
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
