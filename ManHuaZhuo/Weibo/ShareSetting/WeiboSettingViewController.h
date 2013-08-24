

#import <UIKit/UIKit.h>

@interface WeiboSettingViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
{
    
}
@property (nonatomic, retain) NSArray *arrayOfWeiboStatus;
@property (retain, nonatomic) IBOutlet UITableView *tableViewWeibos;

@end
