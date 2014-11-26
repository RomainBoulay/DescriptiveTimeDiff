Pod::Spec.new do |s|
  s.name = 'DescriptiveTimeDiff'
  s.version = '0.2'
  s.platform = :ios, '6.0'
  s.ios.deployment_target = '6.0'
  s.license = 'MIT'
  s.summary = 'DescriptiveTimeDiff is a NSDate Category aiming to get descriptive time intervals between dates.'
  s.description = <<-DESC
                    DescriptiveTimeDiff is a NSDate Category aiming to get descriptive time intervals between dates. Localized in French and English.
                  DESC
  s.homepage = 'https://github.com/RomainBoulay/DescriptiveTimeDiff'
  s.author = { 'Romain Boulay' => 'https://twitter.com/r_boulay' }
  s.source = { :git => 'https://github.com/RomainBoulay/DescriptiveTimeDiff.git', :tag => "#{s.version}" }
  s.source_files = 'DescriptiveTimeDiff/*.{h,m}'
  s.resources = 'DescriptiveTimeDiff/{en,fr}.lproj'

  s.frameworks = 'Foundation'
  s.dependency 'TTTLocalizedPluralString', '~> 0.0.9'
  s.requires_arc = true
end
