import pybullet as p

p.connect(p.GUI)

p.setGravity(0, 0, -9.8)
p.loadURDF("aubo_i5.urdf", [0,0,0])
# p.loadURDF("final_rooted_combined_matlab.urdf", [0,0,0])

while True:
    p.stepSimulation()