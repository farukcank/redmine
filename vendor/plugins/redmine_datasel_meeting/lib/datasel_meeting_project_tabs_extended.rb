require_dependency 'projects_helper'

module DataselMeetingProjectTabsExtended

    def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable
            alias_method_chain :project_settings_tabs, :datasel_meeting
        end
    end

    module ClassMethods
    end

    module InstanceMethods

        def project_settings_tabs_with_datasel_meeting
            tabs = project_settings_tabs_without_datasel_meeting
            if @project.module_enabled?("datasel_meeting")
              tabs.push({:name => 'datasel_meeting', :controller => :settings, :action => :save, :partial => 'settings/settings', :label => :datasel_meeting})
            end
            return tabs
        end

    end

end
