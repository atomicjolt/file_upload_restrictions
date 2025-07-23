module FileUploadRestrictions
  module FilesControllerOverrides
    extend ActiveSupport::Concern

      def api_create
        @policy, @attachment = Attachment.decode_policy(params[:Policy], params[:Signature])
        @context = @attachment.context
        size_limit = @context&.account ? @context&.account.max_file_size[:value].to_f : nil

        if (file_size_plugin = Canvas::Plugin.find("file_upload_restrictions")) && file_size_plugin.enabled? && (file_size_plugin.settings[:enable_file_types] == "true")
          if !(Account::Settings.file_type_restrictions.include? File.extname(params[:attachment][:uploaded_data].original_filename).delete_prefix("."))
            not_allowed = "File type not allowed for upload"
            render status: :bad_request, json: {
              errors: [message: not_allowed],
              message: not_allowed,
              text: not_allowed
            }
            return
          end
          # if (size_limit && ((size_limit * 1024 * 1024) <= params[:attachment][:size]))
          if (size_limit && ((size_limit * 1024 * 1024) <= params[:attachment][:uploaded_data].tempfile.size))
            render status: :bad_request, json: {
              message: "File size of upload is larger than account maximum setting"
            }
            return
          end
        end
        super
      end
  end
end
