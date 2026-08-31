# Test case selection
# TC ?= another_i2c_test
TC ?= axi_i2c_test

SEED ?= 1234

# VCS compile options
VCS_OPTS := -full64 -sverilog -ntb_opts uvm-1.2
VCS_OPTS += -timescale=1ns/1ps
VCS_OPTS += -debug_access+all -kdb -lca
VCS_OPTS += -cm line+cond+fsm+tgl+branch+assert
VCS_OPTS += +incdir+./tb

# Simulation options
SIM_OPTS := +UVM_TESTNAME=$(TC)
SIM_OPTS += +UVM_VERBOSITY=UVM_HIGH
SIM_OPTS += +ntb_random_seed=$(SEED)
SIM_OPTS += -cm line+cond+fsm+tgl+branch+assert
SIM_OPTS += -cm_dir coverage.vdb
SIM_OPTS += -cm_name $(TC)_$(SEED)

# Verdi options
VERDI_OPTS := -dbdir simv.daidir
COV_OPTS   := -cov -covdir coverage.vdb

.PHONY: all compile sim verdi vw vc clean help

all: sim

compile:
	vcs $(VCS_OPTS) -f filelist.f -top tb_top -o simv \
		-l compile.log

sim: compile
	./simv $(SIM_OPTS) -l sim.log

# Run the simulation and open the VCS KDB database in Verdi.
verdi: sim
	verdi $(VERDI_OPTS)

# Open the existing design database without rerunning simulation.
vw:
	verdi $(VERDI_OPTS) &

# Run the simulation and open the coverage database.
vc: sim
	verdi $(COV_OPTS)

clean:
	rm -rf simv simv.daidir csrc ucli.key vc_hdrs.h \
		compile.log sim.log novas.conf novas.rc verdiLog \
		coverage.vdb *.fsdb *.vpd *.key

help:
	@echo "make compile                       Compile DUT and UVM testbench"
	@echo "make sim [TC=test] [SEED=number]   Compile and run simulation"
	@echo "make verdi                         Run simulation and open Verdi"
	@echo "make vw                            Open the existing Verdi database"
	@echo "make vc                            Run and open coverage results"
	@echo "make clean                         Remove generated simulation files"
