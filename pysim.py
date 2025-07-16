import pybullet as p

p.connect(p.GUI)

p.setGravity(0, 0, -9.8)

p.loadURDF("combined.urdf", [0,0,0])

while True:
    p.stepSimulation()