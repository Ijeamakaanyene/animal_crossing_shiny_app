species_available = function(personality_selected, df) {
  # Takes in a personality and returns the species available as a vector
  
  species_available = df %>%
    dplyr::filter(personality == !!personality_selected) %>%
    dplyr::select(species) %>%
    unique() %>%
    unlist() %>%
    unname()
  
  return(species_available)
  
}

characters_available = function(species_selected, personality_selected, df){
  # Takes in the species selected and returns the available characters as a dataframe
  
  characters_available = df %>%
    dplyr::filter(personality == !!personality_selected,
           species == !!species_selected) %>%
    dplyr::select(name, gender, song, phrase, url)
  
  return(characters_available)
  
}


generate_character = function(characters_available_df){
  
  character_selected = characters_available_df %>%
    dplyr::sample_n(size = 1) %>%
    dplyr::select(url, name, gender, song, phrase)
    
  colnames(character_selected) = c("Image", "Name", "Gender", "Song",
                                   "Phrase")

  
  character_selected = character_selected %>%
    tidyr::pivot_longer(everything(),
                        names_to = "Persona Type",
                        values_to = "Persona Info") %>%
    gt::gt() %>%
    gt::tab_header(title = "Your Animal Crossing Persona") %>%
    gt::text_transform(
      locations = cells_body(vars(`Persona Info`)),
      fn = function(x){
        ifelse(
          grepl("https", x),
          web_image(url = x, height = 100),
          x)
      }
    )
  
  return(character_selected)
  
}
