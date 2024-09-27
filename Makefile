CFLAGS_applespi.o = -I$(src)	# for tracing

CONFIG_MODULE_SIG=n
CONFIG_MODULE_SIG_ALL=n
# CONFIG_MODULE_SIG_FORCE is not set 
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set

KVERSION := $(KERNELRELEASE)
ifeq ($(origin KERNELRELEASE), undefined)
KVERSION := $(shell uname -r)
endif

ifneq ($(KVERSION),)
	ifeq ($(shell expr $(KVERSION) \< 5.3), 1)
		obj-m += applespi.o
	endif
endif

obj-m += apple-ibridge.o
obj-m += apple-ib-tb.o
obj-m += apple-ib-als.o

KDIR := /lib/modules/$(KVERSION)/build
PWD := $(shell pwd)

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean

install:
	$(MAKE) -C $(KDIR) M=$(PWD) modules_install

test: all
	sync
	-rmmod applespi
	insmod ./applespi.ko
