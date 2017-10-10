# I added seed data here. Seed database with 'rake db:seed'
squat = Movement.new(name: "squat", reps: 15)
squat.instructions = "Stand with feet slightly wider than shoulder-width apart. While maintaining upright torso, bend knees and descend as if sitting down in a chair. Slowly ascend while gradually straightening legs."
squat.target_area = "glutes, hamstrings and quadriceps"
squat.modification = "Start with a shallow movement or use a wall to provide stability."
squat.challenge = "Add a plyometric jump or a side-step."
squat.save
