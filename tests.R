library(tidyverse)
library(gganimate)

pool <- rnorm(1000,mean=0,sd=1)

df <- NULL

for(i in 1:1100){
  if(i<=1000){
    df <- rbind(df,data.frame(x=pool[1:i],state=i,n=i))
  }
  else {
    df <- rbind(df,data.frame(x=pool,state=i,n=1000))
   }
  print(i)
}

df$n <- paste0("n: ",df$n)

plot <- ggplot(df,aes(x=x))+
  geom_histogram(fill="#56018D",alpha=0.2,)+
  scale_x_continuous("",labels=seq(-5,5,1),
                     breaks=seq(-5,5,1),
                     expand=c(0,0))+
  scale_y_continuous("",expand=c(0,0))+
  coord_cartesian(xlim=c(-3.5,3.5),ylim=c(0,90))+
  theme_minimal()+
  theme(legend.position = "none")+
  transition_states(state,
                    transition_length = 1,
                    state_length = 0.5)+
  ease_aes('cubic-in-out')

animate(plot,height=5,width=10,units="cm",res=1080)
anim_save("normaldistri_anim.gif", animation = last_animation(), path = "/Users/williampoirier/Dropbox/Website/files")



