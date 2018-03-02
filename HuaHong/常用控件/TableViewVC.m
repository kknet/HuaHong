//
//  TableViewVC.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/13.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "TableViewVC.h"
#import "PullUpRefreshView.h"
#import "QKCRIndicateCell.h"
#import "QKCRIndicateHeadView.h"
#import "QKCRRecordTypeView.h"
#import "AudioRecorderManager.h"


#define kHeadViewHeight 40
#define kBottomHeight 100
#define bgColor [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1.0]
@interface TableViewVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIRefreshControl *refreshControl;
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) UIButton *recordBtn;
@property (nonatomic,strong) NSMutableArray *titles;
@end

@implementation TableViewVC

static NSString *headIdentifier = @"QKCRIndicateHeadView";

-(void)viewReportAction
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"tableView";
    self.view.backgroundColor = bgColor;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:172/255.0 blue:130/255.0 alpha:1.0];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"查看报表" style:(UIBarButtonItemStylePlain) target:self action:@selector(viewReportAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];


    
    for (int i=0; i<10; i++) {
        [self.data addObject:[NSString stringWithFormat:@"%d",arc4random()%100]];

    }
    
    self.titles = [NSMutableArray arrayWithArray:@[@"2018.02.23",@"2018.02.23",@"2018.02.23",@"2018.02.24",@"2018.02.25",@"2018.02.25",@"2018.02.25",@"2018.02.25",@"2018.02.26",@"2018.02.26"]];
    
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.recordBtn];

    
    //下拉刷新
    if (@available(iOS 10.0, *)) {
        self.tableView.refreshControl = self.refreshControl;
    } else {
        [self.tableView addSubview:self.refreshControl];
    }
    
    //上拉加载
    __weak typeof(self) weekSelf = self;
    [self.tableView.refreshView setPullUpBlock:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weekSelf.data addObject:[NSString stringWithFormat:@"%d",arc4random()%100]];
            
            [weekSelf.tableView reloadData];
            
            [weekSelf.tableView.refreshView endloadMore];
        });
        
    }];
}

-(NSMutableArray *)data
{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    
    return _data;
}
-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-kBottomHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"QKCRIndicateCell" bundle:nil] forCellReuseIdentifier:@"QKCRIndicateCell"];
        [_tableView registerClass:[QKCRIndicateHeadView class] forHeaderFooterViewReuseIdentifier:headIdentifier];
        
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 80;
        _tableView.backgroundColor = bgColor;
        
    }
    
    
    return _tableView;
}

-(UIButton *)recordBtn
{
    if (_recordBtn == nil) {
        
        UIImage *image = [UIImage imageNamed:@"microphone"];
        
        _recordBtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-image.size.width)/2, (kBottomHeight-image.size.height)/2 + (kScreenHeight-kBottomHeight), image.size.height, image.size.height)];
        _recordBtn.layer.cornerRadius = image.size.height/2;
        [_recordBtn setImage:image forState:UIControlStateNormal];
        
        [[_recordBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            //选择录音类型
            [self selectRecordType];
        }];
    }
    
    return _recordBtn;
}
#pragma mark - 下拉刷新
-(UIRefreshControl *)refreshControl
{
    if (_refreshControl == nil)
    {
        _refreshControl = [[UIRefreshControl alloc]init];
        _refreshControl.backgroundColor = [UIColor grayColor];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        NSString *title = [NSString stringWithFormat:@"最后一次更新：%@",dateStr];
        NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        NSAttributedString *attriTitle = [[NSAttributedString alloc]initWithString:title attributes:attributes];
        _refreshControl.attributedTitle = attriTitle;
        _refreshControl.tintColor = [UIColor whiteColor];
        [_refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

-(void)refreshAction
{
    NSLog(@"下拉刷新");
    
    [_refreshControl endRefreshing];
//    [_refreshControl beginRefreshing];

}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QKCRIndicateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QKCRIndicateCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [[cell rac_signalForSelector:@selector(playAction:)]subscribeNext:^(RACTuple * _Nullable x) {
        
        //播放录音
        NSLog(@"播放录音");
        cell.progress = 0.51;
        
        
    }];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
{
    return @"";
}

// Editing


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return YES;
//}

// Index

//- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView;
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.titles removeObjectAtIndex:indexPath.section];
        [self.data removeObjectAtIndex:indexPath.section];
    [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                 withRowAnimation:UITableViewRowAnimationFade];

    }
}

//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
//{
//    
//}

#pragma mark - UITableViewDelegate
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
//- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath NS_AVAILABLE_IOS(6_0);
//- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
//- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
//
//// Variable height support
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return kHeadViewHeight;
    }
    
    NSString *lastTitle = [self.titles objectAtIndex:section-1];
    NSString *currentTitle = [self.titles objectAtIndex:section];

    if ([lastTitle isEqualToString:currentTitle]) {
        return 0;
    }
    
    return kHeadViewHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    QKCRIndicateHeadView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headIdentifier];
    if (headView == nil) {
        headView = [[QKCRIndicateHeadView alloc]initWithReuseIdentifier:headIdentifier];
    }

    [headView setTime:self.titles[section]];
    return headView;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
//
//// Use the estimatedHeight methods to quickly calcuate guessed values which will allow for fast load times of the table.
//// If these methods are implemented, the above -tableView:heightForXXX calls will be deferred until views are ready to be displayed, so more expensive logic can be placed there.
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(7_0);
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0);
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0);
//
//// Section header & footer information. Views are preferred over title should you decide to provide both
//

//will be adjusted to default or specified header height
//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;   // custom view for footer. will be adjusted to default or specified footer height
//
//// Accessories (disclosures).
//
//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath NS_DEPRECATED_IOS(2_0, 3_0) __TVOS_PROHIBITED;
//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
//
//// Selection
//
//// -tableView:shouldHighlightRowAtIndexPath: is called when a touch comes down on a row.
//// Returning NO to that message halts the selection process and does not cause the currently selected row to lose its selected look while the touch is down.
//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0);
//- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0);
//- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0);
//
//// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
//- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//- (nullable NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);
//// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    [self selectRecordType];
}

#pragma mark - 选择录音类型
-(void)selectRecordType
{
    QKCRRecordTypeView *selectView = [QKCRRecordTypeView shared];
    [selectView show];
    
    [[selectView rac_signalForSelector:@selector(startAction)]subscribeNext:^(RACTuple * _Nullable x) {
       
        //开始语
        NSLog(@"startAction");

    }];
    
    [[selectView rac_signalForSelector:@selector(endAction)]subscribeNext:^(RACTuple * _Nullable x) {
        
        //结束语
        NSLog(@"endAction");

    }];
}
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);
//
//// Editing
//
//// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0) __TVOS_PROHIBITED;
//
//// Use -tableView:trailingSwipeActionsConfigurationForRowAtIndexPath: instead of this method, which will be deprecated in a future release.
//// This method supersedes -tableView:titleForDeleteConfirmationButtonForRowAtIndexPath: if return value is non-nil
//- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) __TVOS_PROHIBITED;



//// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
//- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;
//
//// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
//- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath __TVOS_PROHIBITED;
//- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(nullable NSIndexPath *)indexPath __TVOS_PROHIBITED;
//
//// Moving/reordering
//
//// Allows customization of the target row for a particular row as it is being moved/reordered
//- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath;
//
//// Indentation
//
//- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath; // return 'depth' of row for hierarchies
//
//// Copy/Paste.  All three methods must be implemented by the delegate.
//
//- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(5_0);
//- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender NS_AVAILABLE_IOS(5_0);
//- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender NS_AVAILABLE_IOS(5_0);
//
//// Focus
//
//- (BOOL)tableView:(UITableView *)tableView canFocusRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0);
//- (BOOL)tableView:(UITableView *)tableView shouldUpdateFocusInContext:(UITableViewFocusUpdateContext *)context NS_AVAILABLE_IOS(9_0);
//- (void)tableView:(UITableView *)tableView didUpdateFocusInContext:(UITableViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator NS_AVAILABLE_IOS(9_0);
//- (nullable NSIndexPath *)indexPathForPreferredFocusedViewInTableView:(UITableView *)tableView NS_AVAILABLE_IOS(9_0);


 //ios 11 新增方法
 - (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
 
 UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除"
 handler:^(UIContextualAction * _Nonnull action,__kindof UIView * _Nonnull sourceView,void (^ _Nonnull completionHandler)(BOOL)){
 
 [self.tableView deleteRowsAtIndexPaths: [NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
 completionHandler(true);
 }];
 
 // 设置按钮图片
 [deleteAction setImage:[UIImage imageNamed:@"close" inBundle:nil compatibleWithTraitCollection:nil]];
 
 
 NSArray *actions = [[NSArray alloc] initWithObjects:deleteAction, nil];
 
 return [UISwipeActionsConfiguration configurationWithActions:actions];
 }

//右滑
//- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos);
@end
