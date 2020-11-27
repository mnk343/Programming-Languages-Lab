import System.Random
import Data.List

registered_teams :: [[Char]]
registered_teams = ["BS" , "CM" , "CH" , "CV" , "CS" , "DS" , "EE" , "HU" , "MA" , "ME" , "PH" , "ST" ]

get_random_number :: IO Int
get_random_number = do 
  n <- randomRIO(0,11)
  return n

generate_new_random_shuffling random_shuffle = 
  do
    index <- get_random_number
    if (length random_shuffle) /= 12 then do
     if index `elem` random_shuffle
       then generate_new_random_shuffling random_shuffle
     else
       generate_new_random_shuffling (random_shuffle ++ [index])
    else return random_shuffle

fixture "all" = do
  let teams_shuffling = generate_new_random_shuffling []
  teams_shuffling














