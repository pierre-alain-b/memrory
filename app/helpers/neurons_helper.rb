module NeuronsHelper
  
  #Use the appropriate icon image
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
  
  # Transform the list of labels in a list of links to display neurons with same label
  def display_labels(strLabels)
    unless strLabels.nil?
    labels = ""
    strArray = strLabels.split(",")
    strArray.each { |label|
      label=label.strip
      labels = labels.to_str + link_to(label.to_str, :controller=>"neurons", :action=>"label", :id=>label.to_str) + " "
    }
    labels
    else
      ""
    end
  end
  
end
