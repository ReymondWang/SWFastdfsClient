Pod::Spec.new do |spec|
  spec.name         = 'SWFastdfsClient'
  spec.version      = '1.0'
  spec.license      = 'BSD'
  spec.summary      = 'A swift client for distributed file system Fastdfs.'
  spec.homepage     = 'https://github.com/ReymondWang/SWFastdfsClient'
  spec.author       = 'yanan wang'
  spec.source       = { :git => 'git@github.com:ReymondWang/SWFastdfsClient.git' }
  spec.source_files = 'SWFastdfsClient/*'
  spec.requires_arc = true
  spec.dependency 'CryptoSwift'
end
