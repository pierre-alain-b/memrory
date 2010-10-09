module NeuronsHelper
  
  def file_icon_image(upload,size='48px')
    extension = File.extname(upload.file_name).downcase
    if extension.length > 0
      extension = extension[1,10]
    end
    
    if Asset::ICONS.include?(extension)
      if !(upload.document.content_type =~ /^image.*/).nil?
        image_tag(upload.document.url(:thumb))
      else
        image_tag("file_icons/#{size}/#{extension}.png", :class => "file_icon #{extension}")
      end
    else
      image_tag("file_icons/#{size}/_blank.png")
    end
  end
  
end
