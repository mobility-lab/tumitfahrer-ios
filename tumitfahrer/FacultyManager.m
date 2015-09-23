//
//  Faculty.m
//  tumitfahrer
//
/*
 * Copyright 2015 TUM Technische Universität München
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */
//

#import "FacultyManager.h"
#import "Faculty.h"

@interface FacultyManager ()

@property (nonatomic, strong) NSMutableArray *facultyArray;

@end

@implementation FacultyManager

+(instancetype)sharedInstance {
    static FacultyManager *sharedFaculty = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFaculty = [[self alloc] init];
    });
    return sharedFaculty;
}

-(instancetype)init {
    self = [super init];
    if(self) {
        self.facultyArray = [[NSMutableArray alloc] init];
        [self initFaculties];
    }
    return self;
}

-(void)initFaculties {
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"Architecture" facultyId:0]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"Chemistry" facultyId:1]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"Civil, Geo, Env. Eng." facultyId:2]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"Electrical Engineering." facultyId:3]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"Informatics" facultyId:4]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"Life and Food Science" facultyId:5]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"Mathematics" facultyId:6]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"Mechnical Engineering" facultyId:7]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"Medicine" facultyId:8]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"Physics" facultyId:9]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"Sport and Health Science" facultyId:10]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"TUM School of Education" facultyId:11]];
    [self.facultyArray addObject:[[Faculty alloc] initWithName:@"TUM School of Management" facultyId:12]];
}

-(NSArray *)allFaculties {
    return self.facultyArray;
}

// return name of a specific faculty
-(NSString *)nameOfFacultyAtIndex:(NSInteger)index {
    if(index < 0 || index >= [self.facultyArray count])
        return @"";
    
    Faculty *faculty = [self.facultyArray objectAtIndex:index];
    return faculty.name;
}


-(NSInteger)indexForFacultyName:(NSString *)name {
    int index = 0;
    for (Faculty *faculty in self.facultyArray) {
        if ([faculty.name isEqualToString:name]) {
            return index;
        }
        index++;
    }
    return 0;
}
@end
