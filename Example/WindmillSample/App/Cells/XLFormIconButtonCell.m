//
//  XLFormIconButtonCell.m
//  WindDemo
//
//  Created by Codi on 2021/6/7.
//

#import "XLFormIconButtonCell.h"

NSString * const XLFormRowDescriptorTypeIconButton = @"XLFormRowDescriptorTypeIconButton";

@interface XLFormIconButtonCell ()

@property(nonatomic) BOOL useTintColor;
@property (nonatomic, strong) NSString *iconName;

@end

@implementation XLFormIconButtonCell

+ (void)load {
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[XLFormIconButtonCell class] forKey:XLFormRowDescriptorTypeIconButton];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _useTintColor = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}



#pragma mark - XLFormDescriptorCell

-(void)configure
{
    [super configure];
}

-(void)update
{
    [super update];
    BOOL isDisabled = self.rowDescriptor.isDisabled;
    self.textLabel.text = self.rowDescriptor.title;
    BOOL simpleAction = !(self.rowDescriptor.action.viewControllerClass || [self.rowDescriptor.action.viewControllerStoryboardId length] != 0 || [self.rowDescriptor.action.viewControllerNibName length] != 0 || [self.rowDescriptor.action.formSegueIdentifier length] != 0 || self.rowDescriptor.action.formSegueClass);
    self.textLabel.textAlignment = !simpleAction ? NSTextAlignmentNatural : NSTextAlignmentCenter;
    self.accessoryType = simpleAction || isDisabled ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
    self.editingAccessoryType = self.accessoryType;
    self.selectionStyle = isDisabled ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
    if (self.iconName) {
        self.imageView.image = [UIImage imageNamed:self.iconName];
        CGSize itemSize = CGSizeMake(25, 25);
        UIGraphicsBeginImageContextWithOptions(itemSize,NO,UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
        [self.imageView.image drawInRect:imageRect];
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    if (simpleAction && _useTintColor){
        CGFloat red, green, blue, alpha;
        [self.tintColor getRed:&red green:&green blue:&blue alpha:&alpha];
        self.textLabel.textColor  = [UIColor colorWithRed:red green:green blue:blue alpha:(isDisabled ? 0.3 : 1.0)];
    }
    
    self.detailTextLabel.text = self.rowDescriptor.value;
}


-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller {
    if (self.rowDescriptor.action.formBlock){
        self.rowDescriptor.action.formBlock(self.rowDescriptor);
    }
    else if (self.rowDescriptor.action.formSelector){
        [controller performFormSelector:self.rowDescriptor.action.formSelector withObject:self.rowDescriptor];
    }
    else if ([self.rowDescriptor.action.formSegueIdentifier length] != 0){
        [controller performSegueWithIdentifier:self.rowDescriptor.action.formSegueIdentifier sender:self.rowDescriptor];
    }
    else if (self.rowDescriptor.action.formSegueClass){
        UIViewController * controllerToPresent = [self controllerToPresent];
        NSAssert(controllerToPresent, @"either rowDescriptor.action.viewControllerClass or rowDescriptor.action.viewControllerStoryboardId or rowDescriptor.action.viewControllerNibName must be assigned");
        UIStoryboardSegue * segue = [[self.rowDescriptor.action.formSegueClass alloc] initWithIdentifier:self.rowDescriptor.tag source:controller destination:controllerToPresent];
        [controller prepareForSegue:segue sender:self.rowDescriptor];
        [segue perform];
    }
    else{
        UIViewController * controllerToPresent = [self controllerToPresent];
        if (controllerToPresent){
            if ([controllerToPresent conformsToProtocol:@protocol(XLFormRowDescriptorViewController)]){
                ((UIViewController<XLFormRowDescriptorViewController> *)controllerToPresent).rowDescriptor = self.rowDescriptor;
            }
            if (controller.navigationController == nil || [controllerToPresent isKindOfClass:[UINavigationController class]] || self.rowDescriptor.action.viewControllerPresentationMode == XLFormPresentationModePresent){
                [controller presentViewController:controllerToPresent animated:YES completion:nil];
            }
            else{
                [controller.navigationController pushViewController:controllerToPresent animated:YES];
            }
        }
        
    }
}


#pragma mark - Helpers

-(UIViewController *)controllerToPresent
{
    if (self.rowDescriptor.action.viewControllerClass){
        return [[self.rowDescriptor.action.viewControllerClass alloc] init];
    }
    else if ([self.rowDescriptor.action.viewControllerStoryboardId length] != 0){
        UIStoryboard * storyboard =  [self storyboardToPresent];
        NSAssert(storyboard != nil, @"You must provide a storyboard when rowDescriptor.action.viewControllerStoryboardId is used");
        return [storyboard instantiateViewControllerWithIdentifier:self.rowDescriptor.action.viewControllerStoryboardId];
    }
    else if ([self.rowDescriptor.action.viewControllerNibName length] != 0){
        Class viewControllerClass = NSClassFromString(self.rowDescriptor.action.viewControllerNibName);
        NSAssert(viewControllerClass, @"class owner of self.rowDescriptor.action.viewControllerNibName must be equal to %@", self.rowDescriptor.action.viewControllerNibName);
        return [[viewControllerClass alloc] initWithNibName:self.rowDescriptor.action.viewControllerNibName bundle:nil];
    }
    return nil;
}

-(UIStoryboard *)storyboardToPresent
{
    if ([self.formViewController respondsToSelector:@selector(storyboardForRow:)]){
        return [self.formViewController storyboardForRow:self.rowDescriptor];
    }
    if (self.formViewController.storyboard){
        return self.formViewController.storyboard;
    }
    return nil;
}

@end
