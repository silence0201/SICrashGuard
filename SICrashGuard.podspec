Pod::Spec.new do |s|
  s.name         = "SICrashGuard"
  s.version      = "0.1.0"
  s.summary      = "Runtime SICrashGuard."
  s.description  = <<-DESC
                      Simple iOS Runtime Guard System
                   DESC

  s.homepage     = "https://github.com/silence0201/SICrashGuard"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author    = "Silence"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/silence0201/SICrashGuard.git", :tag => "#{s.version}" }
  s.source_files  = "SICrashGuard", "SICrashGuard/**/*.{h,m,mm}"
  s.public_header_files = "SICrashGuard/Manager/*.h"
  s.requires_arc =[ 'SICrashGuard/CallStack/*.m',
                    'SICrashGuard/Containers/*.m',
                    'SICrashGuard/DynamicClass/*.m',
                    'SICrashGuard/KVO/*.m',
                    'SICrashGuard/Notification/*.m',
                    'SICrashGuard/Manager/*.m',
                    'SICrashGuard/NSNull/*.m',
                    'SICrashGuard/NSTimer/*.m',
                    'SICrashGuard/Record/*.m',
                    'SICrashGuard/Swizzle/*.m',
                    'SICrashGuard/NSTimer/*.m',
                    'SICrashGuard/UI/*.m',
                    'SICrashGuard/Unrecoginzed/*.m',
                    'SICrashGuard/WildPointer/SIWildPointert.m',
  ]

end
