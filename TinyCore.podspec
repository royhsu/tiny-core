Pod::Spec.new do |spec|
  spec.name = 'TinyCore'
  spec.version = '0.9.0'
  spec.license = 'MIT'
  spec.summary = 'TinyCore provides fundamental types and functions.'
  spec.homepage = 'https://github.com/royhsu/tiny-core'
  spec.authors = { 'Roy Hsu' => 'roy.hsu@tinyworld.cc' }
  spec.source = { 
    :git => 'https://github.com/royhsu/tiny-core.git', 
    :tag => spec.version
  }
  spec.framework = 'Foundation'
  spec.source_files = 'Sources/Core/Sources/*.swift', 'Sources/Core/Sources/**/*.swift', 'Sources/Core/Sources/**/**/*.swift', 'Sources/Core/Sources/**/**/**/*.swift'
  spec.ios.source_files = 'Sources/iOS/Sources/*.swift', 'Sources/iOS/Sources/**/*.swift', 'Sources/iOS/Sources/**/**/*.swift', 'Sources/iOS/Sources/**/**/**/*.swift'
  spec.ios.deployment_target = '10.0'
  spec.swift_version = '5.0'
end
