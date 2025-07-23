import pybullet as p
import time

p.connect(p.GUI)

p.setGravity(0, 0, -9.8)
robotId = p.loadURDF("aubo_i5.urdf", [0,0,0], useFixedBase = True)

endEffectorIndex = 6
endEffectorPos = [[6, 5, 4], [1, 8.5, 9]]

for pos in endEffectorPos:
    jointPoses = p.calculateInverseKinematics(
                robotId,
                endEffectorIndex,
                pos,
                solver=p.IK_DLS,
                maxNumIterations=50,
                residualThreshold=0.0001,
            )

    for i in range(6):
            p.setJointMotorControl2(
                bodyIndex=robotId,
                jointIndex=i,
                controlMode=p.POSITION_CONTROL,
                targetPosition=jointPoses[i],
                targetVelocity=0,
                force=500,
                positionGain=0.3,
                velocityGain=1,
            )
    for _ in range(480):  # simulate 1 second if timestep is 1/240
        p.stepSimulation()
        time.sleep(1/480)



# Joint Index: 0, Joint Name: world_joint, Link Name: base_link
# Joint Index: 1, Joint Name: shoulder_joint, Link Name: shoulder_Link
# Joint Index: 2, Joint Name: upperArm_joint, Link Name: upperArm_Link
# Joint Index: 3, Joint Name: foreArm_joint, Link Name: foreArm_Link
# Joint Index: 4, Joint Name: wrist1_joint, Link Name: wrist1_Link
# Joint Index: 5, Joint Name: wrist2_joint, Link Name: wrist2_Link
# Joint Index: 6, Joint Name: wrist3_joint, Link Name: wrist3_Lin

while True:
    p.stepSimulation()