//
//  NSDate+DescriptiveTimeDiff.m
//


#import "NSDate+DescriptiveTimeDiff.h"

#import "TTTLocalizedPluralString.h"

#define LOCALISABLE_FULL    @"LocalizableFull"
#define LOCALISABLE_SHORT   @"LocalizableShort"

#define NSL(key, table) (NSLocalizedStringFromTable(key, table, nil))

#define LEFT_FORMAT(table)  (NSL(@"LeftFormat", table))
#define AGO_FORMAT(table)   (NSL(@"AgoFormat", table))
#define IN_FORMAT(table)    (NSL(@"InFormat", table))


@implementation NSDate (DescriptiveTimeDiff)


#pragma mark - Public
- (BOOL)isSameDay:(NSDate *)comparedDate {
    return [self isEqualToDate:comparedDate unitFlags:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit)];
}


- (BOOL)isSameMonth:(NSDate *)comparedDate {
    return [self isEqualToDate:comparedDate unitFlags:(NSYearCalendarUnit|NSMonthCalendarUnit)];
}


- (BOOL)isSameYear:(NSDate *)comparedDate {
    return [self isEqualToDate:comparedDate unitFlags:NSYearCalendarUnit];
}


- (NSInteger)day {
    return [[self dateComponentsWithUnitFlags:NSDayCalendarUnit] day];
}


- (NSInteger)month {
    return [[self dateComponentsWithUnitFlags:NSMonthCalendarUnit] month];
}


- (NSInteger)year {
    return [[self dateComponentsWithUnitFlags:NSYearCalendarUnit] year];
}


- (NSInteger)dayDifferenceWithDate:(NSDate *)otherDate {
    return [self differenceWithDate:otherDate unitFlags:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) differenceExtraction:^NSInteger(NSDateComponents *dateComponents) {
        return [dateComponents day];
    }];
}


- (NSInteger)monthDifferenceWithDate:(NSDate *)otherDate {
    return [self differenceWithDate:otherDate unitFlags:(NSYearCalendarUnit|NSMonthCalendarUnit) differenceExtraction:^NSInteger(NSDateComponents *dateComponents) {
        return [dateComponents month];
    }];
}


- (NSDateComponents *)dateComponentsForDifferenceWithDate:(NSDate *)otherDate unitFlags:(NSCalendarUnit)unitFlags {
    return [[NSCalendar currentCalendar] components:unitFlags fromDate:self toDate:otherDate options:0];
}


- (NSString *)descriptiveTimeDifferenceWithDate:(NSDate *)date type:(DescriptiveTimeDiffType)type fullString:(BOOL)isFullStrings {
    // Compute time interval
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponents = [self dateComponentsForDifferenceWithDate:date unitFlags:unitFlags];
    NSString *localizationsTable = (isFullStrings) ? LOCALISABLE_FULL : LOCALISABLE_SHORT;
    
    // Special case pass
    NSString *specialCaseString = [self specialCasesWithComponents:dateComponents type:type fullString:isFullStrings localizationsTable:localizationsTable];
    return (specialCaseString) ?: [self descriptionWithType:type dateComponents:dateComponents localizationsTable:localizationsTable];
}


#pragma mark - Private
- (NSInteger)differenceWithDate:(NSDate *)otherDate unitFlags:(NSCalendarUnit)unitFlags differenceExtraction:(NSInteger (^)(NSDateComponents *dateComponents))extractionDifference {
    NSParameterAssert(otherDate && extractionDifference);
    NSDate *simplifiedSelfDate = [self simplifiedDateWithUnitFlags:unitFlags];
    NSDate *simplifiedOtherDate = [otherDate simplifiedDateWithUnitFlags:unitFlags];
    
    NSDateComponents *components = [simplifiedSelfDate dateComponentsForDifferenceWithDate:simplifiedOtherDate unitFlags:unitFlags];
    return extractionDifference(components);
}


- (BOOL)isEqualToDate:(NSDate *)otherDate unitFlags:(NSCalendarUnit)unitFlags {
    NSParameterAssert(otherDate);
    NSDate *simplifiedSelfDate = [self simplifiedDateWithUnitFlags:unitFlags];
    NSDate *simplifiedOtherDate = [otherDate simplifiedDateWithUnitFlags:unitFlags];
    return [simplifiedSelfDate isEqualToDate:simplifiedOtherDate];
}


- (NSDate *)simplifiedDateWithUnitFlags:(NSCalendarUnit)unitFlags {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:unitFlags fromDate:self];
    return [cal dateFromComponents:components];
}


- (NSString *)specialCasesWithComponents:(NSDateComponents *)components
                                    type:(DescriptiveTimeDiffType)type
                              fullString:(BOOL)isFullStrings
                      localizationsTable:(NSString *)table {
    
    if (type == DescriptiveTimeDiffTypeSuffixIn
        && (components.year == NSUndefinedDateComponent || components.year == 0)
        && (components.month == NSUndefinedDateComponent || components.month == 0)) {
        
        NSAssert(components.day >= 0, @"Comparison should be always positive, check the order");
        if (components.day == 1)
            return NSL(@"tomorrow", table);
        else if (components.day == 0)
            return NSL(@"today", table);
    }
    
    return nil;
}


+ (NSString *)stringWithComponents:(NSDateComponents *)dateComponents localizationsTable:(NSString *)table {
    NSString *returnString;
    NSArray *componentsArray = @[@(dateComponents.year),
                                 @(dateComponents.month),
                                 @(dateComponents.day),
                                 @(dateComponents.hour),
                                 @(dateComponents.minute),
                                 @(dateComponents.second)];
    
    NSArray *localizationKeyArray = @[@"year",
                                      @"month",
                                      @"day",
                                      @"hour",
                                      @"minute",
                                      @"second"];
    
    for (NSUInteger index = 0 ; index < componentsArray.count ; ++index) {
        NSNumber *currentComponentNumber = componentsArray[index];
        NSInteger currentComponent = ABS(currentComponentNumber.integerValue);
        
        if (currentComponent != NSUndefinedDateComponent && currentComponent != 0) {
            // Compute week number
            if ([localizationKeyArray[index] isEqualToString:@"day"] && currentComponent > 6)
                returnString = [self.class stringWithKey:@"week" localizationsTable:table andCount:currentComponent/7];
            else
                returnString = [self.class stringWithKey:localizationKeyArray[index] localizationsTable:table andCount:currentComponent];
            
            break;
        }
    }
    
    return returnString;
}


+ (NSString *)stringWithKey:(NSString *)i18nKey localizationsTable:(NSString *)table andCount:(NSInteger)count {
    return [NSString stringWithFormat:NSL(TTTLocalizedPluralStringKeyForCountAndSingularNoun(count, i18nKey), table), count];
}


- (NSDateComponents *)dateComponentsWithUnitFlags:(NSCalendarUnit)unitFlags {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:unitFlags fromDate:self];
    return components;
}


- (NSString *)descriptionWithType:(DescriptiveTimeDiffType)type dateComponents:(NSDateComponents *)dateComponents localizationsTable:(NSString *)localizationsTable {
    // Determining string format with given type
    NSString *format;
    switch (type) {
        case DescriptiveTimeDiffTypeSuffixLeft:
            format = LEFT_FORMAT(localizationsTable);
            break;
            
        case DescriptiveTimeDiffTypeSuffixAgo:
            format = AGO_FORMAT(localizationsTable);
            break;
            
        case DescriptiveTimeDiffTypeSuffixIn:
            format = IN_FORMAT(localizationsTable);
            break;
            
        default:
            break;
    }
    
    // Aggregate returned string
    NSString *description = [self.class stringWithComponents:dateComponents localizationsTable:localizationsTable];
    
    if (format.length && description.length)
        description = [NSString stringWithFormat:format, description];
    
    return (description.length) ? description : nil;
}


@end
