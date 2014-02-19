//
//  NSDate+DescriptiveTimeDiff.h
//


typedef NS_ENUM(NSInteger, DescriptiveTimeDiffType)
{
	DescriptiveTimeDiffTypeSuffixNone = 0,
    DescriptiveTimeDiffTypeSuffixLeft,
    DescriptiveTimeDiffTypeSuffixAgo
};


@interface NSDate (DescriptiveTimeDiff)

- (NSString *)stringWithHumanizedTimeDifference:(DescriptiveTimeDiffType)humanizedType withFullString:(BOOL)fullStrings;

@end
