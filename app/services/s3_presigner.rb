class S3Presigner

  def self.presign(limit: limit)
    aws        = AppConfig['aws']
    filename   = "#{SecureRandom.uuid}.xml"
    upload_key = Pathname.new(aws['s3_path']).join(filename).to_s

    creds      = Aws::Credentials.new(aws['access_key_id'], aws['secret_access_key'])
    s3         = Aws::S3::Resource.new(region: aws['region'], credentials: creds)
    obj        = s3.bucket(aws['s3_bucket']).object(upload_key)

    params = { acl: 'public-read' }
    params[:content_length] = limit if limit

    return {
      url: obj.presigned_url(:put, params),
      resource_url:  obj.public_url
    }
  end

end
