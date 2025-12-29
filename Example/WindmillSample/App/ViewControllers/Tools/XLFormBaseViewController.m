//
//  XLFormBaseViewController.m
//  WindmillSample
//
//  Created by Codi on 2021/12/9.
//

#import "XLFormBaseViewController.h"
#import "WindmillDropdownListView.h"
#import "XLFormDropdownCell.h"


@interface XLFormBaseViewController ()

@end

@implementation XLFormBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSString *)getSelectPlacementId {
    XLFormRowDescriptor *row = [self.form formRowWithTag:kDropdownListView];
    DropdownListItem *item = row.value;
    return item.itemId;
}

- (void)updateFromRowDisableWithTag:(NSString *)tag error:(NSError *)error {
    XLFormRowDescriptor *row = [self.form formRowWithTag:tag];
    row.disabled = @NO;
    if (error) {
        NSString *code = [NSString stringWithFormat:@"code: %ld", (long)error.code];
        NSString *msg = [NSString stringWithFormat:@"message: %@", error.localizedDescription];
        row.selectorOptions = @[code, msg];
    }else {
        row.selectorOptions = @[@"error = nil"];
    }
    [self updateFormRow:row];
}

- (void)clearRowState:(NSArray *)datasource {
    for (NSDictionary *item in datasource) {
        XLFormRowDescriptor *row = [self.form formRowWithTag:item[@"tag"]];
        row.disabled = @YES;
        [self updateFormRow:row];
    }
}

- (XLFormSectionDescriptor *)dropdownSection:(NSArray *)dataSource {
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:@"Dropdown"];
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:kDropdownListView rowType:XLFormRowDescriptorTypeDropdown title:@"广告网络"];
    row.selectorOptions = dataSource;
    [section addFormRow:row];
    return section;
}


@end
