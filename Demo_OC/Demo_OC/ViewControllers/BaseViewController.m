//
//  BaseViewController.m
//  ToBidDemoOC
//
//  Created by Codi on 2025/10/24.
//

#import "BaseViewController.h"
#import "WindmillDropdownListView.h"
#import "XLFormDropdownCell.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = NSStringFromClass(self.class);
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (NSString *)getSelectPlacementId {
    XLFormRowDescriptor *row = [self.form formRowWithTag:kDropdownListView];
    DropdownListItem *item = row.value;
    return item.itemId;
}

- (XLFormSectionDescriptor *)dropdownSection:(NSArray *)dataSource {
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:@"Dropdown"];
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:kDropdownListView rowType:XLFormRowDescriptorTypeDropdown title:@"广告网络"];
    row.selectorOptions = dataSource;
    [section addFormRow:row];
    return section;
}


@end
