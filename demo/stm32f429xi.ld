ENTRY(Reset_Handler)
MEMORY
{
    ROM    (rx): ORIGIN = 0x08000000, LENGTH = 2048K
    BANK0  (rx): ORIGIN = 0x08000000, LENGTH = 1024K
    BANK1  (rx): ORIGIN = 0x08100000, LENGTH = 1024K
    RAM   (rwx): ORIGIN = 0x20000000, LENGTH = 192K
    SRAM1 (rwx): ORIGIN = 0x20000000, LENGTH = 112K
    SRAM2 (rwx): ORIGIN = 0x2001C000, LENGTH = 16K
    SRAM3 (rwx): ORIGIN = 0x20020000, LENGTH = 64K
    CMRAM (rwx): ORIGIN = 0x10000000, LENGTH = 64K
}
SECTIONS
{
	.text :
	{
		KEEP(*(.isr_vector))
		*(.text*)
		KEEP(*(.init))  KEEP(*(.fini))
		*crtbegin.o(.ctors)
		*crtbegin?.o(.ctors)
		*(EXCLUDE_FILE(*crtend?.o *crtend.o) .ctors)
		*(SORT(.ctors.*))
		*(.ctors)
		*crtbegin.o(.dtors)
		*crtbegin?.o(.dtors)
		*(EXCLUDE_FILE(*crtend?.o *crtend.o).dtors)
		*(SORT(.dtors.*))
		*(.dtors)
		*(.rodata*)
		KEEP(*(.eh_frame*))
	} > ROM
    .ARM.extab :
    {
    	*(.ARM.extab* .gnu.linkonce.armextab.*)
    } > ROM
	__exidx_start = .;
	.ARM.exidx :
	{
		*(.ARM.exidx* .gnu.linkonce.armexidx.*)
	} > ROM
	__exidx_end = .;
	__etext = .;
	.data : AT (__etext)
	{
		__data_start__ = .;
		*(vtable)
		*(.data*)
		. = ALIGN(4);
		PROVIDE_HIDDEN (__preinit_array_start = .);
		KEEP(*(.preinit_array))
		PROVIDE_HIDDEN (__preinit_array_end = .);
		. = ALIGN(4);
		PROVIDE_HIDDEN (__init_array_start = .);
		KEEP(*(SORT(.init_array.*)))
		KEEP(*(.init_array))
		PROVIDE_HIDDEN (__init_array_end = .);
		. = ALIGN(4);
		PROVIDE_HIDDEN (__fini_array_start = .);
		KEEP(*(SORT(.fini_array.*)))
		KEEP(*(.fini_array))
		PROVIDE_HIDDEN (__fini_array_end = .);
		. = ALIGN(4);
		__data_end__ = .;
	} > RAM
	.bss (NOLOAD) :
	{
		__bss_start__ = .;
		*(.bss*)
		*(COMMON)
		__bss_end__ = .;
	} > RAM
	.heap (NOLOAD) :
	{
		__end__ = .;
		*(.heap*)
		__HeapLimit = .;
	} > RAM
	.stack_dummy (NOLOAD) :
	{
		*(.stack)
	} > RAM

	__StackTop = ORIGIN(RAM) + LENGTH(RAM);
	__StackLimit = __StackTop - SIZEOF(.stack_dummy);
	PROVIDE(__stack = __StackTop);
	ASSERT(__StackLimit >= __HeapLimit, "region RAM overflowed with stack")

	PROVIDE(_estack = __stack);
	PROVIDE(_sidata = __etext);
	PROVIDE(_sdata = __data_start__);
	PROVIDE(_edata = __data_end__);
	PROVIDE(_sbss = __bss_start__);
	PROVIDE(_ebss = __bss_end__);
}
