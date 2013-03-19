CC=gcc
CXX=g++
CFLAGS=-g 
CPPFLAGS=-w $(CFLAGS) -I include/

SOURCES=lattice.cpp\
	sqlite_wrapper.cpp\
	utility.cpp\
	index_builder.cpp
 
all: indexer retrieve ctags

vpath %.h include/
vpath %.cpp src/

OBJ=$(addprefix obj/,$(SOURCES:.cpp=.o))

LIBRARY= -lsqlite3\
	 -lpthread\
	 -ldl\
	 -lcmdparser\
	 -larray\

LIBRARY_PATH=-L/usr/local/boton/lib/

indexer: $(OBJ) indexer.cpp
	$(CXX) $(CPPFLAGS) -o $@ $^ $(LIBRARY_PATH) $(LIBRARY) 
retrieve: $(OBJ) retrieve.cpp
	$(CXX) $(CPPFLAGS) -o $@ $^ $(LIBRARY_PATH) $(LIBRARY)
test: $(OBJ) test.cpp
	$(CXX) $(CPPFLAGS) -o $@ $^ $(LIBRARY_PATH) $(LIBRARY)
ctags:
	@ctags -R *

obj/%.o: %.cpp
	$(CXX) $(CPPFLAGS) -o $@ -c $<

obj/%.d: %.cpp
	@$(CXX) -MM $(CPPFLAGS) $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,obj/\1.o $@ : ,g' < $@.$$$$ > $@;\
	rm -f $@.$$$$

-include $(addprefix obj/,$(subst .cpp,.d,$(SOURCES)))

.PHONY:
clean:
	rm -rf indexer retrieve obj/*
