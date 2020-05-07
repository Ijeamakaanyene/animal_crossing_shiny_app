villagers = readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-05/villagers.csv')
items = readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-05/items.csv')


library(dplyr)

villagers = villagers %>%
  mutate(birthday = paste0(birthday, "-", 2020),
         birthday_full = lubridate::mdy(birthday), 
         birthday_stylized = paste0(lubridate::month(birthday_full, label = TRUE), " ", 
                                    lubridate::day(birthday_full)))

villages_data = villagers %>%
  dplyr::select(name, gender, species, personality, song, phrase,
                url, birthday_stylized)

items_data = items %>%
  dplyr::select(name, category, sell_value, buy_value)


#readr::write_rds(villages_data, 
                 #here::here("Data", "villagers_data.rds"))
#readr::write_rds(items_data,
 #                here::here("Data", "items_data.rds"))

