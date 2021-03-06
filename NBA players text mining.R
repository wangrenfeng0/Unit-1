library(ggthemes) 
library(plotly)
library(magrittr)
library(ggplot2)
library(tidyr)
library(maps)
library(dplyr)
library(mapproj)
library(stringr)
library(naniar)
player = read.csv(file.choose(), header= TRUE)
head(player)
str(player)
player$heightsplit=str_split(player$height, '-')

for (i in 1:nrow(player)) 
{
   player$heightinch[i]=as.numeric(player$heightsplit[[i]][1])*12+as.numeric(player$heightsplit[[i]][2])
}

player$heightinch=unlist(player$heightinch)

s = sapply(player, function(x) sum(is.na(x)))

player %>% filter(is.na(player$heightinch))


player$heightinch=replace_na(player$heightinch, 74)

player$positionfact=as.factor(player$position)

player %>% filter(player$positionfact !='') %>% ggplot(aes(x=heightinch, fill=positionfact))+
  geom_histogram()+ggtitle('Players heights distributions of each position')+facet_wrap(~positionfact)

------------------------------------------

ggplot(player[player$position=='C' | player$position=='F',],aes(x=position, y=weight))+geom_boxplot()+ggtitle('Distribution of the weight of centers (C) and the distribution of the weight of forwards (F).')



#player$height_num=strsplit(player$height,'-')
player=separate(player,col=height,into=c('feet','inch'),sep='-', remove=TRUE)

class(player$feet)
player=mutate(player,height_inch=as.numeric(player$feet)*12+as.numeric(player$inch))
player


#for (i in 1:nrow(player)) 
#{
#    player$height_inch[[i]]=as.numeric(player$height_num[[i]][[1]])*12+as.numeric(player$height_num[[i]][[2]])
#}
#player

p=ggplot(player[player$position=='C' | player$position=='F',],aes(x=position, y=height_inch))+
  geom_boxplot()+ggtitle('Distribution of the height of centers (C) and the distribution of the height of forwards (F).')


ggplotly(p)

p=ggplot(player,aes(x=position, y=height_inch))+
  geom_boxplot()
ggplotly(p)

ggplot(player,aes(x=position, fill=height_inch))+geom_bar(position='dodge')


p=ggplot(player[player$position=='C',],aes(x=position, y=height_inch))+
  geom_boxplot()
ggplotly(p)

ggplot(player)+geom_point(aes(x=weight, y=heightinch, color=position))+geom_smooth(aes(x=weight, y=heightinch, color=position, linetype=position))+
  facet_wrap(~position)

ggplot(player,aes(x=weight, y=height_inch))+geom_point(position='jitter')

class(player$birth_data)

player$birthday=as.Date(player$birth_date, format='%b %d, %Y')
head(player)
class(player$birthday)
p=ggplot(player, aes(x=birthday, y=height_inch))+geom_point()+theme_economist()+geom_smooth(aes(x=birthday, y=height_inch))
ggplotly(p)



p=plot_ly(player, x=~weight, y=~height_inch, z=~birthday, color=~position) %>%
  add_markers() %>%
  layout(scene = list(xaxis=list(title='Weight'),
                       yaxis=list(title='Height(inches)'),
                       zaxis=list(title='Birthday')))


p
install.packages("Rcpp")
install.packages('gganimate')



