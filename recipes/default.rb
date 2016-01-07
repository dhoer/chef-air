# silent install: http://help.adobe.com/en_US/air/redist/WS485a42d56cd19641-70d979a8124ef20a34b-8000.html#WS485a42d56cd19641-70d979a8124ef20a34b-7ffb
if platform?('windows')
  options = %w(-silent -eulaAccepted)

  if node['air']['path']
    if node['air']['path'].start_with?('file://')
      local_path = node['air']['path'].gsub('file:///', '').tr('/', '\\').tr('|', ':')
    else
      filename = node['air']['path'].split('/').last
      local_path = "#{Chef::Config[:file_cache_path]}\\#{filename}"

      remote_file local_path do
        source node['air']['path']
      end
    end

    directory node['air']['location'] do
      recursive true
    end

    options << '-pingbackAllowed' if node['air']['pingback_allowed']
    options << "-location \"#{node['air']['location']}\"" if node['air']['location']
    options << '-desktopShortcut' if node['air']['desktop_shortcut']
    options << '-programMenu' if node['air']['program_menu']
    options << "\"#{local_path}\""
  end

  windows_package 'Adobe AIR' do # ~FC009
    source "#{node['air']['download_url']}/#{node['air']['version']}/AdobeAIRInstaller.exe"
    options options.join(' ')
    installer_type :custom
    success_codes [0, 1]
  end

  registry_key 'HKLM\SOFTWARE\Policies\Adobe\AIR' do
    values [{
      name: 'UpdateDisabled',
      type: :dword,
      data: node['air']['update_disabled'] ? 1 : 0
    }]
    recursive true
  end

  disable_file = "#{ENV['APPDATA']}\\Adobe\\AIR\\updateDisabled"
  if node['air']['update_disabled']
    file disable_file
  else
    file disable_file do
      action :delete
    end
  end
else
  Chef::Log.warn("Platform #{node['platform']} not supported!")
end
