# Makefile
# aoneill - 09/10/17

# Top level
SRC := src
OBJ := obj
BIN := bin
SYSTEMD := systemd

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

PKGS := protobuf
CXXFLAGS += $(shell pkg-config --cflags $(PKGS))
LDFLAGS  := $(shell pkg-config --libs $(PKGS))

################################################################################

# Basic functionality
SUPPORT_C = $(shell cd $(SRC)/ \
						    && find * -name "*.cc" -not -name "main.cc" -type f 2>/dev/null)
SUPPORT_O = $(addprefix $(OBJ)/,$(SUPPORT_C:%.cc=%.o))

all: CXXFLAGS += -Ofast
all: init $(BIN)/$(EXEC_NAME)
debug: CXXFLAGS += -DDEBUG -g -pg
debug: init $(BIN)/$(EXEC_NAME)

$(OBJ)/%.o: $(SRC)/%.cc
	@mkdir -p "$(dir $@)"
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -c $^ -o $@

################################################################################

# Executable
$(BIN)/$(EXEC_NAME): $(SUPPORT_O) $(SRC)/main.cc
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $^ -o $@

################################################################################

# Structure
$(OBJ) $(BIN):
	mkdir -p "$(OBJ)" "$(BIN)"

.PHONY: init
init: $(OBJ) $(BIN)

.PHONY: clean
clean:
	rm -rf ./$(OBJ)/ ./$(BIN)/
	rm -rf gmon.out

# Distribute
.PHONY: install
install: all
	mkdir -p $(PREFIX)/bin $(PREFIX)/lib/systemd/system
	cp $(BIN)/* $(PREFIX)/bin/
	cp $(SYSTEMD)/* $(PREFIX)/lib/systemd/system/

