module ApplicationHelper

  def image_server
    array = ["/assets/bkgrnd1.jpg", "/assets/bkgrnd2.jpg"]
    return array.sample
  end
end
