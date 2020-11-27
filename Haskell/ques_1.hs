import Data.List

check_empty [] = True
check_empty _ = False

union_sets setA [] = sort setA
union_sets setA setB = do
 let element = head setB
 if element `elem` setA
  then union_sets setA (tail setB)
 else
  union_sets (setA ++ [element]) (tail setB)

intersection_sets_helper setA [] setC = sort setC
intersection_sets_helper setA setB setC = do
 let element = head setB
 if element `elem` setA
  then intersection_sets_helper setA (tail setB) (setC ++ [element])
 else
  intersection_sets_helper setA (tail setB) setC

intersection_sets setA setB = 
  intersection_sets_helper setA setB []

subtraction_sets_helper [] setB setC = sort setC
subtraction_sets_helper setA setB setC = do
 let element = head setA
 if element `elem` setB
  then subtraction_sets_helper (tail setA) setB setC 
 else
  subtraction_sets_helper (tail setA) setB (setC ++ [element])

subtraction_sets setA setB = 
  subtraction_sets_helper setA setB []

addition_sets_for_one_element element [] temp_set = temp_set
addition_sets_for_one_element element setB temp_set = do
  let first_element = head setB
  addition_sets_for_one_element element (tail setB) (temp_set ++ [element + first_element])

addition_sets_helper [] setB setC = sort setC
addition_sets_helper setA setB setC = do
  let element = head setA
  let temp_set = addition_sets_for_one_element element setB []
  let union_temp_set = union_sets temp_set setC
  addition_sets_helper (tail setA) setB union_temp_set

addition_sets setA setB = 
  addition_sets_helper setA setB []
