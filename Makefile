# Makefile
# aoneill - 09/10/17

# Top level
SRC := src
OBJ := obj

EXEC_NAME := stowaway
SYSTEMD_SERVICE := $(EXEC_NAME).service

# System
ifeq ($(origin PREFIX), undefined)
	PREFIX := /usr
endif

################################################################################

# Toolchain
CXX := g++
CXXFLAGS := -Wall -fPIC -DPIC -I./$(SRC)

################################################################################

# Basic functionality
SUPPORT_C = $(shell cd $(SRC)/ && find * -name "*.cc" -type f 2>/dev/null)
SUPPORT_O = $(addprefix $(OBJ)/,$(SUPPORT_C:%.cc=%.o))

all: CXXFLAGS += -Ofast
all: init $(LIB_NAME) $(EXEC_NAME)
debug: CXXFLAGS += -DDEBUG -g -pg
debug: init $(LIB_NAME) $(EXEC_NAME)

$(OBJ)/%.o: $(SRC)/%.cc
	@mkdir -p "$(dir $@)"
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -c $^ -o $@

################################################################################

# Executable
$(EXEC_NAME): $(SUPPORT_O) main.cc
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $^ -o $@

################################################################################

# Structure
$(OBJ):
	mkdir -p "$(OBJ)"

.PHONY: init
init: $(OBJ)

.PHONY: clean
clean:
	rm -rf ./$(OBJ)/
	rm -rf $(EXEC_NAME) gmon.out

# Distribute
.PHONY: install
install: all
	mkdir -p $(PREFIX)/bin $(PREFIX)/lib/systemd/system
	cp $(EXEC_NAME) $(PREFIX)/bin/
	cp $(SYSTEMD_SERVICE) $(PREFIX)/lib/systemd/system/

