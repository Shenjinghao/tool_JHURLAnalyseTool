//
//  JHURLAnalyseListTableViiewCell.m
//  JHURLAnalyseTool
//
//  Created by Shenjinghao on 2017/2/9.
//  Copyright © 2017年 JHModule. All rights reserved.
//

#import "JHURLAnalyseListTableViiewCell.h"
#import "JHURLAnalyseManager.h"

@implementation JHURLAnalyseListTableViiewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCellViews];
    }
    return self;
}

- (void) createCellViews
{
    _urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, [UIScreen mainScreen].bounds.size.width - 30, 20)];
    [self.contentView addSubview:_urlLabel];
    
    _methodLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 120, 20)];
    [self.contentView addSubview:_methodLabel];
    
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 40, 120, 20)];
    [self.contentView addSubview:_statusLabel];
}

- (void)updateCellInfo:(NSDictionary *)cellInfo
{
    _urlLabel.text = [NSString stringWithFormat:@"URL: %@", cellInfo[JHUrlRequestUrl]];
    _methodLabel.text = [NSString stringWithFormat:@"Method: %@", cellInfo[JHUrlRequestHttpMethod]];
    
    //调整状态码颜色
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Status: %@", cellInfo[JHUrlRequestStatusCode]]];
    [attrString setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, 8)];
    NSInteger statusCode = [cellInfo[JHUrlRequestStatusCode] integerValue];
    if (statusCode >= 200 && statusCode < 300) {
        [attrString setAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor]} range:NSMakeRange(8, [NSString stringWithFormat:@"%ld",statusCode].length)];
    }else{
        [attrString setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(8, [NSString stringWithFormat:@"%ld",statusCode].length)];
    }
    
    _statusLabel.attributedText = attrString;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
