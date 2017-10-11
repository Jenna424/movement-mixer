module Sluggable
  module InstanceMethods
    def generate_slug # returns slugged version of instance's @name attribute value
      name.downcase.gsub(" ", "-") # call #name instance getter on instance (self) to return its @name attribute and then
    end # make @name value all lowercase and replace any spaces with hyphens
  end
end
