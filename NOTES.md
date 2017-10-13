When form to create a new user is submitted, params hash looks like this:
params = {
  "name" => "@name attribute value of user instance",
  "email" => "@email attribute value of user instance",
  "password" => "@password attribute value of user instance"  
}

When login form is submitted, params hash looks like this:
params = {
  "name" => "@name value of user instance",
  "password" => "@password value of user instance"
}

When form to create a new workout routine is submitted, params hash looks like this:
params = {
  "routine" => {
    "name" => "@name attribute value of routine instance",
    "training_type" => "@training_type attribute value of routine instance",
    "duration" => "@duration attribute value of routine instance",
    "difficulty_level" => "@difficulty_level attribute value of routine instance",
    "equipment" => "@equipment attribute value of routine instance",
    "movement_ids" => [array of @id attribute values of existing movement instances belonging to routine instance]
  },
  "movement" => {
    "name" => "@name attribute value of new movement instance created for new routine",
    "instructions" => "@instructions attribute value of movement instance",
    "target_area" => "@target_area attribute value of movement instance",
    "reps" => @reps integer attribute value of movement instance,
    "modification" => "@modification attribute value of movement instance",
    "challenge" => "@challenge attribute value of movement instance"
  }
}
