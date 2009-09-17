class FilestoreController < ApplicationController
  unloadable

  before_filter :find_project, :authorize

  def index
    @base_dir = Setting.plugin_redmine_twinslash_filestore['base_dir'] + @project.identifier
    @entries = Dir.glob(@base_dir + '/*')
  end

  def download
    base_dir = Setting.plugin_redmine_twinslash_filestore['base_dir'] + @project.identifier
    path = base_dir + '/' + params[:filename]
    if !File.expand_path(path).match(Regexp.new("^#{Regexp.quote(base_dir)}")) || !File.exists?(path)
      render_404
    else
      send_file path, :filename => filename_for_content_disposition(File.basename(path))
    end
  end

  def find_project
    @project = Project.find(params[:project_id])
  end
end
