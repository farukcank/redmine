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
    permission :view_meeting, {:meetings => [:show,:index]}
    permission :edit_meeting, {:meetings => [:edit,:create],:internal_participants => [:make_invited,:make_uninvited,:make_attended,:make_not_attended,:create]}
  end
  menu :project_menu, :meetings, { :controller => 'meetings', :action => 'index' }, :caption => 'Meetings', :after => :activity, :param => :id
end
