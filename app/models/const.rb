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
    StringTheme = [PersonName, StreetName, Address, EmailName, CompanyName, LoremIpsum]
    NumberTheme = [PhoneNumber, Year]
    DateTheme = [BirthDate, Random]
  end

  class Theme
    AvailableTheme =
        {
        "Text"=>["Person Name", "Person Address", "Email", "Lorem Ipsum", "Month"],
        "Number"=>["Phone Number", "Cell Phone","Month","Year", "Random"],
        "Date Time"=>["Birth Date (w/o Time)","Random", "Birth Date"],
        "Boolean"=>["True/False"]
        }
  end


end
