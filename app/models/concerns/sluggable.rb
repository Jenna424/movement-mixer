module Sluggable

  module InstanceMethods
    def generate_slug # returns slugged version of instance's @name attribute value
      name.downcase.gsub(" ", "-") # call #name instance getter on instance (self) to return its @name attribute and then
    end # make @name value all lowercase and replace any spaces with hyphens
  end

  module ClassMethods
    def find_by_slugged_name(slugged_name)
      all.detect {|instance| instance.generate_slug == slugged_name} # call #all on class to return array of all instances of that class
    end # Iterate over array of all instances and return the first instance whose slugged version of its @name attribute (returned by calling #generate_slug on instance) equals slugged_name argument
  end
  
end
