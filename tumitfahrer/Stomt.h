//
//  Stomt.h
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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StomtAgreement;

@interface Stomt : NSManagedObject

@property (nonatomic, retain) NSNumber * stomtId;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * creator;
@property (nonatomic, retain) NSNumber * isNegative;
@property (nonatomic, retain) NSNumber * counter;
@property (nonatomic, retain) NSSet *agreements;
@end

@interface Stomt (CoreDataGeneratedAccessors)

- (void)addAgreementsObject:(StomtAgreement *)value;
- (void)removeAgreementsObject:(StomtAgreement *)value;
- (void)addAgreements:(NSSet *)values;
- (void)removeAgreements:(NSSet *)values;

@end
