# I added seed data here. Seed database with 'rake db:seed'
jenna = User.create(name: "Jenna", email: "Jenna424", password: "love2code")

pushup_data = {
  "name" => "Push-Up",
  "instructions" => "Start on all fours in a high plank position, with your hands placed slightly wider than shoulder-width apart and your heels hovering just above the ground. Keeping your back flat and level, bend your elbows as you lower yourself down with your arms pressed close to your sides. Create your own resistance as you slowly rise back up, until your arms are fully straightened at the top of the range of motion. Repeat.",
  "target_area" => "Triceps and shoulders",
  "reps" => 10,
  "sets" => 3,
  "modification" => "Perform push-up in kneeling position",
  "challenge" => "Pause at bottom of push-up and hold this position for 10 seconds"
}

squat_data = {
  "name" => "Bodyweight Squat",
  "instructions" => "Stand with your feet hip-width apart, maintaining upright posture. Bend your knees and descend as if you're sitting down in a chair. Slowly ascend while gradually straightening your legs.",
  "target_area" => "Glutes, quads and hamstrings",
  "reps" => 5,
  "sets" => 3,
  "modification" => "Use a smaller range of motion and don't squat as deeply",
  "challenge" => "Add a plyometric jump between squats."
}

jenna.movements.create(pushup_data)
jenna.movements.create(squat_data)
