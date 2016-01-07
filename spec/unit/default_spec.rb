# Encoding: utf-8

require_relative 'spec_helper'

describe 'air::default' do
  before do
    ENV['SystemDrive'] = 'C:'
    ENV['APPDATA'] = 'C:\Users\vagrant\AppData\Roaming'
  end

  context 'windows' do
    describe 'install air runtime only' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2', log_level: ::LOG_LEVEL) do |node|
          node.set['air']['location'] = 'C:\air_installed'
          node.set['air']['update_disabled'] = true
        end.converge(described_recipe)
      end

      it 'installs AIR Runtime' do
        expect(chef_run).to install_windows_package('Adobe AIR').with(
          source: 'http://airdownload.adobe.com/air/win/download/20.0/AdobeAIRInstaller.exe',
          options: '-silent -eulaAccepted',
          installer_type: :custom,
          success_codes: [0, 1]
        )
      end

      it 'creates registry key' do
        expect(chef_run).to create_registry_key('HKLM\SOFTWARE\Policies\Adobe\AIR').with(
          recursive: true
        )
      end

      it 'creates update disable file' do
        expect(chef_run).to create_file('C:\Users\vagrant\AppData\Roaming\Adobe\AIR\updateDisabled')
      end
    end

    describe 'install of local air application' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2', log_level: ::LOG_LEVEL) do |node|
          node.set['air']['path'] = 'file://|C:/tmp/myapp.air'
          node.set['air']['location'] = 'C:\air_installed'
        end.converge(described_recipe)
      end

      it 'create location directory' do
        expect(chef_run).to create_directory('C:\air_installed')
      end

      it 'installs AIR Runtime and Application' do
        expect(chef_run).to install_windows_package('Adobe AIR').with(
          source: 'http://airdownload.adobe.com/air/win/download/20.0/AdobeAIRInstaller.exe',
          options: "-silent -eulaAccepted -pingbackAllowed -location \"C:\\air_installed\" "\
          "-desktopShortcut -programMenu \"file:\\\\:C:\\tmp\\myapp.air\"",
          installer_type: :custom,
          success_codes: [0, 1]
        )
      end
    end

    describe 'install of remote air application' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'windows', version: '2012R2', log_level: ::LOG_LEVEL, file_cache_path: 'C:\chef\cache') do |node|
          node.set['air']['path'] =
            'http://download.stage.macromedia.com/pub/developer/air/sample_apps/AIRWebFontDemo.air'
          node.set['air']['location'] = 'C:\air_installed\sub_directory'
        end.converge(described_recipe)
      end

      it 'downloads air application' do
        expect(chef_run).to create_remote_file('C:\chef\cache\AIRWebFontDemo.air').with(
          source: 'http://download.stage.macromedia.com/pub/developer/air/sample_apps/AIRWebFontDemo.air'
        )
      end

      it 'create location directory' do
        expect(chef_run).to create_directory('C:\air_installed\sub_directory')
      end

      it 'installs AIR Runtime and Application' do
        expect(chef_run).to install_windows_package('Adobe AIR').with(
          source: 'http://airdownload.adobe.com/air/win/download/20.0/AdobeAIRInstaller.exe',
          options: "-silent -eulaAccepted -pingbackAllowed -location \"C:\\air_installed\\sub_directory\" "\
          "-desktopShortcut -programMenu \"C:\\chef\\cache\\AIRWebFontDemo.air\"",
          installer_type: :custom,
          success_codes: [0, 1]
        )
      end
    end
  end
end
