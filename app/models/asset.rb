class Asset < ActiveRecord::Base
  
  #List of icons available in public/images/file_icons
  ICONS = %w(aac ai aiff avi bmp c cpp css dat dmg doc dotx dwg dxf eps exe flv gif h hpp html ics iso java jpg key mid mp3 mp4 mpg odf ods odt otp ots ott pdf php png ppt psd py qt rar rb rtf sql tga tgz tiff txt wav xls xlsx xml yml zip)
  
  belongs_to :neuron
  has_attached_file :document, #, :path => ":rails_root/assets/:id/:style/:filename"
  :styles =>  {
    :thumb=> "100x100#"
  }
  
  before_post_process :image?
  validates_attachment_size :document, :less_than => 5.megabytes
  validates_attachment_presence :document  
  
  def image?
    !(document_content_type =~ /^image.*/).nil?
  end
  
  def file_name
    document_file_name
  end

  def file_size
    document_file_size
  end
end
