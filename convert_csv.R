########
### Run this R script to convert all .csv files in the working directory (getwd())
### to the original .dat file format and creats a summary .csv file with 
### the number of times a Ss cheated
########
convert <- function(df, name) {

df[df$correct == "",]$correct <- NA
# check if participant cheated at least once (otherwise this variable is not available)
if (is.logical(df$has_cheated)) {
	df[df$has_cheated == "",]$has_cheated <- NA
} else {
	df$has_cheated <- NA
}
df$has_cheated

# split blocks
block1 <- df[1:which(as.character(df$internal_node_id) == "0.0-5.0"),]
block2 <- df[which(as.character(df$internal_node_id) == "0.0-5.0"):nrow(df),]


## Position 1
## time to hit SPACEBAR on last show of equation
# arguments: block, wait time in ms until equation shown
time_to_space <- function(block) {
  row.names(block) <- 1:nrow(block) # make sure that the row names are correct inside this function (for example for the second block)
  out <- c()
  for (i in 1:length(unique(block[!is.na(block$equa_id),]$equa_id))) {
    curr_trials <- block[as.numeric(block$equa_id) == i & block$trial_type == "single-stim" & !is.na(block$equa_id),]
    position <- as.numeric(row.names(tail(curr_trials, 1)))
    if (!is.na(tail(curr_trials, 1)$has_cheated)) {   # in trials where has_cheated is NOT NA, the solution was shown.
      out <- c(out, tail(curr_trials, 1)$rt + (block[position-1,]$time_elapsed - block[position-2,]$time_elapsed)) # here we add the time that passed until the solution was shown and add it to the time until SPACE was pressed
    } else {
      out <- c(out, tail(curr_trials, 1)$rt) # since the solution was not shown we can take the time of the last single-stim
    }

  }
  return(out)
  }


## Position 2
## calculate if equation was shown or not a.k.a. cheating
# argument: block
cheat_trials <- function(block) {
  out <- c()
  for (i in 1:length(unique(block[!is.na(block$equa_id),]$equa_id))) {
    if("true" %in% block[as.numeric(block$equa_id) == i & !is.na(block$equa_id), ]$has_cheated) {
      out <- c(out, 1)
    } else {
      out <- c(out, 0)
    }
  }
  return(out)
}

## Position 3 
# time to enter correct solution to equation from last show of equation (e.g., last repeat, or first show if 0 repeats)
# arguments: block 
time_to_solution <- function(block) {
  row.names(block) <- 1:nrow(block) # make sure that the row names are correct inside this function (for example for the second block)
  out <- c()
  for (i in 1:length(unique(block[!is.na(block$equa_id),]$equa_id))) {
    curr_trials <- block[as.numeric(block$equa_id) == i & block$trial_type == "survey-input-validate" & !is.na(block$equa_id),]
    answer_stim_position <- as.numeric(row.names(tail(curr_trials, 1)))
    
    if(!is.na(block[answer_stim_position-1, ]$has_cheated)) { # has cheated in this trial, so we need to add the waittime, solution time and time to enter
      out <- c(out, (block[answer_stim_position-2,]$time_elapsed - block[answer_stim_position-3,]$time_elapsed) + block[answer_stim_position-1,]$rt + block[answer_stim_position,]$rt)
      
    } else { # did not cheat in this trial, so we just need to add time of equation presentation and time to enter
    
      out <- c(out, block[answer_stim_position-1,]$rt + block[answer_stim_position,]$rt)
    }
    
  }
  return(out)
}


## Position 4 
# whether the equation was repeated (FALSE=No, TRUE=Yes)
# arguments: block
repeated_trials <- function(block) {
  out <- c()
  for (i in 1:length(unique(block[!is.na(block$equa_id),]$equa_id))) {
    if(nrow(block[as.numeric(block$equa_id) == i & !is.na(block$equa_id),]) > 3) {  # if an unique equation ID appears more than 3 times, it was repeated
      out <- c(out, "#TRUE#")
    } else {
      
      out <- c(out, "#FALSE#")
    }
    
  }
  return(out)
}


## Position 5 
# total time to complete equation, from first exposure to equation until correct solution entered; 
# note that when equation was not repeated, this value is almost equal the value in Position 3
# arguments: block
time_to_complete <- function(block) {
  row.names(block) <- 1:nrow(block) # make sure that the row names are correct inside this function (for example for the second block)
  
  out <- c()
  for (i in 1:length(unique(block[!is.na(block$equa_id),]$equa_id))) {
    curr_trials <- block[as.numeric(block$equa_id) == i & !is.na(block$equa_id),]
    start <- block[as.numeric(row.names(head(curr_trials,1)))-1,]$time_elapsed
    end <- tail(curr_trials, 1)$time_elapsed
    out <- c(out, end-start)
    
  }
  return(out)
}

Position1 <- c(time_to_space(block1), time_to_space(block2))
Position2 <- c(cheat_trials(block1), cheat_trials(block2))
Position3 <- c(time_to_solution(block1), time_to_solution(block2))
Position4 <-  c(repeated_trials(block1), repeated_trials(block2))
Position5 <- c(time_to_complete(block1), time_to_complete(block2))

elapsed_time <- max(df$time_elapsed) / (1000 * 60)

out <- data.frame(Position1,Position2,Position3,Position4,Position5)

out <- apply(out, 1, paste, collapse = ",")
out <- paste(out, collapse=",")

output <- paste(paste('\n"Next Participant"'), paste(out, sep=","), paste('"Elapsed time = ',elapsed_time,'"\n', sep=""), sep='\n')

fileConn<-file(paste(name,"output.dat", sep="_"))
writeLines(output, fileConn)
close(fileConn)

}


#### this part loads in all files and runs the "convert" function
temp = list.files(pattern="mydata*")
myfiles = lapply(temp, read.table, header=TRUE, sep=",")
for (i in 1:length(temp)) {
  convert(myfiles[[i]], temp[i])
}

## some additional info (number of cheats)
dat <- data.frame()
for (i in 1:length(temp)) {
  # split blocks
  df <- myfiles[[i]]
  block1 <- df[1:which(as.character(df$internal_node_id) == "0.0-5.0"),]
  block2 <- df[which(as.character(df$internal_node_id) == "0.0-5.0"):nrow(df),]
  cheat_trials <- function(block) {
    out <- c()
    for (i in 1:length(unique(block[!is.na(block$equa_id),]$equa_id))) {
      if("true" %in% block[as.numeric(block$equa_id) == i & !is.na(block$equa_id), ]$has_cheated) {
        out <- c(out, 1)
      } else {
        out <- c(out, 0)
      }
    }
    return(out)
  }
  block1 <- sum(cheat_trials(block1))
  block2 <- sum(cheat_trials(block2))
  total <- sum(block1, block2)
  dat <- rbind(dat, cbind(id = temp[i], block1, block2, total))
}
write.csv(dat, file = "cheat_data.csv")

