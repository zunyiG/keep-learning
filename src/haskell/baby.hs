doubleMe x = x + x

doubleUs x y = doubleMe x + doubleMe y

doubleSmallNumber x = if x > 100
                      then x
                      else doubleMe x

doubleSmallNumber' x = (if x > 100 then x else doubleMe x) + 1

namE'Str = "This is a text line!"
