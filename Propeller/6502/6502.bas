'' 6502 emu based on macca's compukit emulator

const _clkfreq=336956522

' 6502 constants

const REGP_N = 7
const REGP_V = 6
const REGP_B = 4
const REGP_D = 3
const REGP_I = 2
const REGP_Z = 1
const REGP_C = 0

' TODO: call 6502: set PC, return with .ret or set the int. Regset has to be in hub. 


dim ram_6502(65535) as ubyte


start()

function start() as integer
return cpu(@cog_6502,@ram_6502)
end function

asm shared  ''' todo pass ram addr


                org     $000

cog_6502        getct   ts                  ' timer reference for clock throttling
                mov     _I, #4              ' reset cycles

                mov     _P, #%00110000      ' initial flags
                mov     _S, #$FF            ' initial stack pointer

                mov     ptrb, ##$FFFC       ' read reset vector
                add     ptrb, ram_addr      ' |
                rdword  ptrb, ptrb          ' |
                add     ptrb, ram_addr      ' |

                rep     @loop, #8          ' ready to single-step
                push    #loop

loop            nop
                nop

                add     _T, _I              ' update total cycles count

                mul     _I, _I_CLK          ' clock throttling   ' ____ todo rewrite this
                addct1  ts, _I              ' |
p001            jnct1   #p001               ' |

                rdbyte  t1, ptrb++          ' fetch instruction

                rdlut   t1, t1              ' decode instruction

                getnib  _I, t1, #7          ' get cycles count
                setnib  t1, #0, #7          ' |

                execf   t1                  ' execute instruction


'
'
' Instructions
'
i_adc_abs       call    #\_fetch_abs        ' %1_1111110
i_adc_abs_x     call    #\_fetch_abs_x      ' %1_111110
i_adc_abs_y     call    #\_fetch_abs_y      ' %1_11110
i_adc_ind_x     call    #\_fetch_ind_x      ' %1_1110
i_adc_ind_y     call    #\_fetch_ind_y      ' %1_110
i_adc_zpg       call    #\_fetch_zpg        ' %1_10
i_adc_zpg_x     call    #\_fetch_zpg_x      ' %1_0
i_adc_imm       rdbyte  t1, ptrb++          ' %0

_adc            testb   _P, #REGP_C     wc

                testb   _P, #REGP_D     wz
        if_z    jmp     #_adc_dec

                getbyte t3, _A, #0          ' t3 = sum
                addx    t3, t1              ' |
                testb   t3, #7          wz  ' affects N
                bitz    _P, #REGP_N         ' |

                getbyte t2, _A, #0          ' t2 = ~(A ^ operand)
                xor     t2, t1              ' |
                xor     t2, #$FF            ' |
                getbyte t4, _A, #0          ' t4 = A ^ sum
                xor     t4, t3
                and     t2, t4              ' t2 = ~(A ^ operand) & (A ^ sum)
                testb   t2, #7          wz  ' affects V
                bitz    _P, #REGP_V         ' |

                testb   t3, #8          wz  ' affects C
                bitz    _P, #REGP_C         ' |

                getbyte _A, t3, #0

                test    _A, #$FF        wz  ' affects Z
        _ret_   bitz    _P, #REGP_Z         ' |

_adc_dec        mov     t2, _A              ' t2 = lo
                and     t2, #$0F
                mov     t4, t1
                and     t4, #$0F
                addx    t2, t4

                mov     t3, _A              ' t3 = hi
                and     t3, #$F0
                mov     t4, t1
                and     t4, #$F0
                add     t3, t4

                cmp     t2, #$09        wcz
        if_a    add     t2, #$06
        if_a    add     t3, #$10

                testb   t3, #7          wz  ' affects N
                bitz    _P, #REGP_N         ' |

                getbyte t5, _A, #0          ' t5 = ~(A ^ operand)
                xor     t5, t1              ' |
                xor     t5, #$FF            ' |
                getbyte t4, _A, #0          ' t4 = A ^ hi
                xor     t4, t3
                and     t5, t4              ' t5 = ~(A ^ operand) & (A ^ hi)
                testb   t5, #7          wz  ' affects V
                bitz    _P, #REGP_V         ' |

                cmp     t3, #$90        wcz
        if_a    add     t3, #$60

                testb   t3, #8          wz  ' affects C
                bitz    _P, #REGP_C         ' |

                getnib  _A, t2, #0
                add     _A, t3

                and     _A, #$FF        wz  ' affects Z
        _ret_   bitz    _P, #REGP_Z         ' |

i_log_abs       call    #\_fetch_abs        ' %xxx_1_1111110
i_log_zpg       call    #\_fetch_zpg        ' %xxx_1_111110
i_log_abs_x     call    #\_fetch_abs_x      ' %xxx_1_11110
i_log_abs_y     call    #\_fetch_abs_y      ' %xxx_1_1110
i_log_ind_x     call    #\_fetch_ind_x      ' %xxx_1_110
i_log_ind_y     call    #\_fetch_ind_y      ' %xxx_1_10
i_log_zpg_x     call    #\_fetch_zpg_x      ' %xxx_1_0
i_log_imm       rdbyte  t1, ptrb++          ' %xxx_0
                and     t1, _A              '  110 AND
                xor     t1, _A              '  101 EOR
                or      t1, _A              '  011 ORA
                getbyte _A, t1, #0
                jmp     #_flags

i_asl_abs       call    #\_fetch_abs        ' %01_000_1_1110
i_asl_zpg       call    #\_fetch_zpg        ' %01_000_1_110
i_asl_abs_x     call    #\_fetch_abs_x      ' %01_000_1_10
i_asl_zpg_x     call    #\_fetch_zpg_x      ' %01_000_1_0
i_asl           getbyte t1, _A, #0          ' %10_000_0

                testb   t1, #7          wz
                shl     t1, #1
                bitz    _P, #REGP_C

                getbyte _A, t1, #0
                call    #\_write
                jmp     #_flags
                                            '       SC NVZC
i_branch        rdbyte  t1, ptrb++          ' BCC: %10_1110_0
                                            ' BCS: %01_1110_0
                                            ' BNE: %10_1101_0
                                            ' BEQ: %01_1101_0
                testb   _P, #REGP_C     wc  ' BPL: %10_0111_0
                testb   _P, #REGP_Z     wc  ' BMI: %01_0111_0
                testb   _P, #REGP_V     wc  ' BVC: %10_1011_0
                testb   _P, #REGP_N     wc  ' BVS: %01_1011_0
        if_c    ret                         ' Clear
        if_nc   ret                         ' Set

                add     _I, #1
                sub     ptrb, ram_addr
                signx   t1, #7
                add     ptrb, t1
                cmpsub  ptrb, ##$10000
        _ret_   add     ptrb, ram_addr

i_bit_abs       call    #\_fetch_abs
i_bit_zpg       call    #\_fetch_zpg
_bit            test    _A, t1          wz
                bitz    _P, #REGP_Z
                and     t1, #%11000000
                and     _P, #%00111111
        _ret_   or      _P, t1

i_brk           add     ptrb, #1
                sub     ptrb, ram_addr
                getbyte t1, ptrb, #1        ' PCH -> (S)
                call    #_push_t1
                getbyte t1, ptrb, #0        ' PCL -> (S)
                call    #_push_t1
                getbyte t1, _P, #0          ' P -> (S)
                bith    t1, #REGP_B         ' B=1
                call    #_push_t1

                bith    _P, #REGP_I         ' I=1

                mov     t2, ##$FFFE
                add     t2, ram_addr
                rdword  ptrb, t2
        _ret_   add     ptrb, ram_addr

i_clc   _ret_   bitl    _P, #REGP_C
i_cld   _ret_   bitl    _P, #REGP_D
i_cli   _ret_   bitl    _P, #REGP_I
i_clv   _ret_   bitl    _P, #REGP_V

i_cmp_abs       call    #\_fetch_abs        ' %xxx_0_1_1111110
i_cmp_abs_x     call    #\_fetch_abs_x      ' %xxx_0_1_111110
i_cmp_abs_y     call    #\_fetch_abs_y      ' %xxx_0_1_11110
i_cmp_ind_x     call    #\_fetch_ind_x      ' %xxx_0_1_1110
i_cmp_ind_y     call    #\_fetch_ind_y      ' %xxx_0_1_110
i_cmp_zpg       call    #\_fetch_zpg        ' %xxx_0_1_10
i_cmp_zpg_x     call    #\_fetch_zpg_x      ' %xxx_0_1_0
i_cmp_imm       rdbyte  t1, ptrb++          ' %xxx_00
                mov     t2, t1
                getbyte t1, _A, #0          '  110 CMP
                getbyte t1, _X, #0          '  101 CPX
                getbyte t1, _Y, #0          '  011 CPY
                sub     t1, t2
                testb   t1, #8          wz
                bitnz   _P, #REGP_C
                jmp     #_flags

i_dec_zpg       call    #\_fetch_zpg        ' %xx_1110
i_dec_abs_x     call    #\_fetch_abs_x      ' %xx_110
i_dec_zpg_x     call    #\_fetch_zpg_x      ' %xx_10
i_dec_abs       call    #\_fetch_abs        ' %xx_0
                sub     t1, #1              '  10 DEC
                add     t1, #1              '  01 INC
                call    #\_write
                jmp     #_flags

                                            ' INX INY DEX DEY
i_inde_xy       getbyte t1, _X, #0          '  0   1   0   1
                getbyte t1, _Y, #0          '  1   0   1   0
                add     t1, #1              '  0   0   1   1
                sub     t1, #1              '  1   1   0   0
                getbyte _X, t1, #0          '  0   1   0   1
                getbyte _Y, t1, #0          '  1   0   1   0
                jmp     #_flags

i_jmp           rdword  ptrb, ptrb          ' 0 0
                add     ptrb, ram_addr      ' 1 0
                rdword  ptrb, ptrb          ' 1 0
        _ret_   add     ptrb, ram_addr      ' 0 0

i_jsr           rdword  t4, ptrb            ' t4 = new PC
                add     ptrb, #1

                sub     ptrb, ram_addr
                getbyte t1, ptrb, #1        ' PCH -> (S)
                call    #_push_t1
                getbyte t1, ptrb, #0        ' PCL -> (S)
                call    #_push_t1

                mov     ptrb, t4
        _ret_   add     ptrb, ram_addr

i_ld_abs        call    #\_fetch_abs        ' %xxx_1_11111110
i_ld_abs_x      call    #\_fetch_abs_x      ' %xxx_1_1111110
i_ld_abs_y      call    #\_fetch_abs_y      ' %xxx_1_111110
i_ld_zpg        call    #\_fetch_zpg        ' %xxx_1_11110
i_ld_zpg_x      call    #\_fetch_zpg_x      ' %xxx_1_1110
i_ld_zpg_y      call    #\_fetch_zpg_y      ' %xxx_1_110
i_ld_ind_x      call    #\_fetch_ind_x      ' %xxx_1_10
i_ld_ind_y      call    #\_fetch_ind_y      ' %xxx_1_0
i_ld_imm        rdbyte  t1, ptrb++          ' %xxx_0
                mov     _A, t1              '  110 LDA
                mov     _X, t1              '  101 LDX
                mov     _Y, t1              '  011 LDY
                jmp     #_flags

i_lsr_abs       call    #\_fetch_abs        ' %01_000_1_1110
i_lsr_zpg       call    #\_fetch_zpg        ' %01_000_1_110
i_lsr_abs_x     call    #\_fetch_abs_x      ' %01_000_1_10
i_lsr_zpg_x     call    #\_fetch_zpg_x      ' %01_000_1_0
i_lsr           getbyte t1, _A, #0          ' %10_000_0

                testb   t1, #0          wz
                shr     t1, #1
                bitz    _P, #REGP_C

                getbyte _A, t1, #0
                call    #\_write
                jmp     #_flags

i_nop           ret

i_push          getbyte t1, _A, #0
                getbyte t1, _P, #0
                jmp     #_push_t1

i_pla           call    #_pop_t1
                getbyte _A, t1, #0
                jmp     #_flags

i_plp           call    #_pop_t1
                getbyte _P, t1, #0
        _ret_   or      _P, #%00110000      ' always on flags

i_rol_abs       call    #\_fetch_abs        ' %01_00000_1_1110
i_rol_zpg       call    #\_fetch_zpg        ' %01_00000_1_110
i_rol_abs_x     call    #\_fetch_abs_x      ' %01_00000_1_10
i_rol_zpg_x     call    #\_fetch_zpg_x      ' %01_00000_1_0
i_rol           getbyte t1, _A, #0          ' %10_00000_0

                testb   _P, #REGP_C     wc
                testb   t1, #7          wz
                shl     t1, #1
                bitc    t1, #0
                bitz    _P, #REGP_C

                getbyte _A, t1, #0
                call    #\_write

                jmp     #_flags


i_ror_abs       call    #\_fetch_abs        ' %01_00000_1_1110
i_ror_zpg       call    #\_fetch_zpg        ' %01_00000_1_110
i_ror_abs_x     call    #\_fetch_abs_x      ' %01_00000_1_10
i_ror_zpg_x     call    #\_fetch_zpg_x      ' %01_00000_1_0
i_ror           getbyte t1, _A, #0          ' %10_00000_0

                testb   _P, #REGP_C     wc
                testb   t1, #0          wz
                shr     t1, #1
                bitc    t1, #7
                bitz    _P, #REGP_C

                getbyte _A, t1, #0
                call    #\_write

                jmp     #_flags

i_rti           call    #_pop_t1            ' (S) -> P
                mov     _P, t1
                ' fall-through
i_rts           call    #_pop_t1            ' (S) -> PCL
                getbyte ptrb, t1, #0        ' |
                call    #_pop_t1            ' (S) -> PCH
                setbyte ptrb, t1, #1        ' |
                incmod  ptrb, ##$FFFF       ' PC = PC + 1 (skip if RTI)
        _ret_   add     ptrb, ram_addr

i_sbc_abs       call    #\_fetch_abs        ' %1_1111110
i_sbc_abs_x     call    #\_fetch_abs_x      ' %1_111110
i_sbc_abs_y     call    #\_fetch_abs_y      ' %1_11110
i_sbc_ind_x     call    #\_fetch_ind_x      ' %1_1110
i_sbc_ind_y     call    #\_fetch_ind_y      ' %1_110
i_sbc_zpg       call    #\_fetch_zpg        ' %1_10
i_sbc_zpg_x     call    #\_fetch_zpg_x      ' %1_0
i_sbc_imm       rdbyte  t1, ptrb++          ' %0

_sbc            testbn  _P, #REGP_C     wc

                getbyte t3, _A, #0          ' t3 = sum
                subx    t3, t1              ' |
                testb   t3, #7          wz  ' affects N
                bitz    _P, #REGP_N         ' |

                getbyte t2, _A, #0          ' t2 = (A ^ operand)
                xor     t2, t1              ' |
                getbyte t4, _A, #0          ' t4 = A ^ sum
                xor     t4, t3
                and     t2, t4              ' t2 = (A ^ operand) & (A ^ sum)
                testb   t2, #7          wz  ' affects V
                bitz    _P, #REGP_V         ' |

                testb   t3, #8          wz  ' affects C
                bitnz   _P, #REGP_C         ' |

                test    t3, #$FF        wz  ' affects Z
                bitz    _P, #REGP_Z         ' |

                testb   _P, #REGP_D     wz
        if_z    jmp     #_sbc_dec

                getbyte _A, t3, #0

                test    _A, #$FF        wz  ' affects Z
        _ret_   bitz    _P, #REGP_Z         ' |

_sbc_dec        mov     t2, _A              ' t2 = lo
                and     t2, #$0F
                mov     t4, t1
                and     t4, #$0F
                subx    t2, t4

                mov     t3, _A              ' t3 = hi
                and     t3, #$F0
                mov     t4, t1
                and     t4, #$F0
                sub     t3, t4

                test    t2, #$10        wz
        if_nz   sub     t2, #$06
        if_nz   sub     t3, #$01

                test    t3, #$100       wz
        if_nz   sub     t3, #$60

                getbyte _A, t3, #0
                setnib  _A, t2, #0

                test    _A, #$FF        wz  ' affects Z
        _ret_   bitz    _P, #REGP_Z         ' |

i_sec   _ret_   bith    _P, #REGP_C
i_sed   _ret_   bith    _P, #REGP_D
i_sei   _ret_   bith    _P, #REGP_I

i_st_abs        call    #\_fetch_abs        ' %xxx_11111110
i_st_abs_x      call    #\_fetch_abs_x      ' %xxx_1111110
i_st_abs_y      call    #\_fetch_abs_y      ' %xxx_111110
i_st_zpg        call    #\_fetch_zpg        ' %xxx_11110
i_st_zpg_x      call    #\_fetch_zpg_x      ' %xxx_1110
i_st_zpg_y      call    #\_fetch_zpg_y      ' %xxx_110
i_st_ind_x      call    #\_fetch_ind_x      ' %xxx_10
i_st_ind_y      call    #\_fetch_ind_y      ' %xxx_0
_st             mov     t1, _A              '  110 A
                mov     t1, _X              '  101 X
                mov     t1, _Y              '  011 Y
                jmp     #\_write
                                            ' TAX TAY TSX TXA TXS TYA
i_taxya         getbyte t1, _A, #0          '  0   0   1   1   1   1
                getbyte t1, _X, #0          '  1   1   1   0   0   1
                getbyte t1, _Y, #0          '  1   1   1   1   1   0
                getbyte t1, _S, #0          '  1   1   0   1   1   1
                getbyte _A, t1, #0          '  1   1   1   0   1   0
                getbyte _X, t1, #0          '  0   1   0   1   1   1
                getbyte _Y, t1, #0          '  1   0   1   1   1   1
                getbyte _S, t1, #0          '  1   1   1   1   0   1
                jmp     #_flags             '                  1
                ret

'
'
' Common subroutines
'
_flags          test    t1, #$FF       wz   ' affects Z
                bitz    _P, #REGP_Z         ' |
                testb   t1, #7         wz   ' affects N
        _ret_   bitz    _P, #REGP_N         ' |

_fetch_abs      rdword  t2, ptrb++
                jmp     #\_read

_fetch_abs_x    rdword  t2, ptrb++

                getbyte t3, t2, #0
                add     t3, _X
                cmp     t3, #$100       wc  ' page boundary
        if_nc   add     _I, #1              ' add 1 cycle

                add     t2, _X
                jmp     #\_read

_fetch_abs_y    rdword  t2, ptrb++

                getbyte t3, t2, #0
                add     t3, _Y
                cmp     t3, #$100       wc  ' page boundary
        if_nc   add     _I, #1              ' add 1 cycle

                add     t2, _Y
                jmp     #\_read

_fetch_zpg      rdbyte  t2, ptrb++
                jmp     #\_read

_fetch_zpg_x    rdbyte  t2, ptrb++
                add     t2, _X
                and     t2, #$FF
                jmp     #\_read

_fetch_zpg_y    rdbyte  t2, ptrb++
                add     t2, _Y
                and     t2, #$FF
                jmp     #\_read

_fetch_ind_x    rdbyte  t3, ptrb++
                add     t3, _X
                getbyte t4, t3, #0
                add     t4, ram_addr
                rdbyte  t2, t4
                add     t3, #1
                getbyte t4, t3, #0
                add     t4, ram_addr
                rdbyte  t1, t4
                setbyte t2, t1, #1
                jmp     #\_read

_fetch_ind_y    rdbyte  t3, ptrb++

                getbyte t4, t3, #0
                add     t4, ram_addr
                rdbyte  t2, t4              ' t2 = low
                add     t3, #1

                getbyte t4, t3, #0
                add     t4, ram_addr
                rdbyte  t1, t4              ' t1 = high

                add     t2, _Y
                cmp     t2, #$100       wc  ' page boundary
        if_nc   add     _I, #1              ' add 1 cycle

                shl     t1, #8
                add     t2, t1
                and     t2, ##$FFFF
                jmp     #\_read

_push_t1        getbyte t2, _S, #0
                add     t2, #$100
                add     t2, ram_addr
                wrbyte  t1, t2
        _ret_   decmod  _S, #$FF

_pop_t1         incmod  _S, #$FF
                getbyte t2, _S, #0
                add     t2, #$100
                add     t2, ram_addr
        _ret_   rdbyte  t1, t2

_read           getword t5, t2, #0
                add     t5, ram_addr
        _ret_   rdbyte  t1, t5

_write          getword t5, t2, #0
                add     t5, ram_addr
        _ret_   wrbyte  t1, t5

i_halt          ret

'
'
' Initialized
'
ram_addr        long    $40000 ' todo pass ram

'
'
' CPU Registers
'
_A              long    $00     ' 8-bit working registers
_X              long    $00
_Y              long    $00

_S              long    $FF     ' 8-bit stack pointer

_P              long    $20     ' 8-bit flag register
                                '   7 = N - negative
                                '   6 = V - overflow
                                '   5 = ?
                                '   4 = B - break
                                '   3 = D - decimal
                                '   2 = I - interrupt
                                '   1 = Z - zero
                                '   0 = C - carry

_PC             long    $0000   ' 16-bit program counter

_T              long    0       ' total cycles
_I              long    0       ' instruction cycles
_I_CLK          long    _CLKFREQ / 1_000_000 ' effective cycle frequency


' Temporaries
'
t1              res     1
t2              res     1
t3              res     1
t4              res     1
t5              res     1

ts              res     1

                fit     $1F0

''---------------------------------------- LUT

                org     $200

lut_6502
'
' instruction         snippet                  skip pattern         cycles    encoding
'--------------------------------------------------------------------------------------------
                long  i_brk       +                      %0 << 10 + 7 << 28 ' 00 BRK
                long  i_log_ind_x +              %011_1_110 << 10 + 2 << 28 ' 01 ORA ($nn,X)
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 02
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 03
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 04
                long  i_log_zpg   +           %011_1_111110 << 10 + 3 << 28 ' 05 ORA $nn
                long  i_asl_zpg   +           %01_000_1_110 << 10 + 5 << 28 ' 06 ASL $nn
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 07
                long  i_push      +                     %01 << 10 + 3 << 28 ' 08 PHP
                long  i_log_imm   +                  %011_0 << 10 + 2 << 28 ' 09 ORA #$nn
                long  i_asl       +               %10_000_0 << 10 + 2 << 28 ' 0A ASL
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 0B
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 0C
                long  i_log_abs   +          %011_1_1111110 << 10 + 4 << 28 ' 0D ORA $nnnn
                long  i_asl_abs   +          %01_000_1_1110 << 10 + 6 << 28 ' 0E ASL $nnnn
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 0F

                long  i_branch    +              %10_0111_0 << 10 + 3 << 28 ' 10 BPL $nn
                long  i_log_ind_y +               %011_1_10 << 10 + 2 << 28 ' 11 ORA ($nn),Y
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 12
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 13
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 14
                long  i_log_zpg_x +                %011_1_0 << 10 + 2 << 28 ' 15 ORA $nn,X
                long  i_asl_zpg_x +             %01_000_1_0 << 10 + 6 << 28 ' 16 ASL $nn,X
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 17
                long  i_clc       +                      %0 << 10 + 2 << 28 ' 18 CLC
                long  i_log_abs_y +             %011_1_1110 << 10 + 2 << 28 ' 19 ORA $nnnn,Y
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 1A
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 1B
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 1C
                long  i_log_abs_x +            %011_1_11110 << 10 + 2 << 28 ' 1D ORA $nnnn,X
                long  i_asl_abs_x +            %01_000_1_10 << 10 + 7 << 28 ' 1E ASL $nnnn,X
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 1F

                long  i_jsr       +                      %0 << 10 + 6 << 28 ' 20 JSR $nn
                long  i_log_ind_x +              %110_1_110 << 10 + 6 << 28 ' 21 AND ($nn,X)
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 22
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 23
                long  i_bit_zpg   +                      %0 << 10 + 3 << 28 ' 24 BIT $nn
                long  i_log_zpg   +           %110_1_111110 << 10 + 3 << 28 ' 25 AND $nn
                long  i_rol_zpg   +         %01_00000_1_110 << 10 + 5 << 28 ' 26 ROL $nn
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 27
                long  i_plp       +                      %0 << 10 + 4 << 28 ' 28 PLP
                long  i_log_imm   +                  %110_0 << 10 + 2 << 28 ' 29 AND #$nn
                long  i_rol       +             %10_00000_0 << 10 + 2 << 28 ' 2A ROL
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 2B
                long  i_bit_abs   +                     %10 << 10 + 4 << 28 ' 2C BIT $nnnn
                long  i_log_abs   +          %110_1_1111110 << 10 + 4 << 28 ' 2D AND $nnnn
                long  i_rol_abs   +        %01_00000_1_1110 << 10 + 4 << 28 ' 2E ROL $nnnn
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 2F

                long  i_branch    +              %01_0111_0 << 10 + 3 << 28 ' 30 BMI $nn
                long  i_log_ind_y +               %110_1_10 << 10 + 5 << 28 ' 31 AND ($nn),Y
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 32
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 33
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 34
                long  i_log_zpg_x +                %110_1_0 << 10 + 4 << 28 ' 35 AND $nn,X
                long  i_rol_zpg_x +           %01_00000_1_0 << 10 + 6 << 28 ' 36 ROL $nn,X
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 37
                long  i_sec       +                      %0 << 10 + 2 << 28 ' 38 SEC
                long  i_log_abs_y +             %110_1_1110 << 10 + 4 << 28 ' 39 AND $nnnn,Y
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 3A
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 3B
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 3C
                long  i_log_abs_x +            %110_1_11110 << 10 + 4 << 28 ' 3D AND $nnnn,X
                long  i_rol_abs_x +          %01_00000_1_10 << 10 + 7 << 28 ' 3E ROL $nnnn,X
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 3F

                long  i_rti       +               %11000000 << 10 + 6 << 28 ' 40 RTI
                long  i_log_ind_x +              %101_1_110 << 10 + 2 << 28 ' 41 EOR ($nn,X)
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 42
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 43
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 44
                long  i_log_zpg   +           %101_1_111110 << 10 + 3 << 28 ' 45 EOR $nn
                long  i_lsr_zpg   +           %01_000_1_110 << 10 + 2 << 28 ' 46 LSR $nn
                long  i_halt      +                      %0 << 10 + 5 << 28 ' 47
                long  i_push      +                     %10 << 10 + 3 << 28 ' 48 PHA
                long  i_log_imm   +                  %101_0 << 10 + 2 << 28 ' 49 EOR #$nn
                long  i_lsr       +               %10_000_0 << 10 + 2 << 28 ' 4A LSR
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 4B
                long  i_jmp       +                   %0110 << 10 + 3 << 28 ' 4C JMP $nnnn
                long  i_log_abs   +          %101_1_1111110 << 10 + 4 << 28 ' 4D EOR $nnnn
                long  i_lsr_abs   +          %01_000_1_1110 << 10 + 6 << 28 ' 4E LSR $nnnn
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 4F

                long  i_branch    +              %10_1011_0 << 10 + 3 << 28 ' 50 BVC $nn
                long  i_log_ind_y +               %101_1_10 << 10 + 2 << 28 ' 51 EOR ($nn),Y
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 52
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 53
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 54
                long  i_log_zpg_x +                %101_1_0 << 10 + 2 << 28 ' 55 EOR $nn,X
                long  i_lsr_zpg_x +             %01_000_1_0 << 10 + 6 << 28 ' 56 LSR $nn,X
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 57
                long  i_cli       +                      %0 << 10 + 2 << 28 ' 58 CLI
                long  i_log_abs_y +             %101_1_1110 << 10 + 2 << 28 ' 59 EOR $nnnn,Y
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 5A
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 5B
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 5C
                long  i_log_abs_x +            %101_1_11110 << 10 + 2 << 28 ' 5D EOR $nnnn,X
                long  i_lsr_abs_x +            %01_000_1_10 << 10 + 7 << 28 ' 5E LSR $nnnn,X
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 5F

                long  i_rts       +                      %0 << 10 + 6 << 28 ' 60 RTS
                long  i_adc_ind_x +                 %1_1110 << 10 + 6 << 28 ' 61 ADC ($nn,X)
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 62
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 63
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 64
                long  i_adc_zpg   +                   %1_10 << 10 + 3 << 28 ' 65 ADC $nn
                long  i_ror_zpg   +         %01_00000_1_110 << 10 + 5 << 28 ' 66 ROR $nn
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 67
                long  i_pla       +                      %0 << 10 + 4 << 28 ' 68 PLA
                long  i_adc_imm   +                      %0 << 10 + 2 << 28 ' 69 ADC #$nn
                long  i_ror       +             %10_00000_0 << 10 + 2 << 28 ' 6A ROR
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 6B
                long  i_jmp       +                   %0000 << 10 + 5 << 28 ' 6C JMP ($nnnn)
                long  i_adc_abs   +              %1_1111110 << 10 + 4 << 28 ' 6D ADC $nnnn
                long  i_ror_abs   +        %01_00000_1_1110 << 10 + 6 << 28 ' 6E ROR $nnnn
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 6F

                long  i_branch    +              %01_1011_0 << 10 + 3 << 28 ' 70 BVS $nn
                long  i_adc_ind_y +                  %1_110 << 10 + 5 << 28 ' 71 ADC ($nn),Y
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 72
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 73
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 74
                long  i_adc_zpg_x +                    %1_0 << 10 + 4 << 28 ' 75 ADC $nn,X
                long  i_ror_zpg_x +           %01_00000_1_0 << 10 + 6 << 28 ' 76 ROR $nn,X
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 77
                long  i_sei       +                      %0 << 10 + 2 << 28 ' 78 SEI
                long  i_adc_abs_y +                %1_11110 << 10 + 4 << 28 ' 79 AND $nnnn,Y
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 7A
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 7B
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 7C
                long  i_adc_abs_x +               %1_111110 << 10 + 4 << 28 ' 7D ADC $nnnn,X
                long  i_ror_abs_x +          %01_00000_1_10 << 10 + 7 << 28 ' 7E ROR $nnnn,X
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 7F

                long  i_halt      +                      %0 << 10 + 2 << 28 ' 80
                long  i_st_ind_x  +                 %110_10 << 10 + 6 << 28 ' 81 STA ($nn,X)
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 82
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 83
                long  i_st_zpg    +              %011_11110 << 10 + 3 << 28 ' 84 STY $nn
                long  i_st_zpg    +              %110_11110 << 10 + 3 << 28 ' 85 STA $nn
                long  i_st_zpg    +              %101_11110 << 10 + 3 << 28 ' 86 STX $nn
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 87
                long  i_inde_xy   +               %01_01_01 << 10 + 2 << 28 ' 88 DEY
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 89
                long  i_taxya     +              %1110_1101 << 10 + 2 << 28 ' 8A TXA
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 8B
                long  i_st_abs    +           %011_11111110 << 10 + 4 << 28 ' 8C STY $nnnn
                long  i_st_abs    +           %110_11111110 << 10 + 4 << 28 ' 8D STA $nnnn
                long  i_st_abs    +           %101_11111110 << 10 + 4 << 28 ' 8E STX $nnnn
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 8F

                long  i_branch    +              %10_1110_0 << 10 + 3 << 28 ' 90 BCC $nn
                long  i_st_ind_y  +                  %110_0 << 10 + 6 << 28 ' 91 STA ($nn),Y
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 92
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 93
                long  i_st_zpg_x  +               %011_1110 << 10 + 4 << 28 ' 94 STY $nn,X
                long  i_st_zpg_x  +               %110_1110 << 10 + 4 << 28 ' 95 STA $nn,X
                long  i_st_zpg_y  +                %101_110 << 10 + 4 << 28 ' 96 STX $nn,Y
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 97
                long  i_taxya     +              %1110_1011 << 10 + 2 << 28 ' 98 TYA
                long  i_st_abs_y  +             %110_111110 << 10 + 5 << 28 ' 99 STA $nnnn,Y
                long  i_taxya     +            %1_0111_1101 << 10 + 2 << 28 ' 9A TXS
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 9B
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 9C
                long  i_st_abs_x  +            %110_1111110 << 10 + 5 << 28 ' 9D STA $nnnn,X
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 9E
                long  i_halt      +                      %0 << 10 + 2 << 28 ' 9F

                long  i_ld_imm    +                  %011_0 << 10 + 2 << 28 ' A0 LDY #nn
                long  i_ld_ind_x  +               %110_1_10 << 10 + 6 << 28 ' A1 LDA ($nn,X)
                long  i_ld_imm    +                  %101_0 << 10 + 2 << 28 ' A2 LDX #nn
                long  i_halt      +                      %0 << 10 + 2 << 28 ' A3
                long  i_ld_zpg    +            %011_1_11110 << 10 + 3 << 28 ' A4 LDY zpg
                long  i_ld_zpg    +            %110_1_11110 << 10 + 3 << 28 ' A5 LDA zpg
                long  i_ld_zpg    +            %101_1_11110 << 10 + 3 << 28 ' A6 LDX zpg
                long  i_halt      +                      %0 << 10 + 2 << 28 ' A7
                long  i_taxya     +              %1011_1110 << 10 + 2 << 28 ' A8 TAY
                long  i_ld_imm    +                  %110_0 << 10 + 2 << 28 ' A9 LDA #nn
                long  i_taxya     +              %1101_1110 << 10 + 2 << 28 ' AA TAX
                long  i_halt      +                      %0 << 10 + 2 << 28 ' AB
                long  i_ld_abs    +         %011_1_11111110 << 10 + 4 << 28 ' AC LDY nnnn
                long  i_ld_abs    +         %110_1_11111110 << 10 + 4 << 28 ' AD LDA nnnn
                long  i_ld_abs    +         %101_1_11111110 << 10 + 4 << 28 ' AE LDX nnnn
                long  i_halt      +                      %0 << 10 + 2 << 28 ' AF

                long  i_branch    +              %01_1110_0 << 10 + 3 << 28 ' B0 BCS $nn
                long  i_ld_ind_y  +                %110_1_0 << 10 + 5 << 28 ' B1 LDA ($nn),Y
                long  i_halt      +                      %0 << 10 + 2 << 28 ' B2
                long  i_halt      +                      %0 << 10 + 2 << 28 ' B3
                long  i_ld_zpg_x  +             %011_1_1110 << 10 + 4 << 28 ' B4 LDY $nn,Y
                long  i_ld_zpg_x  +             %110_1_1110 << 10 + 4 << 28 ' B5 LDA $nn,X
                long  i_ld_zpg_y  +              %101_1_110 << 10 + 4 << 28 ' B6 LDX $nn,Y
                long  i_halt      +                      %0 << 10 + 2 << 28 ' B7
                long  i_clv       +                      %0 << 10 + 2 << 28 ' B8 CLV
                long  i_ld_abs_y  +           %110_1_111110 << 10 + 4 << 28 ' B9 LDA $nnnn,Y
                long  i_taxya     +              %1101_0111 << 10 + 2 << 28 ' BA TSX
                long  i_halt      +                      %0 << 10 + 2 << 28 ' BB
                long  i_ld_abs_x  +          %011_1_1111110 << 10 + 4 << 28 ' BC LDY $nnnn,X
                long  i_ld_abs_x  +          %110_1_1111110 << 10 + 4 << 28 ' BD LDA $nnnn,X
                long  i_ld_abs_y  +           %101_1_111110 << 10 + 4 << 28 ' BE LDX $nnnn,Y
                long  i_halt      +                      %0 << 10 + 2 << 28 ' BF

                long  i_cmp_imm   +                 %011_00 << 10 + 2 << 28 ' C0 CPY #$nn
                long  i_cmp_ind_x +           %110_0_1_1110 << 10 + 6 << 28 ' C1 CMP ($nn,X)
                long  i_halt      +                      %0 << 10 + 2 << 28 ' C2
                long  i_halt      +                      %0 << 10 + 2 << 28 ' C3
                long  i_cmp_zpg   +             %011_0_1_10 << 10 + 3 << 28 ' C4 CPY $nn
                long  i_cmp_zpg   +             %110_0_1_10 << 10 + 3 << 28 ' C5 CMP $nn
                long  i_dec_zpg   +                %10_1110 << 10 + 5 << 28 ' C6 DEC $nn
                long  i_halt      +                      %0 << 10 + 2 << 28 ' C7
                long  i_inde_xy   +               %01_10_01 << 10 + 2 << 28 ' C8 INY
                long  i_cmp_imm   +                 %110_00 << 10 + 2 << 28 ' C9 CMP #$nn
                long  i_inde_xy   +               %10_01_10 << 10 + 2 << 28 ' CA DEX
                long  i_halt      +                      %0 << 10 + 2 << 28 ' CB
                long  i_cmp_abs   +        %011_0_1_1111110 << 10 + 4 << 28 ' CC CPY $nnnn
                long  i_cmp_abs   +        %110_0_1_1111110 << 10 + 4 << 28 ' CD CMP $nnnn
                long  i_dec_abs   +                   %10_0 << 10 + 6 << 28 ' CE DEC $nnnn
                long  i_halt      +                      %0 << 10 + 2 << 28 ' CF

                long  i_branch    +              %10_1101_0 << 10 + 3 << 28 ' D0 BNE $mm
                long  i_cmp_ind_y +            %110_0_1_110 << 10 + 2 << 28 ' D1 CMP ($nn),Y
                long  i_halt      +                      %0 << 10 + 2 << 28 ' D2
                long  i_halt      +                      %0 << 10 + 2 << 28 ' D3
                long  i_halt      +                      %0 << 10 + 2 << 28 ' D4
                long  i_cmp_zpg_x +              %110_0_1_0 << 10 + 2 << 28 ' D5 CMP $nn,X
                long  i_dec_zpg_x +                  %10_10 << 10 + 6 << 28 ' D6 DEC $nn,X
                long  i_halt      +                      %0 << 10 + 2 << 28 ' D7
                long  i_cld       +                      %0 << 10 + 2 << 28 ' D8 CLD
                long  i_cmp_abs_y +          %110_0_1_11110 << 10 + 4 << 28 ' D9 CMP $nnnn,Y
                long  i_halt      +                      %0 << 10 + 2 << 28 ' DA
                long  i_halt      +                      %0 << 10 + 2 << 28 ' DB
                long  i_halt      +                      %0 << 10 + 2 << 28 ' DC
                long  i_cmp_abs_x +         %110_0_1_111110 << 10 + 4 << 28 ' DD CMP $nnnn,X
                long  i_dec_abs_x +                 %10_110 << 10 + 7 << 28 ' DE DEC $nnnn,X
                long  i_halt      +                      %0 << 10 + 2 << 28 ' DF

                long  i_cmp_imm   +                 %101_00 << 10 + 2 << 28 ' E0 CPX #$nn
                long  i_sbc_ind_x +                 %1_1110 << 10 + 6 << 28 ' E1 SBC ($nn,X)
                long  i_halt      +                      %0 << 10 + 2 << 28 ' E2
                long  i_halt      +                      %0 << 10 + 2 << 28 ' E3
                long  i_cmp_zpg   +             %101_0_1_10 << 10 + 3 << 28 ' E4 CPX $nn
                long  i_sbc_zpg   +                   %1_10 << 10 + 3 << 28 ' E5 SBC #$nn
                long  i_dec_zpg   +                %01_1110 << 10 + 5 << 28 ' E6 INC $nn
                long  i_halt      +                      %0 << 10 + 2 << 28 ' E7
                long  i_inde_xy   +               %10_10_10 << 10 + 2 << 28 ' E8 INX
                long  i_sbc_imm   +                      %0 << 10 + 2 << 28 ' E9 SBC #$nn
                long  i_nop       +                      %0 << 10 + 2 << 28 ' EA NOP
                long  i_halt      +                      %0 << 10 + 4 << 28 ' EB
                long  i_cmp_abs   +        %101_0_1_1111110 << 10 + 2 << 28 ' EC CPX $nnnn
                long  i_sbc_abs   +              %1_1111110 << 10 + 4 << 28 ' ED SBC $nnnn
                long  i_dec_abs   +                   %01_0 << 10 + 6 << 28 ' EE INC $nnnn
                long  i_halt      +                      %0 << 10 + 2 << 28 ' EF

                long  i_branch    +              %01_1101_0 << 10 + 3 << 28 ' F0 BEQ $nn
                long  i_sbc_ind_y +                  %1_110 << 10 + 5 << 28 ' F1 SBC ($nn),Y
                long  i_halt      +                      %0 << 10 + 2 << 28 ' F2
                long  i_halt      +                      %0 << 10 + 2 << 28 ' F3
                long  i_halt      +                      %0 << 10 + 2 << 28 ' F4
                long  i_sbc_zpg_x +                    %1_0 << 10 + 4 << 28 ' F5 SBC $nn,X
                long  i_dec_zpg_x +                  %01_10 << 10 + 6 << 28 ' F6 INC $nn,X
                long  i_halt      +                      %0 << 10 + 2 << 28 ' F7
                long  i_sed       +                      %0 << 10 + 2 << 28 ' F8 SED
                long  i_sbc_abs_y +                %1_11110 << 10 + 4 << 28 ' F9 SBC $nnnn,Y
                long  i_halt      +                      %0 << 10 + 2 << 28 ' FA
                long  i_halt      +                      %0 << 10 + 2 << 28 ' FB
                long  i_halt      +                      %0 << 10 + 2 << 28 ' FC
                long  i_sbc_abs_x +               %1_111110 << 10 + 4 << 28 ' FD SBC $nnnn,X
                long  i_dec_abs_x +                 %01_110 << 10 + 7 << 28 ' FE INC $nnnn
                long  i_halt      +                      %0 << 10 + 2 << 28 ' FF


                fit     $3FF

end asm
