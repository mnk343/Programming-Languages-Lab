{--
            AUTHOR: MAYANK WADHWANI
                    170101038

			Program to implement the optimal architecture based on the conditions given
--}


-- Importing the necessary files
import Data.List

-- Check if a given area is already present in the architecture,
-- because if it is, we dont need to keep a separate dimension for the same area
check_area_already_present :: Int -> [[[Int]]] -> Bool
check_area_already_present area [] = False
check_area_already_present area possible_architectures = do
  -- Check if area is equal to area of head of list
  let area_head_list = ((head possible_architectures) !! 2) !!0
  if area == (area_head_list) then True
  else check_area_already_present area (tail possible_architectures)

-- Function that appends the element of a given list to a list to create unique entries of areas
insert_unique_architectures :: [Int] -> [[Int]] -> Int -> Int -> [[[Int]]] -> [[[Int]]]
insert_unique_architectures element [] count_rooms_listA count_rooms_listB possible_architectures = possible_architectures
insert_unique_architectures element listB count_rooms_listA count_rooms_listB possible_architectures = do
  let listB_head = head listB
  -- Calculate the area of the room
  let area = ( ((element!!0) * (element!!1)) * count_rooms_listA + ( (listB_head!!0) * (listB_head!!1) * count_rooms_listB ) )
  -- Check if some other dimension with the same area already exists,
  -- if it does, ignore this dimension and iterate forward
  if (check_area_already_present area possible_architectures ) then
    insert_unique_architectures element (tail listB) count_rooms_listA count_rooms_listB possible_architectures
  else
    insert_unique_architectures element (tail listB) count_rooms_listA count_rooms_listB (possible_architectures ++ [[ (element++[count_rooms_listA]) , (listB_head++[count_rooms_listB]) , [area,0,0]]])

-- Function to find the cross product of 2 given input lists 
-- also storing the net areas with it which will be used later
cross_product :: [[Int]] -> [[Int]] -> Int -> Int -> [[[Int]]] -> [[[Int]]]
cross_product [] listB count_rooms_listA count_rooms_listB possible_architectures = possible_architectures 
cross_product listA listB count_rooms_listA count_rooms_listB possible_architectures = do 
  let element = head listA
  -- Take out an element from the list 1 and for this element, insert all unique areas from list 2
  let temp_possible_architectures = insert_unique_architectures element listB count_rooms_listA count_rooms_listB possible_architectures
  cross_product (tail listA) listB count_rooms_listA count_rooms_listB temp_possible_architectures

-- Function to insert all dimensions for a given start height for all possible widths within the range
insertDimensions :: Int -> Int -> Int -> [[Int]] -> [[Int]]
insertDimensions startHeight startWidth endWidth temp_dimensions = do
  if startWidth > endWidth then temp_dimensions
  else
    insertDimensions startHeight (startWidth+1) endWidth (temp_dimensions ++ [[startHeight, startWidth]] )

-- Function to generate a list of all possible dimensions for a given range
-- of input dimensions for height and width
generate_all_dimensions :: Int -> Int -> Int -> Int -> [[Int]] -> [[Int]]
generate_all_dimensions startHeight startWidth endHeight endWidth temp_dimensions = do
  if (startHeight > endHeight) then temp_dimensions
  else do
  let insert_dimensions_for_start_height = insertDimensions startHeight startWidth endWidth temp_dimensions
  generate_all_dimensions (startHeight+1) startWidth endHeight endWidth insert_dimensions_for_start_height

-- Function that finds the cross product between the kitchens and halls
-- taking into consideration the fact that the count of kitchens is
-- 1 for upto 3 bedrooms, so if bedrooms is 9 then we can have upto 3 kitchens
find_cross_product_for_variable_kitchens :: Int -> Int -> [[[Int]]] -> [[[Int]]]
find_cross_product_for_variable_kitchens 0 _ temp_cross_product = temp_cross_product
find_cross_product_for_variable_kitchens number_of_kitchens number_of_bathrooms  temp_cross_product = do
  let temp_cross_product_for_given_kitchens = cross_product (generate_all_dimensions 7 5 15 13 []) (generate_all_dimensions 4 5 8 9 [] ) number_of_kitchens number_of_bathrooms []  
  find_cross_product_for_variable_kitchens (number_of_kitchens-1) number_of_bathrooms (temp_cross_product ++ temp_cross_product_for_given_kitchens )

-- Function that finds the cross product for 2 cross products given an element of the first cross product
-- We merge the 2 cross products into one cross product
cross_product_for_four_rooms_with_fixed_element :: [[Int]] -> [[[Int]]] -> [[[Int]]] -> [[[Int]]]
cross_product_for_four_rooms_with_fixed_element element [] temp_cross_product = temp_cross_product
cross_product_for_four_rooms_with_fixed_element element crossProductB temp_cross_product = do
  let elementListB = head crossProductB
  -- The element to be added is the list of values from the 2 cross products and the combined area of them
  let element_to_add = [ element!!0, element!!1, elementListB!!0, elementListB!!1, [ ((element!!2)!!0) + ((elementListB!!2)!!0),0,0] ]
  cross_product_for_four_rooms_with_fixed_element element (tail crossProductB) (temp_cross_product++[element_to_add])

-- The helper Function that given two cross product, finds their cross product
cross_product_for_four_rooms :: [[[Int]]] -> [[[Int]]] -> [[[Int]]] -> [[[Int]]]
cross_product_for_four_rooms [] crossProductB crossProductSoFar = crossProductSoFar
cross_product_for_four_rooms crossProductA crossProductB crossProductSoFar = do
  let element = head crossProductA
  let crossProductWithElement = cross_product_for_four_rooms_with_fixed_element element crossProductB []
  cross_product_for_four_rooms (tail crossProductA) crossProductB (crossProductSoFar ++ crossProductWithElement)

-- Just as above, the function to calculate the cross product for 2 given cross products
-- to get a combined cross product consisting of 6 elements
cross_product_for_six_rooms_with_fixed_element :: [[Int]] -> [[[Int]]] -> [[[Int]]] -> [[[Int]]]
cross_product_for_six_rooms_with_fixed_element element [] temp_cross_product = temp_cross_product
cross_product_for_six_rooms_with_fixed_element element crossProductB temp_cross_product = do
  let elementListB = head crossProductB
  let element_to_add = [ element!!0, element!!1, element!!2, element!!3, elementListB!!0, elementListB!!1, [ ((element!!4)!!0) + ((elementListB!!2)!!0),0,0] ]
  cross_product_for_six_rooms_with_fixed_element element (tail crossProductB) (temp_cross_product++[element_to_add])

-- As above, the helper Function to compute the net cross product for 2 given cross products
cross_product_for_six_rooms :: [[[Int]]] -> [[[Int]]] -> [[[Int]]] -> [[[Int]]]
cross_product_for_six_rooms [] crossProductB crossProductSoFar = crossProductSoFar
cross_product_for_six_rooms crossProductA crossProductB crossProductSoFar = do
  let element = head crossProductA
  -- Append the cross product to the final list
  let crossProductWithElement = cross_product_for_six_rooms_with_fixed_element element crossProductB []
  cross_product_for_six_rooms (tail crossProductA) crossProductB (crossProductSoFar ++ crossProductWithElement)

-- Function to prune the given cross product
-- and remove the duplicate areas
-- After execution, it will generate a much shorter list which consists of only 
-- unique areas and their dimensions of all rooms
prune_search_space :: [[[Int]]] -> [Int] -> [[[Int]]] -> [[[Int]]]
prune_search_space [] areas_present pruned_space = pruned_space
prune_search_space net_cross_product areas_present pruned_space = do
  let element = head net_cross_product
  -- If the given constraint of having bedroom greater than or equal to kitchen
  -- and that dimensions of kitchen must be greater than or equal to bathroom fails
  -- we simply ignore this element
  if ( (((element!!3)!!0) > ((element!!2)!!0)) || (((element!!3)!!1) > ((element!!2)!!1)) ) || ( (((element!!2)!!0) > ((element!!0)!!0)) || (((element!!2)!!1) > ((element!!0)!!1)) ) then
    prune_search_space (tail net_cross_product) areas_present pruned_space
  -- Else if area already present, we again ignore this element
  else if ((element!!4)!!0) `elem` areas_present 
    then prune_search_space (tail net_cross_product) areas_present pruned_space 
  else 
    prune_search_space (tail net_cross_product) (areas_present++[((element!!4)!!0)]) (pruned_space ++ [element] )

-- Function that finds the index of the element with the largest area of the set
find_index_of_architecture_with_max_area :: [[[Int]]] -> Int -> Int -> Int -> Int -> Int 
find_index_of_architecture_with_max_area [] total_area maxSoFar indexMaxSoFar currentIndex = indexMaxSoFar
find_index_of_architecture_with_max_area final_cross_product total_area maxSoFar indexMaxSoFar currentIndex = do
  let element = head final_cross_product
  -- If the area of this element is the highest seen so far, we pass this index and area further
  if (((element!!6)!!0) > maxSoFar) && ( ((element!!6)!!0) <= total_area ) then
    find_index_of_architecture_with_max_area (tail final_cross_product) total_area ((element!!6)!!0) currentIndex (currentIndex+1)
  -- If not, we simply iterate over the remaining elements
  else
    find_index_of_architecture_with_max_area (tail final_cross_product) total_area maxSoFar indexMaxSoFar (currentIndex+1)

-- Function that prints the optimal architecture 
-- First, we find the index of the max element,
-- then print all values for this index
printOptimalArchitecture :: [[[Int]]] -> Int -> IO()
printOptimalArchitecture final_cross_product total_area = do
  let index_of_optimal_architecture = (find_index_of_architecture_with_max_area final_cross_product total_area (-1) (-1) 0)
  let optimal_set = final_cross_product !! index_of_optimal_architecture
  putStrLn ("Bedroom: " ++ show((optimal_set!!0)!!2) ++ " (" ++ show((optimal_set!!0)!!0) ++ " * " ++ show((optimal_set!!0)!!1) ++ ")")
  putStrLn ("Hall: " ++ show((optimal_set!!1)!!2) ++ " (" ++ show((optimal_set!!1)!!0) ++ " * " ++ show((optimal_set!!1)!!1) ++ ")")
  putStrLn ("Kitchen: " ++ show((optimal_set!!2)!!2) ++ " (" ++ show((optimal_set!!2)!!0) ++ " * " ++ show((optimal_set!!2)!!1) ++ ")")
  putStrLn ("Bathroom: " ++ show((optimal_set!!3)!!2) ++ " (" ++ show((optimal_set!!3)!!0) ++ " * " ++ show((optimal_set!!3)!!1) ++ ")")
  putStrLn ("Balcony: " ++ show((optimal_set!!4)!!2) ++ " (" ++ show((optimal_set!!4)!!0) ++ " * " ++ show((optimal_set!!4)!!1) ++ ")")
  putStrLn ("Garden: " ++ show((optimal_set!!5)!!2) ++ " (" ++ show((optimal_set!!5)!!0) ++ " * " ++ show((optimal_set!!5)!!1) ++ ")")
  putStrLn ("Unused: " ++ show( total_area - (optimal_set!!6)!!0 ))

-- Function to implement the house planner
-- We take in the total area and number of bedrooms and halls as input
-- and then print the optimal architecture
design :: Int -> Int -> Int -> IO()
design total_area number_of_bedrooms number_of_halls = do
  -- First find cross products for bedroom, halls and kitchens,bathrooms
  let bedrooms_and_halls = cross_product (generate_all_dimensions 10 10 15 15 []) (generate_all_dimensions 15 10 20 15 [] ) number_of_bedrooms number_of_halls []
  let kitchens_and_bathrooms = find_cross_product_for_variable_kitchens ((div ( number_of_bedrooms-1) 3 ) +1 ) (number_of_bedrooms+1) []
  -- Merge this cross product
  let net_cross_product = cross_product_for_four_rooms bedrooms_and_halls kitchens_and_bathrooms []
  -- Prune the search space to optimize on time
  let pruned_cross_product = prune_search_space net_cross_product [] []
  -- Now find the cross product for balcony and garden
  let balcony_and_garden = cross_product (generate_all_dimensions 5 5 10 10 []) (generate_all_dimensions 10 10 20 20 [] ) 1 1 []
  -- Merge everything to get a final cross product
  let final_cross_product = cross_product_for_six_rooms pruned_cross_product balcony_and_garden []  
  -- Print all rooms finally
  printOptimalArchitecture final_cross_product total_area

-- END OF PROGRAM