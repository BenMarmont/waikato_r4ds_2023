library(tidyverse)
library(ggthemes)

# 1) ----
#(12.5%) Download and import the data set, call it *education_data_raw*

# education_data_raw <- read_csv("Assessment 3/xAPI-Edu-Data.csv")
# similar or 
education_data_raw <- read_csv("https://raw.githubusercontent.com/BenMarmont/waikato_r4ds_2023/main/Assessment%20briefs/Assessment%203/xAPI-Edu-Data.csv")
colnames(education_data_raw)


# 2) ----
#(25%) Test if there are any missing values in the data set, if you find any, remove them. 
#       Then, tidy the data so that:
# * "PlaceofBirth" is called "place_of_birth" and only the first letter of each entry in this column is capitalised 
# * Repeat the previous step for "StageID" (call it stage_id, and change the capitalisation)
# * Change the names of "NationalITy" and "VisITedResources" to snake_case
# * Remove any duplicate columns resulting from the previous changes so that only the improved columns remain
# * Change gender to a factor
# * Call this tidied data set "education_data"
education_data_raw |> 
  is.na() |> 
  sum()

# or 

length(na.omit(education_data_raw))
length(education_data_raw)
# length is the same of when NAs are omitted and raw date, therefore no NA.

education_data <- education_data_raw %>% 
  mutate(
    place_of_birth = str_to_sentence(PlaceofBirth),
    stage_id = str_to_sentence(StageID)) %>% 
  rename(nationality = NationalITy,
         visited_resources = VisITedResources) %>% 
  select(-PlaceofBirth, -StageID) %>% 
  mutate(gender = as_factor(gender))
# the renames can also be achieved with a mutate followed by a select
# can be multiple steps rather than one piped chunk of code

# 3) ----
#(12.5%) Group the data by grade and topic then determine which group has the 
# highest total hand raises. You will first need to determine the total hand raises in each group.

colnames(education_data)

# You may notice I use 'colnames' a lot, I use it to quickly print (in console) 
# to copy into my code if they 
# have odd naming conventions I can't remember and autocomplete isn't behaving 

education_data %>% 
  group_by(GradeID, Topic) %>% 
  summarise(total_hand_raise_group = sum(raisedhands),
            student_count = n())  %>% 
  arrange(desc(total_hand_raise_group))

# 4) ----
# (12.5) Filter the data to only include 8th graders and then explore how subject 
# choice relates to average discussion participation. What is the average discussion 
# for each topic in this grade, AND how many students are in the group?

education_data %>% 
  filter(GradeID == "G-08") %>% 
  group_by(Topic) %>% 
  summarise(mean_discussion_participation = mean(Discussion),
            count_discussion_participation = n())

# 5) ----
#(12.5%) Create a model to determine how raisedhands impacts discussion group participation. Then pipe the model to plot it using "plot()".

lm(education_data$raisedhands ~ education_data$Discussion) %>% 
  plot()

# 6)  (25%) New Zealand classification 
  
#   1.  Write a csv called "nz_classifications" which converts the grades in the dataset to
#         how we classify schools in New Zealand (Primary, Intermediate and High)
#   2.  Add/join this to the existing "education_data" 
#   3.  Create a publication quality graph using ggplot to show the most popular topics in each NZ school type
      # -   Facet the graph
      # -   Apply appropriate theme
      # -   Title
      # -   Labels
      # -   Caption with the reference for the data

tibble(GradeID = c("G-01", "G-02", "G-03", "G-04", "G-05", "G-06", 
                    "G-07", "G-08", 
                    "G-09", "G-10", "G-11", "G-12", "G-13"),
       school_type = c("Primary School", "Primary School", "Primary School", "Primary School", "Primary School","Primary School",
                             "Intermediate School", "Intermediate School",
                             "High School", "High School", "High School", "High School","High School")) |> 
  write_csv("nz_classifications.csv")


nz_classifications <-  read_csv("nz_classifications.csv")

education_data
nz_classifications

education_data_for_plot <- left_join(education_data, nz_classifications, by = "GradeID")

nz_grouping <- education_data_for_plot %>%
  group_by(school_type, Topic) %>% 
  summarise(count = n())  


nz_grouping %>%   
  ggplot(aes(x = Topic, y = count)) + 
  geom_col()+
  facet_wrap(vars(school_type), nrow = 3, ncol = 1) +
  ggthemes::theme_clean() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Topic Popularity Under NZ School Classification",
       ylab = "Count",
       caption = "Data source: Amrieh et al, 2016 and Amrieh et al 2015") 

#     alternative layout

nz_grouping %>%   
  ggplot(aes(x = Topic, y = count)) + 
  geom_col()+
  facet_wrap(vars(school_type), nrow = 3, ncol = 1) +
  ggthemes::theme_clean() +
  # theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Topic Popularity Under NZ School Classification",
       ylab = "Count",
       caption = "Data source: Amrieh et al, 2016 and Amrieh et al 2015") + 
  coord_flip()


