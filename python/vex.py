# Import the vexcodeiq library
import vexcodeiq

# Initialize the brain
brain = vexcodeiq.Brain()

# Set up the motors
left_motor = vexcodeiq.Motor(vexcodeiq.Ports.PORT1)
right_motor = vexcodeiq.Motor(vexcodeiq.Ports.PORT10)
intake_motor = vexcodeiq.Motor(vexcodeiq.Ports.PORT20)

# Set up the sensors
limit_switch = vexcodeiq.LimitSwitch(vexcodeiq.Ports.PORT4)

# Initialize variables
drive_power = 50
intake_power = 50

# Define functions
def drive_forward():
    left_motor.spin(vexcodeiq.DirectionType.FORWARD, drive_power)
    right_motor.spin(vexcodeiq.DirectionType.FORWARD, drive_power)

def stop_drive():
    left_motor.stop()
    right_motor.stop()

def intake():
    intake_motor.spin(vexcodeiq.DirectionType.FORWARD, intake_power)

def eject():
    intake_motor.spin(vexcodeiq.DirectionType.REVERSE, intake_power)

def stop_intake():
    intake_motor.stop()

# Define the main program loop
while True:
    # Check if the limit switch is pressed
    if limit_switch.is_pressed():
        # Stop the drive motors and intake motor
        stop_drive()
        stop_intake()
    else:
        # Drive forward
        drive_forward()

        # Check for user input to control the intake motor
        if brain.button_is_pressed(vexcodeiq.Button.A):
            intake()
        elif brain.button_is_pressed(vexcodeiq.Button.B):
            eject()
        else:
            stop_intake()