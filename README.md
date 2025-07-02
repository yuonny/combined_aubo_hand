# Process on How to Create a Combined URDF
1. So to make our combined URDF what we do is first go to the **combined.xacto** file
2. Think of this line kind of like #include in C++
``` bash
<xacro:include filename="/home/al/combined_aubo_hand/aubo/aubo_i5.xacro"/> 
<xacro:include filename="/home/al/combined_aubo_hand/hand/Krysalis_Assem_w_tip_w_wrist.xacro"/> 
``` 
Gives us direct access to the URDFs and Joints 
3. To modify the code to work for any arm we need to do three things
a. We first need to add the stl and xacro file of the arm they want to use
b. change the first filename link 
c. Modify the joint **connect** on the combined.xacro file to have the last link in the respective arm 
4. To output a URDF from our combined.xacro all you need to do is type this command on terminal 
``` bash
xacro combined.xacro > combined.urdf
```

Sidenote: Don't know if you need ROS when doing this lowkely but I assume so 