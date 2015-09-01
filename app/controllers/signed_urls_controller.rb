class SignedUrlsController < BaseController

  def create
    render json: S3Presigner.presign(AppConfig['aws']['s3_path'], params[:filename])
  end

end
