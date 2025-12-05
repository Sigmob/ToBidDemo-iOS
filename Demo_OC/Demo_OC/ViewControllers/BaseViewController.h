//
//  BaseViewController.h
//  ToBidDemoOC
//
//  Created by Codi on 2025/10/24.
//

#import <UIKit/UIKit.h>
#import <XLForm/XLForm.h>

static NSString * const kDropdownListView = @"kDropdownListView";

@interface BaseViewController : XLFormViewController

- (NSString *)getSelectPlacementId;

- (XLFormSectionDescriptor *)dropdownSection:(NSArray *)dataSource;

@end
