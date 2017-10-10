When form to create a new user is submitted, params hash looks like this:
params = {
  "username" => "@username attribute value of user instance",
  "email" => "@email attribute value of user instance",
  "password" => "@password attribute value of user instance"  
}

When login form is submitted, params hash looks like this:
params = {
  "username" => "@username value of user instance",
  "password" => "@password value of user instance"
}
