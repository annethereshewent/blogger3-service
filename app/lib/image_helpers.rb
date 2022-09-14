module ImageHelpers
  def get_image_url(image)
    Rails.application.routes.url_helpers.rails_blob_path image, only_path: true if image.present?
  end

  def decode_base64_image(base64_url)
    decoded_data = Base64.decode64(base64_url.split(',')[1])
    StringIO.new(decoded_data)
  end

  def get_content_type(base64_url)
    base64_url.split('data:')[1].split(';')[0]
  end

  def random_string
    @string ||= SecureRandom.urlsafe_base64
  end
end