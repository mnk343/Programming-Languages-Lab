{--
            AUTHOR: MAYANK WADHWANI
                    170101038

            Program to implement basic set operations on user input
--}


-- Importing the necessary files
import Data.List

-- Function to check if the set is empty or not
-- We are writing such definition so that we can take input any type of lists from the user (string or number)
check_empty :: Ord a => [a] -> Bool
check_empty [] = True
check_empty _ = False

-- Function to find the union of 2 given sets
union_sets :: Ord a => [a] -> [a] -> [a]
-- Base case: We return the ordered list
union_sets setA [] = sort setA
-- Recursive case: We take the head of setA and
-- check if it has already been inserted, if not, we insert it and iterate
union_sets setA setB = do
 let element = head setB
 if element `elem` setA
  then union_sets setA (tail setB)
 else
  union_sets (setA ++ [element]) (tail setB)

-- Helper function used to implement the intersection of 2 sets
intersection_sets_helper :: Ord a => [a] -> [a] -> [a] -> [a]
-- Base case: We return the ordered list
intersection_sets_helper setA [] setC = sort setC
-- Recursive case: We take the head of setA and
-- check if it is in setB, if not, we ignore it and iterate
intersection_sets_helper setA setB setC = do
 let element = head setB
 if element `elem` setA
  then intersection_sets_helper setA (tail setB) (setC ++ [element])
 else
  intersection_sets_helper setA (tail setB) setC

-- Function to find the intersection of 2 given sets
intersection_sets :: Ord a => [a] -> [a] -> [a]
intersection_sets setA setB = 
  intersection_sets_helper setA setB []

-- Helper function used to implement the subtraction of 2 sets
subtraction_sets_helper :: Ord a => [a] -> [a] -> [a] -> [a]
-- Base case: We return the ordered list
subtraction_sets_helper [] setB setC = sort setC
-- Recursive case: We take the head of setA and
-- check if it is in setB, if not, we append it to result and iterate
subtraction_sets_helper setA setB setC = do
 let element = head setA
 if element `elem` setB
  then subtraction_sets_helper (tail setA) setB setC 
 else
  subtraction_sets_helper (tail setA) setB (setC ++ [element])

-- Function to find the subtraction of 2 given sets
subtraction_sets :: Ord a => [a] -> [a] -> [a]
subtraction_sets setA setB = 
  subtraction_sets_helper setA setB []

-- Helper function used to implement the addition of 2 sets given an element of 1 set
-- Base case: We return the list
addition_sets_for_one_element element [] temp_set = temp_set
-- Recursive case: We iterate over the second list
-- and add it to all elements of the first list
addition_sets_for_one_element element setB temp_set = do
  let first_element = head setB
  addition_sets_for_one_element element (tail setB) (temp_set ++ [element + first_element])

-- Helper function used to implement the addition of 2 sets
-- Base case: We return the ordered list
addition_sets_helper [] setB setC = sort setC
-- Recursive case: We take the head of setA and
-- with all the elements of setB add it and take union of all
addition_sets_helper setA setB setC = do
  let element = head setA
  let temp_set = addition_sets_for_one_element element setB []
  let union_temp_set = union_sets temp_set setC
  addition_sets_helper (tail setA) setB union_temp_set

-- Function that takes in input 2 sets and returns the final set denoting their sum
addition_sets setA setB = 
  addition_sets_helper setA setB []

-- END OF PROGRAM