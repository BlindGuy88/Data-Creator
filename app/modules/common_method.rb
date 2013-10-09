module CommonMethod
    def put_to_common_type(type)
      result = ""
      number_types = ["int","integer","double","float"]
      text_types = ["string","varchar"]
      date_types = ["date","datetime"]
      boolean_types = ["boolean","bool"]
      class_types = ["class"]
      lower_type = type.downcase
      if number_types.include? lower_type
        result = "Number"
      end
      if text_types.include? lower_type
        result = "Text"
      end
      if date_types.include? lower_type
        result = "Date"
      end
      if boolean_types.include? lower_type
        result = "Bool"
      end
      if class_types.include? lower_type
        result = "Class"
      end
      return result
    end

  def create_random_theme(type)
    result = ''
    case type.downcase
      when "text"
        result = Const::ThemeName::StringTheme[rand(Const::ThemeName::StringTheme.length)]
      when "number"
        result = Const::ThemeName::NumberTheme[rand(Const::ThemeName::NumberTheme.length)]
      when "date"
        result = Const::ThemeName::NumberTheme[rand(Const::ThemeName::NumberTheme.length)]
    end
    return result
  end

end