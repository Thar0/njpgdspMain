.rsp

// addressing
DMEM_START equ 0x0000
DMEM_SIZE equ 0x1000
DMEM_END equ DMEM_START + DMEM_SIZE
IMEM_START equ DMEM_END
IMEM_SIZE equ 0x1000
IMEM_END equ IMEM_START + IMEM_SIZE

DMEM_START_VIRT equ 0x04000000 | DMEM_START
IMEM_START_VIRT equ 0x04000000 | IMEM_START

RSPBOOT_ENTRYPOINT equ IMEM_START + 0x80
RSPBOOT_ENTRYPOINT_VIRT equ 0x04000000 | RSPBOOT_ENTRYPOINT

OS_YIELD_DATA_SIZE equ 0xC00

// OSTask structure
OS_TASK_SIZE           equ 0x40
.definelabel OSTask_addr, DMEM_END - OS_TASK_SIZE

OS_TASK_OFF_TYPE       equ 0x00
OS_TASK_OFF_FLAGS      equ 0x04
OS_TASK_OFF_UBOOT      equ 0x08
OS_TASK_OFF_UBOOT_SZ   equ 0x0C
OS_TASK_OFF_UCODE      equ 0x10
OS_TASK_OFF_UCODE_SZ   equ 0x14
OS_TASK_OFF_UDATA      equ 0x18
OS_TASK_OFF_UDATA_SZ   equ 0x1C
OS_TASK_OFF_STACK      equ 0x20
OS_TASK_OFF_STACK_SZ   equ 0x24
OS_TASK_OFF_OUTBUFF    equ 0x28
OS_TASK_OFF_OUTBUFF_SZ equ 0x2C
OS_TASK_OFF_DATA       equ 0x30
OS_TASK_OFF_DATA_SZ    equ 0x34
OS_TASK_OFF_YIELD      equ 0x38
OS_TASK_OFF_YIELD_SZ   equ 0x3C

// OSTask flags
OS_TASK_YIELDED  equ 0x0001
OS_TASK_DP_WAIT  equ 0x0002
OS_TASK_LOADABLE equ 0x0004
OS_TASK_SP_ONLY  equ 0x0008
OS_TASK_USR0     equ 0x0010
OS_TASK_USR1     equ 0x0020
OS_TASK_USR2     equ 0x0040
OS_TASK_USR3     equ 0x0080

// DPC Status flags (write)
DPC_CLR_XBUS_DMEM_DMA equ 0x0001
DPC_SET_XBUS_DMEM_DMA equ 0x0002
DPC_CLR_FREEZE        equ 0x0004
DPC_SET_FREEZE        equ 0x0008
DPC_CLR_FLUSH         equ 0x0010
DPC_SET_FLUSH         equ 0x0020
DPC_CLR_TMEM_CTR      equ 0x0040
DPC_CLR_PIPE_CTR      equ 0x0080
DPC_CLR_CMD_CTR       equ 0x0100
DPC_CLR_CLOCK_CTR     equ 0x0200

// DPC Status flags (read)
DPC_STATUS_XBUS_DMEM_DMA equ 0x0001
DPC_STATUS_FREEZE        equ 0x0002
DPC_STATUS_FLUSH         equ 0x0004
DPC_STATUS_START_GCLK    equ 0x0008
DPC_STATUS_TMEM_BUSY     equ 0x0010
DPC_STATUS_PIPE_BUSY     equ 0x0020
DPC_STATUS_CMD_BUSY      equ 0x0040
DPC_STATUS_CBUF_READY    equ 0x0080
DPC_STATUS_DMA_BUSY      equ 0x0100
DPC_STATUS_END_VALID     equ 0x0200
DPC_STATUS_START_VALID   equ 0x0400

// SP Status flags (write)
SP_CLR_HALT       equ 0x00000001
SP_SET_HALT       equ 0x00000002
SP_CLR_BROKE      equ 0x00000004
SP_CLR_INTR       equ 0x00000008
SP_SET_INTR       equ 0x00000010
SP_CLR_SSTEP      equ 0x00000020
SP_SET_SSTEP      equ 0x00000040
SP_CLR_INTR_BREAK equ 0x00000080
SP_SET_INTR_BREAK equ 0x00000100
SP_CLR_SIG0       equ 0x00000200 // yield
SP_SET_SIG0       equ 0x00000400
SP_CLR_SIG1       equ 0x00000800 // yielded
SP_SET_SIG1       equ 0x00001000
SP_CLR_SIG2       equ 0x00002000 // task done
SP_SET_SIG2       equ 0x00004000
SP_CLR_SIG3       equ 0x00008000 // rsp signal
SP_SET_SIG3       equ 0x00010000
SP_CLR_SIG4       equ 0x00020000 // cpu signal
SP_SET_SIG4       equ 0x00040000
SP_CLR_SIG5       equ 0x00080000
SP_SET_SIG5       equ 0x00100000
SP_CLR_SIG6       equ 0x00200000
SP_SET_SIG6       equ 0x00400000
SP_CLR_SIG7       equ 0x00800000
SP_SET_SIG7       equ 0x01000000

// SP Status flags (read)
SP_STATUS_HALT       equ 0x0001
SP_STATUS_BROKE      equ 0x0002
SP_STATUS_DMA_BUSY   equ 0x0004
SP_STATUS_DMA_FULL   equ 0x0008
SP_STATUS_IO_FULL    equ 0x0010
SP_STATUS_SSTEP      equ 0x0020
SP_STATUS_INTR_BREAK equ 0x0040
SP_STATUS_SIG0       equ 0x0080 // yield
SP_STATUS_SIG1       equ 0x0100 // yielded
SP_STATUS_SIG2       equ 0x0200 // task done
SP_STATUS_SIG3       equ 0x0400
SP_STATUS_SIG4       equ 0x0800
SP_STATUS_SIG5       equ 0x1000
SP_STATUS_SIG6       equ 0x2000
SP_STATUS_SIG7       equ 0x4000

// scalar macros
.macro li, reg, imm
    addi reg, $zero, imm
.endmacro

// vector macros
.macro vclr, dst
    vxor dst, dst, dst
.endmacro

.create DATA_FILE, DMEM_START

data_0000: 
    .dh 0x10
    .dh 0x2000, 0xC000
    .dh (1 << 11), (1 << 6), (1 << 1)   // Shift amounts for RGBA bits
    .dh 1, 1

data_0010: // YUV to RGB conversion data
    .dh round(0.40250 * 65535), round(0.34430 * 65535), round(0.71441 * 65535), round(0.77300 * 65535)
    .dh 0x0FF0, 0xFFFF
    .dh round(0.0078125 * 65535) // (1 / 128) * 65535
    .dh 2048

data_0020: // IDCT coefficients
    .dh 0x18F9, 0x8276, 0x6A6E, 0xB8E3, 0x471D, 0x7D8A, 0x0000, 0x0000

data_0030: // More IDCT coefficients
    .dh 0x5A82, 0xA57E, 0x30FC, 0x89BE, 0x7642, 0x0000, 0x0000, 0x0000

data_0040: // Unreferenced
    .dh 0x18F9, 0x6A6E, 0xB8E3, 0x8276, 0x471D, 0x18F9, 0x8276, 0x6A6E
    .dh 0x6A6E, 0x8276, 0xE707, 0xB8E3, 0x7D8A, 0x471D, 0x6A6E, 0x18F9

SUBBLOCK_SIZE equ 0x40 * 2  // 64 u16s

MACROBLOCK_SIZE_1 equ SUBBLOCK_SIZE * 4 // type = 0     Y Y U V     ?
MACROBLOCK_SIZE_2 equ SUBBLOCK_SIZE * 6 // type > 0     Y Y Y Y U V ?

qTables:
NUM_QTABLES equ 3

qTableY:
    .skip SUBBLOCK_SIZE

qTableU:
    .skip SUBBLOCK_SIZE

qTableV:
    .skip SUBBLOCK_SIZE

// task data
// 0x01E0
task_data:
TASK_ADDRESS    equ task_data + 0x00        // dram address of macroblock data?
TASK_MBCOUNT    equ task_data + 0x04        // macroblock count
TASK_MODE       equ task_data + 0x08        // mode, 0 = YUV 2 = YYUV ?
TASK_QTABLEYPTR equ task_data + 0x0C        // Y quantization table
TASK_QTABLEUPTR equ task_data + 0x10        // U quantization table
TASK_QTABLEVPTR equ task_data + 0x14        // V quantization table
TASK_MBSIZE     equ task_data + 0x18        // macroblock size (filled in by the microcode on yield)
    .skip 0x20

.headersize task_data - orga()
// the macroblock buffer uses the same space as the task data
// 0x01E0
macroblock_buffer:
    .skip MAX(MACROBLOCK_SIZE_1, MACROBLOCK_SIZE_2)

// 0x04E0
    .skip SUBBLOCK_SIZE
// 0x0560
work_buffer:
// used to store intermediate calculations in various stages
// first stores the result of subblock multiplications
    .skip MAX(MACROBLOCK_SIZE_1, MACROBLOCK_SIZE_2)

zigzag_buffer: // zig-zagged macroblock
    .skip MAX(MACROBLOCK_SIZE_1, MACROBLOCK_SIZE_2)

OUTPUT_BUF_SIZE_1 equ 0x100 // mode = 0
OUTPUT_BUF_SIZE_2 equ 0x200 // mode > 0
    .skip 0x80
// 0x0BE0
outputBuffer:
    .skip MAX(OUTPUT_BUF_SIZE_1, OUTPUT_BUF_SIZE_2)

// Temporary buffer for transposing data
// 0x0DE0
transposeBuffer:
    .skip 0x80

// Unused?
    .skip 0x160

.close

.create CODE_FILE, RSPBOOT_ENTRYPOINT_VIRT

// Global registers

vzero equ v0

jpeg_format     equ $9
macroblock_size equ $12

mbAddr equ $25
mbCount equ $3

outputDRAM equ $26

qTableYPtr equ $9
qTableUPtr equ $10
qTableVPtr equ $11

taskFlags equ $22
taskYieldPtr equ $23
taskYieldSize equ $24

// on entry from rspboot, $1 contains a pointer to the OSTask
entry:
    lw      taskFlags, OS_TASK_OFF_FLAGS($1)
    lw      taskYieldPtr, OS_TASK_OFF_YIELD($1)
    lw      taskYieldSize, OS_TASK_OFF_YIELD_SZ($1)
    andi    taskFlags, taskFlags, OS_TASK_YIELDED   // check if resuming from a yield
    beqz    taskFlags, not_yield                    // branch forward if not resuming from a yield
     lqv    $v2[0], (data_0020)($zero)
    lw      mbCount, TASK_ADDRESS                   // when resuming from a yield, address is replaced with the current mbcount
    lw      mbAddr, TASK_MBCOUNT                    // when resuming from a yield, mbcount is replaced with the current address
    lw      outputDRAM, TASK_MODE
    lw      qTableYPtr, TASK_QTABLEYPTR
    lw      qTableUPtr, TASK_QTABLEUPTR
    lw      qTableVPtr, TASK_QTABLEVPTR
    j       process_task
     lw     macroblock_size, TASK_MBSIZE
not_yield:
    lw      $29, OS_TASK_OFF_DATA_SZ($1)
    lw      $27, OS_TASK_OFF_DATA($1)
    li      $28, task_data
    jal     dma_read                        // read task data structure
     addi   $29, $29, -1
    jal     dma_wait
     li     $29, SUBBLOCK_SIZE - 1          // read quantization tables
    lw      $27, TASK_QTABLEYPTR
    jal     dma_read
     li     $28, qTableY
    jal     dma_wait
     lw     $27, TASK_QTABLEUPTR
    jal     dma_read
     li     $28, qTableU
    jal     dma_wait
     lw     $27, TASK_QTABLEVPTR
    jal     dma_read
     li     $28, qTableV
    jal     dma_wait
     lw     jpeg_format, TASK_MODE
    lw      mbAddr, TASK_ADDRESS
    bgtz    jpeg_format, mode_setup_nonzero     // branch based on mode
     lw     mbCount, TASK_MBCOUNT
    li      $10, MACROBLOCK_SIZE_1 - 1
    li      $11, OUTPUT_BUF_SIZE_1 - 1
    j       mode_setup_done
     li     macroblock_size, MACROBLOCK_SIZE_1
mode_setup_nonzero:
    li      $10, MACROBLOCK_SIZE_2 - 1
    li      $11, OUTPUT_BUF_SIZE_2 - 1
    li      macroblock_size, MACROBLOCK_SIZE_2
mode_setup_done:
    sub     outputDRAM, mbAddr, macroblock_size

// Process task starting either from first run or from yield
process_task:
    addi    $27, mbAddr, 0                  // read in first macroblock
    li      $28, macroblock_buffer
    jal     dma_read
     add    $29, $zero, $10
    add     $2, $zero, mbCount
    lqv     $v3[0], (data_0030)($zero)
    vclr    $vzero                          // set up dedicated zero vector register
    jal     dma_wait
     add    mbAddr, mbAddr, macroblock_size

main_loop:
    beq     $2, mbCount, skip_write_out
     li     $27, outputBuffer               // write out result of previous iteration if not the first main loop iteration
    addi    $28, outputDRAM, 0
    jal     dma_write
     add    $29, $zero, $11
skip_write_out:
    addi    mbCount, mbCount, -1

/**
 *  Inverse Quantization
 */
inverse_quantization:
    @@src         equ $4
    @@dst         equ $5
    @@qTable      equ $6
    @@count       equ $7
    @@numChannels equ $8

    li      @@src, macroblock_buffer
    li      @@dst, work_buffer - SUBBLOCK_SIZE
    li      @@count, NUM_QTABLES
    addi    @@numChannels, jpeg_format, 2   // mode + 2, number of Y channels
    li      @@qTable, qTables
    lqv     $v1[0], (data_0000)($zero)
    lqv     $v16[0], 0x00(@@src)            // load subblock data from macroblock data
    lqv     $v17[0], 0x10(@@src)
    lqv     $v18[0], 0x20(@@src)
    lqv     $v19[0], 0x30(@@src)
    lqv     $v20[0], 0x40(@@src)
    lqv     $v21[0], 0x50(@@src)
    lqv     $v22[0], 0x60(@@src)
    lqv     $v23[0], 0x70(@@src)
    addi    @@src, @@src, SUBBLOCK_SIZE
@@loop:         // for each qtable
    lqv     $v5[0], 0x00(@@qTable)          // load qtable
    lqv     $v6[0], 0x10(@@qTable)
    lqv     $v7[0], 0x20(@@qTable)
    lqv     $v8[0], 0x30(@@qTable)
    lqv     $v9[0], 0x40(@@qTable)
    lqv     $v10[0], 0x50(@@qTable)
    lqv     $v11[0], 0x60(@@qTable)
    lqv     $v12[0], 0x70(@@qTable)
    addi    @@count, @@count, -1
@@innerloop:    // multiply each subblock by the qtable
    sqv     $v24[0], 0x00(@@dst)            // interleaved stores, vector load/stores run on the SU while the multiplies run on the VU
    vmudh   $v16, $v16, $v5                 // multiply: subblock *= qtable
    sqv     $v25[0], 0x10(@@dst)
    vmudh   $v17, $v17, $v6
    sqv     $v26[0], 0x20(@@dst)
    vmudh   $v18, $v18, $v7
    sqv     $v27[0], 0x30(@@dst)
    vmudh   $v19, $v19, $v8
    sqv     $v28[0], 0x40(@@dst)
    vmudh   $v20, $v20, $v9
    sqv     $v29[0], 0x50(@@dst)
    vmudh   $v21, $v21, $v10
    sqv     $v30[0], 0x60(@@dst)
    vmudh   $v22, $v22, $v11
    sqv     $v31[0], 0x70(@@dst)
    vmudh   $v23, $v23, $v12
    vmudn   $v24, $v16, $v1[0] // 0x0010    // multiply: subblock *= 0x10
    vmudn   $v25, $v17, $v1[0] // 0x0010
    lqv     $v16[0], 0x00(@@src)
    vmudn   $v26, $v18, $v1[0] // 0x0010
    lqv     $v17[0], 0x10(@@src)
    vmudn   $v27, $v19, $v1[0] // 0x0010
    lqv     $v18[0], 0x20(@@src)
    vmudn   $v28, $v20, $v1[0] // 0x0010
    lqv     $v19[0], 0x30(@@src)
    vmudn   $v29, $v21, $v1[0] // 0x0010
    lqv     $v20[0], 0x40(@@src)
    vmudn   $v30, $v22, $v1[0] // 0x0010
    lqv     $v21[0], 0x50(@@src)
    vmudn   $v31, $v23, $v1[0] // 0x0010
    lqv     $v22[0], 0x60(@@src)
    lqv     $v23[0], 0x70(@@src)
    addi    @@src, @@src, SUBBLOCK_SIZE
    addi    @@numChannels, @@numChannels, -1
    bgtz    @@numChannels, @@innerloop
     addi   @@dst, @@dst, SUBBLOCK_SIZE
    li      @@numChannels, 1                // once the Y channel is done, only run the inner loop once for U and V
    bgtz    @@count, @@loop
     addi   @@qTable, @@qTable, SUBBLOCK_SIZE
    sqv     $v24[0], 0x00(@@dst)            // store results
    sqv     $v25[0], 0x10(@@dst)
    sqv     $v26[0], 0x20(@@dst)
    sqv     $v27[0], 0x30(@@dst)
    sqv     $v28[0], 0x40(@@dst)
    sqv     $v29[0], 0x50(@@dst)
    sqv     $v30[0], 0x60(@@dst)
    sqv     $v31[0], 0x70(@@dst)

/**
 *  Zig-Zag Sequencing
 */
zigzag:
    @@src   equ $4
    @@dst   equ $5
    @@count equ $7

    addi    @@count, jpeg_format, 4     // mode + 4
    li      @@src, work_buffer
    li      @@dst, zigzag_buffer
@@loop:
    addi    @@count, @@count, -1
    lqv     $v24[0], 0x00(@@src)
    lqv     $v25[0], 0x10(@@src)
    lqv     $v26[0], 0x20(@@src)
    lqv     $v27[0], 0x30(@@src)
    lqv     $v28[0], 0x40(@@src)
    lqv     $v29[0], 0x50(@@src)
    lqv     $v30[0], 0x60(@@src)
    lqv     $v31[0], 0x70(@@src)
    ssv     $v24[0], 0x00(@@dst)        // 0x00 -> (0x00, 0x10, 0x02, 0x04, 0x12, 0x20, 0x30, 0x22)
    ssv     $v24[2], 0x10(@@dst)
    ssv     $v24[4], 0x02(@@dst)
    ssv     $v24[6], 0x04(@@dst)
    ssv     $v24[8], 0x12(@@dst)
    ssv     $v24[10], 0x20(@@dst)
    ssv     $v24[12], 0x30(@@dst)
    ssv     $v24[14], 0x22(@@dst)
    ssv     $v25[0], 0x14(@@dst)        // 0x10 -> (0x14, 0x06, 0x08, 0x16, 0x24, 0x32, 0x40, 0x50)
    ssv     $v25[2], 0x06(@@dst)
    ssv     $v25[4], 0x08(@@dst)
    ssv     $v25[6], 0x16(@@dst)
    ssv     $v25[8], 0x24(@@dst)
    ssv     $v25[10], 0x32(@@dst)
    ssv     $v25[12], 0x40(@@dst)
    ssv     $v25[14], 0x50(@@dst)
    ssv     $v26[0], 0x42(@@dst)        // 0x20 -> (0x42, 0x34, 0x26, 0x18, 0x0A, 0x0C, 0x1A, 0x28)
    ssv     $v26[2], 0x34(@@dst)
    ssv     $v26[4], 0x26(@@dst)
    ssv     $v26[6], 0x18(@@dst)
    ssv     $v26[8], 0x0A(@@dst)
    ssv     $v26[10], 0x0C(@@dst)
    ssv     $v26[12], 0x1A(@@dst)
    ssv     $v26[14], 0x28(@@dst)
    ssv     $v27[0], 0x36(@@dst)        // 0x30 -> (0x36, 0x44, 0x52, 0x60, 0x70, 0x62, 0x54, 0x46)
    ssv     $v27[2], 0x44(@@dst)
    ssv     $v27[4], 0x52(@@dst)
    ssv     $v27[6], 0x60(@@dst)
    ssv     $v27[8], 0x70(@@dst)
    ssv     $v27[10], 0x62(@@dst)
    ssv     $v27[12], 0x54(@@dst)
    ssv     $v27[14], 0x46(@@dst)
    ssv     $v28[0], 0x38(@@dst)        // 0x40 -> (0x38, 0x2A, 0x1C, 0x0E, 0x1E, 0x2C, 0x3A, 0x48)
    ssv     $v28[2], 0x2A(@@dst)
    ssv     $v28[4], 0x1C(@@dst)
    ssv     $v28[6], 0x0E(@@dst)
    ssv     $v28[8], 0x1E(@@dst)
    ssv     $v28[10], 0x2C(@@dst)
    ssv     $v28[12], 0x3A(@@dst)
    ssv     $v28[14], 0x48(@@dst)
    ssv     $v29[0], 0x56(@@dst)        // 0x50 -> (0x56, 0x64, 0x72, 0x74, 0x66, 0x58, 0x4A, 0x3C)
    ssv     $v29[2], 0x64(@@dst)
    ssv     $v29[4], 0x72(@@dst)
    ssv     $v29[6], 0x74(@@dst)
    ssv     $v29[8], 0x66(@@dst)
    ssv     $v29[10], 0x58(@@dst)
    ssv     $v29[12], 0x4A(@@dst)
    ssv     $v29[14], 0x3C(@@dst)
    ssv     $v30[0], 0x2E(@@dst)        // 0x60 -> (0x2E, 0x3E, 0x4C, 0x5A, 0x68, 0x76, 0x78, 0x6A)
    ssv     $v30[2], 0x3E(@@dst)
    ssv     $v30[4], 0x4C(@@dst)
    ssv     $v30[6], 0x5A(@@dst)
    ssv     $v30[8], 0x68(@@dst)
    ssv     $v30[10], 0x76(@@dst)
    ssv     $v30[12], 0x78(@@dst)
    ssv     $v30[14], 0x6A(@@dst)
    ssv     $v31[0], 0x5C(@@dst)        // 0x70 -> (0x5C, 0x4E, 0x5E, 0x6C, 0x7A, 0x7C, 0x6E, 0x7E)
    ssv     $v31[2], 0x4E(@@dst)
    ssv     $v31[4], 0x5E(@@dst)
    ssv     $v31[6], 0x6C(@@dst)
    ssv     $v31[8], 0x7A(@@dst)
    ssv     $v31[10], 0x7C(@@dst)
    ssv     $v31[12], 0x6E(@@dst)
    ssv     $v31[14], 0x7E(@@dst)
    addi    @@src, @@src, SUBBLOCK_SIZE
    bgtz    @@count, @@loop
     addi   @@dst, @@dst, SUBBLOCK_SIZE

/**
 *  Start reading next macroblock
 */
begin_read_next_macroblock:
    jal     dma_wait                        // read next macroblock if not the last iteration
     add    outputDRAM, outputDRAM, macroblock_size
    beqz    mbCount, inverse_dct
     addi   $27, mbAddr, 0
    li      $28, macroblock_buffer
    jal     dma_read
     add    $29, $zero, $10

/**
 *  Inverse DCT
 */
inverse_dct:
    @@src          equ $4
    @@dst          equ $5
    @@numChannels  equ $7
    @@transposeBuf equ $21

    addi    @@numChannels, jpeg_format, 4       // mode + 4
    li      @@src, zigzag_buffer
    li      @@dst, work_buffer - SUBBLOCK_SIZE
    li      @@transposeBuf, transposeBuffer
    lqv     $v19[0], 0x30(@@src)
    lqv     $v21[0], 0x50(@@src)
    lqv     $v23[0], 0x70(@@src)
    lqv     $v17[0], 0x10(@@src)
    lqv     $v16[0], 0x00(@@src)
    lqv     $v20[0], 0x40(@@src)
    lqv     $v22[0], 0x60(@@src)
    lqv     $v18[0], 0x20(@@src)
    addi    @@src, @@src, SUBBLOCK_SIZE
@@loop: // for each channel
    addi    @@numChannels, @@numChannels, -1
    // IDCT in X direction
    vmulf   $v10, $v19, $v2[2]
    vmacf   $v10, $v21, $v2[4]              // $v10  = $v19 * 0.8315(0x6A6E) + $v21 * 0.5555(0x471D)
    vmulf   $v11, $v23, $v2[0]
    sqv     $v24[0], 0x00(@@dst)
    vmacf   $v11, $v17, $v2[5]              // $v11  = $v23 * 0.1951(0x18F9) + $v17 * 0.9808(0x7D8A)
    sqv     $v31[0], 0x70(@@dst)
    vmulf   $v8, $v17, $v2[0]
    sqv     $v27[0], 0x30(@@dst)
    vmacf   $v8, $v23, $v2[1]               //  $v8  = $v17 * 0.1951(0x18F9) + $v23 * -0.9807(0x8276)
    sqv     $v28[0], 0x40(@@dst)
    vmulf   $v9, $v21, $v2[2]
    sqv     $v25[0], 0x10(@@dst)
    vmacf   $v9, $v19, $v2[3]               //  $v9  = $v21 * 0.8315(0x6A6E) + $v19 * -0.5555(0xB8E3)
    sqv     $v30[0], 0x60(@@dst)
    vmulf   $v6, $v16, $v3[0]
    sqv     $v26[0], 0x20(@@dst)
    vmacf   $v6, $v20, $v3[1]               //  $v6  = $v16 * 0.7071(0x5A82) + $v20 * -0.7070(0xA57E)
    sqv     $v29[0], 0x50(@@dst)
    vsub    $v5, $v11, $v10                 //  $v5  = $v11 - $v10
    vsub    $v4, $v8, $v9                   //  $v4  =  $v8 -  $v9
    vadd    $v12, $v8, $v9                  // $v12  =  $v8 -  $v9
    vadd    $v15, $v11, $v10                // $v15  = $v11 - $v10
    vmulf   $v13, $v5, $v3[0]
    vmacf   $v13, $v4, $v3[1]               // $v13  =  $v5 * 0.7071(0x5A82) +  $v4 * -0.7070(0xA57E)
    vmulf   $v14, $v5, $v3[0]
    vmacf   $v14, $v4, $v3[0]               // $v14  =  $v5 * 0.7071(0x5A82) +  $v4 * 0.7071(0x5A82)
    vmulf   $v4, $v16, $v3[0]
    vmacf   $v4, $v20, $v3[0]               //  $v4  = $v16 * 0.7071(0x5A82) + $v20 * 0.7071(0x5A82)
    vmulf   $v5, $v22, $v3[2]
    vmacf   $v5, $v18, $v3[4]               //  $v5  = $v22 * (0x30FC) + $v18 * (0x7642)
    vmulf   $v7, $v18, $v3[2]
    vmacf   $v7, $v22, $v3[3]               //  $v7  = $v18 * (0x30FC) + $v22 * (0x89BE)
    nop
    vadd    $v8, $v4, $v5                   //  $v8  =  $v4 +  $v5
    vsub    $v11, $v4, $v5                  // $v11  =  $v4 -  $v5
    vadd    $v9, $v6, $v7                   //  $v9  =  $v6 +  $v7
    vsub    $v10, $v6, $v7                  // $v10  =  $v6 -  $v7
    vadd    $v16, $v8, $v15                 // $v16  =  $v8 + $v15
    vsub    $v23, $v8, $v15                 // $v23  =  $v8 - $v15
    vadd    $v19, $v11, $v12                // $v19  = $v11 + $v12
    vsub    $v20, $v11, $v12                // $v20  = $v11 - $v12
    vadd    $v17, $v9, $v14                 // $v17  =  $v9 + $v14
    vsub    $v22, $v9, $v14                 // $v22  =  $v9 - $v14
    vadd    $v18, $v10, $v13                // $v18  = $v10 + $v13
    vsub    $v21, $v10, $v13                // $v21  = $v10 - $v13
    // Transpose
    stv     $v16[0], 0x00(@@transposeBuf)
    stv     $v16[2], 0x10(@@transposeBuf)
    stv     $v16[4], 0x20(@@transposeBuf)
    stv     $v16[6], 0x30(@@transposeBuf)
    stv     $v16[8], 0x40(@@transposeBuf)
    stv     $v16[10], 0x50(@@transposeBuf)
    stv     $v16[12], 0x60(@@transposeBuf)
    stv     $v16[14], 0x70(@@transposeBuf)
    ltv     $v24[0], 0x00(@@transposeBuf)
    ltv     $v24[14], 0x10(@@transposeBuf)
    ltv     $v24[12], 0x20(@@transposeBuf)
    ltv     $v24[10], 0x30(@@transposeBuf)
    ltv     $v24[8], 0x40(@@transposeBuf)
    ltv     $v24[6], 0x50(@@transposeBuf)
    ltv     $v24[4], 0x60(@@transposeBuf)
    ltv     $v24[2], 0x70(@@transposeBuf)
    // IDCT in Y direction
    vmulf   $v10, $v27, $v2[2]
    vmacf   $v10, $v29, $v2[4]              // $v10  = $v27 * 0.8315(0x6A6E) + $v29 * 0.5555(0x471D)
    vmulf   $v11, $v31, $v2[0]
    vmacf   $v11, $v25, $v2[5]              // $v11  = $v31 * 0.1951(0x18F9) + $v25 * 0.9808(0x7D8A)
    vmulf   $v8, $v25, $v2[0]
    vmacf   $v8, $v31, $v2[1]               //  $v8  = $v25 * 0.1951(0x18F9) + $v31 * -0.9807(0x8276)
    vmulf   $v9, $v29, $v2[2]
    vmacf   $v9, $v27, $v2[3]               //  $v9  = $v29 * 0.8315(0x6A6E) + $v27 * -0.5555(0xB8E3)
    vmulf   $v6, $v24, $v3[0]
    vmacf   $v6, $v28, $v3[1]               //  $v6  = $v24 * 0.7071(0x5A82) + $v28 * -0.7070(0xA57E)
    vsub    $v5, $v11, $v10                 //  $v5  = $v11 - $v10
    vsub    $v4, $v8, $v9                   //  $v4  =  $v8 -  $v9
    vadd    $v12, $v8, $v9                  // $v12  =  $v8 +  $v9
    vadd    $v15, $v11, $v10                // $v15  = $v11 + $v10
    vmulf   $v13, $v5, $v3[0]
    vmacf   $v13, $v4, $v3[1]               // $v13  =  $v5 * 0.7071(0x5A82) +  $v4 * -0.7070(0xA57E)
    vmulf   $v14, $v5, $v3[0]
    lqv     $v19[0], 0x30(@@src)
    vmacf   $v14, $v4, $v3[0]               // $v14  =  $v5 * 0.7071(0x5A82) +  $v4 * 0.7071(0x5A82)
    lqv     $v21[0], 0x50(@@src)
    vmulf   $v4, $v24, $v3[0]
    lqv     $v23[0], 0x70(@@src)
    vmacf   $v4, $v28, $v3[0]               //  $v4  = $v24 * 0.7071(0x5A82) + $v28 * 0.7071(0x5A82)
    lqv     $v17[0], 0x10(@@src)
    vmulf   $v5, $v30, $v3[2]
    lqv     $v16[0], 0x00(@@src)
    vmacf   $v5, $v26, $v3[4]               //  $v5  = $v30 * (0x30FC) + $v26 * (0x7642)
    lqv     $v20[0], 0x40(@@src)
    vmulf   $v7, $v26, $v3[2]
    lqv     $v22[0], 0x60(@@src)
    vmacf   $v7, $v30, $v3[3]               //  $v7  = $v26 * (0x30FC) + $v30 * (0x89BE)
    lqv     $v18[0], 0x20(@@src)
    nop
    vadd    $v8, $v4, $v5                   //  $v8  =  $v4 +  $v5
    vsub    $v11, $v4, $v5                  // $v11  =  $v4 -  $v5
    vadd    $v9, $v6, $v7                   //  $v9  =  $v6 +  $v7
    vsub    $v10, $v6, $v7                  // $v10  =  $v6 -  $v7
    vmulf   $v24, $v8, $v1[1]
    vmacf   $v24, $v15, $v1[1]              // $v24  =  $v8 * 0.25(0x2000) + $v15 * 0.25(0x2000)
    vmacf   $v31, $v15, $v1[2]              // $v31  =  $v8 * 0.25(0x2000) + $v15 * 0.25(0x2000) + $v15 * -0.5(0xC000)
    vmulf   $v27, $v11, $v1[1]
    vmacf   $v27, $v12, $v1[1]              // $v27  = $v11 * 0.25(0x2000) + $v12 * 0.25(0x2000)
    vmacf   $v28, $v12, $v1[2]              // $v28  = $v11 * 0.25(0x2000) + $v12 * 0.25(0x2000) + $v12 * -0.5(0xC000)
    vmulf   $v25, $v9, $v1[1]
    vmacf   $v25, $v14, $v1[1]              // $v25  =  $v9 * 0.25(0x2000) + $v14 * 0.25(0x2000)
    vmacf   $v30, $v14, $v1[2]              // $v30  =  $v9 * 0.25(0x2000) + $v14 * 0.25(0x2000) + $v14 * -0.5(0xC000)
    vmulf   $v26, $v10, $v1[1]
    vmacf   $v26, $v13, $v1[1]              // $v26  = $v10 * 0.25(0x2000) + $v13 * 0.25(0x2000) 
    vmacf   $v29, $v13, $v1[2]              // $v29  = $v10 * 0.25(0x2000) + $v13 * 0.25(0x2000) + $v13 * -0.5(0xC000)
    addi    @@src, @@src, SUBBLOCK_SIZE
    bgtz    @@numChannels, @@loop
     addi   @@dst, @@dst, SUBBLOCK_SIZE
    sqv     $v24[0], 0x00(@@dst)
    sqv     $v31[0], 0x70(@@dst)
    sqv     $v27[0], 0x30(@@dst)
    sqv     $v28[0], 0x40(@@dst)
    sqv     $v25[0], 0x10(@@dst)
    sqv     $v30[0], 0x60(@@dst)
    sqv     $v26[0], 0x20(@@dst)
    sqv     $v29[0], 0x50(@@dst)

/**
 *  Convert YUV to RGBA16
 */
yuv2rgba:
    bgtz    jpeg_format, yuv2rgba_mode2  // Branch based on mode
     nop

// Mode 0
yuv2rgba_mode0:
    @@srcY      equ $4
    @@srcUV     equ $20
    @@dst       equ $5
    @@count     equ $7

    @@px1_R equ $v15
    @@px1_G equ $v17
    @@px1_B equ $v13
    @@px2_R equ $v16
    @@px2_G equ $v18
    @@px2_B equ $v14
    @@px1 equ $v28
    @@px2 equ $v27

    @@U1 equ $v24
    @@U2 equ $v23
    @@V1 equ $v26
    @@V2 equ $v25
    @@Y1 equ $v6
    @@Y2 equ $v5
    @@Udata equ $v7
    @@Vdata equ $v8

    li      @@srcY, work_buffer
    vclr    $v19
    addi    @@srcUV, @@srcY, 2 * SUBBLOCK_SIZE  // Skip Y subblocks
    vclr    $v20
    li      @@dst, outputBuffer - 0x20
    vclr    $v21
    lqv     @@Udata[0], (SUBBLOCK_SIZE * 0)(@@srcUV)
    vclr    $v22
    llv     $v19[0], (data_0000 + 0xC)($zero)   // [1, 1, 0, 0, 0, 0, 0, 0]
    llv     $v20[4], (data_0000 + 0xC)($zero)   // [0, 0, 1, 1, 0, 0, 0, 0]
    llv     $v21[8], (data_0000 + 0xC)($zero)   // [0, 0, 0, 0, 1, 1, 0, 0]
    llv     $v22[12], (data_0000 + 0xC)($zero)  // [0, 0, 0, 0, 0, 0, 1, 1]
    li      @@count, 8                          // 8 YUV components, 16 RGBA pixels
    vmudh   @@U1, $v19, @@Udata[0]
    lqv     @@Vdata[0], (SUBBLOCK_SIZE * 1)(@@srcUV)
    vmadh   @@U1, $v20, @@Udata[1]
    lqv     $v1[0], (data_0000)($zero)
    vmadh   @@U1, $v21, @@Udata[2]
    lqv     $v4[0], (data_0010)($zero)
    vmadh   @@U1, $v22, @@Udata[3]
    vmudh   @@U2, $v19, @@Udata[4]
    vmadh   @@U2, $v20, @@Udata[5]
    vmadh   @@U2, $v21, @@Udata[6]
    vmadh   @@U2, $v22, @@Udata[7]
    vmudh   @@V1, $v19, @@Vdata[0]
    lqv     @@Y1[0], (SUBBLOCK_SIZE * 0)(@@srcY)
    vmadh   @@V1, $v20, @@Vdata[1]
    lqv     @@Y2[0], (SUBBLOCK_SIZE * 1)(@@srcY)
    vmadh   @@V1, $v21, @@Vdata[2]
    vmadh   @@V1, $v22, @@Vdata[3]
    vmudh   @@V2, $v19, @@Vdata[4]
    vmadh   @@V2, $v20, @@Vdata[5]
    vmadh   @@V2, $v21, @@Vdata[6]
    addi    @@srcY, @@srcY, 0x10
    vmadh   @@V2, $v22, @@Vdata[7]
    addi    @@srcUV, @@srcUV, 0x10
@@loop:
    vadd    $v10, @@Y1, $v4[7]                  // (Y1) + (2048)
    sqv     @@px1[0], 0x00(@@dst)
    vadd    $v9, @@Y2, $v4[7]                   // (Y2) + (2048)
    sqv     @@px2[0], 0x10(@@dst)
    vmudm   @@px1_R, @@V1, $v4[0]               // (V1) * (0.4025)      0.4025 = 0x670A
    addi    @@dst, @@dst, 0x20
    vmudm   @@px2_R, @@V2, $v4[0]               // (V2) * (0.4025)      0.4025 = 0x670A
    vmudm   @@px1_G, @@U1, $v4[1]               // (U1) * (0.3443)      0.3443 = 0x5824
    vmudm   @@px2_G, @@U2, $v4[1]               // (U2) * (0.3443)      0.3443 = 0x5824
    vmudm   $v11, @@V1, $v4[2]                  // (V1) * (0.7144)      0.7144 = 0xB6E3
    vmudm   $v12, @@V2, $v4[2]                  // (V2) * (0.7144)      0.7144 = 0xB6E3
    vmudm   @@px1_B, @@U1, $v4[3]               // (U1) * (0.7229)      0.7229 = 0xC5E3
    vmudm   @@px2_B, @@U2, $v4[3]               // (U2) * (0.7229)      0.7229 = 0xC5E3
    vadd    @@px1_R, @@px1_R, @@V1              // (V1 * 0.4025) + (V1)
    vadd    @@px2_R, @@px2_R, @@V2              // (V2 * 0.4025) + (V2)
    vadd    @@px1_G, @@px1_G, $v11              // (U1 * 0.3443) + (V1 * 0.7144)
    vadd    @@px2_G, @@px2_G, $v12              // (U2 * 0.3443) + (V2 * 0.7144)
    vadd    @@px1_B, @@px1_B, @@U1              // (U1 * 0.7229) + (U1)
    vadd    @@px2_B, @@px2_B, @@U2              // (U2 * 0.7229) + (U2)
    vadd    @@px1_R, @@px1_R, $v10              // r = (V1 * 0.4025 + V1) + (Y1 + 2048)
    vadd    @@px2_R, @@px2_R, $v9               // r = (V2 * 0.4025 + V2) + (Y2 + 2048)
    vsub    @@px1_G, $v10, @@px1_G              // g = (Y1 + 2048) - (U1 * 0.3443 + V1 * 0.7144)
    vsub    @@px2_G, $v9, @@px2_G               // g = (Y2 + 2048) - (U2 * 0.3443 + V2 * 0.7144)
    vadd    @@px1_B, @@px1_B, $v10              // b = (U1 * 0.7229 + U1) + (Y1 + 2048)
    vadd    @@px2_B, @@px2_B, $v9               // b = (U2 * 0.7229 + U2) + (Y2 + 2048)
    vge     @@px1_R, @@px1_R, $vzero            // r = Clamp_Max(r, 0)
    lqv     @@Y1[0], (SUBBLOCK_SIZE * 0)(@@srcY)
    vge     @@px2_R, @@px2_R, $vzero            // r = Clamp_Max(r, 0)
    lqv     @@Y2[0], (SUBBLOCK_SIZE * 1)(@@srcY)
    vge     @@px1_G, @@px1_G, $vzero            // g = Clamp_Max(g, 0)
    lqv     @@Udata[0], (SUBBLOCK_SIZE * 0)(@@srcUV)
    vge     @@px2_G, @@px2_G, $vzero            // g = Clamp_Max(g, 0)
    lqv     @@Vdata[0], (SUBBLOCK_SIZE * 1)(@@srcUV)
    vge     @@px1_B, @@px1_B, $vzero            // b = Clamp_Max(b, 0)
    vge     @@px2_B, @@px2_B, $vzero            // b = Clamp_Max(b, 0)
    vlt     @@px1_R, @@px1_R, $v4[4]            // r = Clamp_Min(r, 0xFF0)
    vlt     @@px2_R, @@px2_R, $v4[4]            // r = Clamp_Min(r, 0xFF0)
    vlt     @@px1_G, @@px1_G, $v4[4]            // g = Clamp_Min(g, 0xFF0)
    vlt     @@px2_G, @@px2_G, $v4[4]            // g = Clamp_Min(g, 0xFF0)
    vlt     @@px1_B, @@px1_B, $v4[4]            // b = Clamp_Min(b, 0xFF0)
    vlt     @@px2_B, @@px2_B, $v4[4]            // b = Clamp_Min(b, 0xFF0)
    vmudm   @@px1_R, @@px1_R, $v4[6]            // r /= 128.0 (*= 0.0078125)
    vmudm   @@px2_R, @@px2_R, $v4[6]            // r /= 128.0 (*= 0.0078125)
    vmudm   @@px1_G, @@px1_G, $v4[6]            // g /= 128.0 (*= 0.0078125)
    vmudm   @@px2_G, @@px2_G, $v4[6]            // g /= 128.0 (*= 0.0078125)
    vmudm   @@px1_B, @@px1_B, $v4[6]            // b /= 128.0 (*= 0.0078125)
    vmudm   @@px2_B, @@px2_B, $v4[6]            // b /= 128.0 (*= 0.0078125)
    vmudn   @@px1_R, @@px1_R, $v1[3]            // r <<= 11
    vmudn   @@px2_R, @@px2_R, $v1[3]            // r <<= 11
    vmudh   @@px1_G, @@px1_G, $v1[4]            // g <<= 6
    vmudh   @@px2_G, @@px2_G, $v1[4]            // g <<= 6
    vmudh   @@px1_B, @@px1_B, $v1[5]            // b <<= 1
    vmudh   @@px2_B, @@px2_B, $v1[5]            // b <<= 1
    vmudh   @@U1, $v19, @@Udata[0]
    vmadh   @@U1, $v20, @@Udata[1]
    vmadh   @@U1, $v21, @@Udata[2]
    vmadh   @@U1, $v22, @@Udata[3]
    vor     @@px1_R, @@px1_R, @@px1_G
    vor     @@px2_R, @@px2_R, @@px2_G
    vmudh   @@U2, $v19, @@Udata[4]
    vmadh   @@U2, $v20, @@Udata[5]
    vmadh   @@U2, $v21, @@Udata[6]
    vmadh   @@U2, $v22, @@Udata[7]
    vor     @@px1, @@px1_R, @@px1_B
    vor     @@px2, @@px2_R, @@px2_B
    vmudh   @@V1, $v19, @@Vdata[0]
    addi    @@count, @@count, -1
    vmadh   @@V1, $v20, @@Vdata[1]
    addi    @@srcY, @@srcY, 0x10
    vmadh   @@V1, $v21, @@Vdata[2]
    addi    @@srcUV, @@srcUV, 0x10
    vmadh   @@V1, $v22, @@Vdata[3]
    vor     @@px1, @@px1, $v1[6] // 0x0001      // a = 1
    vor     @@px2, @@px2, $v1[6] // 0x0001      // a = 1
    vmudh   @@V2, $v19, @@Vdata[4]
    vmadh   @@V2, $v20, @@Vdata[5]
    vmadh   @@V2, $v21, @@Vdata[6]
    bgtz    @@count, @@loop
     vmadh  @@V2, $v22, @@Vdata[7]
    sqv     @@px1[0], 0x00(@@dst)
    sqv     @@px2[0], 0x10(@@dst)
    j       main_loop_end
     nop

// Mode > 0
yuv2rgba_mode2:
    @@srcY      equ $4
    @@srcUV     equ $20
    @@dst       equ $5
    @@count     equ $7
    @@count2    equ $8

    @@px1_R equ $v24
    @@px1_G equ $v26
    @@px1_B equ $v28
    @@px2_R equ $v23
    @@px2_G equ $v25
    @@px2_B equ $v27
    @@px1 equ $v30
    @@px2 equ $v29

    @@U1 equ $v14
    @@U2 equ $v13
    @@V1 equ $v16
    @@V2 equ $v15
    @@Y1 equ $v6
    @@Y2 equ $v5
    @@Udata equ $v7
    @@Vdata equ $v8

    li      @@srcY, work_buffer
    vclr    $v9
    addi    @@srcUV, @@srcY, 4 * SUBBLOCK_SIZE // Skip Y subblocks
    vclr    $v10
    li      @@dst, outputBuffer - 0x20
    vclr    $v11
    li      @@count, 2
    vclr    $v12
    li      @@count2, 4
    lqv     @@Vdata[0], (SUBBLOCK_SIZE * 1)(@@srcUV)
    lqv     @@Udata[0], (SUBBLOCK_SIZE * 0)(@@srcUV)
    llv     $v9[0], (data_0000 + 0xC)($zero)    // [1, 1, 0, 0, 0, 0, 0, 0]
    llv     $v10[4], (data_0000 + 0xC)($zero)   // [0, 0, 1, 1, 0, 0, 0, 0]
    llv     $v11[8], (data_0000 + 0xC)($zero)   // [0, 0, 0, 0, 1, 1, 0, 0]
    llv     $v12[12], (data_0000 + 0xC)($zero)  // [0, 0, 0, 0, 0, 0, 1, 1]
    lqv     $v1[0], (data_0000)($zero)
    lqv     $v4[0], (data_0010)($zero)
    addi    @@srcUV, @@srcUV, 0x10
@@loop:
    vmudh   @@V1, $v9, @@Vdata[0]
    addi    @@count2, @@count2, -1
    vmadh   @@V1, $v10, @@Vdata[1]
    lqv     @@Y1[0], 0x00(@@srcY)
    vmadh   @@V1, $v11, @@Vdata[2]
    lqv     @@Y2[0], 0x80(@@srcY)
    vmadh   @@V1, $v12, @@Vdata[3]
    addi    @@srcY, @@srcY, 0x10
    vor     @@px1_R, @@px1_R, @@px1_G
    vor     @@px2_R, @@px2_R, @@px2_G
    vmudh   @@V2, $v9, @@Vdata[4]
    vmadh   @@V2, $v10, @@Vdata[5]
    vmadh   @@V2, $v11, @@Vdata[6]
    vmadh   @@V2, $v12, @@Vdata[7]
    vadd    $v18, @@Y1, $v4[7]              // (Y1) + (2048)
    vadd    $v17, @@Y2, $v4[7]              // (Y2) + (2048)
    vmudh   @@U1, $v9, @@Udata[0]
    vmadh   @@U1, $v10, @@Udata[1]
    vmadh   @@U1, $v11, @@Udata[2]
    vmadh   @@U1, $v12, @@Udata[3]
    vor     @@px1, @@px1_R, @@px1_B
    vor     @@px2, @@px2_R, @@px2_B
    vmudh   @@U2, $v9, @@Udata[4]
    vmadh   @@U2, $v10, @@Udata[5]
    vmadh   @@U2, $v11, @@Udata[6]
    vmadh   @@U2, $v12, @@Udata[7]
    vor     @@px1, @@px1, $v1[6] // 0x0001
    vor     @@px2, @@px2, $v1[6] // 0x0001
    vmudm   @@px1_R, @@V1, $v4[0]           // (V1) * (0.4025)      0.4025 = 0x670A
    vmudm   @@px2_R, @@V2, $v4[0]           // (V2) * (0.4025)      0.4025 = 0x670A
    vmudm   @@px1_G, @@U1, $v4[1]           // (U1) * (0.3443)      0.3443 = 0x5824
    vmudm   @@px2_G, @@U2, $v4[1]           // (U2) * (0.3443)      0.3443 = 0x5824
    vmudm   $v21, @@V1, $v4[2]              // (V1) * (0.7144)      0.7144 = 0xB6E3
    vmudm   $v22, @@V2, $v4[2]              // (V2) * (0.7144)      0.7144 = 0xB6E3
    vmudm   @@px1_B, @@U1, $v4[3]           // (U1) * (0.7229)      0.7229 = 0xC5E3
    vmudm   @@px2_B, @@U2, $v4[3]           // (U2) * (0.7229)      0.7229 = 0xC5E3
    vadd    @@px1_R, @@px1_R, @@V1          // (V1 * 0.4025) + (V1)
    vadd    @@px2_R, @@px2_R, @@V2          // (V2 * 0.4025) + (V2)
    vadd    @@px1_G, @@px1_G, $v21          // (U1 * 0.3443) + (V1 * 0.7144)
    sqv     @@px1[0], 0x00(@@dst)
    vadd    @@px2_G, @@px2_G, $v22          // (U2 * 0.3443) + (V2 * 0.7144)
    sqv     @@px2[0], 0x10(@@dst)
    vadd    @@px1_B, @@px1_B, @@U1          // (U1 * 0.7229) + (U1)
    addi    @@dst, @@dst, 0x20
    vadd    @@px2_B, @@px2_B, @@U2          // (U2 * 0.7229) + (U2)
    vadd    @@px1_R, @@px1_R, $v18          // (V1 * 0.4025 + V1) + (Y1 + 2048)
    vadd    @@px2_R, @@px2_R, $v17          // (V2 * 0.4025 + V2) + (Y2 + 2048)
    vsub    @@px1_G, $v18, @@px1_G          // (Y1 + 2048) - (U1 * 0.3443 + V1 * 0.7144)
    vsub    @@px2_G, $v17, @@px2_G          // (Y2 + 2048) - (U2 * 0.3443 + V2 * 0.7144)
    vadd    @@px1_B, @@px1_B, $v18          // (U1 * 0.7229 + U1) + (Y1 + 2048)
    vadd    @@px2_B, @@px2_B, $v17          // (U2 * 0.7229 + U2) + (Y2 + 2048)
    vge     @@px1_R, @@px1_R, $vzero
    vge     @@px2_R, @@px2_R, $vzero
    vge     @@px1_G, @@px1_G, $vzero
    vge     @@px2_G, @@px2_G, $vzero
    vge     @@px1_B, @@px1_B, $vzero
    vge     @@px2_B, @@px2_B, $vzero
    vlt     @@px1_R, @@px1_R, $v4[4] // 0x0FF0
    vlt     @@px2_R, @@px2_R, $v4[4] // 0x0FF0
    vlt     @@px1_G, @@px1_G, $v4[4] // 0x0FF0
    vlt     @@px2_G, @@px2_G, $v4[4] // 0x0FF0
    vlt     @@px1_B, @@px1_B, $v4[4] // 0x0FF0
    vlt     @@px2_B, @@px2_B, $v4[4] // 0x0FF0
    vmudm   @@px1_R, @@px1_R, $v4[6] // 0x0200  // r /= 128.0 (*= 0.0078125)
    lqv     @@Y1[0], 0x00(@@srcY)
    vmudm   @@px2_R, @@px2_R, $v4[6] // 0x0200  // r /= 128.0 (*= 0.0078125)
    lqv     @@Y2[0], 0x80(@@srcY)
    vmudm   @@px1_G, @@px1_G, $v4[6] // 0x0200  // g /= 128.0 (*= 0.0078125)
    addi    @@srcY, @@srcY, 0x10
    vmudm   @@px2_G, @@px2_G, $v4[6] // 0x0200  // g /= 128.0 (*= 0.0078125)
    vmudm   @@px1_B, @@px1_B, $v4[6] // 0x0200  // b /= 128.0 (*= 0.0078125)
    vmudm   @@px2_B, @@px2_B, $v4[6] // 0x0200  // b /= 128.0 (*= 0.0078125)
    vmudn   @@px1_R, @@px1_R, $v1[3] // 0x0800  // r <<= 11
    vmudn   @@px2_R, @@px2_R, $v1[3] // 0x0800  // r <<= 11
    vmudh   @@px1_G, @@px1_G, $v1[4] // 0x0040  // g <<= 6
    vmudh   @@px2_G, @@px2_G, $v1[4] // 0x0040  // g <<= 6
    vmudh   @@px1_B, @@px1_B, $v1[5] // 0x0002  // b <<= 1
    vmudh   @@px2_B, @@px2_B, $v1[5] // 0x0002  // b <<= 1
    vadd    $v18, @@Y1, $v4[7]              // (Y1) + (2048)
    vadd    $v17, @@Y2, $v4[7]              // (Y2) + (2048)
    vor     @@px1_R, @@px1_R, @@px1_G
    vor     @@px2_R, @@px2_R, @@px2_G
    vmudm   $v20, @@V1, $v4[0]              // (V1) * (0.4025)      0.4025 = 0x670A
    vmudm   $v19, @@V2, $v4[0]              // (V2) * (0.4025)      0.4025 = 0x670A
    vor     @@px1, @@px1_R, @@px1_B
    vor     @@px2, @@px2_R, @@px2_B
    vmudm   @@px1_G, @@U1, $v4[1]           // (U1) * (0.3443)      0.3443 = 0x5824
    vmudm   @@px2_G, @@U2, $v4[1]           // (U2) * (0.3443)      0.3443 = 0x5824
    vmudm   $v21, @@V1, $v4[2]              // (V1) * (0.7144)      0.7144 = 0xB6E3
    vor     @@px1, @@px1, $v1[6] // 0x0001
    vor     @@px2, @@px2, $v1[6] // 0x0001
    vmudm   $v22, @@V2, $v4[2]              // (V2) * (0.7144)      0.7144 = 0xB6E3
    vmudm   @@px1_B, @@U1, $v4[3]           // (U1) * (0.7229)      0.7229 = 0xC5E3
    vmudm   @@px2_B, @@U2, $v4[3]           // (U2) * (0.7229)      0.7229 = 0xC5E3
    vadd    @@px1_R, $v20, @@V1             // (V1 * 0.4025) + (V1)
    vadd    @@px2_R, $v19, @@V2             // (V2 * 0.4025) + (V2)
    vadd    @@px1_G, @@px1_G, $v21          // (U1 * 0.3443) + (V1 * 0.7144)
    sqv     @@px1[0], 0x00(@@dst)
    vadd    @@px2_G, @@px2_G, $v22          // (U2 * 0.3443) + (V2 * 0.7144)
    sqv     @@px2[0], 0x10(@@dst)
    vadd    @@px1_B, @@px1_B, @@U1          // (U1 * 0.7229) + (U1)
    addi    @@dst, @@dst, 0x20
    vadd    @@px2_B, @@px2_B, @@U2          // (U2 * 0.7229) + (U2)
    vadd    @@px1_R, @@px1_R, $v18          // (V1 * 0.4025 + V1) + (Y1 + 2048)
    vadd    @@px2_R, @@px2_R, $v17          // (V2 * 0.4025 + V2) + (Y2 + 2048)
    vsub    @@px1_G, $v18, @@px1_G          // (Y1 + 2048) - (U1 * 0.3443 + V1 * 0.7144)
    vsub    @@px2_G, $v17, @@px2_G          // (Y2 + 2048) - (U2 * 0.3443 + V2 * 0.7144)
    vadd    @@px1_B, @@px1_B, $v18          // (U1 * 0.7229 + U1) + (Y1 + 2048)
    vadd    @@px2_B, @@px2_B, $v17          // (U2 * 0.7229 + U2) + (Y2 + 2048)
    vge     @@px1_R, @@px1_R, $vzero
    vge     @@px2_R, @@px2_R, $vzero
    vge     @@px1_G, @@px1_G, $vzero
    vge     @@px2_G, @@px2_G, $vzero
    vge     @@px1_B, @@px1_B, $vzero
    vge     @@px2_B, @@px2_B, $vzero
    vlt     @@px1_R, @@px1_R, $v4[4] // 0x0FF0
    vlt     @@px2_R, @@px2_R, $v4[4] // 0x0FF0
    vlt     @@px1_G, @@px1_G, $v4[4] // 0x0FF0
    vlt     @@px2_G, @@px2_G, $v4[4] // 0x0FF0
    vlt     @@px1_B, @@px1_B, $v4[4] // 0x0FF0
    vlt     @@px2_B, @@px2_B, $v4[4] // 0x0FF0
    vmudm   @@px1_R, @@px1_R, $v4[6] // 0x0200  // r /= 128.0 (*= 0.0078125)
    lqv     @@Udata[0], (SUBBLOCK_SIZE * 0)(@@srcUV)
    vmudm   @@px2_R, @@px2_R, $v4[6] // 0x0200  // r /= 128.0 (*= 0.0078125)
    lqv     @@Vdata[0], (SUBBLOCK_SIZE * 1)(@@srcUV)
    vmudm   @@px1_G, @@px1_G, $v4[6] // 0x0200  // g /= 128.0 (*= 0.0078125)
    addi    @@srcUV, @@srcUV, 0x10
    vmudm   @@px2_G, @@px2_G, $v4[6] // 0x0200  // g /= 128.0 (*= 0.0078125)
    vmudm   @@px1_B, @@px1_B, $v4[6] // 0x0200  // b /= 128.0 (*= 0.0078125)
    vmudm   @@px2_B, @@px2_B, $v4[6] // 0x0200  // b /= 128.0 (*= 0.0078125)
    vmudn   @@px1_R, @@px1_R, $v1[3] // 0x0800  // r <<= 11
    vmudn   @@px2_R, @@px2_R, $v1[3] // 0x0800  // r <<= 11
    vmudh   @@px1_G, @@px1_G, $v1[4] // 0x0040  // g <<= 6
    vmudh   @@px2_G, @@px2_G, $v1[4] // 0x0040  // g <<= 6
    vmudh   @@px1_B, @@px1_B, $v1[5] // 0x0002  // b <<= 1
    bgtz    @@count2, @@loop
     vmudh  @@px2_B, @@px2_B, $v1[5] // 0x0002  // b <<= 1
    addi    @@count, @@count, -1
    li      @@count2, 4
    bgtz    @@count, @@loop
     addi   @@srcY, @@srcY, SUBBLOCK_SIZE
    vor     @@px1_R, @@px1_R, @@px1_G
    vor     @@px2_R, @@px2_R, @@px2_G
    vor     @@px1, @@px1_R, @@px1_B
    vor     @@px2, @@px2_R, @@px2_B
    vor     @@px1, @@px1, $v1[6] // 0x0001
    vor     @@px2, @@px2, $v1[6] // 0x0001
    sqv     @@px1[0], 0x00(@@dst)
    sqv     @@px2[0], 0x10(@@dst)

main_loop_end:
    jal     dma_wait
     nop
    mfc0    taskFlags, SP_STATUS
    beqz    mbCount, task_done                      // Branch if no work left to do
     add    mbAddr, mbAddr, macroblock_size
    andi    taskFlags, taskFlags, SP_STATUS_SIG0    // yielded
    beqz    taskFlags, main_loop
     nop
task_yield:
    sub     mbAddr, mbAddr, macroblock_size
    sw      mbCount, TASK_ADDRESS
    sw      mbAddr, TASK_MBCOUNT
    sw      outputDRAM, TASK_MODE
    sw      qTableYPtr, TASK_QTABLEYPTR
    sw      qTableUPtr, TASK_QTABLEUPTR
    sw      qTableVPtr, TASK_QTABLEVPTR
    sw      macroblock_size, TASK_MBSIZE
    li      $27, DMEM_START             // write dmem contents out to the yield buffer
    addi    $28, taskYieldPtr, 0
    jal     dma_write
     addi   $29, taskYieldSize, -1
    ori     $21, $zero, SP_SET_SIG1     // set yielded
    jal     dma_wait
     mtc0   $21, SP_STATUS
task_done:
    li      $27, outputBuffer       // write out data
    addi    $28, outputDRAM, 0
    jal     dma_write
     add    $29, $zero, $11
    jal     dma_wait
     li     $21, SP_SET_SIG2        // set task done
    mtc0    $21, SP_STATUS
    break
    nop
forever:
    j       forever
     nop

/**
 * DMA Read:
 *  $27 = DRAM Addr
 *  $28 = DMEM Addr
 *  $29 = Read Length
 *
 *  $30 = temp var
 */
dma_read:
    mfc0    $30, SP_SEMAPHORE
@@acquire_semaphore:
    bnez    $30, @@acquire_semaphore
     mfc0   $30, SP_SEMAPHORE
    mfc0    $30, SP_DMA_FULL
@@dma_full:
    bnez    $30, @@dma_full
     mfc0   $30, SP_DMA_FULL
    mtc0    $28, SP_MEM_ADDR
    mtc0    $27, SP_DRAM_ADDR
    jr      $ra
     mtc0   $29, SP_RD_LEN

/**
 * DMA Read:
 *  $27 = DMEM Addr
 *  $28 = DRAM Addr
 *  $29 = Write Length
 *
 *  $30 = temp var
 */
dma_write:
    mfc0    $30, SP_SEMAPHORE
@@acquire_semaphore:
    bnez    $30, @@acquire_semaphore
     mfc0   $30, SP_SEMAPHORE
    mfc0    $30, SP_DMA_FULL
@@dma_full:
    bnez    $30, @@dma_full
     mfc0   $30, SP_DMA_FULL
    mtc0    $27, SP_MEM_ADDR
    mtc0    $28, SP_DRAM_ADDR
    jr      $ra
     mtc0   $29, SP_WR_LEN

/**
 * DMA Wait:
 *
 *  $30 = temp var
 */
dma_wait:
    mfc0    $30, SP_DMA_BUSY
@@dma_busy:
    bnez    $30, @@dma_busy
     mfc0   $30, SP_DMA_BUSY
    jr      $ra
     mtc0   $zero, SP_SEMAPHORE

.align 8

.close
