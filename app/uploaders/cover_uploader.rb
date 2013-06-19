# encoding: utf-8

class CoverUploader < ImageUploader
  
  def store_dir
    "uploads/covers/#{model.class.to_s.underscore}/#{model.id}"
  end
  
  process convert: 'png'

  def filename
    @name ||= "#{secure_filename}.png" if original_filename
  end
end
