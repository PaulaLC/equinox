### Elevator pitch

# Packages
library(dplyr)

# Init parameters
n_floors <- 9
n_persons_floor <-150
n_persons <- n_floors * n_persons_floor
n_lifts <- 6
lift_capacity <- 10

# Times
time_doors <- 8/3600
time_traffic <- 2/3600
time_floor <- 4/3600

### Simulation system
# Init id-floor
df0 <- data.frame(id = paste0('id_', 1:n_persons), 
                  floor = trunc(runif(n_persons, min = 1, max = n_floors + 1)))

n_mov <- n_persons
floor_from <- rep(0, n_mov)
floor_to <- df0$floor
time_call <- rnorm(n = n_mov, mean = 9, sd = 0.5)
time_call <- ifelse(time_call < 7.5, 7.5, time_call)
time_in <- rep(24, n_mov)
time_out <- rep(24, n_mov)
lift <- rep(0, n_mov)

df1 <- data.frame(id = df0$id, floor_from, floor_to, 
                  time_call, time_in, time_out, lift, allocated = 0)
df1 <- df1[order(df1$time_call),]
row.names(df1) <- 1:nrow(df1)

rm(floor_from, floor_to, time_call, time_in, time_out, lift)

### Optimization system
times <- seq(from = 7.5, to = 21, by = 1/180)
df_lift <- data.frame(lift = 1:6, floor_from = 0, floor_to = 0, 
                      time_in = 6.0, time_out = 6.0, n_persons = 0)

for(i in 1:length(times)){
  
  df_lift[df_lift$time_out <= times[i], 'n_persons'] <- 0
  
  df_queue <- df1[(df1$time_call <= times[i]) & (df1$allocated == 0),]
  
  while(nrow(df_queue) != 0){
    
    df_queue$direction <- ifelse(df_queue$floor_to - df_queue$floor_from > 0, 'up','down')
    
    # Check disponibility of lifts
    lifts_available <- df_lift[(df_lift$time_out <= times[i]) & (df_lift$n_persons < 10),]
    
    if(nrow(lifts_available) != 0){
      
      # Calculate best lift
      df_queue_grouped <- df_queue %>% group_by(floor_from, direction) %>% summarise(max_floor = max(floor_to), min_floor = min(floor_to), n=n())
      
      # For each queue of a floor asign lift
      for(j in 1:nrow(df_queue_grouped)) {
        
        floors_covered <- abs(lifts_available$floor_to - df_queue_grouped[j,]$floor_from)
        best_lift <- lifts_available[which.min(floors_covered), 'lift']
        floors_covered <- min(floors_covered)
        
        # Allocate best lift
        index <- df_queue_grouped[j,]$floor_from == df_queue$floor_from
        df_queue_new <- data.frame(lift = best_lift,
                                   allocated = 1,
                                   time_in = max(((floors_covered * time_floor) + min(df_queue[index, 'time_call'])),
                                                 max(df_queue[index, 'time_call'])))
        time_out_new <- (df_queue[index, 'floor_to'] - df_queue[index, 'floor_from']) * time_floor + 
          time_traffic + time_doors + df_queue_new$time_in
        df_queue_new <- data.frame(df_queue_new, time_out_new)
        df_queue[index, c('lift', 'allocated', 'time_in', 'time_out')] <- df_queue_new
        df1[(df1$time_call <= times[i]) & (df1$allocated == 0),c('lift', 'allocated', 'time_in', 'time_out')] <- df_queue[,c('lift', 'allocated', 'time_in', 'time_out')]
        
        
        # Add new movement
        new_mov <- data.frame(lift = best_lift, 
                              df_queue_grouped[j,])
        new_mov$time_in <- min(df_queue_new$time_in)
        new_mov$time_out <- max(df_queue_new$time_out)
        if(new_mov$direction == 'up') {
          new_mov$floor <- new_mov$max_floor
        } else{
          new_mov$floor <- new_mov$min_floor
        }
        new_mov <- new_mov %>% 
          rename(floor_to = floor, n_persons = n) %>% 
          select(lift, floor_from, floor_to, time_in, time_out, n_persons)
        df_lift[df_lift$lift == best_lift, ] <- new_mov
        
      }
      
      # Update queue
      df_queue <- df_queue[!index,]
    }
  }
  
}  

# Results on dataset with all morning movements in df1
