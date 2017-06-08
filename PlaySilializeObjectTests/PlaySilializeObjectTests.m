//
//  PlaySilializeObjectTests.m
//  PlaySilializeObjectTests
//
//  Created by yuu ogasawara on 2017/06/08.
//  Copyright © 2017年 stv. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"
#import "Address.h"

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

-(void)testArchiveAndUnarchiveThreePeople{
    XCTAssertTrue([self archivePeopleInfo]);
    NSArray<Person*>* personsArray = [self personsArray];
    NSArray<Person*> *loadedArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
    
    if (loadedArray) {
        [loadedArray enumerateObjectsUsingBlock:^(Person* person, NSUInteger idx, BOOL *stop){
            Person* referencedPerson = personsArray[idx];
            XCTAssertEqualObjects(person.name, referencedPerson.name);
            
            Address* referencedAddress = referencedPerson.address;
            XCTAssertEqualObjects(person.address.zipCode, referencedAddress.zipCode);
            XCTAssertEqualObjects(person.address.state, referencedAddress.state);
            XCTAssertEqualObjects(person.address.city, referencedAddress.city);
            XCTAssertEqualObjects(person.address.other, referencedAddress.other);

        }];
    }
}

- (BOOL)archivePeopleInfo{
    
    NSArray<Person*>* personsArray = [self personsArray];
    
    NSString* filePath = [self filePath];
    
    return [NSKeyedArchiver archiveRootObject:personsArray
                                       toFile:filePath];
}

-(NSArray<Person*>*)personsArray{
    Person *tYamada = [[Person alloc] init];
    tYamada.name = @"山田敏郎";
    Address* yAddress = [[Address alloc] init];
    yAddress.zipCode = @"104-0061";
    yAddress.state = @"東京都";
    yAddress.city = @"中央区";
    yAddress.other = @"銀座１丁目";
    tYamada.address = yAddress;
    
    Person* hYamada = [[Person alloc] init];
    hYamada.name = @"山田ひかり";
    hYamada.address = yAddress;
    
    Person *tanaka = [[Person alloc] init];
    tanaka.name = @"田中翔太";
    Address* tAddress = [[Address alloc] init];
    tAddress.zipCode = @"145-0071";
    tAddress.state = @"東京都";
    tAddress.city = @"大田区";
    tAddress.other = @"田園調布１丁目";
    tanaka.address = tAddress;
    
    return @[tYamada,hYamada,tanaka];
}

-(NSString*)filePath{
    NSString* documentsDirectoryPathString = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return [documentsDirectoryPathString stringByAppendingPathComponent:@"data.dat"];
}

@end
