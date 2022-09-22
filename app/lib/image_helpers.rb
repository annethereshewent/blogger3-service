require 'net/http'
require 'streamio-ffmpeg'

module ImageHelpers
  def get_image_url(image)
    Rails.application.routes.url_helpers.rails_blob_url image, host: ENV["BLOGGER_BASE"] if image.present?
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

  def convert_gif_to_mp4(gif_url)
    movie = FFMPEG::Movie.new(gif_url)

    filename = "#{SecureRandom.urlsafe_base64}.mp4"
    output_path = Rails.root.join("tmp", "storage", filename).to_s

    movie.transcode(output_path)

    [output_path, filename]
  end
end