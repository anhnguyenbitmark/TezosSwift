Pod::Spec.new do |s|
  s.name         = "TezosSwift"
  s.version      = "1.0"
  s.summary      = "TezosSwift provides a Swift based toolchain for interacting with the Tezos blockchain"
  s.description  = <<-DESC
  TezosSwift provides utilities for interacting with the Tezos Blockchain over an RPC API.
                   DESC

  s.homepage      = "https://github.com/AckeeCZ/TezosSwift"
  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.author        = { 'Ackee' => 'info@ackee.cz' }
  s.source        = { :git => "https://github.com/AckeeCZ/TezosSwift.git", :tag => s.version.to_s }
  s.source_files  = "TezosSwift/**/*"
  s.exclude_files = "TezosSwift/*.plist"
  s.swift_version = "4.2"
  s.ios.deployment_target = "10.0"

  s.dependency "BigInt", "~> 3.1"		
  s.dependency "MnemonicKit", "~> 1.3.0"
  s.dependency "Sodium", "~> 0.7.0"  
  s.dependency "Result", "~> 4.0.0" 
  
end
