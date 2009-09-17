require 'redmine'

Dispatcher.to_prepare do
end

Redmine::Plugin.register :redmine_twinslash_filestore do
  name 'Twinslash Filestore plugin'
  author 'Just Lest'
  description ''
  version '0.0.1'

  project_module :filestore do
    permission :filestore, {:filestore => [:index, :download]}, :public => true
  end

  menu :project_menu,
       :filestore,
       {:controller => :filestore, :action => :index},
       :caption => 'Filestore',
       :after => :documents,
       :param => :project_id

  settings :default => {'base_dir' => '',
                        'create_command' => '',
                        'add_user_command' => '',
                        'del_user_command' => ''},
           :partial => 'settings/twinslash_filestore_settings'
end

ActiveRecord::Base.observers << :enabled_module_twinslash_filestore_observer
ActiveRecord::Base.observers << :member_twinslash_filestore_observer
