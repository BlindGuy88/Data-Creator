module Const
  class TypeName
    Date = "Date"
    Boolean = "Boolean"
    Text = "Text"
    Number = "Number"
  end
  class ThemeName
    PersonName = "Person Name"
    StreetName = "Street Name"
    Address = "Person Address"
    PhoneNumber = "Phone Number"
    EmailName = "Email Name"
    CompanyName = "Company Name"
    LoremIpsum = "Lorem Ipsum"
    Year = "Year"
    Month = "Month"
    BirthDate = "Birth Date"
    Random = "Random"
    CCExpired = "Credit Card"
    TrueFalse = "True/False"
    Increment = "Increment"
    True = "True"
    False = "False"
    StringTheme = [PersonName, StreetName, Address, EmailName, CompanyName, LoremIpsum]
    NumberTheme = [PhoneNumber, Increment, Random]
    DateTheme = [BirthDate, CCExpired]
    BooleanTheme = [TrueFalse,True,False]
  end

  class Theme
    AvailableTheme =
        {
        "Text"=>ThemeName::StringTheme,
        "Number"=>ThemeName::NumberTheme,
        "Date"=>ThemeName::DateTheme,
        "Boolean"=>ThemeName::BooleanTheme
        }
  end


end
