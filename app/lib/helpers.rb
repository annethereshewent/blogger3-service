module Helpers
  def get_image_url(image) 
    Rails.application.routes.url_helpers.rails_blob_path image, only_path: true if image.present? 
  end
end