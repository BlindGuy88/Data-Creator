module Const
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
    Date = "Date"
    BirthDate = "Birth Date"
    Random = "Random"
    CCExpired = "Credit Card"
    StringTheme = [PersonName, StreetName, Address, EmailName, CompanyName, LoremIpsum]
    NumberTheme = [PhoneNumber, Year]
    DateTheme = [BirthDate, CCExpired,Random]
  end

  class Theme
    AvailableTheme =
        {
        "Text"=>ThemeName::StringTheme,
        "Number"=>ThemeName::NumberTheme,
        "Date"=>ThemeName::DateTheme,
        "Boolean"=>["True/False"]
        }
  end


end
