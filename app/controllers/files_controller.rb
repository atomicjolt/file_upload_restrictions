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

# Parts of this file have been copied from Instructure's file located at
# https://github.com/instructure/canvas-lms/app/controllers/enrollments_api_controller.rb


require_dependency "app/controllers/files_controller"

FILE_SIZE_ENGINE_ROOT = CanvasFileSize::Engine.root

class FilesController
  unmodified_upload = instance_method(:api_create)
  # @@errors[:too_large_max_size] ||= 'File size of upload is too large for account maximum'

  # alias :unmodified_create_pending :create_pending
  define_method(:api_create) do
  # def create_pending
    # errors = []
    byebug
    @context = Context.find_by_asset_string(params[:attachment][:context_code])
    size_limit = @context&.account.settings[:max_file_size]

    if (file_size_plugin = Canvas::Plugin.find("canvas_file_size")) && file_size_plugin.enabled?
      if !(Account::Settings.file_type_restrictions.include? File.extname(params[:attachment][:filename]).delete_prefix("."))
        render status: :bad_request, json: {
          message: "File type not allowed for upload"
        }
        return
      end
      if ((size_limit * 1024 * 1024) <= params[:attachment][:size])
        render status: :bad_request, json: {
          message: "File size of upload is larger than account maximum setting"
        }
        return
      end
    end
    unmodified_upload.bind(self).()
  end

end
