require 'twinslash_filestore'

class MemberTwinslashFilestoreObserver < ActiveRecord::Observer
  observe :member

  def after_save(member)
    if member.project.module_enabled?(:filestore)
      Twinslash::Filestore.add_user(member.project, member.user)
    end
  end

  def after_destroy(member)
    if member.project.module_enabled?(:filestore)
      Twinslash::Filestore.del_user(member.project, member.user)
    end
  end
end
