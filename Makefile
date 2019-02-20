CC ?= gcc

# library name
LIB_NAME = lili

# source directory and output name
SRC_DIR = src
OUTPUT = lib$(LIB_NAME)

# flags for debugging
ifeq ($(DEBUG), 1)
CFLAGS += -O0 -g -DDEBUG
else
CFLAGS += -O3
endif

# flags
CFLAGS += $(CONFIG) -Wall -Wextra -fPIC
LDFLAGS += -shared

# libraries
LIBS =

# source and object files
SRC = $(wildcard $(SRC_DIR)/*.c)
OBJ = $(SRC:.c=.o)

# library version
LIB_VERSION = $(shell grep -oP "define.*VERSION[ \t]*\K[0-9.\"]*" $(SRC_DIR)/$(LIB_NAME).h)

.PHONY: doc

all: $(OUTPUT).so $(OUTPUT).a

$(OUTPUT).so: $(OBJ)
	$(CC) $(OBJ) $(LDFLAGS) $(LIBS) -o $@

$(OUTPUT).a: $(OBJ)
	$(AR) cqs $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

clean:
	rm -f $(OBJ) $(basename $(OUTPUT)).*

doc:
	@( cat Doxyfile ; echo "PROJECT_NUMBER=$(LIB_VERSION)" ) | doxygen -
	@echo "Documentation for $(LIB_NAME) version $(LIB_VERSION) generated"
