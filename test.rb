require 'pry'

test_array = ["\n\t\t\t\t\t\t\t\t\t\tMethod\n\t\t\t\t\t\t\t\t\t\t1 Before starting on the pork, put the pork roast in the freezer for 30 minutes to make it easier to cut", "  While the pork is chilling, you can make the filling", "\n\n2 Bring all the filling ingredients to simmer in medium saucepan over medium-high heat", " Cover, reduce heat to low, and cook until apples are very soft, about 20 minutes", " Strain through a fine-mesh sieve, reserving the liquid", "  Use a rubber spatula to press against the apple mixture in the sieve to extract as much liquid out as possible", "  Return liquid to saucepan and simmer over medium-high heat until reduced to 1/2 cup, about 5 minutes", "  Remove from heat, set aside and reserve this liquid for use as a glaze", " Pulse apple mixture in food processor, about fifteen 1-second pulses", " Set aside", "\n\n\n\n2 Preheat oven to 350°F or prepare your grill for indirect heat", "  You will be \"double-butterflying\" the pork roast", "  Lay the roast down, fat side up", "  Insert the knife into the roast 1/2-inch horizontally from the bottom of the roast, along the long side of the roast", "  Make a  long cut along the bottom of the roast, stopping 1/2 inch before the edge of the roast", "  You might find it easier to handle by starting at a corner of the roast", "\n\n\n\nOpen up the roast and continue to cut through the thicker half of the roast, again keeping 1/2 inch from the bottom", "  Repeat until the roast is an even 1/2-inch thickness all over when laid out", "\n\n\n\nIf necessary, pound the roast to an even thickness with a meat pounder", "\n\n\n\n3 Season the inside of the roast well with salt and pepper", "  Spread out the filling on the roast, leaving a 1/2-inch border from the edges", "  Starting with the short side of the roast, roll it up very tightly", "  Secure with kitchen twine at 1-inch intervals", "  Season the outside of the roast generously with salt and pepper", "\n\n4 Place roast on a rack in a roasting pan, place in oven, on the middle rack", "  \n\nYou can also grill the roast, using indirect heat either gas or charcoal", "  If you are using charcoal, use about 5 pounds of coals, bank them to one side", "  Preheat the grill, covered", "  Wipe the grates with olive oil", "  Place roast, fat side up, on the side of the grill that has no coals underneath", "  Place the lid on the grill, with the vent directly over the roast", "  If you are grilling with gas, place all the burners on high for 15 minutes to heat the grates, brush grates with olive oil, turn off the middle burner, place roast fat-side up on middle burner", "  If you are grilling, turn roast half way through the cooking", "\n\nCook for 45 to 60 minutes, until the internal temperature of the roast is 130 to 135 degrees", "  Brush with half of the glaze and cook for 5 minutes longer", "  Remove the roast from the oven or grill", "  Place it on a cutting board", "  Tent it with foil to rest and keep warm for 15 minutes before slicing", "\n\n\n\n5 Slice into 1/2-inch wide pieces, removing the cooking twine as you cut the roast", "  Serve with remaining glaze", "\n\t\t\t\t\t\t\t\t\t"]


def extract_step_one(string)
  new_string = string.split("1")
  new_string = new_string[1]
  remove_trailing_spaces = new_string.strip
  return remove_trailing_spaces
end
#extract_step_one("Method\n\t\t\t\t\t\t\t\t\t\t1 Before starting on the pork, put the pork roast in the freezer for 30 minutes to make it easier to cut")





def split_instruction_steps(array)

  array.each do |sentence|
    sentence.strip!
  end

  new_array = array
  #strips 1st sentence to remove word "Method"
  first_sentence = extract_step_one(new_array[0])
  new_array[0] = first_sentence

  array_of_arrays = []
  nested_array = []
  new_array.each do |sentence|
    if sentence[0].to_i == 0
      nested_array << sentence
    else
      array_of_arrays << nested_array
      nested_array = []
      nested_array << sentence

      #binding.pry
    end
  end

  puts "#{array_of_arrays}"
  puts nil
  puts "Length: #{array_of_arrays.length}"

end
split_instruction_steps(test_array)




def cleaned_up(array)
  remove_method_word = array.split(".")
  stripped = remove_method_word[1].strip

  new_array = array
  new_array[0] = stripped

  puts "#{new_array}"
  #binding.pry
  return new_array
end

#cleaned_up(test_array)



#RegEx testing

# line1 = "\n\t\t\t\t\t\t\t\t\t\tMethod\n\t\t\t\t\t\t\t\t\t\t1 Before starting on the pork, put the pork roast in the freezer for 30 minutes to make it easier to cut"
# line2 = " While the pork is chilling, you can make the filling.\n\n2 Bring all the filling ingredients to simmer in medium saucepan over medium-high heat"

# if ( line1 =~ /1(.*)/ )
#   puts "Line1 has the number 1 in it"
# end
# if ( line2 =~ /2(.*)/ )
#   puts "Line2 has the number 2 in it"
# end
