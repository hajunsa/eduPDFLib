//
//  CustomOutlines.m
//  ezPDFViewLibrarySample
//
//  Created by 허기수 on 2015. 9. 14..
//  Copyright (c) 2015년 Unidocs Inc. All rights reserved.
//

#import "CustomOutlines.h"
#import "CustomOutlineCell.h"

@implementation CustomOutlines

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.player) {
        // 목차 목록을 계층 구조로 가져 옵니다.
        self.outlines = [self.player outlines:NO maximumDepth:INT32_MAX];
    }
    
    self.navigationItem.title = NSLocalizedString(@"목차", "");
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    if (!self.pushed) { // 네비게이션 푸시로 컨트롤러가 열린 경우가 아니라면
        // 목차창 닫기
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"닫기", "") style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
        self.navigationItem.rightBarButtonItem.tintColor = self.view.tintColor;
        
        // 모든 목차를 표시할 때는 이전 상태로 갈 필요가 없습니다.
        if (![self.outlines isFlat]) {  // 계층 구조 라면
            // 이전 목차 상태로 가기
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"이전", "") style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
            
            // 이전 목차 상태로 가기 가능 여부
            self.navigationItem.leftBarButtonItem.enabled = [self.outlines canPop];
            self.navigationItem.leftBarButtonItem.tintColor = self.view.tintColor;
        }
    }

}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pop
{
    // 이전 목차 상태로 가기
    [self.outlines pop];
    // 목차가 갱신됬으니 리로드 합니다.
    [self.tableView reloadData];
    // 이전 목차 상태로 가기 가능 여부
    self.navigationItem.leftBarButtonItem.enabled = [self.outlines canPop];
}

- (NSDictionary *)outlineWithRow:(NSInteger)row
{
    // 해당 row에 목차를 돌려줍니다.
    return [self.outlines objectAtIndex:row];
}

#pragma mark - UITableViewController data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 현재 이동한 목차 커서에서 자식 목차 갯수
    return [self.outlines count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 목차 셀 UI는 어떤 형태로든 만들 수 있습니다.
    CustomOutlineCell *cell = (CustomOutlineCell *)[self.tableView dequeueReusableCellWithIdentifier:@"outline"];
    
    if (cell == nil)
    {
        NSArray *ar = [[NSBundle mainBundle] loadNibNamed:@"CustomOutlineCell" owner:nil options:nil];
        cell = [ar objectAtIndex:0];

        // 폴더형(자식을 가지고 있는)목차 실행 함수를 설정합니다.
        [cell.push addTarget:self action:@selector(enterFolder:) forControlEvents:UIControlEventTouchDown];
    }
    
    // 목차 데이터를 가져 옵니다.
    NSDictionary *obj = [self outlineWithRow:indexPath.row];
    
    if (obj == nil) {
        return cell;
    }
    
    // 모든 목차를 표시하는 경우 목차 객체 깊이에 따라 들여쓰기를 하였습니다.
    if ([self.outlines isFlat]) {
        NSNumber *depthObj = [obj objectForKey:@"depth"];
        if (depthObj) {
            int depth = [depthObj intValue];
            CGRect rc = CGRectOffset(cell.frame, depth*11, 0);
            rc.origin.y = 0;
            rc.size.width -= depth*11;
            cell.containView.frame = rc;
        }
    }
    
    // 표시할 타이틀을 설정합니다.
    cell.title.text = [obj objectForKey:@"title"];
    // 해당 인덱스를 저장합니다. 버튼이 눌렸을 때 해당 인덱스가 필요합니다.
    cell.push.row = indexPath.row;
    // 자식들을 가지고 있는지 여부
    BOOL kids = [[obj objectForKey:@"kids"] boolValue];
    
    // 자식들을 가지고 있다면
    if (kids)
    {
        // 폴더형 목차
        // 모든 목차가 표시 하지 않는 경우만 커서 이동이 가능하게 해야 합니다.
        if (![self.outlines isFlat]) {
            cell.push.hidden = NO;
        } else {
            cell.push.hidden = YES;
        }
//        UIImage *img = [UIImage imageNamed:@"folder"];
//        cell.icon.image = img;
    }
    
    else
    {
        // 이동 목차
        cell.push.hidden = YES;
//        UIImage *img = [UIImage imageNamed:@"PDF_file"];
//        cell.icon.image = img;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 목차 데이터를 가져 옵니다.
    NSDictionary *obj = [self outlineWithRow:indexPath.row];
    // 이동할 페이지 번호
    NSString *page = [obj objectForKey:@"destPage"];
    
    if (page)
    {
        int pageNo = [page intValue];
        
        if (pageNo == 0)
        {
            return;
        }
        // 페이지를 이동 합니다.
        [self.player gotoPage:pageNo completion:^(EDPageMoveFinishedType finished) {
            
        }];
    }
    
    // 오픈 가능한 uri
    NSString *uri = [obj objectForKey:@"uri"];
    
    if (uri)
    {
        // 오픈 처리를 합니다.
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:uri]];
    }
    
    // 이동 및 오픈 처리가 완료하였으므로 목차 화면을 닫습니다.
    if (self.pushed) {
        [self.navigationController popViewControllerAnimated:YES];
    } else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)enterFolder:(CustomFolderButton *)sender
{
    // 폴더형 목차를 들어가야 할 때
    CustomFolderButton *s = (CustomFolderButton *)sender;
    // 이벤트를 발생한 버튼에서 인덱스 값을 얻어오고
    NSInteger row = s.row;
    // 해당 목차 데이터를 가져와서
    NSDictionary *obj = [self outlineWithRow:row];
    
    // 자식들이 있다면
    BOOL kids = [[obj objectForKey:@"kids"] boolValue];
    if (kids)
    {
        // 해당 폴더로 들어갑니다.
        NSString *Id = [obj objectForKey:@"id"];
        [self.outlines push:Id];
        // 테이블뷰를 갱신합니다.
        [self.tableView reloadData];

        // 네비게이션 타이틀을 변경합니다.
        self.navigationItem.title = [obj objectForKey:@"title"];
        // 이전 목차 상태로 가기 가능 여부를 설정합니다.
        self.navigationItem.leftBarButtonItem.enabled = [self.outlines canPop];
    }
}

@end
