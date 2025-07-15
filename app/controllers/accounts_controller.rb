# Copyright (C) 2017 Atomic Jolt

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Parts of this file have been copied from Instructure's file located at
# https://github.com/instructure/canvas-lms/app/controllers/enrollments_api_controller.rb


require_dependency "app/controllers/accounts_controller"
require "byebug"


FILE_SIZE_ENGINE_ROOT = CanvasFileSize::Engine.root

class AccountsController
  # unmodified_update = instance_method(:update)
  alias unmodified_permitted_account_attributes permitted_account_attributes
  alias ORIG_PERMITTED_SETTINGS_FOR_UPDATE PERMITTED_SETTINGS_FOR_UPDATE
  if (file_size_plugin = Canvas::Plugin.find("canvas_file_size")) && file_size_plugin.enabled?
    debugger
    byebug
    pry
    PERMITTED_SETTINGS_FOR_UPDATE=[:max_file_size,].union(ORIG_PERMITTED_SETTINGS_FOR_UPDATE)
  end

  def permitted_account_attributes
    byebug
    debugger
    if (file_size_plugin = Canvas::Plugin.find("canvas_file_size")) && file_size_plugin.enabled?
      [:max_file_size].union(unmodified_permitted_account_attributes)
    else
      unmodified_permitted_account_attributes
    end
  end

  # define_method(:update) do
  #   if (file_size_plugin = Canvas::Plugin.find("canvas_file_size")) && file_size_plugin.enabled?
  #     return update_api if api_request?
  #   end
  #   unmodified_update.bind(self).()
  # end

end
