import xml.etree.ElementTree as ET
import os

tree = ET.parse("combined.urdf")
root = tree.getroot()

for mesh in root.findall(".//mesh"):
    filename = mesh.get("filename")
    if filename:
        if filename.endswith(".DAE"):
            filename = filename.replace(".DAE", ".STL")
        new_file_name = os.path.basename(filename)
        mesh.set("filename", new_file_name)

tree.write("combined.urdf")