Facter.add(:lemonldap_current_config) do
  setcode do
    configs = Dir['/var/lib/lemonldap-ng/conf/lmConf-*.json']
    if configs.length == 0
      output = 0
    else
      output = configs.sort.last[/\d/]
    end
    output
  end
end