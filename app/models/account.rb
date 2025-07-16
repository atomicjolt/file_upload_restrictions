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


require_dependency "app/models/account"

FILE_SIZE_ENGINE_ROOT = CanvasFileSize::Engine.root

Account.class_eval do
  include Context
  include ::Account::Settings
  include ::Csp::AccountHelper

  add_setting: :max_file_size, inheritable: true
end
