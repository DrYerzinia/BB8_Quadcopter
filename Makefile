TARGETS=$(shell ls scad/parts | sed -e 's/scad/stl/g' | sed -e 's/^/stl\//')
TARGETS+=$(shell ls scad/parts | sed -e 's/scad/gcode/g' | sed -e 's/^/gcode\//')

SLICE_CFG = --load settings/body.ini --print-center 76,76

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

gcode/Body_P1.gcode: stl/Body_P1.stl
	slic3r $< $(SLICE_CFG) --output $@

gcode/Body_P2.gcode: stl/Body_P2.stl
	slic3r $< $(SLICE_CFG) --output $@

