module FileUploadRestrictions
  module AccountsModelOverrides
    extend ActiveSupport::Concern

    prepended do
      if respond_to?(:add_setting) && Canvas::Plugin.find(:file_upload_restrictions).enabled?
        add_setting :max_file_size, inheritable: true
        puts "FileUploadRestrictions: Added 'max_file_size' setting to Account model."
      else
        warn "[FileUploadRestrictions] Warning: Account model does not respond to 'add_setting'. Skipping setting addition."
      end
    end
  end
end
