//
//  PlaySilializeObjectTests.m
//  PlaySilializeObjectTests
//
//  Created by yuu ogasawara on 2017/06/08.
//  Copyright © 2017年 stv. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface PlaySilializeObjectTests : XCTestCase

@end

@implementation PlaySilializeObjectTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testSaveAndLoad{
    NSArray* before = @[@"山田太郎", @"東京都中央区"];
    //オブジェクトのアーカイブ（バイナリ化）
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:before];
    //オブジェクトのアンアーカイブ(元に戻す）
    NSArray *after = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    XCTAssertEqualObjects(before, after);
}

-(void)testLoadFile{
    NSArray* before = @[@"山田太郎", @"東京都中央区"];
    NSString* documentsDirectoryPathString = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString* filePath = [documentsDirectoryPathString stringByAppendingPathComponent:@"data.dat"];
    BOOL successful =[NSKeyedArchiver archiveRootObject:before
                                                 toFile:filePath];
    XCTAssertTrue(successful);
    
    NSArray* after = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    XCTAssertEqualObjects(before, after);
}

@end
