{--
            AUTHOR: MAYANK WADHWANI
                    170101038

            Program to implement the draw for the fixtures for the football league
--}


-- Importing the necessary files
import System.Random
import Data.List
import System.IO.Unsafe
import Data.IORef

-- This is used to initiliaze the seed which basically allocates some reserve in the memory
seed :: IORef [Int]
seed = unsafePerformIO $ newIORef []

-- List of all the registered teams playing the tournament
registered_teams :: [[Char]]
registered_teams = [ "BS" , "CM" , "CH" , "CV" , "CS" , "DS" , "EE" , "HU" , "MA" , "ME" , "PH" , "ST" ]

-- Function to get a random number in a range
get_random_number :: IO Int
get_random_number = do 
  n <- randomRIO(0,11)
  return n

-- Function to generate a random shuffling which will be used to create the fixtures
generate_new_random_shuffling :: [Int] -> IO [Int]
generate_new_random_shuffling random_shuffle = 
  do
    -- We first get a random number in the range
    index <- get_random_number
    -- If there are less than 12 teams added in the fixture, we check that
    -- the team number corresponding to the random number selected is already scheduled or not
    if (length random_shuffle) /= 12 then do
     if index `elem` random_shuffle
       then generate_new_random_shuffling random_shuffle
     else
       generate_new_random_shuffling (random_shuffle ++ [index])
    else return random_shuffle

-- Function to generate a fixture given the random shufflings
generate_fixture ::  [Int] -> [[Char]] -> [[Char]]
-- Base case: if there is no more elements left, return the fixture 
generate_fixture [] temp_fixture = temp_fixture
-- Recursive case: Append the team corresponding to the index given by the head of the shuffling
generate_fixture random_shuffle temp_fixture = do
  let element = (head random_shuffle)
  generate_fixture (tail random_shuffle) (temp_fixture ++ [(registered_teams !! element)])

-- Lists to store the possible days and times 
dates = [ "1-12-2020" , "2-12-2020" , "3-12-2020" ]
times = ["9:30" , "19:30"]

-- Function to print the entire fixture
printFixture :: [[Char]] -> Int -> IO()
printFixture [] _ = putStrLn ("")
-- Recursive case: For the head and the next head, print the teams,
-- and the date and time for them
printFixture fixture number = do
  let team1 = (head fixture)
  let team2 = (head (tail fixture))
  -- Date and time can be calculated based on the match number
  let date = dates !! (div number 2)
  let time = times !! (mod number 2)

  putStrLn (team1 ++ " vs " ++ team2 ++ "     " ++ date ++ "     " ++ time  )
  printFixture (tail (tail fixture)) (number+1)

-- Function to get the index of a given team code in the fixture list by using linear search
findIndexInFixture :: [[Char]] -> [Char] -> Int -> Int
findIndexInFixture fixture team_code index = do
  let element = (head fixture)
  -- If we have found the element, we simply return the index
  if (element == team_code)
    then index
  else findIndexInFixture (tail fixture) team_code (index+1)

-- Function to print the match details for a given match number
printMatchDetails :: [[Char]] -> Int -> IO()
printMatchDetails fixture match_number = do
  -- We first find the teams for the given match number
  let team1 = fixture !! ( (match_number-1)*2)
  let team2 = fixture !! (( (match_number-1)*2) + 1)

  -- We then calculate the indices for the date and time for that match
  let date = dates !! (div (match_number-1) 2)
  let time = times !! (mod (match_number-1) 2)

  -- We finally print all on the terminal
  putStrLn (team1 ++ " vs " ++ team2 ++ "     " ++ date ++ "     " ++ time  )

-- Function to print the fixture as scheduled for a particular team
printFixtureForTeam :: [[Char]] -> [Char] -> IO()
printFixtureForTeam fixture team_code = do
  -- Find the index and the match number for the team and then print everything
  let index = findIndexInFixture fixture team_code 0
  let match_number = ((div index 2) + 1)
  printMatchDetails fixture match_number

-- Function to print the next fixture for a given date and time
printFixtureForDateAndTime :: [[Char]] -> Int -> IO()
printFixtureForDateAndTime fixture match_number = do
  printMatchDetails fixture match_number

fixture :: [Char] -> IO()
-- The fixture function that will be called by the user to generate a new random shuffling of the teams for the football league
fixture "all" = do
  -- We first generate a random shuffling for the teams
  let randomFixture = unsafePerformIO(generate_new_random_shuffling [])
  let fixture = (generate_fixture randomFixture [])
  -- We then write this shuffling which will be used by the later functions in the allocated space (initiliazed above)
  writeIORef seed randomFixture
  -- We then print the generated fixture
  printFixture fixture 0

-- The fixture function that will be called by the user to look for a fixture for a given team code
fixture team_code = do
  -- We read the fixture as generated above
  random_shuffle <- readIORef seed
  let fixture = (generate_fixture random_shuffle [])
  -- If the user tries to look at the fixture without calling "all", we display appropriate messages
  if (length random_shuffle) == 0 then
    putStrLn "Fixture not created yet"
  -- If team is registered, show its fixture
  else if team_code `elem` registered_teams then
    printFixtureForTeam fixture team_code
  -- If it is not registered, show error messages
  else 
    putStrLn "Wrong team entered"

-- Function to print the next match for a given date and time
nextMatch :: Int -> Double -> IO()
nextMatch date time = do 
  -- First read the shuffling as generated above
  random_shuffle <- readIORef seed
  -- If the user tries to look at the fixture without calling "all", we display appropriate messages
  if (length random_shuffle) == 0 then
    putStrLn "Fixture not created yet"
  else do
    -- Look for the match index which is just greater than the input date and time
    let fixture = (generate_fixture random_shuffle [])
    let match_number_based_on_date = date*2
    -- if all matches are over, show no more matches left message
    if date>=3 && time > 19.30 then putStrLn "No more matches left."
    -- else show the details of the match
    else if time > 19.30 then printFixtureForDateAndTime fixture (match_number_based_on_date+1)
    else if time > 9.30 then printFixtureForDateAndTime fixture (match_number_based_on_date )
    else printFixtureForDateAndTime fixture (match_number_based_on_date-1)

-- END OF PROGRAM