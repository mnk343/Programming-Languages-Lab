import System.Random
import Data.List
import System.IO.Unsafe

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

random_shuffle = unsafePerformIO(generate_new_random_shuffling [])

dates = [ "1-12-2020" , "2-12-2020" , "3-12-2020" ]
times = ["9:30" , "19:30"]

printFixture [] _ = putStrLn ("")
printFixture fixture number = do
  let team1 = (head fixture)
  let team2 = (head (tail fixture))
  let date = dates !! (div number 2)
  let time = times !! (mod number 2)

  putStrLn (team1 ++ " vs " ++ team2 ++ "     " ++ date ++ "     " ++ time  )
  printFixture (tail (tail fixture)) (number+1)

findIndexInFixture :: [[Char]] -> [Char] -> Int -> Int
findIndexInFixture fixture team_code index = do
  let element = (head fixture)
  if (element == team_code)
    then index
  else findIndexInFixture (tail fixture) team_code (index+1)

printMatchDetails fixture match_number = do
  let team1 = fixture !! ( (match_number-1)*2)
  let team2 = fixture !! (( (match_number-1)*2) + 1)
  let date = dates !! (div (match_number-1) 2)
  let time = times !! (mod (match_number-1) 2)
  putStrLn (team1 ++ " vs " ++ team2 ++ "     " ++ date ++ "     " ++ time  )

printFixtureForTeam fixture team_code = do
  let index = findIndexInFixture fixture team_code 0
  let match_number = ((div index 2) + 1)
  printMatchDetails fixture match_number

printFixtureForDateAndTime fixture match_number = do
  printMatchDetails fixture match_number

fixture "all" = do
  let fixture = (generate_fixture random_shuffle [])
  printFixture fixture 0

fixture team_code = do
  let fixture = (generate_fixture random_shuffle [])
  if (length random_shuffle) == 0 then
    putStrLn "Fixture not created yet"
  else if team_code `elem` registered_teams then
    printFixtureForTeam fixture team_code
  else 
    putStrLn "Wrong team entered"

nextMatch :: Int -> Double -> IO()
nextMatch date time = do 
  let fixture = (generate_fixture random_shuffle [])
  let match_number_based_on_date = date*2
  if date==3 && time > 19.30 then putStrLn "No more matches left."
  else if time > 9.30 then printFixtureForDateAndTime fixture (match_number_based_on_date )
  else printFixtureForDateAndTime fixture (match_number_based_on_date-1)
