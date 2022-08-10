//
//  main.m
//  JADYun
//
//  Created by shuaishuai0814 on 07/15/2020.
//  Copyright (c) 2020 shuaishuai0814. All rights reserved.
//

#import "JADAppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([JADAppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
