sqrt' x = let
  improve guss = (x/guss + guss)/2;
  good_enough guss change_guss = (abs(change_guss - guss))/guss < 0.00000001
  sqrt_iter guss
    | (good_enough guss (improve guss)) = guss
    | otherwise = sqrt_iter (improve guss)
  in sqrt_iter 1
