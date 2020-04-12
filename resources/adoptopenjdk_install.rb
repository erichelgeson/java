resource_name :adoptopenjdk_install
include Java::Cookbook::AdoptOpenJdkHelpers
default_action :install

# Common options
property :version, String, name_property: true, description: 'Java version to install'

# Linux options
property :variant, String, description: 'Install flavour'
property :url, String, description: 'The URL to download from'
property :checksum, String, description: 'The checksum for the downloaded file'
property :java_home, String, description: 'Set to override the java_home'
property :java_home_mode, String, description: 'The permission for the Java home directory'
property :java_home_owner, String, description: 'Owner of the Java Home'
property :java_home_group, String, description: 'Group for the Java Home'
property :default, [true, false], description: ' Whether to set this as the defalut Java'
property :bin_cmds, Array, description: 'A list of bin_cmds based on the version and variant'
property :alternatives_priority, Integer, description: 'Alternatives priority to set for this Java'
property :reset_alternatives, [true, false], description: 'Whether to reset alternatives before setting'

# MacOS options
property :tap_full, [true, false], default: true, description: 'Perform a full clone on the tap, as opposed to a shallow clon.'
property :tap_url, String, description: 'The URL of the tap'
property :cask_options, String, description: 'Options to pass to the brew command during installation'
property :homebrew_path, String, description: 'The path to the homebrew binary'
property :owner, [String, Integer], description: 'The owner of the Homebrew installation'

action :install do
  case node['platform_family']
  when 'mac_os_x'
    adoptopenjdk_macos_install 'homebrew' do
      tap_full new_resource.tap_full
      tap_url new_resource.tap_url
      cask_options new_resource.cask_options
      homebrew_path new_resource.homebrew_path
      owner new_resource.owner
      version new_resource.version
    end
  when 'windows'
    log 'not yet implemented'
  else
    adoptopenjdk_linux_install 'linux' do
      version new_resource.version
      variant new_resource.variant
      url new_resource.url
      checksum new_resource.checksum
      java_home new_resource.java_home unless java_home.nil?
      java_home_mode new_resource.java_home_mode
      java_home_group new_resource.java_home_group
    end

    # node.default['java']['java_home'] = new_resource.java_home
  end
end

action :remove do
  case node['platform_family']
  when 'mac_os_x'
    adoptopenjdk_macos_install 'homebrew' do
      tap_full new_resource.tap_full
      tap_url new_resource.tap_url
      cask_options new_resource.cask_options
      homebrew_path new_resource.homebrew_path
      owner new_resource.owner
      action :remove
    end
  when 'windows'
    log 'not yet implemented'
  else
    adoptopenjdk_linux_install 'linux' do
      version new_resource.version unless new_resource.nil?
      variant new_resource.variant unless new_resource.nil?
      java_home new_resource.java_home unless new_resource.nil?
      bin_cmds new_resource.bin_cmds unless new_resource.nil?
      action :remove
    end
  end
end
