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
    "reps" => @reps attribute value of movement instance,
    "modification" => "@modification attribute value of movement instance",
    "challenge" => "@challenge attribute value of movement instance"
  }
}

When form to create a new exercise movement is submitted, params hash looks like this:
params = {
  "movement" => {
    "name" => "@name attribute value of movement instance",
    "instructions" => "@instructions attribute value of movement instance",
    "target_area" => "@target_area attribute value of movement instance",
    "reps" => "@reps attribute value of movement instance",
    "modification" => "@modification attribute value of movement instance",
    "challenge" => "@challenge attribute value of movement instance",
    "routine_ids" => [array of @id attribute values of existing routine instances that the movement instance 'has many' of, i.e., that the movement instance belongs in/is found in]
  },
  "routine" => {
    "name" => "@name attribute value of new routine instance created for new movement to be in",
    "training_type" => "@training_type attribute value of new routine instance",
    "duration" => "@duration attribute value of new routine instance",
    "difficulty_level" => @difficulty_level attribute value of new routine instance,
    "equipment" => "@equipment attribute value of new routine instance",
  }
}
