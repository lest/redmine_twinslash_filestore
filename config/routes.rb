ActionController::Routing::Routes.draw do |map|
  map.connect 'projects/:project_id/filestore/:action', :controller => 'filestore'
end
