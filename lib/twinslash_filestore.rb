module Twinslash
  class Filestore
    def self.method_missing(name, *args)
      command = Setting.plugin_redmine_twinslash_filestore[name.to_s + '_command']
      args.map! do |arg|
        res = arg
        res = arg.identifier if arg.is_a?(Project)
        res = arg.login if arg.is_a?(User)
        res
      end
      command_with_args = "#{command} #{args.join(' ')}"
      Rails.logger.debug(command_with_args)
      system(command_with_args)
    end
  end
end
