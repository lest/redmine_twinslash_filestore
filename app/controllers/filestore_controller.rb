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

  def comment
    params[:value] = '<no comment>' if params[:value].empty?
    base_dir = Setting.plugin_redmine_twinslash_filestore['base_dir'] + @project.identifier
    path = base_dir + '/' + params[:filename]
    if File.expand_path(path).match(Regexp.new("^#{Regexp.quote(base_dir)}")) && File.exists?(path)
      begin
        lines = File.readlines(File.dirname(path) + '/description.ion')
      rescue StandardError
        lines = []
      end
      found = false
      lines.map! do |line|
        words = line.split(' ')
        if words[0] == File.basename(path)
          line = words[0] + ' ' + params[:value]
          found = true
        end
        line
      end
      lines << File.basename(path) + ' ' + params[:value] unless found
      file = File.open(File.dirname(path) + '/description.ion', 'w')
      lines.each {|l| file.puts(l)}
      file.close
    end
    @value = params[:value]
    render :layout => false
  end

  def find_project
    @project = Project.find(params[:project_id])
  end
end
