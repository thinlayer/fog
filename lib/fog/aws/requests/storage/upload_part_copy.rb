module Fog
  module Storage
    class AWS
      class Real

        # Upload a part for a multipart upload from an existing bucket using the copy directive
        #
        # ==== Parameters
        # * bucket_name<~String> - Name of bucket to add part to
        # * object_name<~String> - Name of object to add part to
        # * upload_id<~String> - Id of upload to add part to
        # * part_number<~String> - Index of part in upload
        # * source_bucket<~String> - Name of source bucket where source object resides
        # * source_object<~String> - Name of source object to copy
        # * options<~Hash>:
        #   * 'x-amz-source-range'<~String> - Range of bytes to copy from source object
        #   * 'x-amz-copy-source-if-match'<~String> - Copies object if its etag matches this value
        #   * 'x-amz-copy-source-if-modified_since'<~Time> - Copies object it it has been modified since this time
        #   * 'x-amz-copy-source-if-none-match'<~String> - Copies object if its etag does not match this value
        #   * 'x-amz-copy-source-if-unmodified-since'<~Time> - Copies object it it has not been modified since this time
        #   * 'version_id'<~String> - Copy if source is modified since this date
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * headers<~Hash>:
        #     * 'x-amz-copy-source-version-id'<~String> - The version id of the source object that was copied
        #     * 'x-amz-server-side-encryption'<~String> - The encryption algorithm used by Amazon to encrypt this part
        #   * body<~Hash>:
        #     * 'ETag'<~String> - Etag of the new part
        #     * 'LastModified'<~String> - Date the part was last modified
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/mpUploadUploadPartCopy.html
        #
        def upload_part_copy(bucket_name, object_name, upload_id, part_number, source_bucket, source_object, options = {})
          source_path = "/#{source_bucket}/#{CGI.escape(source_object)}"
          source_path += "?versionId=#{version_id}" if options.delete(:version_id)
          headers = options
          headers['x-amz-copy-source'] = source_path
          request({
            :expects    => 200,
            :idempotent => true,
            :headers    => headers,
            :host       => "#{bucket_name}.#{@host}",
            :method     => 'PUT',
            :path       => CGI.escape(object_name),
            :query      => {'uploadId' => upload_id, 'partNumber' => part_number}
          })
        end

      end # Real
    end # Storage
  end # AWS
end # Fog
