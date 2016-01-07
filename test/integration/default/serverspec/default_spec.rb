# Encoding: utf-8
require 'serverspec'

if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil?
  set :backend, :exec
else
  set :backend, :cmd
  set :os, family: 'windows'
end

case os[:family]
when 'windows'
  describe file('C:\Program Files (x86)\Common Files\Adobe AIR\Versions\1.0') do
    it { should be_directory }
  end

  describe file('C:\Users\vagrant\AppData\Local\Adobe\AIR\logs\Install.log') do
    its(:content) { should match(/Runtime Installer end with exit code 0/) }
  end

  describe file('C:\air\sample_apps\Bee\Bee.exe') do
    it { should be_file }
  end
end
