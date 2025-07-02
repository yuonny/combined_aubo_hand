# Process on How to Create a Combined URDF
## Understanding the Connection 
1. So to make our combined URDF what we do is first go to the **combined.xacto** file
2. Think of this line kind of like #include in C++
``` bash
<xacro:include filename="/home/al/combined_aubo_hand/aubo/aubo_i5.xacro"/> 
<xacro:include filename="/home/al/combined_aubo_hand/hand/Krysalis_Assem_w_tip_w_wrist.xacro"/> 
``` 
Gives us direct access to the URDFs and Joints 

## How to Modify the Combined Xacro to Work with Any Arm

To adapt the code for a different robotic arm, follow these steps:

1. **Add STL and XACRO Files**
   - Include the STL and `.xacro` files of the desired robotic arm in your project directory (or reference their path correctly).

2. **Update the Arm File Include**
   - Open `combined.xacro` and update the include statement for the arm:
     ```xml
     <xacro:include filename="PATH/TO/YOUR/ARM.xacro" />
     ```
   - Replace `PATH/TO/YOUR/ARM.xacro` with the actual path to your chosen arm's XACRO file.

3. **Modify the Connection Joint**
   - In `combined.xacro`, update the joint named `connect` so that its `parent` attribute matches the **last link** of your new arm.
   - Example:
     ```xml
     <joint name="connect" type="fixed">
       <parent link="YOUR_ARM_LAST_LINK" />
       <child link="YOUR_HAND_BASE_LINK" />
       <!-- ... -->
     </joint>
     ```

> 💡 Make sure that the link names match exactly what's defined in the respective arm and hand URDF/XACRO files.

 ## Converting to URDF 
 To output a URDF from our combined.xacro all you need to do is type this command on terminal 

``` bash
xacro combined.xacro > combined.urdf
```

Sidenote: Don't know if you need ROS when doing this lowkely but I assume so 
