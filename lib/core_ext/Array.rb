class Array
  def contains_hash_with_key_value? key, value
    each do |hash|
      return true if hash.has_key?(key) && hash[key] == value
    end
    false
  end
  
  def get_hash_with_key_value key, value
    each do |hash|
      return hash if hash.has_key?(key) && hash[key] == value
    end
    nil
  end
end