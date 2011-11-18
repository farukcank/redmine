require 'redmine'

Redmine::Plugin.register :redmine_datasel_meeting do
  name 'Redmine Datasel Meeting plugin'
  author 'Faruk Can KAYA'
  description 'Plugin for datasel meetings'
  version '0.0.1'
  url 'https://avicenna.datasel.com.tr/redmine/'
  author_url 'https://avicenna.datasel.com.tr/redmine/'

  #permission :meetings, { :meetings => [:index, :show, :new, :edit] }, :public => true
  project_module :meeting do
    permission :list_meetings, :meetings => :index
    permission :show_meeting, :meetings => :show
    permission :new_meeting, :meetings => :new
    permission :edit_meeting, :meetings => :edit
  end
  menu :project_menu, :meetings, { :controller => 'meetings', :action => 'index' }, :caption => 'Meetings', :after => :activity, :param => :id
end
