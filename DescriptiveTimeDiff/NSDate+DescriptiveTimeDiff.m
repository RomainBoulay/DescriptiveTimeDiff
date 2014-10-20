//
//  NSDate+DescriptiveTimeDiff.m
//


#import "NSDate+DescriptiveTimeDiff.h"

#import "TTTLocalizedPluralString.h"
//#import "NSDate+Utils.h"

#define LOCALISABLE_FULL    @"LocalizableFull"
#define LOCALISABLE_SHORT   @"LocalizableShort"

#define NSL(key, table) (NSLocalizedStringFromTable(key, table, nil))

#define LEFT_FORMAT(table)  (NSL(@"LeftFormat", table))
#define AGO_FORMAT(table)   (NSL(@"AgoFormat", table))
#define IN_FORMAT(table)    (NSL(@"InFormat", table))


@implementation NSDate (DescriptiveTimeDiff)


#pragma mark - Private
- (NSString *)specialCasesWithComponents:(NSDateComponents *)components
                                    type:(DescriptiveTimeDiffType)type
                              fullString:(BOOL)isFullStrings
                      localizationsTable:(NSString *)table {
    
    if (type == DescriptiveTimeDiffTypeSuffixIn
        && (components.year == NSUndefinedDateComponent || components.year == 0)
        && (components.month == NSUndefinedDateComponent || components.month == 0)) {
        
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
    return [NSString stringWithFormat:NSL(TTTLocalizedPluralStringKeyForCountAndSingularNoun(count, NSL(i18nKey, table)), table), count];
}


- (NSDateComponents *)dateComponentsWithUnitFlags:(NSCalendarUnit)unitFlags {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:unitFlags fromDate:self];
    return components;
}


#pragma mark - Public
- (NSInteger)day {
    NSDateComponents *components = [self dateComponentsWithUnitFlags:NSDayCalendarUnit];
    NSInteger day = [components day];
    return day;
}


- (NSInteger)month {
    NSDateComponents *components = [self dateComponentsWithUnitFlags:NSMonthCalendarUnit];
    NSInteger month = [components month];
    return month;
}


- (NSInteger)year {
    NSDateComponents *components = [self dateComponentsWithUnitFlags:NSYearCalendarUnit];
    NSInteger year = [components year];
    return year;
}


- (NSInteger)dayDifferenceWithDate:(NSDate *)aDate {
    NSDateComponents *components = [self dateComponentsForDifferenceWithDate:aDate unitFlags:NSDayCalendarUnit];
    NSInteger days = [components day];
    return days;
}


- (NSInteger)monthDifferenceWithDate:(NSDate *)aDate {
    NSDateComponents *components = [self dateComponentsForDifferenceWithDate:aDate unitFlags:NSMonthCalendarUnit];
    NSInteger months = [components month];
    return months;
}


- (NSDateComponents *)dateComponentsForDifferenceWithDate:(NSDate *)aDate unitFlags:(NSCalendarUnit)unitFlags {
    NSDate *startDate = self;
    NSDate *endDate = aDate;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:unitFlags
                                          fromDate:startDate
                                            toDate:endDate
                                           options:0];
    
    return components;
}


- (NSString *)descriptiveTimeDifferenceWithDate:(NSDate *)date type:(DescriptiveTimeDiffType)type fullString:(BOOL)isFullStrings {
    // Compute time interval
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponents = [self dateComponentsForDifferenceWithDate:date unitFlags:unitFlags];
    NSString *localizationsTable = (isFullStrings) ? LOCALISABLE_FULL : LOCALISABLE_SHORT;
    
    
    // Special case pass
    NSString *specialCaseString = [self specialCasesWithComponents:dateComponents type:type fullString:isFullStrings localizationsTable:localizationsTable];
    if (specialCaseString)
        return specialCaseString;
    
    
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
