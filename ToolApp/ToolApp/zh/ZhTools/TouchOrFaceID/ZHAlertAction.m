//
//  ZHAlertAction.m
//  ToucheIDORFaceID
//
//  Created by zhangzhihua-imac on 2019/11/20.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//

#import "ZHAlertAction.h"
#import <UIKit/UIKit.h>
#import "UIWindow+ZHExtension.h"

@implementation ZHAlertAction


+ (BOOL)isIosVersion8AndAfter{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ;
}

+ (void)showAlertWithTitle:(NSString*)title msg:(NSString*)message buttonsStatement:(NSArray<NSString*>*)arrayItems chooseBlock:(void (^)(NSInteger buttonIdx))block{
    
    NSMutableArray* argsArray = [[NSMutableArray alloc] initWithArray:arrayItems];
 
    
    if ( [ZHAlertAction isIosVersion8AndAfter])
    {
        //UIAlertController style
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        for (int i = 0; i < [argsArray count]; i++)
        {
            UIAlertActionStyle style =  (0 == i)? UIAlertActionStyleCancel: UIAlertActionStyleDefault;
            // Create the actions.
            UIAlertAction *action = [UIAlertAction actionWithTitle:[argsArray objectAtIndex:i] style:style handler:^(UIAlertAction *action) {
                if (block) {
                    block(i);
                }
            }];
            [alertController addAction:action];
        }
        
        [[ZHAlertAction getTopViewController] presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
}


+ (UIViewController*)getTopViewController{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    return window.currentViewController;
}



+ (void)showActionSheetWithTitle:(NSString*)title
                         message:(NSString*)message
               cancelButtonTitle:(NSString*)cancelString
          destructiveButtonTitle:(NSString*)destructiveButtonTitle
                otherButtonTitle:(NSArray<NSString*>*)otherButtonArray
                     chooseBlock:(void (^)(NSInteger buttonIdx))block{
    NSMutableArray* argsArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    
    if (cancelString) {
        [argsArray addObject:cancelString];
    }
    if (destructiveButtonTitle) {
        [argsArray addObject:destructiveButtonTitle];
    }
  
    [argsArray addObjectsFromArray:otherButtonArray];
        
    if ( [ZHAlertAction isIosVersion8AndAfter])
    {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        for (int i = 0; i < [argsArray count]; i++)
        {
            UIAlertActionStyle style =  (0 == i)? UIAlertActionStyleCancel: UIAlertActionStyleDefault;
            
            if (1==i && destructiveButtonTitle) {
                
                style = UIAlertActionStyleDestructive;
            }
            
            // Create the actions.
            UIAlertAction *action = [UIAlertAction actionWithTitle:[argsArray objectAtIndex:i] style:style handler:^(UIAlertAction *action) {
                if (block) {
                    block(i);
                }
            }];
            [alertController addAction:action];
        }
        
        [[ZHAlertAction getTopViewController] presentViewController:alertController animated:YES completion:nil];
        return;
    }
}


@end
