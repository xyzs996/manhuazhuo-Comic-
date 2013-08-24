
#import "TableViewWeiboSettingCell.h"

@implementation TableViewWeiboSettingCell
@synthesize imageViewIcon, labelTip, labelDetail, switchSetting;


- (void)setup
{
    imageViewIcon = [[UIImageView alloc] init];
    [self addSubview:imageViewIcon];
    [imageViewIcon release];
    
    labelTip = [[UILabel alloc] init];
    labelTip.textColor = [UIColor blackColor];
    labelTip.font = [UIFont boldSystemFontOfSize:19];
    labelTip.backgroundColor = [UIColor clearColor];
    [self addSubview:labelTip];
    [labelTip release];
    
    labelDetail = [[UILabel alloc] init];
    labelDetail.font = [UIFont systemFontOfSize:13];
    labelDetail.textColor = [UIColor grayColor];
    labelDetail.backgroundColor = [UIColor clearColor];
    labelDetail.numberOfLines = 3;
    [self addSubview:labelDetail];
    [labelDetail release];
    
    switchSetting = [[UISwitch alloc] init];
    [self addSubview:switchSetting];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    imageViewIcon.frame = CGRectMake(20, 5, 30, 30);
    labelTip.frame = CGRectMake(20+35, 10, self.frame.size.width-79-40-35, 25);
    labelDetail.frame = CGRectMake(20, 40, self.frame.size.width-50, self.frame.size.height-46-5);
    switchSetting.frame = CGRectMake(self.frame.size.width-79-35, 9, 79, 21);
}

@end

































