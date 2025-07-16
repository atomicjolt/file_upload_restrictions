# Copyright (C) 2022 Atomic Jolt

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

module CanvasFileSize
  NAME = "Canvas File Size".freeze
  DISPLAY_NAME = "Canvas File Size".freeze
  DESCRIPTION = "Enables custom file restrictions".freeze

  class Engine < ::Rails::Engine
    config.paths["lib"].eager_load!
    config.paths["app/models"].eager_load!

    config.to_prepare do
      Canvas::Plugin.register(
        :canvas_file_size,
        nil,
        name: -> { I18n.t(:canvas_file_size_name, NAME) },
        display_name: -> { I18n.t :canvas_file_size_display, DISPLAY_NAME },
        author: "Atomic Jolt",
        author_website: "http://www.atomicjolt.com/",
        description: -> { t(:description, DESCRIPTION) },
        version: CanvasFileSize::Version,
        settings_partial: 'canvas_file_size/plugin_settings',
        settings: {
          global_max_file_size: nil,
          allowed_file_types: nil
        }
      )

      default_allowed_file_types = ["js","html","imscc","zip","xml"]
      if ActiveRecord::Base.connection.table_exists?('plugin_settings') && Canvas::Plugin.find(:canvas_file_size).enabled?
        ActiveSupport.on_load(:action_controller) do
          # Prepend the engine's view path to the front of the lookup paths to use custom "_additional_settings" partial
          prepend_view_path CanvasFileSize::Engine.root.join('app', 'views')
        end
        Account::Settings.define_singleton_method :file_type_restrictions do
          @plugin ||= PluginSetting.find_by(name: "canvas_file_size")
          # max_file_size=@plugin.settings[:global_max_file_size].present? ? @plugin.settings[:global_max_file_size].to_i : nil
          allowed_file_types=@plugin.settings[:allowed_file_types].present? ? @plugin.settings[:allowed_file_types].downcase.split(',').union(default_allowed_file_types) : default_allowed_file_types
          allowed_file_types
        end
      end

    end
  end
end
