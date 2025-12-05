//
//  AdViewModel.m
//  ToBidDemoOC
//
//  Created by Codi on 2025/10/27.
//

#import "AdViewModel.h"

@implementation AdViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.adMap = [NSMutableDictionary dictionary];
    }
    return self;
}

@end
