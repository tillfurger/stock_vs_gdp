import subprocess

program_list = ["upstream.py", "process.py"]

for program in program_list:
    subprocess.call(["python", program])
    print("Finished: " + program)