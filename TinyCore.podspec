Pod::Spec.new do |spec|
  spec.name             = 'TinyCore'
  spec.version          = '0.1.0'
  spec.license          = 'MIT'
  spec.homepage         = 'https://github.com/royhsu/tiny-core.git'
  spec.authors          = { 'Roy Hsu' => 'roy.hsu@tinyworld.cc' }
  spec.summary          = 'The foundation of Tiny frameworks.'
  spec.source           = { :git => 'https://github.com/royhsu/tiny-core.git', :tag => spec.version }

  spec.ios.deployment_target = '10.0'

  spec.source_files     = 'Sources/**/*.swift', 'Sources/*.swift'
end
