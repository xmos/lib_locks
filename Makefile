DIRS	= lib_locks

all: $(DIRS)
lib_locks: dummy
	$(MAKE) -C lib_locks

clean:
	-for d in $(DIRS); do ($(MAKE) -C $$d clean); done

dummy:
