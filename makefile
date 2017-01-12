# [Insert witty comment here]

# start stuff

# Edit these directories if more are needed.  Order is ASM, C++, C.
SDIRS		:=	$(CURDIR) src
#CPPDIRS		:=	$(CURDIR) 
#CDIRS		:=	$(CURDIR) 

# The linker configuration file name
LDCFG=ldconfig.cfg

# The name of the VICE label file
VLFILE=used_addresses.txt

# end stuff

PROJ=$(shell basename $(CURDIR))

#EDIS=$(proj)_elfdis.stmp

AS=ca65
LD=ld65
OD=od65

ASFLAGS=--cpu 6502 -U -g
LDFLAGS=-o $(PROJ).bin -C $(LDCFG) -Ln $(VLFILE)

COMP=$(AS) $(ASFLAGS)
COMP2=$(AS) $(ASFLAGS) $(1)
LINK=$(LD) $(1) $(LDFLAGS)


export VPATH	:=	$(foreach dir,$(SDIRS),$(CURDIR)/$(dir))

ASFILES		:=	$(foreach dir,$(SDIRS),$(notdir $(wildcard $(dir)/*.jolt80)))

ASOBJS=$(ASFILES:.jolt80=.o)
#ASLSTS=$(ASFILES:.jolt80=.lst)

all:  all_pre $(ASOBJS)
	@#$(call LINK, objs/*.o) && ./tools/dump_readmemh_input.sh
	$(call LINK, objs/*.o) && ./tools/dump_readmemh_input.sh && ./tools/dump_readmemh_input_16.sh

all_pre: 
	mkdir -p objs

$(ASOBJS) : %.o : %.jolt80
	$(call COMP, $(@:.o=.lst)) $< -o objs/$@

clean:  
	rm -fv *.stmp *.o objs/*.o $(PROJ).bin $(VLFILE) && rmdir objs

rebuild:  
	make clean && make -j8
