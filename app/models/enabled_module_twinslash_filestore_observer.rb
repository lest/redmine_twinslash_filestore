require 'twinslash_filestore'

class EnabledModuleTwinslashFilestoreObserver < ActiveRecord::Observer
  unloadable

  observe :enabled_module

  def after_save(enabled_module)
    if enabled_module.name == 'filestore'
      project = enabled_module.project
      Twinslash::Filestore.create(project.identifier)
      for user in project.users
        Twinslash::Filestore.add_user(project, user) if user.allowed_to?(:filestore_write, project)
      end
    end
  end

  def after_destroy(enabled_module)
    if enabled_module.name == 'filestore'
      project = enabled_module.project
      for user in project.users
        Twinslash::Filestore.del_user(project, user)
      end
    end
  end
end
