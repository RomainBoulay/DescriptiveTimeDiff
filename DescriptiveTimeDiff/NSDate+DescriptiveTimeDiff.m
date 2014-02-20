//
//  NSDate+DescriptiveTimeDiff.m
//


#import "NSDate+DescriptiveTimeDiff.h"

#import "TTTLocalizedPluralString.h"

#define LOCALISABLE_FULL    @"LocalizableFull"
#define LOCALISABLE_SHORT   @"LocalizableShort"

#define NSLoca(key) (NSLocalizedStringFromTable(key, localeTable, nil))

#define UNTIL_FORMAT    (NSLoca(@"UntilFormat"))
#define LEFT_FORMAT     (NSLoca(@"LeftFormat"))
#define AGO_FORMAT      (NSLoca(@"AgoFormat"))


@implementation NSDate (DescriptiveTimeDiff)

// Constants
static NSInteger secondsInADay      =   3600*24;
static NSInteger secondsInAWeek     =   3600*24*7;
static NSInteger secondsInAMonth    =   3600*24*30;
static NSInteger secondsInAYear     =   3600*24*365;

#pragma mark - Static formatters
+ (NSDateFormatter *)yearDateFormatter {
    static NSDateFormatter *yearDateFormatter = nil ;
    
    if (!yearDateFormatter) {
        yearDateFormatter = [[NSDateFormatter alloc] init];
        yearDateFormatter.dateFormat = @"YYYY-MM-dd";
    }
    
    return yearDateFormatter;
}


+ (NSDateFormatter *)shortDateFormatter {
    static NSDateFormatter *dateDateFormatter = nil ;
    
    if (!dateDateFormatter) {
        dateDateFormatter = [[NSDateFormatter alloc] init];
        dateDateFormatter.dateFormat = @"dd MMM.";
    }
    
    return dateDateFormatter;
}


+ (NSDateFormatter *)fullDateFormatter {
    static NSDateFormatter *fullDateDateFormatter = nil ;
    
    if (!fullDateDateFormatter) {
        fullDateDateFormatter = [[NSDateFormatter alloc] init];
        fullDateDateFormatter.dateFormat = @"dd MMMM";
    }
    
    return fullDateDateFormatter;
}


+ (NSDateFormatter *)fullStringDayFormatter {
    static NSDateFormatter *fullStringDayFormatter = nil ;
    
    if (!fullStringDayFormatter) {
        fullStringDayFormatter = [[NSDateFormatter alloc] init];
        fullStringDayFormatter.dateFormat = @"EEEE";
    }
    
    return fullStringDayFormatter;
}


+ (NSDateFormatter *)shortStringDayFormatter {
    static NSDateFormatter *shortStringDayFormatter = nil ;
    
    if (!shortStringDayFormatter) {
        shortStringDayFormatter = [[NSDateFormatter alloc] init];
        shortStringDayFormatter.dateFormat = @"EEE";
    }
    
    return shortStringDayFormatter;
}


#pragma mark - Private methods
- (NSDateComponents *)timeIntervalComponentsFromTimeInterval:(NSTimeInterval)timeInterval {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    NSInteger yearsDiff = abs(timeInterval/secondsInAYear);
    NSInteger monthsDiff = abs(timeInterval/secondsInAMonth);
    NSInteger weeksDiff = abs(timeInterval/secondsInAWeek);
    NSInteger daysDiff = abs(timeInterval/secondsInADay);
    NSInteger hoursDiff = llabs((llabs(timeInterval) - (daysDiff * secondsInADay)) / 3600);
    NSInteger minutesDiff = llabs((llabs(timeInterval) - ((daysDiff * secondsInADay) + (hoursDiff * 60))) / 60);
    NSInteger secondsDiff = llabs((llabs(timeInterval) - ((daysDiff * secondsInADay) + (minutesDiff * 60))));
    
    dateComponents.year = yearsDiff;
    dateComponents.month = monthsDiff;
    dateComponents.week = weeksDiff;
    dateComponents.day = daysDiff;
    dateComponents.hour = hoursDiff;
    dateComponents.minute = minutesDiff;
    dateComponents.second = secondsDiff;
    
    return dateComponents;
}


- (NSString *)descriptiveTimeDifferenceWithType:(DescriptiveTimeDiffType)type withFullString:(BOOL)isFullStrings {
    NSString *localeTable = (isFullStrings) ? LOCALISABLE_FULL : LOCALISABLE_SHORT;
    
    return [self descriptiveTimeDifferenceWithDate:[NSDate date]
                                              type:type
                                    withFullString:isFullStrings
                         descriptiveTimeDifference:^NSString *(NSDateComponents *dateComponents) {
        
        NSString *returnString;
        if (dateComponents.year > 1) {
            //            returnString = [[self.class yearDateFormatter] stringFromDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval]];
            returnString = [[self.class yearDateFormatter] stringFromDate:self];
            if (returnString.length)
                returnString = [NSString stringWithFormat:UNTIL_FORMAT, returnString];
        }
        
        else if (dateComponents.month > 3) {
            returnString = [[self.class shortDateFormatter] stringFromDate:self];
            if (returnString.length)
                returnString = [NSString stringWithFormat:UNTIL_FORMAT, returnString];
        }
        
        else if (dateComponents.month > 0)
            return [NSString stringWithFormat:NSLoca(TTTLocalizedPluralStringKeyForCountAndSingularNoun(dateComponents.month, NSLoca(@"month"))), dateComponents.month];
        
        else if (dateComponents.week > 0) {
            returnString = [NSString stringWithFormat:NSLoca(TTTLocalizedPluralStringKeyForCountAndSingularNoun(dateComponents.week, NSLoca(@"week"))), dateComponents.week];
        }
        
        else if (dateComponents.day > 4) {
            returnString = [NSString stringWithFormat:NSLoca(TTTLocalizedPluralStringKeyForCountAndSingularNoun(dateComponents.day, NSLoca(@"day"))), dateComponents.day];
        }
        
        else if (dateComponents.day > 0) {
            NSDateFormatter *dayFormatter = (isFullStrings) ? [self.class fullStringDayFormatter] : [self.class shortStringDayFormatter];
            return [dayFormatter stringFromDate:self];
        }
        
        else if (dateComponents.hour > 0) {
            returnString = [NSString stringWithFormat:NSLoca(TTTLocalizedPluralStringKeyForCountAndSingularNoun(dateComponents.hour, NSLoca(@"hour"))), dateComponents.hour];
        }
        
        else if (dateComponents.minute > 0) {
            returnString = [NSString stringWithFormat:NSLoca(TTTLocalizedPluralStringKeyForCountAndSingularNoun(dateComponents.minute, NSLoca(@"minute"))), dateComponents.minute];
        }
        else {
            returnString = [NSString stringWithFormat:NSLoca(TTTLocalizedPluralStringKeyForCountAndSingularNoun(dateComponents.second, NSLoca(@"second"))), dateComponents.second];
        }
        
        // Append format if needed
        if (type == DescriptiveTimeDiffTypeSuffixLeft)
            returnString = [NSString stringWithFormat:LEFT_FORMAT, returnString];
        else if (type == DescriptiveTimeDiffTypeSuffixAgo)
            returnString = [NSString stringWithFormat:AGO_FORMAT, returnString];
        
        return returnString;
    }];
}

typedef NSString * (^descriptiveTimeDifference)(NSDateComponents *dateComponents);


- (NSString *)descriptiveTimeDifferenceWithDate:(NSDate *)date type:(DescriptiveTimeDiffType)type withFullString:(BOOL)isFullStrings descriptiveTimeDifference:(descriptiveTimeDifference)descriptiveTimeDifferenceBlock {
    NSTimeInterval timeInterval = [self timeIntervalSinceDate:date];
    NSDateComponents *dateComponents = [self timeIntervalComponentsFromTimeInterval:timeInterval];
    
    if (descriptiveTimeDifferenceBlock)
        return descriptiveTimeDifferenceBlock(dateComponents);
    
    return nil;
}

@end
