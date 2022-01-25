Gem::Specification.new do |s|
  s.name = 'indexer101'
  s.version = '0.3.0'
  s.summary = 'Experimental gem to search a list of words 1 character at ' + 
      'a time. Intended for use as auto suggestion.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/indexer101.rb']
  s.add_runtime_dependency('dynarex', '~> 1.9', '>=1.9.0')
  s.add_runtime_dependency('dxlite', '~> 0.4', '>=0.4.1')
  s.add_runtime_dependency('thwait', '~> 0.2', '>=0.2.0')
  s.signing_key = '../privatekeys/indexer101.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/indexer101'
end
