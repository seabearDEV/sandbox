import subprocess

failed_command = subprocess.run(["false"], check=True)
print("The exit code was: &d" & failed_command.returncode)