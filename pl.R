## importing data from source
getwd()
install.packages("tidyverse")
library(tidyverse)

season18 <-read_csv("season-1819_csv.csv")
view(season18)
season18<-season18[,-23:-61]

view(season18)
season18<-season18 %>%
  rename(FT_HomeTeam_Goals=FTHG,FT_AwayTeam_Goals=FTAG,FT_Result=FTR)%>%
  rename(HT_HomeTeam_Goals=HTHG,HT_AwayTeam_Goals=HTAG,HT_Result=HTR)%>%
  rename(HomeTeam_Shorts=HS,AwayTeam_Shorts=AS,Shorts_on_Target_Hometeam=HST,Red_Cards_Away=AR)%>%
  rename(Shots_on_Target_Awayteam=AST,Foul_Home_Team=HF,Foul_Away_Team_=AF)%>%
  rename(Cornors_Taken_Home_team=HC,Cornors_Taken_Away_team=AC)%>%
  rename(Yellow_Cards_Home=HY,Yellow_Cards_Away=AY,Red_Cards_Home=HR)


view(season18)

## -- team won at home  
won_at_home<-season18 %>%
  filter(FT_Result=="H")%>%
  select(HomeTeam)%>%
  arrange(HomeTeam)%>%
  rename(Team=HomeTeam)%>%
  group_by(Team)%>%
  summarise(matches_won_at_home=n())
view(won_at_home)



## -- team won at Away 
won_away_from_home<-season18 %>%
  filter(FT_Result=="A")%>%
  select(AwayTeam)%>%
  arrange(AwayTeam)%>%
  rename(Team=AwayTeam)%>%
  group_by(Team)%>%
  summarise(matches_won_away=n())

view( won_away_from_home)

## -- team drawn away from home 
drawn_away_from_home<-season18 %>%
  filter(FT_Result=="D")%>%
  select(AwayTeam)%>%
  arrange(AwayTeam)%>%
  rename(Team=AwayTeam)%>%
  group_by(Team)%>%
  summarise(matches_drawn_away=n())
view(drawn_away_from_home)


Tottenham<-c("Tottenham",0)
drawn_away_from_home<-rbind(drawn_away_from_home,Tottenham)
drawn_away_from_home<- drawn_away_from_home%>%
  arrange(Team)
view(drawn_away_from_home)

## team drawn at home
draws_at_home<-season18 %>%
  filter(FT_Result=="D")%>%
  select(HomeTeam)%>%
  arrange(HomeTeam)%>%
  rename(Team=HomeTeam)%>%
  group_by(Team)%>%
  summarise(matches_drawn_at_home=n())
view(draws_at_home)

man_city<-c("Man City",0)
draws_at_home<-rbind( draws_at_home,man_city)
draws_at_home<-draws_at_home%>%
  arrange(Team)
view(draws_at_home)



## binding details so far
details<-cbind(won_at_home,won_away_from_home,draws_at_home,drawn_away_from_home)
view(details)
details<-details[,-3]
details<-details[,-4]
details<-details[,-5]

view(details)


## matches lost
## lost match details

lost<-season18%>%
  select(HomeTeam,AwayTeam,FT_Result)

lost<-lost%>%
  filter(FT_Result=="A")
view(lost)

## lost at home
lost_at_home<-lost%>%
  select(HomeTeam)%>%
  arrange(HomeTeam)%>%
  rename(Team=HomeTeam)%>%
  group_by(Team)%>%
  summarise(matches_lost_at_home=n())
view(lost_at_home)


lost_at_home<-lost_at_home%>%
  filter(matches_lost_at_home!=0)
view(lost_at_home)

liverpool<-c("Liverpool",0)
lost_at_home<-rbind(lost_at_home,liverpool)
lost_at_home<- lost_at_home%>%
  arrange(Team)
view(lost_at_home)

## lost away
lost<-season18%>%
  select(HomeTeam,AwayTeam,FT_Result)

lost<-lost%>%
  filter(FT_Result=="H")
view(lost)

lost_at_away<-lost%>%
  select(AwayTeam)%>%
  arrange(AwayTeam)%>%
  rename(Team=AwayTeam)%>%
  group_by(Team)%>%
  summarise(matches_lost_away=n())
view(lost_at_away)

## binding the data
binding<-cbind(lost_at_home,lost_at_away)
view(binding)

binding<-binding[,-3]

##binding to details
details<-cbind(details,binding)
view(details)

details<-details[,-6]
view(details)




## goals scored at home
goals<-season18%>%
  select(HomeTeam,FT_HomeTeam_Goals)%>%
  arrange(HomeTeam)%>%
  rename(Team=HomeTeam)%>%
  group_by(Team)%>%
  summarise(goals_scored_at_home=sum(FT_HomeTeam_Goals))
view(goals)

## goals conceded at home
goal_conceded<-season18%>%
  select(HomeTeam,FT_AwayTeam_Goals)%>%
  arrange(HomeTeam)%>%
  rename(Team=HomeTeam)%>%
  group_by(Team)%>%
  summarise(goals_conceded_at_home=sum(FT_AwayTeam_Goals))
view(goal_conceded)

## goals scored away
goal_away<-season18%>%
  select(AwayTeam,FT_AwayTeam_Goals)%>%
  arrange(AwayTeam)%>%
  rename(Team=AwayTeam)%>%
  group_by(Team)%>%
  summarise(goals_scored_away=sum(FT_AwayTeam_Goals))
view(goal_away)

## goals conceded away
goals_con_away<-season18%>%
  select(AwayTeam,FT_HomeTeam_Goals)%>%
  arrange(AwayTeam)%>%
  rename(Team=AwayTeam)%>%
  group_by(Team)%>%
  summarise(goals_conceded_away=sum(FT_HomeTeam_Goals))
view(goals_con_away)

## binding these details together 
goal_details<-cbind(goals,goal_conceded,goal_away,goals_con_away)
view(goal_details)

goal_details<-goal_details[-3]
goal_details<-goal_details[-4]
goal_details<-goal_details[-5]

##  getting total goals scored,conceded at home & away

goal_details<-goal_details%>%
  mutate(total_goals_scored=goals_scored_at_home+goals_scored_away)%>%
  mutate(total_goals_concede=goals_conceded_at_home+goals_conceded_away)
view(goal_details)

## goal difference
goal_details<-goal_details%>%
  mutate(goal_difference=total_goals_scored-total_goals_concede)
view(goal_details)


## combining with main details
details<-cbind(details,goal_details)
view(details)

details<-details[-8]



## all about shots

## shots at home
shorts<-season18%>%
  select(HomeTeam,HomeTeam_Shorts)%>%
  rename(Team=HomeTeam)%>%
  arrange(Team)%>%
  group_by(Team)%>%
  summarise(total_shots_at_home=sum(HomeTeam_Shorts))
view(shorts)

## shots on target at home

shots_on_target<-season18%>%
  select(HomeTeam,Shorts_on_Target_Hometeam)%>%
  rename(Team=HomeTeam)%>%
  arrange(Team)%>%
  group_by(Team)%>%
  summarise( total_shots_on_target_at_home=sum(Shorts_on_Target_Hometeam))
view(shots_on_target)           

## shots at Away
shots_away<-season18%>%
  select(AwayTeam,AwayTeam_Shorts)%>%
  rename(Team=AwayTeam)%>%
  arrange(Team)%>%
  group_by(Team)%>%
  summarise(total_shots_at_Away=sum(AwayTeam_Shorts))
view(shots_away)

## shots on target at Away
shots_on_target_away<-season18%>%
  select(AwayTeam,Shots_on_Target_Awayteam)%>%
  rename(Team=AwayTeam)%>%
  arrange(Team)%>%
  group_by(Team)%>%
  summarise(total_shots_on_target_at_away=sum(Shots_on_Target_Awayteam))
view(shots_on_target_away)

## binding all data
shots_details<- cbind(shorts,shots_on_target,shots_away,shots_on_target_away)
view(shots_details)
shots_details<-shots_details[-3]
shots_details<-shots_details[-4]
shots_details<-shots_details[-5]
view(shots_details)

shots_details<-shots_details%>%
  mutate(total_shots=total_shots_at_home+total_shots_at_Away)%>%
  mutate(total_shots_on_target=total_shots_on_target_at_home+total_shots_on_target_at_away)
view(shots_details)

details<-cbind(details,shots_details)
view(details)

details<-details[-15]


## other details of season

fouls_at_home<-season18%>%
  select(HomeTeam,Foul_Home_Team)%>%
  rename(Team=HomeTeam)%>%
  arrange(Team)%>%
  group_by(Team)%>%
  summarise(fouls_home=sum(Foul_Home_Team))
view(fouls_at_home)

## fouls at away
fouls_at_away<-season18%>%
  select(AwayTeam,Foul_Away_Team_)%>%
  rename(Team=AwayTeam)%>%
  arrange(Team)%>%
  group_by(Team)%>%
  summarise(fouls_away=sum(Foul_Away_Team_))
view(fouls_at_away)

## bind fouls
foul_details<-cbind(fouls_at_home,fouls_at_away)
view(foul_details)
foul_details<-foul_details[-3]

## total fouls
foul_details<-foul_details%>%
  mutate(total_fouls=fouls_home+fouls_away)
view(foul_details)



## cornor detail
## At home
cornors_at_home<-season18%>%
  select(HomeTeam,Cornors_Taken_Home_team)%>%
  rename(Team=HomeTeam)%>%
  arrange(Team)%>%
  group_by(Team)%>%
  summarise(cornors_home=sum(Cornors_Taken_Home_team))
view(cornors_at_home)

## cornors away
cornors_at_Away<-season18%>%
  select(AwayTeam,Cornors_Taken_Away_team)%>%
  rename(Team=AwayTeam)%>%
  arrange(Team)%>%
  group_by(Team)%>%
  summarise(cornors_away=sum(Cornors_Taken_Away_team))
view(cornors_at_Away)

## bind cornors
cornors<-cbind(cornors_at_home,cornors_at_Away)
cornors<-cornors[-3]
view(cornors)

cornors<-cornors%>%
  mutate(total_cornors_taken=cornors_home+cornors_away)
view(cornors)


## binding foul and cornor details
fc_details<-cbind(foul_details,cornors)
view(fc_details)
fc_details<-fc_details[-5]

##bind all details
details<-cbind(details,fc_details)
view(details)
details<-details[-21]



## yellow and red cards

yellowcards_at_home<-season18%>%
  select(HomeTeam,Yellow_Cards_Home)%>%
  rename(Team=HomeTeam)%>%
  arrange(Team)%>%
  group_by(Team)%>%
  summarise(yellow_cards_home=sum(Yellow_Cards_Home))
view(yellowcards_at_home)

yellowcards_at_away<-season18%>%
  select(AwayTeam,Yellow_Cards_Away)%>%
  rename(Team=AwayTeam)%>%
  arrange(Team)%>%
  group_by(Team)%>%
  summarise(yellow_cards_away=sum(Yellow_Cards_Away))
view(yellowcards_at_away)

y_card<-cbind(yellowcards_at_home,yellowcards_at_away)
view(y_card)
y_card<-y_card[-3]

y_card<-y_card%>%
  mutate(total_yellow_cards=yellow_cards_home+yellow_cards_away)

## red cards home
finding_red_home<-season18%>%
  select(HomeTeam,Red_Cards_Home)%>%
  rename(Team=HomeTeam)%>%
  group_by(Team)%>%
  summarise(total_red_cards_at_home=sum(Red_Cards_Home))
view(finding_red_home)

## red cards away
finding_red_away<-season18%>%
  select(AwayTeam,Red_Cards_Away)%>%
  rename(Team=AwayTeam)%>%
  group_by(Team)%>%
  summarise(total_red_cards_away=sum(Red_Cards_Away))

view(finding_red_away)

red_details<-cbind(finding_red_home,finding_red_away)
view(red_details)

red_details<-red_details[-3]
red_details<-red_details%>%
  mutate(total_red_cards=total_red_cards_at_home+total_red_cards_away)

##joining red and yellow cards together
t_cards<-cbind(y_card,red_details)
t_cards<-t_cards[-5]
## binding with details

details<-cbind(details,t_cards)
details<-details[-27]

view(details)


