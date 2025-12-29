//
//  XLFormBaseViewController.h
//  WindmillSample
//
//  Created by Codi on 2021/12/9.
//

#import <XLForm/XLForm.h>

static NSString * const kDropdownListView = @"kDropdownListView";

@interface XLFormBaseViewController : XLFormViewController

- (XLFormSectionDescriptor *)dropdownSection:(NSArray *)dataSource;

- (NSString *)getSelectPlacementId;

- (void)clearRowState:(NSArray *)datasource;

- (void)updateFromRowDisableWithTag:(NSString *)tag error:(NSError *)error;

@end
