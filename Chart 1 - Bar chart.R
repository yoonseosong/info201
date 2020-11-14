# load packages 
library(tidyverse)

# import tables
hc <- read.csv("https://www.ahrq.gov/sites/default/files/wysiwyg/chsp/compendium/chsp-compendium-2018.csv")
dg <- read.csv("https://www2.census.gov/programs-surveys/popest/tables/2010-2019/state/asrh/sc-est2019-alldata5.csv")

# convert state names to state abbreviations
dg <- dg %>% 
  mutate(state = state.abb[match(NAME, state.name)])

# sum of medics by state
sum_total_mds <- hc %>%
  group_by(health_sys_state) %>%
  summarize(sum_total_mds = sum(total_mds, na.rm = T)) %>% 
  rename(state = health_sys_state)

# population by state
state_pop_2018 <- dg %>% 
  group_by(state) %>% 
  summarize(pop = sum(POPESTIMATE2018, na.rm = T))

# join sum_total_mds and state_pop_2018
# and calculating ratio of medics to population
mds_and_pop <- left_join(sum_total_mds, state_pop_2018) %>% 
  mutate(ratio = sum_total_mds/pop)

# state with min ratio
min_ratio_state <- mds_and_pop %>% 
  filter(ratio == min(ratio, na.rm = T)) %>% 
  pull(state)

# state with min ratio demographics
min_ratio_state_dg <- dg %>% 
  group_by(state, RACE) %>% 
  summarize(pop = sum(POPESTIMATE2018, na.rm = T)) %>% 
  filter(state == min_ratio_state)

# graph of state weith min ratio demographics
min_ratio_state_plot <- ggplot(min_ratio_state_dg, aes(x="", y=pop, fill=as.factor(RACE)))+
  geom_bar(width = 1, stat = "identity") +
  xlab("") +
  ylab("Population") +
  ggtitle(paste("Demographics of", min_ratio_state)) +
  labs(fill = "Race") +
  scale_fill_discrete(labels=c("White", "Black", "American Indian", "Asian", "Pacific Islander"))
 
  