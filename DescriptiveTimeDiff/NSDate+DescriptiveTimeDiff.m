//
//  NSDate+DescriptiveTimeDiff.m
//


#import "NSDate+DescriptiveTimeDiff.h"

#import "TTTLocalizedPluralString.h"

#define LOCALISABLE_FULL    @"LocalizableFull"
#define LOCALISABLE_SHORT   @"LocalizableShort"

#define NSLoca(key) (NSLocalizedStringFromTable(key, translationTable, nil))

#define UNTIL_FORMAT    (NSLoca(@"UntilFormat"))
#define LEFT_FORMAT     (NSLoca(@"LeftFormat"))
#define AGO_FORMAT      (NSLoca(@"AgoFormat"))


@implementation NSDate (DescriptiveTimeDiff)

- (NSString *)stringWithHumanizedTimeDifference:(DescriptiveTimeDiffType)type withFullString:(BOOL)isFullStrings
{
    NSTimeInterval timeInterval = [self timeIntervalSinceNow];
    
    NSInteger secondsInADay = 3600*24;
    NSInteger secondsInAWeek =  3600*24*7;
    NSInteger secondsInAMonth =  3600*24*30;
    NSInteger secondsInAYear = 3600*24*365;
    NSInteger yearsDiff = abs(timeInterval/secondsInAYear);
    NSInteger monthsDiff = abs(timeInterval/secondsInAMonth);
    NSInteger weeksDiff = abs(timeInterval/secondsInAWeek);
    NSInteger daysDiff = abs(timeInterval/secondsInADay);
    NSInteger hoursDiff = llabs((llabs(timeInterval) - (daysDiff * secondsInADay)) / 3600);
    NSInteger minutesDiff = llabs((llabs(timeInterval) - ((daysDiff * secondsInADay) + (hoursDiff * 60))) / 60);
    NSInteger secondsDiff = llabs((llabs(timeInterval) - ((daysDiff * secondsInADay) + (minutesDiff * 60))));
    
    NSString *yearString;
    NSString *dateString;
    NSString *monthString;
    NSString *weekString;
    NSString *dayString;
    NSString *hourString;
    NSString *minuteString;
    NSString *secondString;
    
    NSDateFormatter *yearDateFormatter = [[NSDateFormatter alloc] init];
    yearDateFormatter.dateFormat = @"YYYY-MM-dd";
    
    NSDateFormatter *fullYearDateFormatter = [[NSDateFormatter alloc] init];
    fullYearDateFormatter.dateFormat = @"YYYY-MM-dd";
    
    NSDateFormatter *dateDateFormatter = [[NSDateFormatter alloc] init];
    dateDateFormatter.dateFormat = @"dd MMM.";
    
    NSDateFormatter *fullDateDateFormatter = [[NSDateFormatter alloc] init];
    fullDateDateFormatter.dateFormat = @"dd MMMM";
    
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat: (isFullStrings) ? @"EEEE" : @"EEE"];
    
    NSString *translationTable = (isFullStrings) ? LOCALISABLE_FULL : LOCALISABLE_SHORT;
    
    // DescriptiveTimeDiffTypeSuffixNone
    yearString = [yearDateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval]];
    dateString = [dateDateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval]];
    
    monthString = [NSString stringWithFormat:NSLoca(TTTLocalizedPluralStringKeyForCountAndSingularNoun(monthsDiff, NSLoca(@"month"))), monthsDiff];
    weekString = [NSString stringWithFormat:NSLoca(TTTLocalizedPluralStringKeyForCountAndSingularNoun(weeksDiff, NSLoca(@"week"))), weeksDiff];
    dayString = [NSString stringWithFormat:NSLoca(TTTLocalizedPluralStringKeyForCountAndSingularNoun(daysDiff, NSLoca(@"day"))), daysDiff];
    hourString = [NSString stringWithFormat:NSLoca(TTTLocalizedPluralStringKeyForCountAndSingularNoun(hoursDiff, NSLoca(@"hour"))), hoursDiff];
    minuteString = [NSString stringWithFormat:NSLoca(TTTLocalizedPluralStringKeyForCountAndSingularNoun(minutesDiff, NSLoca(@"minute"))), minutesDiff];
    secondString = [NSString stringWithFormat:NSLoca(TTTLocalizedPluralStringKeyForCountAndSingularNoun(secondsDiff, NSLoca(@"second"))), secondsDiff];
    
    NSString *stringFormat;
    switch (type
)
    {
        case DescriptiveTimeDiffTypeSuffixLeft:
            stringFormat = LEFT_FORMAT;
            yearString = [NSString stringWithFormat:UNTIL_FORMAT, yearString];
            dateString = [NSString stringWithFormat:UNTIL_FORMAT, dateString];
            break;
            
        case DescriptiveTimeDiffTypeSuffixAgo:
            stringFormat = AGO_FORMAT;
            break;
            
        case DescriptiveTimeDiffTypeSuffixNone:
        default:
            // Nothing to add
            break;
    }
    
    if (stringFormat) {
        weekString = [NSString stringWithFormat:stringFormat, weekString];
        dayString = [NSString stringWithFormat:stringFormat, dayString];
        hourString = [NSString stringWithFormat:stringFormat, hourString];
        minuteString = [NSString stringWithFormat:stringFormat, minuteString];
        secondString = [NSString stringWithFormat:stringFormat, secondString];
    }
    
    if (yearsDiff > 1)
        return yearString;
    
    else if (monthsDiff > 3)
        return dateString;
    
    else if (monthsDiff > 0)
        return monthString;
    
    else if (weeksDiff > 0)
        return weekString;
    
    else if (daysDiff > 4)
        return dayString;
    
    else if (daysDiff > 0)
        return [dayFormatter stringFromDate:self];
    
    else if (hoursDiff > 0)
        return hourString;
    
    else if (minutesDiff > 0)
        return minuteString;
    
    return secondString;
}

@end
