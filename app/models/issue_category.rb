# Redmine - project management software
# Copyright (C) 2006-2011  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class IssueCategory < ActiveRecord::Base
  after_update :update_issues_from_sharing_change
  belongs_to :project
  belongs_to :assigned_to, :class_name => 'User', :foreign_key => 'assigned_to_id'
  has_many :issues, :foreign_key => 'category_id', :dependent => :nullify

  SHARINGS = %w(none descendants hierarchy tree system)
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:project_id]
  validates_length_of :name, :maximum => 30
  validates_inclusion_of :sharing, :in => SHARINGS
  
  named_scope :named, lambda {|arg| { :conditions => ["LOWER(#{table_name}.name) = LOWER(?)", arg.to_s.strip]}}
  
  alias :destroy_without_reassign :destroy
  
  # Destroy the category
  # If a category is specified, issues are reassigned to this category
  def destroy(reassign_to = nil)
    if reassign_to && reassign_to.is_a?(IssueCategory) && reassign_to.project == self.project
      Issue.update_all("category_id = #{reassign_to.id}", "category_id = #{id}")
    end
    destroy_without_reassign
  end
  
  def <=>(category)
    name <=> category.name
  end
  
  def to_s; name end

  # Returns the sharings that +user+ can set the category to
  def allowed_sharings(user = User.current)
    SHARINGS.select do |s|
      if sharing == s
        true
      else
        case s
        when 'system'
          # Only admin users can set a systemwide sharing
          user.admin?
        when 'hierarchy', 'tree'
          # Only users allowed to manage versions of the root project can
          # set sharing to hierarchy or tree
          project.nil? || user.allowed_to?(:manage_versions, project.root)
        else
          true
        end
      end
    end
  end

  # Update the issue's fixed versions. Used if a version's sharing changes.
  def update_issues_from_sharing_change
    if sharing_changed?
      if SHARINGS.index(sharing_was).nil? ||
          SHARINGS.index(sharing).nil? ||
          SHARINGS.index(sharing_was) > SHARINGS.index(sharing)
        Issue.update_categories_from_sharing_change self
      end
    end
  end
end
