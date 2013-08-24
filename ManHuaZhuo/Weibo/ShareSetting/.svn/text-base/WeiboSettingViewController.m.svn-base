#import "WeiboSettingViewController.h"
#import "TableViewWeiboSettingCell.h"
#import "WeiboCommon.h"
#import "WeiboPublishViewController.h"

enum RowsSetting {
    Row_Sina = 0,
    Row_Tencent ,
    Row_NetEase,
    Row_Sohu,
    Row_Max
};

@interface WeiboSettingViewController()
- (void)loadWieboStatus;
@end

@implementation WeiboSettingViewController
@synthesize arrayOfWeiboStatus;
@synthesize tableViewWeibos;

- (void)dealloc
{
    [arrayOfWeiboStatus release];
    [tableViewWeibos release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置分享账户";
}

- (void)viewDidUnload
{
    [self setTableViewWeibos:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadWieboStatus];
}

- (void)loadWieboStatus
{
    self.arrayOfWeiboStatus = [WeiboCommon loadWeiboInfo];
    [self.tableViewWeibos reloadData];
}

- (BOOL)getWeiboBindedOfIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary *dict = [self.arrayOfWeiboStatus objectAtIndex:indexPath.row];
    NSObject *detailObject = [dict objectForKey:@"name"];
    if (detailObject == [NSNull null]) {
        return NO;
    }
    return YES;
}

- (NSString*)getWeiboNameOfIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary *dict = [self.arrayOfWeiboStatus objectAtIndex:indexPath.row];
    NSString *name = [dict objectForKey:@"name"];
    return name;
}

- (BOOL)getWeiboEnabledOfIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary *dict = [self.arrayOfWeiboStatus objectAtIndex:indexPath.row];
    if ([dict objectForKey:@"name"]) {
        return YES;
    }
    return NO;
    //    NSDictionary *dict = [self.arrayOfWeiboStatus objectAtIndex:indexPath.row];
    //    return [[dict objectForKey:@"enable"] boolValue];
}

- (BOOL)setWeiboEnabledIndexPath:(NSIndexPath*)indexPath andEnable:(BOOL)isEnable
{
    if (![self getWeiboBindedOfIndexPath:indexPath]) {
        return NO;
    }
    [WeiboCommon setWeiboEnableWithWeiboId:1<<indexPath.row andStatus:isEnable];
    return YES;
}

- (NSString*)getTitleOfIndexPath:(NSIndexPath*)indexPath
{
    NSString *title = nil;
    switch (indexPath.row) {
        case Row_Sina:
            title = @"分享到新浪微博";
            break;
        case Row_Tencent:
            title = @"分享到腾讯微博";
            break;
        case Row_NetEase:
            title = @"分享到网易微博";
            break;
        case Row_Sohu:
            title = @"分享到搜狐微博";
            break;
        default:
            break;
    }
    return title;
}

- (NSString *)getIconNameOfIndexPath:(NSIndexPath*)indexPath
{
    NSString *imageName = nil;
    switch (indexPath.row) {
        case Row_Sina:
            imageName = @"icon_sina";
            break;
        case Row_Tencent:
            imageName = @"icon_qq";
            break;
        case Row_NetEase:
            imageName = @"icon_163";
            break;
        case Row_Sohu:
            imageName = @"icon_sohu";
            break;
        default:
            break;
    }
    return imageName;
}

- (void)enterPublishControllerWithIndexPath:(NSIndexPath*)indexPath
{
    WeiboPublishViewController *controller = [[WeiboPublishViewController alloc] init];
    controller.weiboId = 1<<indexPath.row;
    controller.numerousPublish = NO;
    controller.stringContent = @"#话题#和内容";
    [self presentModalViewController:controller animated:YES];
    [controller release];
}

#pragma mark UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return Row_Max;
}
/*
 - (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 NSString *title = nil;
 if (section == 0) {
 title = @"";
 }
 return title;
 }
 */
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TableViewSettingCell";
    TableViewWeiboSettingCell *cell = (TableViewWeiboSettingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TableViewWeiboSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.labelTip.text = [self getTitleOfIndexPath:indexPath];
    NSString *detail = nil;
    
    BOOL isEnabled = NO;
    if ([self getWeiboBindedOfIndexPath:indexPath]) {
        detail = [self getWeiboNameOfIndexPath:indexPath];
        isEnabled = [self getWeiboEnabledOfIndexPath:indexPath];
    }else{
        detail = @"点击添加账户";
    }
    cell.labelDetail.text = detail;
    cell.switchSetting.on = isEnabled;
    cell.switchSetting.tag = indexPath.row;
    cell.imageViewIcon.image = [UIImage imageNamed:[self getIconNameOfIndexPath:indexPath]];
    [cell.switchSetting addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self enterPublishControllerWithIndexPath:indexPath];
}

- (void)switchValueChanged:(id)sender
{
    UISwitch *sw = (UISwitch*)sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sw.tag inSection:0];
    BOOL bind = [self getWeiboBindedOfIndexPath:indexPath];
    if (bind) {
        //[self setWeiboEnabledIndexPath:indexPath andEnable:sw.on];
        //[self loadWieboStatus];
        NSString *title = [NSString stringWithFormat:@"您确定要删除%@的授权账户%@吗？", [self getTitleOfIndexPath:indexPath], [self getWeiboNameOfIndexPath:indexPath]];
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
        sheet.tag = indexPath.row;
        [sheet showInView:self.view];
        [sheet release];
    }else{
        [self enterPublishControllerWithIndexPath:indexPath];
    }
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSInteger row = actionSheet.tag;
        [WeiboCommon deleteWeiboInfo:1<<row];
        [self loadWieboStatus];
    }else {
        [self.tableViewWeibos reloadData];
    }
}


@end





























