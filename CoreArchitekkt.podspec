Pod::Spec.new do |s|
    s.name             = 'CoreArchitekkt'
    s.version          = '0.1.62'
    s.summary          = 'A collection of shared components commonly used across Architekkt projects.'

    s.description      = <<-DESC
A collection of shared components commonly used across Architekkt projects.
    DESC

    s.homepage         = 'https://github.com/Lausbert/CoreArchitekkt'
    s.author           = { 'Lausbert' => 'stephanlerner@icloud.com' }
    s.source           = { :git => 'https://github.com/Lausbert/CoreArchitekkt.git', :tag => s.version.to_s }

    s.platform = :osx
    s.osx.deployment_target = "10.14"
    s.swift_version = '5.0'
  
  s.source_files = 'CoreArchitekkt/Source/**/*'
end
