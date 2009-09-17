ActionController::Routing::Routes.draw do |map|
  map.connect 'projects/:project_id/filestore/:action', :controller => 'filestore'
  map.connect 'projects/:project_id/filestore/download/:filename', :controller => 'filestore', :action => 'download', :project_id => /\w+/, :filename => /.*/
end
