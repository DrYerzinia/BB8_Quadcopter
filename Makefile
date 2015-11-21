TARGETS=$(shell ls scad/parts | sed -e 's/scad/stl/g' | sed -e 's/^/stl\//')
TARGETS+=$(shell ls scad/parts | sed -e 's/scad/gcode/g' | sed -e 's/^/gcode\//')

SLICE_CFG = --print-center 76,76

SLICE_BDY = --load settings/body.ini
SLICE_DOR = --load settings/door.ini
SLICE_SOL = --load settings/solid_mount.ini

all: ${TARGETS}

stl/Body_P1.stl: scad/parts/Body_P1.scad
	openscad -m make -o $@ $<

stl/Body_P2.stl: scad/parts/Body_P2.scad
	openscad -m make -o $@ $<

stl/Body_P3.stl: scad/parts/Body_P3.scad
	openscad -m make -o $@ $<

stl/Body_P4.stl: scad/parts/Body_P4.scad
	openscad -m make -o $@ $<

stl/Body_P5.stl: scad/parts/Body_P5.scad
	openscad -m make -o $@ $<

stl/Body_P6.stl: scad/parts/Body_P6.scad
	openscad -m make -o $@ $<

stl/Body_P7.stl: scad/parts/Body_P7.scad
	openscad -m make -o $@ $<

stl/Body_P8.stl: scad/parts/Body_P8.scad
	openscad -m make -o $@ $<

stl/Body_P9.stl: scad/parts/Body_P9.scad
	openscad -m make -o $@ $<

stl/Body_P10.stl: scad/parts/Body_P10.scad
	openscad -m make -o $@ $<

stl/Body_P11.stl: scad/parts/Body_P11.scad
	openscad -m make -o $@ $<

stl/Body_P12.stl: scad/parts/Body_P12.scad
	openscad -m make -o $@ $<

stl/Body_P13.stl: scad/parts/Body_P13.scad
	openscad -m make -o $@ $<

stl/Body_P14_motor_lift_servo_mount.stl: scad/parts/Body_P14_motor_lift_servo_mount.scad
	openscad -m make -o $@ $<

stl/Body_P15_motor_lift_drum.stl: scad/parts/Body_P15_motor_lift_drum.scad
	openscad -m make -o $@ $<

stl/Door_P1.stl: scad/parts/Door_P1.scad
	openscad -m make -o $@ $<

stl/Door_P2.stl: scad/parts/Door_P2.scad
	openscad -m make -o $@ $<

stl/Door_P3.stl: scad/parts/Door_P3.scad
	openscad -m make -o $@ $<

stl/Door_P4.stl: scad/parts/Door_P4.scad
	openscad -m make -o $@ $<

stl/Door_P5.stl: scad/parts/Door_P5.scad
	openscad -m make -o $@ $<

stl/Door_P6_servo_lever.stl: scad/parts/Door_P6_servo_lever.scad
	openscad -m make -o $@ $<

stl/Door_P7_middle_door_brace.stl: scad/parts/Door_P7_middle_door_brace.scad
	openscad -m make -o $@ $<

stl/Door_P8_middle_door_bumper.stl: scad/parts/Door_P8_middle_door_bumper.scad
	openscad -m make -o $@ $<

stl/Door_P9_cover_slide_hinge.stl: scad/parts/Door_P9_cover_slide_hinge.scad
	openscad -m make -o $@ $<

stl/Door_P10_cover_slide_brace.stl: scad/parts/Door_P10_cover_slide_brace.scad
	openscad -m make -o $@ $<

stl/Door_P11_cover_slide.stl: scad/parts/Door_P11_cover_slide.scad
	openscad -m make -o $@ $<

stl/Prop_P1_hinge.stl: scad/parts/Prop_P1_hinge.scad
	openscad -m make -o $@ $<

stl/Prop_P2_motor_mount.stl: scad/parts/Prop_P2_motor_mount.scad
	openscad -m make -o $@ $<

gcode/Body_P1.gcode: stl/Body_P1.stl
	slic3r $< $(SLICE_BDY) $(SLICE_CFG) --skirts=0 --output $@

gcode/Body_P2.gcode: stl/Body_P2.stl
	slic3r $< $(SLICE_BDY) $(SLICE_CFG) --skirts=0 --brim-width=3 --output $@

gcode/Body_P3.gcode: stl/Body_P3.stl
	slic3r $< $(SLICE_BDY) $(SLICE_CFG) --output $@

gcode/Body_P4.gcode: stl/Body_P4.stl
	slic3r $< $(SLICE_BDY) $(SLICE_CFG) --output $@

gcode/Body_P5.gcode: stl/Body_P5.stl
	slic3r $< $(SLICE_BDY) $(SLICE_CFG) --output $@

gcode/Body_P6.gcode: stl/Body_P6.stl
	slic3r $< $(SLICE_BDY) $(SLICE_CFG) --output $@

gcode/Body_P7.gcode: stl/Body_P7.stl
	slic3r $< $(SLICE_BDY) $(SLICE_CFG) --output $@

gcode/Body_P8.gcode: stl/Body_P8.stl
	slic3r $< $(SLICE_BDY) $(SLICE_CFG) --output $@

gcode/Body_P9.gcode: stl/Body_P9.stl
	2 $< $(SLICE_BDY) $(SLICE_CFG) --output $@

gcode/Body_P10.gcode: stl/Body_P10.stl
	slic3r $< $(SLICE_BDY) $(SLICE_CFG) --output $@

gcode/Body_P11.gcode: stl/Body_P11.stl
	slic3r $< $(SLICE_BDY) $(SLICE_CFG) --output $@

gcode/Body_P12.gcode: stl/Body_P12.stl
	slic3r $< $(SLICE_BDY) $(SLICE_CFG) --output $@

gcode/Body_P13.gcode: stl/Body_P13.stl
	slic3r $< $(SLICE_BDY) $(SLICE_CFG) --output $@

gcode/Body_P14_motor_lift_servo_mount.gcode: stl/Body_P14_motor_lift_servo_mount.stl
	slic3r $< $(SLICE_SOL) $(SLICE_CFG) --output $@

gcode/Body_P15_motor_lift_drum.gcode: stl/Body_P15_motor_lift_drum.stl
	slic3r $< $(SLICE_SOL) $(SLICE_CFG) --output $@

gcode/Door_P1.gcode: stl/Door_P1.stl
	slic3r $< $(SLICE_DOR) $(SLICE_CFG) --output $@

gcode/Door_P2.gcode: stl/Door_P2.stl
	slic3r $< $(SLICE_DOR) $(SLICE_CFG) --output $@

gcode/Door_P3.gcode: stl/Door_P3.stl
	slic3r $< $(SLICE_DOR) $(SLICE_CFG) --output $@

gcode/Door_P11_cover_slide.gcode: stl/Door_P11_cover_slide.stl
	slic3r $< $(SLICE_SOL) $(SLICE_CFG) --output $@

gcode/Prop_P1_hinge.gcode: stl/Prop_P1_hinge.stl
	slic3r $< $(SLICE_SOL) $(SLICE_CFG) --output $@

gcode/Prop_P2_motor_mount.gcode: stl/Prop_P2_motor_mount.stl
	slic3r $< $(SLICE_SOL) $(SLICE_CFG) --output $@
