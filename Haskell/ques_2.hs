import System.Random
import Data.List

registered_teams :: [[Char]]
registered_teams = [ "BS" , "CM" , "CH" , "CV" , "CS" , "DS" , "EE" , "HU" , "MA" , "ME" , "PH" , "ST" ]

get_random_number :: IO Int
get_random_number = do 
  n <- randomRIO(0,11)
  return n

generate_new_random_shuffling :: [Int] -> IO [Int]
generate_new_random_shuffling random_shuffle = 
  do
    index <- get_random_number
    if (length random_shuffle) /= 12 then do
     if index `elem` random_shuffle
       then generate_new_random_shuffling random_shuffle
     else
       generate_new_random_shuffling (random_shuffle ++ [index])
    else return random_shuffle

generate_fixture ::  [Int] -> [[Char]] -> [[Char]]
generate_fixture [] temp_fixture = temp_fixture
generate_fixture random_shuffle temp_fixture = do
  let element = (head random_shuffle)
  generate_fixture (tail random_shuffle) (temp_fixture ++ [(registered_teams !! element)])

fixture "all" = do
  random_shuffle <- generate_new_random_shuffling []
  return (generate_fixture random_shuffle [])














