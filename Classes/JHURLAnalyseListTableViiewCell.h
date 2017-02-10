//
//  JHURLAnalyseListTableViiewCell.h
//  JHURLAnalyseTool
//
//  Created by Shenjinghao on 2017/2/9.
//  Copyright © 2017年 JHModule. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 定制cell
 */
@interface JHURLAnalyseListTableViiewCell : UITableViewCell

@property (nonatomic, strong) id cellID;
@property (nonatomic, strong) UILabel *urlLabel;
@property (nonatomic, strong) UILabel *methodLabel;
@property (nonatomic, strong) UILabel *statusLabel;

//更新cell数据
- (void)updateCellInfo:(NSDictionary*)cellInfo;

@end
