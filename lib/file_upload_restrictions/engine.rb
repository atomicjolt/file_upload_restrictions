# Copyright (C) 2025 Atomic Jolt

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

module FileUploadRestrictions
  NAME = "File Upload Restrictions".freeze
  DISPLAY_NAME = "File Upload Restrictions".freeze
  DESCRIPTION = "Enables custom file restrictions".freeze

  class Engine < ::Rails::Engine
    isolate_namespace FileUploadRestrictions

    config.paths["lib"].eager_load!
    config.paths["app/models"].eager_load!

    config.to_prepare do
      Canvas::Plugin.register(
        :file_upload_restrictions,
        nil,
        name: -> { I18n.t(:file_upload_restrictions_name, NAME) },
        display_name: -> { I18n.t :file_upload_restrictions_display, DISPLAY_NAME },
        author: "Atomic Jolt",
        author_website: "http://www.atomicjolt.com/",
        description: -> { t(:description, DESCRIPTION) },
        version: FileUploadRestrictions::Version,
        settings_partial: 'file_upload_restrictions/plugin_settings',
        settings: {
          global_max_file_size: nil,
          allowed_file_types: nil,
          file_type_error_message: nil
        }
      )

      if defined?(::FilesController) && Canvas::Plugin.find(:file_upload_restrictions).enabled? && (Canvas::Plugin.find(:file_upload_restrictions).settings[:enable_file_types] == "true")
        unless ::FilesController.ancestors.include?(FileUploadRestrictions::FilesControllerOverrides)
          ::FilesController.prepend FileUploadRestrictions::FilesControllerOverrides
          puts "Prepended FileUploadRestrictions::FilesControllerOverrides to FilesController."
        end
      end

      if defined?(::AccountsController) && Canvas::Plugin.find(:file_upload_restrictions).enabled?
        unless ::AccountsController.ancestors.include?(FileUploadRestrictions::AccountsControllerOverrides)
          ::AccountsController.prepend FileUploadRestrictions::AccountsControllerOverrides
          puts "Prepended FileUploadRestrictions::AccountsControllerOverrides to AccountsController."
        end

        ::AccountsController.class_eval do
          if const_defined?(:PERMITTED_SETTINGS_FOR_UPDATE)
            current_settings = const_get(:PERMITTED_SETTINGS_FOR_UPDATE)
            unfrozen_settings = current_settings.dup
            unless unfrozen_settings.include?(:max_file_size)
              updated_settings = unfrozen_settings | [{ max_file_size: [:value, :locked] }.freeze]
              remove_const(:PERMITTED_SETTINGS_FOR_UPDATE)
              const_set(:PERMITTED_SETTINGS_FOR_UPDATE, updated_settings.freeze)
              puts "Added :max_file_size to PERMITTED_SETTINGS_FOR_UPDATE"
            end
          end
        end
      end

      if defined?(::Account) && Canvas::Plugin.find(:file_upload_restrictions).enabled?
        unless ::Account.ancestors.include?(FileUploadRestrictions::AccountsModelOverrides)
          ::Account.prepend FileUploadRestrictions::AccountsModelOverrides
          puts "Prepended FileUploadRestrictions::AccountsModelOverrides to Account model."
        end
      end

      if ActiveRecord::Base.connection.table_exists?('plugin_settings') && Canvas::Plugin.find(:file_upload_restrictions).enabled?
        @plugin ||= PluginSetting.find_by(name: "file_upload_restrictions")
        if @plugin.settings[:enable_max_file_size] == "true"
          ActiveSupport.on_load(:action_controller) do
            # Prepend the engine's view path to the front of the lookup paths to use custom "_additional_settings" partial
            prepend_view_path FileUploadRestrictions::Engine.root.join('app', 'views')
          end
        end
        if @plugin.settings[:enable_file_types] == "true"
          Account::Settings.define_singleton_method :file_type_restrictions do
            @plugin ||= PluginSetting.find_by(name: "file_upload_restrictions")
            default_allowed_file_types = ["js","html","imscc","zip","xml"]
            allowed_file_types=@plugin.settings[:allowed_file_types].present? ? @plugin.settings[:allowed_file_types].downcase.split(',').union(default_allowed_file_types) : default_allowed_file_types
            allowed_file_types
          end
        end
      end

    end
  end
end
