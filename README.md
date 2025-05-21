# ROS-docker

sudo docker run -it --gpus all --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" --env="NVIDIA_VISIBLE_DEVICES=all" --env="NVIDIA_DRIVER_CAPABILITIES=all" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --volume="$HOME/.Xauthority:/root/.Xauthority:rw" --device-cgroup-rule='c 189:* rmw' --device=/dev/bus/usb:/dev/bus/usb --privileged --network host franka_ros:1.0

xhost +local:root  


https://frankaemika.github.io/docs/franka_ros.html

https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

https://docs.docker.com/engine/install/linux-postinstall/


sudo docker exec -it d36d136b7045 bash


roslaunch franka_gazebo panda.launch x:=-0.5     world:=$(rospack find franka_gazebo)/world/stone.sdf     controller:=cartesian_impedance_example_controller     rviz:=true

roslaunch franka_gazebo panda.launch x:=-0.5     world:=$(rospack find franka_gazebo)/world/stone.sdf     controller:=cartesian_impedance_example_controller interactive_marker:=false



rostopic pub -r 10 /cartesian_impedance_example_controller/equilibrium_pose geometry_msgs/PoseStamped "header:
  stamp: now
  frame_id: 'base_link'
pose:
  position:
    x: 0.0
    y: 0.5
    z: 0.0
  orientation:
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0" &
sleep 3 && kill $!
