//
//  MyDataProvider.m
//  DataProvider
//
//  Created by 허기수 on 2016. 12. 29..
//  Copyright © 2016년 HS. All rights reserved.
//

#import "MyDataProvider.h"

@interface MyDataProvider ()

@property(nonatomic, strong) NSFileHandle* handle;

@end


@implementation MyDataProvider

// 파일 열기를 구현합니다.
- (void) open
{
    NSURL *anURL = [NSURL fileURLWithPath:self.path];
    self.handle = [NSFileHandle fileHandleForReadingFromURL:anURL error:nil];
}

// 파일에서 특정 바이트 만큼 가져옵니다.
- (int) getBytes:(char *)buff offset:(unsigned int)offset size:(int)size
{
    // 예제는 DRM이 걸리지 않은 일반 파일이기 때문에 데이터를 바로 꺼내 전달하고 있습니다.
    // 만일 블럭 단위 DRM이 걸려 있다면 offset과 size에 걸친 모든 블럭을 복호화 하고
    // offset과 size만 buff에 넣어 넘겨줘야 합니다.
    [self.handle seekToFileOffset:offset];
    NSData *data = [self.handle readDataOfLength:(NSUInteger)size];
    [data getBytes:buff length:[data length]];
    
    return (int)[data length];
}

// 파일 전체 크기입니다.
- (unsigned int) size
{
    // 블럭 단위 DRM파일 크기와 복호화한 파일크기가 같다면 문제가 없습니다.
    // 만일 크기가 틀리면 복호화한 파일크기를 돌려줘야 합니다.
    [self.handle seekToFileOffset:0];
    
    return (unsigned int)[self.handle seekToEndOfFile];
}

// 파일을 닫습니다.
- (void) close
{
    [self.handle closeFile];
    self.handle = nil;
}

// 라이브러리에서 아직 저장은 지원하지 않습니다.
//- (BOOL) saveAs:(NSString *)path
//{
//    return NO;
//}

@end
