module CommonMethod
    def put_to_common_type(type)
      result = ""
      number_types = ["int","integer","double","float","decimal","shortint","long","longint","real"]
      text_types = ["string","varchar"]
      date_types = ["date","datetime"]
      boolean_types = ["boolean","bool"]
      class_types = ["class"]
      lower_type = type.downcase
      if number_types.include? lower_type
        result = Const::TypeName::Number
      end
      if text_types.include? lower_type
        result = Const::TypeName::Text
      end
      if date_types.include? lower_type
        result = Const::TypeName::Date
      end
      if boolean_types.include? lower_type
        result = Const::TypeName::Boolean
      end
      if class_types.include? lower_type
        result = "Class"
      end
      return result
    end

  def create_random_theme(type)
    result = ''
    case type
      when Const::TypeName::Text
        result = Const::ThemeName::StringTheme[rand(Const::ThemeName::StringTheme.length)]
      when Const::TypeName::Number
        result = Const::ThemeName::NumberTheme[rand(Const::ThemeName::NumberTheme.length)]
      when Const::TypeName::Date
        result = Const::ThemeName::DateTheme[rand(Const::ThemeName::DateTheme.length)]
      when Const::TypeName::Boolean
        result = Const::ThemeName::BooleanTheme[rand(Const::ThemeName::BooleanTheme.length)]

    end
    return result
  end

end