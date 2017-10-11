# I added seed data here. Seed database with 'rake db:seed'
squat = Movement.new(name: "bodyweight squat", reps: 15)
squat.instructions = "Stand with feet slightly wider than shoulder-width apart. While maintaining upright torso, bend knees and descend as if sitting down in a chair. Slowly ascend while gradually straightening legs."
squat.target_area = "glutes, hamstrings and quadriceps"
squat.modification = "Start with a shallow movement or use a wall to provide stability."
squat.challenge = "Add a plyometric jump or a side-step."
squat.save

lunge = Movement.new(name: "forward lunge", reps: 10)
lunge.instructions = "Maintaining upright posture, take a giant step forward with one leg. Descend until both knees are bent at a 90 degree angle, with your back knee hovering above the ground. Push yourself upwards to starting position."
lunge.target_area = "glutes, hamstrings and quadriceps"
lunge.modification = "Reduce range of motion by taking smaller steps."
lunge.challenge = "Perform a bicep curl using dumbbells while lunging."
lunge.save
