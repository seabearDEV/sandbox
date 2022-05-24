import subprocess

list_dir = subprocess.Popen(["ls", "-l"])
list_dir.wait()