# RepRex = Reproducible Example

library(reprex)
y <- 1:4
mean(y) |> reprex()

reprex::reprex(y <- 1:4 |> 
               mean(y))
