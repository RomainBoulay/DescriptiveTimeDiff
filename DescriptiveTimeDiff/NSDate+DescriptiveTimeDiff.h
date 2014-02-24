//
//  NSDate+DescriptiveTimeDiff.h
//


typedef NS_ENUM(NSInteger, DescriptiveTimeDiffType)
{
	DescriptiveTimeDiffTypeSuffixNone = 0,
    DescriptiveTimeDiffTypeSuffixLeft,
    DescriptiveTimeDiffTypeSuffixIn,
    DescriptiveTimeDiffTypeSuffixAgo
};


//typedef NSString * (^descriptiveTimeDifference)(NSDateComponents *dateComponents);


@interface NSDate (DescriptiveTimeDiff)

- (NSString *)descriptiveTimeDifferenceWithDate:(NSDate *)date
                                           type:(DescriptiveTimeDiffType)type
                                     fullString:(BOOL)isFullStrings;

@end
