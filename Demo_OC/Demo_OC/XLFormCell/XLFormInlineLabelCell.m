//
//  XLFormInlineLabelCell.m
//  WindmillSample
//
//  Created by Codi on 2021/12/8.
//

#import "XLFormInlineLabelCell.h"
#import <Masonry/Masonry.h>
#import <UIView+Toast.h>

NSString * const XLFormRowDescriptorTypeLabelInline = @"XLFormRowDescriptorTypeLabelInline";
NSString * const XLFormRowDescriptorTypeLabelControl = @"XLFormRowDescriptorTypeLabelControl";

@implementation XLFormInlineLabelCell

+ (void)load {
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[XLFormInlineLabelCell class] forKey:XLFormRowDescriptorTypeLabelInline];
    [XLFormViewController.inlineRowDescriptorTypesForRowDescriptorTypes setObject:XLFormRowDescriptorTypeLabelControl forKey:XLFormRowDescriptorTypeLabelInline];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (BOOL)becomeFirstResponder {
    if (self.isFirstResponder){
        return [super becomeFirstResponder];
    }
    BOOL result = [super becomeFirstResponder];
    if (result){
        XLFormRowDescriptor * inlineRowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:[XLFormViewController inlineRowDescriptorTypesForRowDescriptorTypes][self.rowDescriptor.rowType]];
        UITableViewCell<XLFormDescriptorCell> * cell = [inlineRowDescriptor cellForFormController:self.formViewController];
        NSAssert([cell conformsToProtocol:@protocol(XLFormInlineRowDescriptorCell)], @"inline cell must conform to XLFormInlineRowDescriptorCell");
        UITableViewCell<XLFormInlineRowDescriptorCell> * inlineCell = (UITableViewCell<XLFormInlineRowDescriptorCell> *)cell;
        inlineCell.inlineRowDescriptor = self.rowDescriptor;
        [self.rowDescriptor.sectionDescriptor addFormRow:inlineRowDescriptor afterRow:self.rowDescriptor];
        [self.formViewController ensureRowIsVisible:inlineRowDescriptor];
    }
    return result;
}

- (BOOL)resignFirstResponder {
    if (![self isFirstResponder]) {
        return [super resignFirstResponder];
    }
    NSIndexPath * selectedRowPath = [self.formViewController.form indexPathOfFormRow:self.rowDescriptor];
    NSIndexPath * nextRowPath = [NSIndexPath indexPathForRow:selectedRowPath.row + 1 inSection:selectedRowPath.section];
    XLFormRowDescriptor * nextFormRow = [self.formViewController.form formRowAtIndex:nextRowPath];
    XLFormSectionDescriptor * formSection = [self.formViewController.form.formSections objectAtIndex:nextRowPath.section];
    BOOL result = [super resignFirstResponder];
    if (result) {
        [formSection removeFormRow:nextFormRow];
    }
    return result;
}

#pragma mark - XLFormDescriptorCell
- (void)configure {
    [super configure];
}

- (void)update {
    [super update];
    if (self.rowDescriptor.isDisabled) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.editingAccessoryType = UITableViewCellAccessoryNone;
    }else {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [self.textLabel setText:self.rowDescriptor.title];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.detailTextLabel.text = [self valueDisplayText];
}

- (BOOL)formDescriptorCellCanBecomeFirstResponder {
    return !(self.rowDescriptor.isDisabled);
}

- (BOOL)formDescriptorCellBecomeFirstResponder {
    if ([self isFirstResponder]){
        [self resignFirstResponder];
        return NO;
    }
    return [self becomeFirstResponder];
}

- (void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller {
    [controller.tableView deselectRowAtIndexPath:[controller.form indexPathOfFormRow:self.rowDescriptor] animated:YES];
}

#pragma mark - Helpers
- (NSString *)valueDisplayText {
    return (self.rowDescriptor.value ? [self.rowDescriptor.value displayText] : self.rowDescriptor.noValueDisplayText);
}

@end

@interface XLFormInlineLabelControl()
@property(nonatomic, strong)UIButton *buttonFoCopy;
@end

@implementation XLFormInlineLabelControl

@synthesize descLabel = _descLabel;
@synthesize inlineRowDescriptor = _inlineRowDescriptor;
+ (void)load {
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[XLFormInlineLabelControl class] forKey:XLFormRowDescriptorTypeLabelControl];
}

- (void)configure {
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [self.contentView addSubview:self.descLabel];
    [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    _buttonFoCopy = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonFoCopy.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_buttonFoCopy];
    _buttonFoCopy.layer.borderColor = [UIColor orangeColor].CGColor;
    _buttonFoCopy.layer.borderWidth = 1;
    _buttonFoCopy.layer.cornerRadius = 5;
    [_buttonFoCopy mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-5);
        make.width.equalTo(@40);
        make.height.equalTo(@15);
        make.top.equalTo(@0);
    }];
    [_buttonFoCopy setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_buttonFoCopy setTitle:@"copy" forState: UIControlStateNormal];
    [_buttonFoCopy addTarget:self action:@selector(copyAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)update {
    [super update];
    self.descLabel.enabled = !self.rowDescriptor.isDisabled;
    XLFormRowDescriptor * formRow = self.inlineRowDescriptor ?: self.rowDescriptor;
    NSArray *options = formRow.selectorOptions;
    NSString *msg = [options componentsJoinedByString:@"\n"];
    self.descLabel.text = msg;
    DDLogDebug(@"%@", formRow);
}

- (void)copyAction: (UITapGestureRecognizer *)doubleTap {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.descLabel.text;
    [self makeToast:@"复制成功"];
}


- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [UILabel new];
        _descLabel.font = [UIFont systemFontOfSize:15];
        _descLabel.numberOfLines = 0;
        _descLabel.backgroundColor = UIColor.clearColor;
    }
    return _descLabel;
}

@end
