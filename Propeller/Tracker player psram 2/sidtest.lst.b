00000                 | 
00000                 | #line 1 "/home/pik33/Programowanie/P2-retromachine/Propeller/Tracker player psram 2/sidtest.p2asm"
00000                 | dat
00000 000 00 00 00 00 | 	nop
00004 001 01 EC 63 FD | 	cogid	pa
00008 002 02 00 00 FF 
0000c 003 04 EC E7 FC | 	coginit	pa,##$404
00010                 | 	orgh	$10
00010     00 00 00 00 | 	long	0	'reserved
00014     00 00 00 00 | 	long	0 ' clock frequency: will default to 160000000
00018     00 00 00 00 | 	long	0 ' clock mode: will default to $10007fb
0001c     00 00 00 00 
      ...             
003f8     00 00 00 00 
003fc     00 00 00 00 | 	orgh	$400
00400     00 F4 05 06 |  _ret_	mov	result1, #0
00404 000             | 	org	0
00404 000             | entry
00404 000 00 F0 0F F2 | 	cmp	ptra, #0 wz
00408 001 0C 02 90 5D |  if_ne	jmp	#spininit
0040c 002 F9 F0 03 F6 | 	mov	ptra, ptr_stackspace_
00410 003 14 EC 0F FB | 	rdlong	pa, #20 wz
00414 004 EC 01 90 5D |  if_ne	jmp	#skip_clock_set_
00418 005 00 00 64 FD | 	hubset	#0
0041c 006 03 80 80 FF 
00420 007 00 F0 67 FD | 	hubset	##16779256
00424 008 86 01 80 FF 
00428 009 1F 80 66 FD | 	waitx	##200000
0042c 00a 03 80 00 FF 
00430 00b FB ED 07 F6 | 	mov	pa, ##16779259
00434 00c 00 EC 63 FD | 	hubset	pa
00438 00d 18 EC 67 FC | 	wrlong	pa, #24
0043c 00e B4 C4 84 FF 
00440 00f 14 00 6C FC | 	wrlong	##160000000, #20
00444 010 BC 01 90 FD | 	jmp	#skip_clock_set_
00448 011 00 00 00 00 
      ...             
005fc 07e 00 00 00 00 
00600 07f 00 00 00 00 | 	orgf	128
00604 080             | skip_clock_set_
00604 080 F4 07 A0 FD | 	call	#_program
00608 081             | cogexit
00608 081 38 01 80 FF 
0060c 082 1F 00 66 FD | 	waitx	##160000
00610 083 01 0E 62 FD | 	cogid	arg01
00614 084 03 0E 62 FD | 	cogstop	arg01
00618 085             | spininit
00618 085 61 E3 05 FB | 	rdlong	objptr, ptra++
0061c 086 61 F5 05 FB | 	rdlong	result1, ptra++
00620 087 28 06 64 FD | 	setq	#3
00624 088 00 0F 06 FB | 	rdlong	arg01, ptra
00628 089 04 F0 87 F1 | 	sub	ptra, #4
0062c 08a 2D F4 61 FD | 	call	result1
00630 08b D4 FF 9F FD | 	jmp	#cogexit
00634 08c             | FCACHE_LOAD_
00634 08c 2B 30 61 FD |     pop	fcache_tmpb_
00638 08d F6 31 01 F1 |     add	fcache_tmpb_, pa
0063c 08e 2A 30 61 FD |     push	fcache_tmpb_
00640 08f F6 31 81 F1 |     sub	fcache_tmpb_, pa
00644 090 02 EC 47 F0 |     shr	pa, #2
00648 091 00 EC 8F F9 |     altd	pa
0064c 092 97 00 00 F6 |     mov	 0-0, ret_instr_
00650 093 01 EC 87 F1 |     sub	pa, #1
00654 094 28 EC 63 FD |     setq	pa
00658 095 98 00 00 FB |     rdlong	$0, fcache_tmpb_
0065c 096 00 00 80 FD |     jmp	#\$0 ' jmp to cache
00660 097             | ret_instr_
00660 097 2D 00 64 FD |     ret
00664 098             | fcache_tmpb_
00664 098 00 00 00 00 |     long 0
00668 099             | builtin_bytefill_
00668 099 01 12 56 F0 |         shr	arg03, #1 wc
0066c 09a 07 11 42 CC |  if_c   wrbyte	arg02, arg01
00670 09b 01 0E 06 C1 |  if_c   add	arg01, #1
00674 09c 00 10 FE F9 |         movbyts	arg02, #0
00678 09d             | builtin_wordfill_
00678 09d 01 12 56 F0 |         shr	arg03, #1 wc
0067c 09e 07 11 52 CC |  if_c   wrword	arg02, arg01
00680 09f 02 0E 06 C1 |  if_c   add	arg01, #2
00684 0a0 08 11 2A F9 |         setword	arg02, arg02, #1
00688 0a1             | builtin_longfill_
00688 0a1 07 01 88 FC |         wrfast	#0,arg01
0068c 0a2 00 12 0E F2 |         cmp	arg03, #0 wz
00690 0a3 09 03 D8 5C |  if_nz  rep	#1, arg03
00694 0a4 17 10 62 5D |  if_nz  wflong	arg02
00698 0a5 2D 00 64 FD |         ret
0069c 0a6             | COUNT_
0069c 0a6 00 00 00 00 |     long 0
006a0 0a7             | RETADDR_
006a0 0a7 00 00 00 00 |     long 0
006a4 0a8             | fp
006a4 0a8 00 00 00 00 |     long 0
006a8 0a9             | pushregs_
006a8 0a9 2B EC 63 FD |     pop  pa
006ac 0aa 2B 4E 61 FD |     pop  RETADDR_
006b0 0ab 03 4C 95 FB |     tjz  COUNT_, #pushregs_done_
006b4 0ac FF 4D 8D F9 |     altd  COUNT_, #511
006b8 0ad 28 00 64 FD |     setq #0-0
006bc 0ae 61 19 66 FC |     wrlong local01, ptra++
006c0 0af             | pushregs_done_
006c0 0af 28 04 64 FD |     setq #2 ' push 3 registers starting at COUNT_
006c4 0b0 61 4D 65 FC |     wrlong COUNT_, ptra++
006c8 0b1 F8 51 01 F6 |     mov    fp, ptra
006cc 0b2 2C EC 63 FD |     jmp  pa
006d0 0b3             |  popregs_
006d0 0b3 2B EC 63 FD |     pop    pa
006d4 0b4 28 04 64 FD |     setq   #2
006d8 0b5 5F 4D 05 FB |     rdlong COUNT_, --ptra
006dc 0b6 02 4C 75 FB |     djf    COUNT_, #popregs__ret
006e0 0b7 28 4C 61 FD |     setq   COUNT_
006e4 0b8 5F 19 06 FB |     rdlong local01, --ptra
006e8 0b9             | popregs__ret
006e8 0b9 2A 4E 61 FD |     push   RETADDR_
006ec 0ba 2C EC 63 FD |     jmp    pa
006f0 0bb             | 
006f0 0bb             | divide_
006f0 0bb 37 6F 5A F6 |        abs     muldivb_,muldivb_     wcz      'abs(y)
006f4 0bc 6C E0 61 FD |        wrc     itmp2_                         'store sign of y
006f8 0bd 36 6D 52 F6 |        abs     muldiva_,muldiva_     wc       'abs(x)
006fc 0be 37 6D 12 FD |        qdiv    muldiva_, muldivb_             'queue divide
00700 0bf 01 E0 65 C5 |  if_c  xor     itmp2_,#1                      'store sign of x
00704 0c0 18 6E 62 FD |        getqx   muldivb_                       'get quotient
00708 0c1 19 6C 62 FD |        getqy   muldiva_                       'get remainder
0070c 0c2 36 6D 82 F6 |        negc    muldiva_,muldiva_              'restore sign, remainder (sign of x)
00710 0c3 00 E0 15 F4 |        testb   itmp2_,#0             wc       'restore sign, division result
00714 0c4 37 6F 82 06 |  _ret_ negc    muldivb_,muldivb_     
00718 0c5             | __pc long 0
00718 0c5 00 00 00 00 
0071c 0c6             | __setjmp
0071c 0c6 2B 8A 61 FD |     pop __pc
00720 0c7 00 F4 05 F6 |     mov result1, #0
00724 0c8 00 F6 05 F6 |     mov result2, #0
00728 0c9 07 DD 01 F6 |     mov abortchain, arg01
0072c 0ca 07 51 61 FC |     wrlong fp, arg01
00730 0cb 04 0E 06 F1 |     add arg01, #4
00734 0cc 07 F1 63 FC |     wrlong ptra, arg01
00738 0cd 04 0E 06 F1 |     add arg01, #4
0073c 0ce 07 E3 61 FC |     wrlong objptr, arg01
00740 0cf 04 0E 06 F1 |     add arg01, #4
00744 0d0 07 8B 61 FC |     wrlong __pc, arg01
00748 0d1 2C 8A 61 FD |     jmp __pc
0074c 0d2             | __unwind_pc long 0
0074c 0d2 00 00 00 00 
00750 0d3             | __unwind_stack
00750 0d3 2B A4 61 FD |    pop  __unwind_pc
00754 0d4             | __unwind_loop
00754 0d4 08 0F 0A F2 |    cmp  arg01, arg02 wz
00758 0d5 10 00 90 AD |   if_z jmp #__unwind_stack_ret
0075c 0d6 07 F1 03 F6 |    mov   ptra, arg01
00760 0d7 6C FF BF FD |    call  #popregs_
00764 0d8 A8 0E 02 F6 |    mov   arg01, fp
00768 0d9 E8 FF 9F FD |    jmp   #__unwind_loop
0076c 0da             | __unwind_stack_ret
0076c 0da 2C A4 61 FD |    jmp  __unwind_pc
00770 0db             | __longjmp
00770 0db 2B 8A 61 FD |     pop __pc
00774 0dc 00 0E 0E F2 |     cmp    arg01, #0 wz
00778 0dd 30 00 90 AD |  if_z jmp #nocatch
0077c 0de 08 F5 01 F6 |     mov result1, arg02
00780 0df 01 F6 05 F6 |     mov result2, #1
00784 0e0 07 11 02 FB |     rdlong arg02, arg01
00788 0e1 04 0E 06 F1 |     add arg01, #4
0078c 0e2 07 F1 03 FB |     rdlong ptra, arg01
00790 0e3 04 0E 06 F1 |     add arg01, #4
00794 0e4 07 E3 01 FB |     rdlong objptr, arg01
00798 0e5 04 0E 06 F1 |     add arg01, #4
0079c 0e6 07 8B 01 FB |     rdlong __pc, arg01
007a0 0e7 A8 0E 02 F6 |     mov arg01, fp
007a4 0e8 A8 FF BF FD |     call #__unwind_stack
007a8 0e9             | __longjmp_ret
007a8 0e9 2C 8A 61 FD |     jmp  __pc
007ac 0ea             | nocatch
007ac 0ea 00 12 0E F2 |     cmp arg03, #0 wz
007b0 0eb 54 FE 9F AD |  if_z jmp #cogexit
007b4 0ec F0 FF 9F FD |     jmp #__longjmp_ret
007b8 0ed             | 
007b8 0ed             | __heap_ptr
007b8 0ed 48 C9 00 00 | 	long	@__heap_base
007bc 0ee             | abortchain
007bc 0ee 00 00 00 00 | 	long	0
007c0 0ef             | itmp1_
007c0 0ef 00 00 00 00 | 	long	0
007c4 0f0             | itmp2_
007c4 0f0 00 00 00 00 | 	long	0
007c8 0f1             | objptr
007c8 0f1 50 D9 00 00 | 	long	@objmem
007cc 0f2             | ptr___struct__s_vfs_file_t_putchar_
007cc 0f2 A4 B9 00 00 | 	long	@__struct__s_vfs_file_t_putchar
007d0 0f3             | ptr___system____default_flush_
007d0 0f3 24 27 00 00 | 	long	@__system____default_flush
007d4 0f4             | ptr___system____default_getc_
007d4 0f4 7C 25 00 00 | 	long	@__system____default_getc
007d8 0f5             | ptr___system____default_putc_
007d8 0f5 00 26 00 00 | 	long	@__system____default_putc
007dc 0f6             | ptr___system____default_putc_terminal_
007dc 0f6 90 26 00 00 | 	long	@__system____default_putc_terminal
007e0 0f7             | ptr___system__dat__
007e0 0f7 44 BB 00 00 | 	long	@__system__dat_
007e4 0f8             | ptr__ff_cc_dat__
007e4 0f8 00 C2 00 00 | 	long	@_ff_cc_dat_
007e8 0f9             | ptr_stackspace_
007e8 0f9 5C D9 00 00 | 	long	@stackspace
007ec 0fa             | result1
007ec 0fa 00 00 00 00 | 	long	0
007f0 0fb             | result2
007f0 0fb 00 00 00 00 | 	long	0
007f4 0fc             | COG_BSS_START
007f4 0fc             | 	fit	480
007f4                 | 	orgh
007f4                 | hubentry
007f4                 | 
007f4                 | _program
007f4     01 4C 05 F6 | 	mov	COUNT_, #1
007f8     A9 00 A0 FD | 	call	#pushregs_
007fc     5D 00 00 FF 
00800     10 19 06 F6 | 	mov	local01, ##@LR__0742
00804     3D 0E 06 F6 | 	mov	arg01, #61
00808     3C 10 06 F6 | 	mov	arg02, #60
0080c     3B 12 06 F6 | 	mov	arg03, #59
00810     3A 14 06 F6 | 	mov	arg04, #58
00814     9C 1C B0 FD | 	call	#__system___vfs_open_sdcardx
00818     FA 10 02 F6 | 	mov	arg02, result1
0081c     0C 0F 02 F6 | 	mov	arg01, local01
00820     68 04 B0 FD | 	call	#__system___mount
00824     5D 00 00 FF 
00828     14 0F 06 F6 | 	mov	arg01, ##@LR__0743
0082c     40 24 B0 FD | 	call	#__system__chdir
00830     5D 00 00 FF 
00834     25 19 06 F6 | 	mov	local01, ##@LR__0744
00838     08 E2 05 F1 | 	add	objptr, #8
0083c     F1 18 62 FC | 	wrlong	local01, objptr
00840     08 E2 85 F1 | 	sub	objptr, #8
00844                 | ' close #7: open filename3$ for input as #7   
00844     07 0E 06 F6 | 	mov	arg01, #7
00848     4C 22 B0 FD | 	call	#__system__close
0084c     08 E2 05 F1 | 	add	objptr, #8
00850     F1 10 02 FB | 	rdlong	arg02, objptr
00854     08 E2 85 F1 | 	sub	objptr, #8
00858     07 0E 06 F6 | 	mov	arg01, #7
0085c     00 12 06 F6 | 	mov	arg03, #0
00860     90 07 B0 FD | 	call	#__system___basic_open_string
00864                 | ' 
00864                 | ' get #7,5,version,2 
00864     04 E2 05 F1 | 	add	objptr, #4
00868     F1 12 02 F6 | 	mov	arg03, objptr
0086c     04 E2 85 F1 | 	sub	objptr, #4
00870     07 0E 06 F6 | 	mov	arg01, #7
00874     05 10 06 F6 | 	mov	arg02, #5
00878     02 14 06 F6 | 	mov	arg04, #2
0087c     02 16 06 F6 | 	mov	arg05, #2
00880     90 08 B0 FD | 	call	#__system___basic_get
00884                 | ' print version 
00884     00 0E 06 F6 | 	mov	arg01, #0
00888     68 28 B0 FD | 	call	#__system___getiolock_0110
0088c     FA 0E 02 F6 | 	mov	arg01, result1
00890     AC 02 B0 FD | 	call	#__system___lockmem
00894     04 E2 05 F1 | 	add	objptr, #4
00898     F1 10 E2 FA | 	rdword	arg02, objptr
0089c     04 E2 85 F1 | 	sub	objptr, #4
008a0     00 0E 06 F6 | 	mov	arg01, #0
008a4     00 12 06 F6 | 	mov	arg03, #0
008a8     0A 14 06 F6 | 	mov	arg04, #10
008ac     28 08 B0 FD | 	call	#__system___basic_print_unsigned
008b0     00 0E 06 F6 | 	mov	arg01, #0
008b4     0A 10 06 F6 | 	mov	arg02, #10
008b8     00 12 06 F6 | 	mov	arg03, #0
008bc     CC 07 B0 FD | 	call	#__system___basic_print_char
008c0     00 0E 06 F6 | 	mov	arg01, #0
008c4     2C 28 B0 FD | 	call	#__system___getiolock_0110
008c8     FA 00 68 FC | 	wrlong	#0, result1
008cc                 | ' get #7,19,speed,4   
008cc     F1 12 02 F6 | 	mov	arg03, objptr
008d0     07 0E 06 F6 | 	mov	arg01, #7
008d4     13 10 06 F6 | 	mov	arg02, #19
008d8     04 14 06 F6 | 	mov	arg04, #4
008dc     04 16 06 F6 | 	mov	arg05, #4
008e0     30 08 B0 FD | 	call	#__system___basic_get
008e4                 | ' print version
008e4     00 0E 06 F6 | 	mov	arg01, #0
008e8     08 28 B0 FD | 	call	#__system___getiolock_0110
008ec     FA 0E 02 F6 | 	mov	arg01, result1
008f0     4C 02 B0 FD | 	call	#__system___lockmem
008f4     04 E2 05 F1 | 	add	objptr, #4
008f8     F1 10 E2 FA | 	rdword	arg02, objptr
008fc     04 E2 85 F1 | 	sub	objptr, #4
00900     00 0E 06 F6 | 	mov	arg01, #0
00904     00 12 06 F6 | 	mov	arg03, #0
00908     0A 14 06 F6 | 	mov	arg04, #10
0090c     C8 07 B0 FD | 	call	#__system___basic_print_unsigned
00910     00 0E 06 F6 | 	mov	arg01, #0
00914     0A 10 06 F6 | 	mov	arg02, #10
00918     00 12 06 F6 | 	mov	arg03, #0
0091c     6C 07 B0 FD | 	call	#__system___basic_print_char
00920     00 0E 06 F6 | 	mov	arg01, #0
00924     CC 27 B0 FD | 	call	#__system___getiolock_0110
00928     FA 00 68 FC | 	wrlong	#0, result1
0092c     A8 F0 03 F6 | 	mov	ptra, fp
00930     B3 00 A0 FD | 	call	#popregs_
00934                 | _program_ret
00934     2D 00 64 FD | 	ret
00938                 | hubexit
00938     81 00 80 FD | 	jmp	#cogexit
0093c                 | 
0093c                 | __system___setbaud
0093c     14 6C 06 FB | 	rdlong	muldiva_, #20
00940     07 6F 02 F6 | 	mov	muldivb_, arg01
00944     BB 00 A0 FD | 	call	#divide_
00948     40 7C 64 FD | 	dirl	#62
0094c     40 7E 64 FD | 	dirl	#63
00950     F7 6E 62 FC | 	wrlong	muldivb_, ptr___system__dat__
00954     10 6E 66 F0 | 	shl	muldivb_, #16
00958     07 10 06 F6 | 	mov	arg02, #7
0095c     37 11 02 F1 | 	add	arg02, muldivb_
00960     3E F8 0C FC | 	wrpin	#124, #62
00964     3E 10 16 FC | 	wxpin	arg02, #62
00968     3F 7C 0C FC | 	wrpin	#62, #63
0096c     14 10 06 F1 | 	add	arg02, #20
00970     3F 10 16 FC | 	wxpin	arg02, #63
00974     41 7C 64 FD | 	dirh	#62
00978     41 7E 64 FD | 	dirh	#63
0097c                 | __system___setbaud_ret
0097c     2D 00 64 FD | 	ret
00980                 | 
00980                 | __system___txraw
00980     01 4C 05 F6 | 	mov	COUNT_, #1
00984     A9 00 A0 FD | 	call	#pushregs_
00988     07 19 02 F6 | 	mov	local01, arg01
0098c     F7 F4 09 FB | 	rdlong	result1, ptr___system__dat__ wz
00990     C2 01 00 AF 
00994     00 0E 06 A6 |  if_e	mov	arg01, ##230400
00998     A0 FF BF AD |  if_e	call	#__system___setbaud
0099c     3E 18 26 FC | 	wypin	local01, #62
009a0     1F 02 64 FD | 	waitx	#1
009a4     60 F6 9F FE | 	loc	pa,	#(@LR__0002-@LR__0001)
009a8     8C 00 A0 FD | 	call	#FCACHE_LOAD_
009ac                 | LR__0001
009ac     40 7C 74 FD | 	testp	#62 wc
009b0     F8 FF 9F 3D |  if_ae	jmp	#LR__0001
009b4                 | LR__0002
009b4     01 F4 05 F6 | 	mov	result1, #1
009b8     A8 F0 03 F6 | 	mov	ptra, fp
009bc     B3 00 A0 FD | 	call	#popregs_
009c0                 | __system___txraw_ret
009c0     2D 00 64 FD | 	ret
009c4                 | 
009c4                 | __system___rxraw
009c4     0D 4C 05 F6 | 	mov	COUNT_, #13
009c8     A9 00 A0 FD | 	call	#pushregs_
009cc     07 19 02 F6 | 	mov	local01, arg01
009d0     F7 1A 0A FB | 	rdlong	local02, ptr___system__dat__ wz
009d4     C2 01 00 AF 
009d8     00 0E 06 A6 |  if_e	mov	arg01, ##230400
009dc     5C FF BF AD |  if_e	call	#__system___setbaud
009e0     00 18 0E F2 | 	cmp	local01, #0 wz
009e4     1C 00 90 AD |  if_e	jmp	#LR__0003
009e8     14 1C 06 FB | 	rdlong	local03, #20
009ec     0A 1C 46 F0 | 	shr	local03, #10
009f0     0E 19 02 FD | 	qmul	local01, local03
009f4     1A F4 61 FD | 	getct	result1
009f8     18 1E 62 FD | 	getqx	local04
009fc     0F F5 01 F1 | 	add	result1, local04
00a00     FA 20 02 F6 | 	mov	local05, result1
00a04                 | LR__0003
00a04     01 22 66 F6 | 	neg	local06, #1
00a08     3F 24 06 F6 | 	mov	local07, #63
00a0c     00 26 06 F6 | 	mov	local08, #0
00a10     04 EE 05 F1 | 	add	ptr___system__dat__, #4
00a14     F7 28 02 FB | 	rdlong	local09, ptr___system__dat__
00a18     04 EE 85 F1 | 	sub	ptr___system__dat__, #4
00a1c                 | LR__0004
00a1c     08 28 16 F4 | 	testb	local09, #8 wc
00a20     09 28 76 F4 | 	testbn	local09, #9 andc
00a24     0A 28 46 F0 | 	shr	local09, #10
00a28     01 26 06 C6 |  if_b	mov	local08, #1
00a2c     40 7E 6C 3D |  if_ae	testp	#63 wz
00a30     01 26 06 26 |  if_nc_and_z	mov	local08, #1
00a34     3F 28 8E 2A |  if_nc_and_z	rdpin	local09, #63
00a38     04 28 46 20 |  if_nc_and_z	shr	local09, #4
00a3c                 | LR__0005
00a3c     00 1A 06 F6 | 	mov	local02, #0
00a40     00 26 0E F2 | 	cmp	local08, #0 wz
00a44     01 1A 66 56 |  if_ne	neg	local02, #1
00a48     00 2A 06 F6 | 	mov	local10, #0
00a4c     00 1C 06 F6 | 	mov	local03, #0
00a50     00 18 0E F2 | 	cmp	local01, #0 wz
00a54     01 1C 66 56 |  if_ne	neg	local03, #1
00a58     00 1E 06 F6 | 	mov	local04, #0
00a5c     00 2C 06 F6 | 	mov	local11, #0
00a60     1A F4 61 FD | 	getct	result1
00a64     FA 2E 02 F6 | 	mov	local12, result1
00a68     17 31 02 F6 | 	mov	local13, local12
00a6c     10 31 82 F1 | 	sub	local13, local05
00a70     00 30 56 F2 | 	cmps	local13, #0 wc
00a74     16 2D 22 C6 |  if_b	not	local11, local11
00a78     00 2C 0E F2 | 	cmp	local11, #0 wz
00a7c     0F 1F 22 56 |  if_ne	not	local04, local04
00a80     0F 1D CA F7 | 	test	local03, local04 wz
00a84     15 2B 22 56 |  if_ne	not	local10, local10
00a88     15 1B 4A F5 | 	or	local02, local10 wz
00a8c     8C FF 9F AD |  if_e	jmp	#LR__0004
00a90     00 26 0E F2 | 	cmp	local08, #0 wz
00a94     14 23 02 56 |  if_ne	mov	local06, local09
00a98     11 23 E2 58 |  if_ne	getbyte	local06, local06, #0
00a9c     04 EE 05 F1 | 	add	ptr___system__dat__, #4
00aa0     F7 28 62 FC | 	wrlong	local09, ptr___system__dat__
00aa4     04 EE 85 F1 | 	sub	ptr___system__dat__, #4
00aa8     11 F5 01 F6 | 	mov	result1, local06
00aac     A8 F0 03 F6 | 	mov	ptra, fp
00ab0     B3 00 A0 FD | 	call	#popregs_
00ab4                 | __system___rxraw_ret
00ab4     2D 00 64 FD | 	ret
00ab8                 | 
00ab8                 | __system____builtin_strcpy
00ab8     07 F9 01 F6 | 	mov	_var01, arg01
00abc     54 F5 9F FE | 	loc	pa,	#(@LR__0007-@LR__0006)
00ac0     8C 00 A0 FD | 	call	#FCACHE_LOAD_
00ac4                 | LR__0006
00ac4     08 F5 C9 FA | 	rdbyte	result1, arg02 wz
00ac8     07 F5 41 FC | 	wrbyte	result1, arg01
00acc     01 10 06 F1 | 	add	arg02, #1
00ad0     01 0E 06 F1 | 	add	arg01, #1
00ad4     EC FF 9F 5D |  if_ne	jmp	#LR__0006
00ad8                 | LR__0007
00ad8     FC F4 01 F6 | 	mov	result1, _var01
00adc                 | __system____builtin_strcpy_ret
00adc     2D 00 64 FD | 	ret
00ae0                 | 
00ae0                 | __system____topofstack
00ae0     00 4C 05 F6 | 	mov	COUNT_, #0
00ae4     A9 00 A0 FD | 	call	#pushregs_
00ae8     08 F0 07 F1 | 	add	ptra, #8
00aec     04 50 05 F1 | 	add	fp, #4
00af0     A8 0E 62 FC | 	wrlong	arg01, fp
00af4     A8 F4 01 F6 | 	mov	result1, fp
00af8     04 50 85 F1 | 	sub	fp, #4
00afc     A8 F0 03 F6 | 	mov	ptra, fp
00b00     B3 00 A0 FD | 	call	#popregs_
00b04                 | __system____topofstack_ret
00b04     2D 00 64 FD | 	ret
00b08                 | 
00b08                 | __system___make_methodptr
00b08     02 4C 05 F6 | 	mov	COUNT_, #2
00b0c     A9 00 A0 FD | 	call	#pushregs_
00b10     07 19 02 F6 | 	mov	local01, arg01
00b14     08 1B 02 F6 | 	mov	local02, arg02
00b18     08 0E 06 F6 | 	mov	arg01, #8
00b1c     A0 0D B0 FD | 	call	#__system___gc_alloc_managed
00b20     FA F4 09 F6 | 	mov	result1, result1 wz
00b24     FA 18 62 5C |  if_ne	wrlong	local01, result1
00b28     FA 18 02 56 |  if_ne	mov	local01, result1
00b2c     04 18 06 51 |  if_ne	add	local01, #4
00b30     0C 1B 62 5C |  if_ne	wrlong	local02, local01
00b34     A8 F0 03 F6 | 	mov	ptra, fp
00b38     B3 00 A0 FD | 	call	#popregs_
00b3c                 | __system___make_methodptr_ret
00b3c     2D 00 64 FD | 	ret
00b40                 | 
00b40                 | __system___lockmem
00b40     01 4C 05 F6 | 	mov	COUNT_, #1
00b44     A9 00 A0 FD | 	call	#pushregs_
00b48     07 19 02 F6 | 	mov	local01, arg01
00b4c     00 F4 05 F6 | 	mov	result1, #0
00b50     01 F4 61 FD | 	cogid	result1
00b54     00 F5 05 F1 | 	add	result1, #256
00b58                 | LR__0008
00b58     0C 0F 0A FB | 	rdlong	arg01, local01 wz
00b5c     0C F5 61 AC |  if_e	wrlong	result1, local01
00b60     0C 0F 02 AB |  if_e	rdlong	arg01, local01
00b64     0C 0F 02 AB |  if_e	rdlong	arg01, local01
00b68     FA 0E 0A F2 | 	cmp	arg01, result1 wz
00b6c     E8 FF 9F 5D |  if_ne	jmp	#LR__0008
00b70     A8 F0 03 F6 | 	mov	ptra, fp
00b74     B3 00 A0 FD | 	call	#popregs_
00b78                 | __system___lockmem_ret
00b78     2D 00 64 FD | 	ret
00b7c                 | 
00b7c                 | __system___tx
00b7c     02 4C 05 F6 | 	mov	COUNT_, #2
00b80     A9 00 A0 FD | 	call	#pushregs_
00b84     07 19 02 F6 | 	mov	local01, arg01
00b88     0A 18 0E F2 | 	cmp	local01, #10 wz
00b8c     18 00 90 5D |  if_ne	jmp	#LR__0009
00b90     08 EE 05 F1 | 	add	ptr___system__dat__, #8
00b94     F7 1A 02 FB | 	rdlong	local02, ptr___system__dat__
00b98     08 EE 85 F1 | 	sub	ptr___system__dat__, #8
00b9c     02 1A CE F7 | 	test	local02, #2 wz
00ba0     0D 0E 06 56 |  if_ne	mov	arg01, #13
00ba4     D8 FD BF 5D |  if_ne	call	#__system___txraw
00ba8                 | LR__0009
00ba8     0C 0F 02 F6 | 	mov	arg01, local01
00bac     D0 FD BF FD | 	call	#__system___txraw
00bb0     A8 F0 03 F6 | 	mov	ptra, fp
00bb4     B3 00 A0 FD | 	call	#popregs_
00bb8                 | __system___tx_ret
00bb8     2D 00 64 FD | 	ret
00bbc                 | 
00bbc                 | __system___rx
00bbc     01 4C 05 F6 | 	mov	COUNT_, #1
00bc0     A9 00 A0 FD | 	call	#pushregs_
00bc4                 | LR__0010
00bc4     00 0E 06 F6 | 	mov	arg01, #0
00bc8     F8 FD BF FD | 	call	#__system___rxraw
00bcc     FA 18 02 F6 | 	mov	local01, result1
00bd0     FF FF 7F FF 
00bd4     FF 19 0E F2 | 	cmp	local01, ##-1 wz
00bd8     E8 FF 9F AD |  if_e	jmp	#LR__0010
00bdc     0D 18 0E F2 | 	cmp	local01, #13 wz
00be0     14 00 90 5D |  if_ne	jmp	#LR__0011
00be4     08 EE 05 F1 | 	add	ptr___system__dat__, #8
00be8     F7 F4 01 FB | 	rdlong	result1, ptr___system__dat__
00bec     08 EE 85 F1 | 	sub	ptr___system__dat__, #8
00bf0     02 F4 CD F7 | 	test	result1, #2 wz
00bf4     0A 18 06 56 |  if_ne	mov	local01, #10
00bf8                 | LR__0011
00bf8     08 EE 05 F1 | 	add	ptr___system__dat__, #8
00bfc     F7 0E 02 FB | 	rdlong	arg01, ptr___system__dat__
00c00     08 EE 85 F1 | 	sub	ptr___system__dat__, #8
00c04     01 0E CE F7 | 	test	arg01, #1 wz
00c08     1C 00 90 AD |  if_e	jmp	#LR__0014
00c0c     7F 18 0E F2 | 	cmp	local01, #127 wz
00c10     0C 00 90 5D |  if_ne	jmp	#LR__0012
00c14     08 0E 06 F6 | 	mov	arg01, #8
00c18     60 FF BF FD | 	call	#__system___tx
00c1c     08 00 90 FD | 	jmp	#LR__0013
00c20                 | LR__0012
00c20     0C 0F 02 F6 | 	mov	arg01, local01
00c24     54 FF BF FD | 	call	#__system___tx
00c28                 | LR__0013
00c28                 | LR__0014
00c28     0C F5 01 F6 | 	mov	result1, local01
00c2c     A8 F0 03 F6 | 	mov	ptra, fp
00c30     B3 00 A0 FD | 	call	#popregs_
00c34                 | __system___rx_ret
00c34     2D 00 64 FD | 	ret
00c38                 | 
00c38                 | __system___waitus
00c38     02 4C 05 F6 | 	mov	COUNT_, #2
00c3c     A9 00 A0 FD | 	call	#pushregs_
00c40     07 19 02 F6 | 	mov	local01, arg01
00c44     10 EE 05 F1 | 	add	ptr___system__dat__, #16
00c48     F7 1A 0A FB | 	rdlong	local02, ptr___system__dat__ wz
00c4c     10 EE 85 F1 | 	sub	ptr___system__dat__, #16
00c50     20 00 90 5D |  if_ne	jmp	#LR__0015
00c54     14 1A 06 FB | 	rdlong	local02, #20
00c58     A1 07 00 FF 
00c5c     40 1A 16 FD | 	qdiv	local02, ##1000000
00c60     10 EE 05 F1 | 	add	ptr___system__dat__, #16
00c64     18 0E 62 FD | 	getqx	arg01
00c68     07 1B 02 F6 | 	mov	local02, arg01
00c6c     F7 0E 62 FC | 	wrlong	arg01, ptr___system__dat__
00c70     10 EE 85 F1 | 	sub	ptr___system__dat__, #16
00c74                 | LR__0015
00c74     0D 19 02 FD | 	qmul	local01, local02
00c78     18 0E 62 FD | 	getqx	arg01
00c7c     1F 0E 62 FD | 	waitx	arg01
00c80     A8 F0 03 F6 | 	mov	ptra, fp
00c84     B3 00 A0 FD | 	call	#popregs_
00c88                 | __system___waitus_ret
00c88     2D 00 64 FD | 	ret
00c8c                 | 
00c8c                 | __system___mount
00c8c     06 4C 05 F6 | 	mov	COUNT_, #6
00c90     A9 00 A0 FD | 	call	#pushregs_
00c94     07 19 02 F6 | 	mov	local01, arg01
00c98     08 1B 02 F6 | 	mov	local02, arg02
00c9c     01 1C 66 F6 | 	neg	local03, #1
00ca0     0C 0F C2 FA | 	rdbyte	arg01, local01
00ca4     2F 0E 0E F2 | 	cmp	arg01, #47 wz
00ca8     1C EE 05 51 |  if_ne	add	ptr___system__dat__, #28
00cac     F7 14 68 5C |  if_ne	wrlong	#10, ptr___system__dat__
00cb0     1C EE 85 51 |  if_ne	sub	ptr___system__dat__, #28
00cb4     01 F4 65 56 |  if_ne	neg	result1, #1
00cb8     24 01 90 5D |  if_ne	jmp	#LR__0024
00cbc     00 1E 06 F6 | 	mov	local04, #0
00cc0                 | LR__0016
00cc0     04 1E 56 F2 | 	cmps	local04, #4 wc
00cc4     A8 00 90 3D |  if_ae	jmp	#LR__0021
00cc8     0F 0F 02 F6 | 	mov	arg01, local04
00ccc     02 0E 66 F0 | 	shl	arg01, #2
00cd0     20 EE 05 F1 | 	add	ptr___system__dat__, #32
00cd4     F7 0E 02 F1 | 	add	arg01, ptr___system__dat__
00cd8     07 F5 09 FB | 	rdlong	result1, arg01 wz
00cdc     20 EE 85 F1 | 	sub	ptr___system__dat__, #32
00ce0     00 1C 56 A2 |  if_e	cmps	local03, #0 wc
00ce4     0F 1D 02 86 |  if_c_and_z	mov	local03, local04
00ce8     7C 00 90 8D |  if_c_and_z	jmp	#LR__0020
00cec     0F 0F 02 F6 | 	mov	arg01, local04
00cf0     02 0E 66 F0 | 	shl	arg01, #2
00cf4     20 EE 05 F1 | 	add	ptr___system__dat__, #32
00cf8     F7 0E 02 F1 | 	add	arg01, ptr___system__dat__
00cfc     07 0F 02 FB | 	rdlong	arg01, arg01
00d00     20 EE 85 F1 | 	sub	ptr___system__dat__, #32
00d04     00 20 06 F6 | 	mov	local05, #0
00d08     04 F3 9F FE | 	loc	pa,	#(@LR__0018-@LR__0017)
00d0c     8C 00 A0 FD | 	call	#FCACHE_LOAD_
00d10                 | LR__0017
00d10     07 F5 C9 FA | 	rdbyte	result1, arg01 wz
00d14     01 20 06 51 |  if_ne	add	local05, #1
00d18     01 0E 06 51 |  if_ne	add	arg01, #1
00d1c     F0 FF 9F 5D |  if_ne	jmp	#LR__0017
00d20                 | LR__0018
00d20     10 F5 01 F6 | 	mov	result1, local05
00d24     FA 0E 02 F6 | 	mov	arg01, result1
00d28     0C 0F 02 F1 | 	add	arg01, local01
00d2c     07 0F C2 FA | 	rdbyte	arg01, arg01
00d30     2F 0E 0E F2 | 	cmp	arg01, #47 wz
00d34     30 00 90 5D |  if_ne	jmp	#LR__0019
00d38     0F 13 02 F6 | 	mov	arg03, local04
00d3c     02 12 66 F0 | 	shl	arg03, #2
00d40     20 EE 05 F1 | 	add	ptr___system__dat__, #32
00d44     F7 12 02 F1 | 	add	arg03, ptr___system__dat__
00d48     09 11 02 FB | 	rdlong	arg02, arg03
00d4c     FA 12 02 F6 | 	mov	arg03, result1
00d50     0C 0F 02 F6 | 	mov	arg01, local01
00d54     20 EE 85 F1 | 	sub	ptr___system__dat__, #32
00d58     2C 21 B0 FD | 	call	#__system__strncmp
00d5c     00 F4 0D F2 | 	cmp	result1, #0 wz
00d60     0F 1D 02 A6 |  if_e	mov	local03, local04
00d64     08 00 90 AD |  if_e	jmp	#LR__0021
00d68                 | LR__0019
00d68                 | LR__0020
00d68     01 1E 06 F1 | 	add	local04, #1
00d6c     50 FF 9F FD | 	jmp	#LR__0016
00d70                 | LR__0021
00d70     FF FF 7F FF 
00d74     FF 1D 0E F2 | 	cmp	local03, ##-1 wz
00d78     1C EE 05 A1 |  if_e	add	ptr___system__dat__, #28
00d7c     F7 16 68 AC |  if_e	wrlong	#11, ptr___system__dat__
00d80     1C EE 85 A1 |  if_e	sub	ptr___system__dat__, #28
00d84     01 F4 65 A6 |  if_e	neg	result1, #1
00d88     54 00 90 AD |  if_e	jmp	#LR__0024
00d8c     0E 1F 02 F6 | 	mov	local04, local03
00d90     0F 23 02 F6 | 	mov	local06, local04
00d94     02 22 66 F0 | 	shl	local06, #2
00d98     30 EE 05 F1 | 	add	ptr___system__dat__, #48
00d9c     F7 22 02 F1 | 	add	local06, ptr___system__dat__
00da0     11 1B 62 FC | 	wrlong	local02, local06
00da4     00 1A 0E F2 | 	cmp	local02, #0 wz
00da8     30 EE 85 F1 | 	sub	ptr___system__dat__, #48
00dac     18 00 90 5D |  if_ne	jmp	#LR__0022
00db0     02 1E 66 F0 | 	shl	local04, #2
00db4     20 EE 05 F1 | 	add	ptr___system__dat__, #32
00db8     F7 1E 02 F1 | 	add	local04, ptr___system__dat__
00dbc     0F 01 68 FC | 	wrlong	#0, local04
00dc0     20 EE 85 F1 | 	sub	ptr___system__dat__, #32
00dc4     14 00 90 FD | 	jmp	#LR__0023
00dc8                 | LR__0022
00dc8     02 1E 66 F0 | 	shl	local04, #2
00dcc     20 EE 05 F1 | 	add	ptr___system__dat__, #32
00dd0     F7 1E 02 F1 | 	add	local04, ptr___system__dat__
00dd4     0F 19 62 FC | 	wrlong	local01, local04
00dd8     20 EE 85 F1 | 	sub	ptr___system__dat__, #32
00ddc                 | LR__0023
00ddc     00 F4 05 F6 | 	mov	result1, #0
00de0                 | LR__0024
00de0     A8 F0 03 F6 | 	mov	ptra, fp
00de4     B3 00 A0 FD | 	call	#popregs_
00de8                 | __system___mount_ret
00de8     2D 00 64 FD | 	ret
00dec                 | 
00dec                 | __system____getvfsforfile
00dec     0F 4C 05 F6 | 	mov	COUNT_, #15
00df0     A9 00 A0 FD | 	call	#pushregs_
00df4     07 19 02 F6 | 	mov	local01, arg01
00df8     08 1B 02 F6 | 	mov	local02, arg02
00dfc     09 1D 02 F6 | 	mov	local03, arg03
00e00     0D 13 C2 FA | 	rdbyte	arg03, local02
00e04     2F 12 0E F2 | 	cmp	arg03, #47 wz
00e08     14 00 90 5D |  if_ne	jmp	#LR__0025
00e0c     0C 0F 02 F6 | 	mov	arg01, local01
00e10     0D 11 02 F6 | 	mov	arg02, local02
00e14     00 13 06 F6 | 	mov	arg03, #256
00e18     94 1F B0 FD | 	call	#__system__strncpy
00e1c     68 00 90 FD | 	jmp	#LR__0028
00e20                 | LR__0025
00e20     40 EE 05 F1 | 	add	ptr___system__dat__, #64
00e24     F7 10 02 F6 | 	mov	arg02, ptr___system__dat__
00e28     40 EE 85 F1 | 	sub	ptr___system__dat__, #64
00e2c     0C 0F 02 F6 | 	mov	arg01, local01
00e30     00 13 06 F6 | 	mov	arg03, #256
00e34     78 1F B0 FD | 	call	#__system__strncpy
00e38     0D 1F CA FA | 	rdbyte	local04, local02 wz
00e3c     48 00 90 AD |  if_e	jmp	#LR__0027
00e40     0D 21 C2 FA | 	rdbyte	local05, local02
00e44     2E 20 0E F2 | 	cmp	local05, #46 wz
00e48     18 00 90 5D |  if_ne	jmp	#LR__0026
00e4c     01 1A 06 F1 | 	add	local02, #1
00e50     0D 23 C2 FA | 	rdbyte	local06, local02
00e54     01 1A 86 F1 | 	sub	local02, #1
00e58     11 25 02 F6 | 	mov	local07, local06
00e5c     07 24 4E F7 | 	zerox	local07, #7 wz
00e60     24 00 90 AD |  if_e	jmp	#LR__0027
00e64                 | LR__0026
00e64     5D 00 00 FF 
00e68     94 10 06 F6 | 	mov	arg02, ##@LR__0732
00e6c     0C 0F 02 F6 | 	mov	arg01, local01
00e70     00 13 06 F6 | 	mov	arg03, #256
00e74     88 1F B0 FD | 	call	#__system__strncat
00e78     0C 0F 02 F6 | 	mov	arg01, local01
00e7c     0D 11 02 F6 | 	mov	arg02, local02
00e80     00 13 06 F6 | 	mov	arg03, #256
00e84     78 1F B0 FD | 	call	#__system__strncat
00e88                 | LR__0027
00e88                 | LR__0028
00e88     00 26 06 F6 | 	mov	local08, #0
00e8c                 | LR__0029
00e8c     04 26 56 F2 | 	cmps	local08, #4 wc
00e90     40 01 90 3D |  if_ae	jmp	#LR__0037
00e94     13 1F 02 F6 | 	mov	local04, local08
00e98     02 1E 66 F0 | 	shl	local04, #2
00e9c     20 EE 05 F1 | 	add	ptr___system__dat__, #32
00ea0     F7 1E 02 F1 | 	add	local04, ptr___system__dat__
00ea4     0F 25 0A FB | 	rdlong	local07, local04 wz
00ea8     20 EE 85 F1 | 	sub	ptr___system__dat__, #32
00eac     1C 01 90 AD |  if_e	jmp	#LR__0036
00eb0     13 21 02 F6 | 	mov	local05, local08
00eb4     02 20 66 F0 | 	shl	local05, #2
00eb8     20 EE 05 F1 | 	add	ptr___system__dat__, #32
00ebc     F7 20 02 F1 | 	add	local05, ptr___system__dat__
00ec0     10 0F 02 FB | 	rdlong	arg01, local05
00ec4     20 EE 85 F1 | 	sub	ptr___system__dat__, #32
00ec8     00 28 06 F6 | 	mov	local09, #0
00ecc     40 F1 9F FE | 	loc	pa,	#(@LR__0031-@LR__0030)
00ed0     8C 00 A0 FD | 	call	#FCACHE_LOAD_
00ed4                 | LR__0030
00ed4     07 F5 C9 FA | 	rdbyte	result1, arg01 wz
00ed8     01 28 06 51 |  if_ne	add	local09, #1
00edc     01 0E 06 51 |  if_ne	add	arg01, #1
00ee0     F0 FF 9F 5D |  if_ne	jmp	#LR__0030
00ee4                 | LR__0031
00ee4     14 2B 02 F6 | 	mov	local10, local09
00ee8     15 21 02 F6 | 	mov	local05, local10
00eec     0C 21 02 F1 | 	add	local05, local01
00ef0     10 1F C2 FA | 	rdbyte	local04, local05
00ef4     2F 1E 0E F2 | 	cmp	local04, #47 wz
00ef8     15 2D 02 56 |  if_ne	mov	local11, local10
00efc     0C 2F 02 56 |  if_ne	mov	local12, local01
00f00     17 2D 02 51 |  if_ne	add	local11, local12
00f04     16 23 CA 5A |  if_ne	rdbyte	local06, local11 wz
00f08     C0 00 90 5D |  if_ne	jmp	#LR__0035
00f0c     13 1F 02 F6 | 	mov	local04, local08
00f10     02 1E 66 F0 | 	shl	local04, #2
00f14     20 EE 05 F1 | 	add	ptr___system__dat__, #32
00f18     F7 1E 02 F1 | 	add	local04, ptr___system__dat__
00f1c     0F 11 02 FB | 	rdlong	arg02, local04
00f20     15 13 02 F6 | 	mov	arg03, local10
00f24     0C 0F 02 F6 | 	mov	arg01, local01
00f28     20 EE 85 F1 | 	sub	ptr___system__dat__, #32
00f2c     58 1F B0 FD | 	call	#__system__strncmp
00f30     FA 1E 0A F6 | 	mov	local04, result1 wz
00f34     94 00 90 5D |  if_ne	jmp	#LR__0035
00f38     13 1F 02 F6 | 	mov	local04, local08
00f3c     02 1E 66 F0 | 	shl	local04, #2
00f40     30 EE 05 F1 | 	add	ptr___system__dat__, #48
00f44     F7 1E 02 F1 | 	add	local04, ptr___system__dat__
00f48     0F 31 02 FB | 	rdlong	local13, local04
00f4c     30 EE 85 F1 | 	sub	ptr___system__dat__, #48
00f50     F0 F0 9F FE | 	loc	pa,	#(@LR__0033-@LR__0032)
00f54     8C 00 A0 FD | 	call	#FCACHE_LOAD_
00f58                 | LR__0032
00f58     15 25 02 F6 | 	mov	local07, local10
00f5c     01 24 06 F1 | 	add	local07, #1
00f60     0C 25 02 F1 | 	add	local07, local01
00f64     12 1F C2 FA | 	rdbyte	local04, local07
00f68     2E 1E 0E F2 | 	cmp	local04, #46 wz
00f6c     2C 00 90 5D |  if_ne	jmp	#LR__0034
00f70     15 2F 02 F6 | 	mov	local12, local10
00f74     02 2E 06 F1 | 	add	local12, #2
00f78     0C 2F 02 F1 | 	add	local12, local01
00f7c     17 2D C2 FA | 	rdbyte	local11, local12
00f80     2F 2C 0E F2 | 	cmp	local11, #47 wz
00f84     15 33 02 56 |  if_ne	mov	local14, local10
00f88     02 32 06 51 |  if_ne	add	local14, #2
00f8c     0C 33 02 51 |  if_ne	add	local14, local01
00f90     19 35 CA 5A |  if_ne	rdbyte	local15, local14 wz
00f94     01 2A 06 A1 |  if_e	add	local10, #1
00f98     BC FF 9F AD |  if_e	jmp	#LR__0032
00f9c                 | LR__0033
00f9c                 | LR__0034
00f9c     00 1C 0E F2 | 	cmp	local03, #0 wz
00fa0     0E 0F 02 56 |  if_ne	mov	arg01, local03
00fa4     0C 11 02 56 |  if_ne	mov	arg02, local01
00fa8     00 13 06 56 |  if_ne	mov	arg03, #256
00fac     00 1E B0 5D |  if_ne	call	#__system__strncpy
00fb0     0C 0F 02 F6 | 	mov	arg01, local01
00fb4     0C 11 02 F6 | 	mov	arg02, local01
00fb8     15 11 02 F1 | 	add	arg02, local10
00fbc     01 10 06 F1 | 	add	arg02, #1
00fc0     F4 FA BF FD | 	call	#__system____builtin_strcpy
00fc4     18 F5 01 F6 | 	mov	result1, local13
00fc8     1C 00 90 FD | 	jmp	#LR__0038
00fcc                 | LR__0035
00fcc                 | LR__0036
00fcc     01 26 06 F1 | 	add	local08, #1
00fd0     B8 FE 9F FD | 	jmp	#LR__0029
00fd4                 | LR__0037
00fd4     01 00 00 FF 
00fd8     44 EE 05 F1 | 	add	ptr___system__dat__, ##580
00fdc     F7 F4 01 FB | 	rdlong	result1, ptr___system__dat__
00fe0     01 00 00 FF 
00fe4     44 EE 85 F1 | 	sub	ptr___system__dat__, ##580
00fe8                 | LR__0038
00fe8     A8 F0 03 F6 | 	mov	ptra, fp
00fec     B3 00 A0 FD | 	call	#popregs_
00ff0                 | __system____getvfsforfile_ret
00ff0     2D 00 64 FD | 	ret
00ff4                 | 
00ff4                 | __system___basic_open_string
00ff4     04 4C 05 F6 | 	mov	COUNT_, #4
00ff8     A9 00 A0 FD | 	call	#pushregs_
00ffc     08 19 02 F6 | 	mov	local01, arg02
01000     09 1B 02 F6 | 	mov	local02, arg03
01004     74 1D B0 FD | 	call	#__system____getftab
01008     FA 1C 0A F6 | 	mov	local03, result1 wz
0100c     18 00 90 5D |  if_ne	jmp	#LR__0039
01010     EE 0E 02 F6 | 	mov	arg01, abortchain
01014     0C 10 06 F6 | 	mov	arg02, #12
01018     01 12 06 F6 | 	mov	arg03, #1
0101c     DB 00 A0 FD | 	call	#__longjmp
01020     01 F4 65 F6 | 	neg	result1, #1
01024     58 00 90 FD | 	jmp	#LR__0041
01028                 | LR__0039
01028     08 1C 06 F1 | 	add	local03, #8
0102c     0E F5 09 FB | 	rdlong	result1, local03 wz
01030     08 1C 86 F1 | 	sub	local03, #8
01034     0E 0F 02 56 |  if_ne	mov	arg01, local03
01038     AC 13 B0 5D |  if_ne	call	#__system___closeraw
0103c     0C 11 02 F6 | 	mov	arg02, local01
01040     0D 13 02 F6 | 	mov	arg03, local02
01044     0E 0F 02 F6 | 	mov	arg01, local03
01048     B6 15 06 F6 | 	mov	arg04, #438
0104c     80 0E B0 FD | 	call	#__system___openraw
01050     FA 1E 02 F6 | 	mov	local04, result1
01054     00 1E 56 F2 | 	cmps	local04, #0 wc
01058     20 00 90 3D |  if_ae	jmp	#LR__0040
0105c     1C EE 05 F1 | 	add	ptr___system__dat__, #28
01060     F7 10 02 FB | 	rdlong	arg02, ptr___system__dat__
01064     1C EE 85 F1 | 	sub	ptr___system__dat__, #28
01068     EE 0E 02 F6 | 	mov	arg01, abortchain
0106c     01 12 06 F6 | 	mov	arg03, #1
01070     DB 00 A0 FD | 	call	#__longjmp
01074     01 F4 65 F6 | 	neg	result1, #1
01078     04 00 90 FD | 	jmp	#LR__0041
0107c                 | LR__0040
0107c     0F F5 01 F6 | 	mov	result1, local04
01080                 | LR__0041
01080     A8 F0 03 F6 | 	mov	ptra, fp
01084     B3 00 A0 FD | 	call	#popregs_
01088                 | __system___basic_open_string_ret
01088     2D 00 64 FD | 	ret
0108c                 | 
0108c                 | __system___basic_print_char
0108c     03 4C 05 F6 | 	mov	COUNT_, #3
01090     A9 00 A0 FD | 	call	#pushregs_
01094     08 19 02 F6 | 	mov	local01, arg02
01098     20 20 B0 FD | 	call	#__system___gettxfunc
0109c     FA 0E 0A F6 | 	mov	arg01, result1 wz
010a0     00 F4 05 A6 |  if_e	mov	result1, #0
010a4     24 00 90 AD |  if_e	jmp	#LR__0042
010a8     07 1B 02 FB | 	rdlong	local02, arg01
010ac     04 0E 06 F1 | 	add	arg01, #4
010b0     07 1D 02 FB | 	rdlong	local03, arg01
010b4     0C 0F 02 F6 | 	mov	arg01, local01
010b8     F1 18 02 F6 | 	mov	local01, objptr
010bc     0D E3 01 F6 | 	mov	objptr, local02
010c0     2D 1C 62 FD | 	call	local03
010c4     0C E3 01 F6 | 	mov	objptr, local01
010c8     01 F4 05 F6 | 	mov	result1, #1
010cc                 | LR__0042
010cc     A8 F0 03 F6 | 	mov	ptra, fp
010d0     B3 00 A0 FD | 	call	#popregs_
010d4                 | __system___basic_print_char_ret
010d4     2D 00 64 FD | 	ret
010d8                 | 
010d8                 | __system___basic_print_unsigned
010d8     03 4C 05 F6 | 	mov	COUNT_, #3
010dc     A9 00 A0 FD | 	call	#pushregs_
010e0     08 19 02 F6 | 	mov	local01, arg02
010e4     09 1B 02 F6 | 	mov	local02, arg03
010e8     0A 1D 02 F6 | 	mov	local03, arg04
010ec     CC 1F B0 FD | 	call	#__system___gettxfunc
010f0     FA 0E 0A F6 | 	mov	arg01, result1 wz
010f4     3A 1A 26 54 |  if_ne	bith	local02, #58
010f8     0D 11 02 56 |  if_ne	mov	arg02, local02
010fc     0C 13 02 56 |  if_ne	mov	arg03, local01
01100     0E 15 02 56 |  if_ne	mov	arg04, local03
01104     C4 01 B0 5D |  if_ne	call	#__system___fmtnum
01108     A8 F0 03 F6 | 	mov	ptra, fp
0110c     B3 00 A0 FD | 	call	#popregs_
01110                 | __system___basic_print_unsigned_ret
01110     2D 00 64 FD | 	ret
01114                 | 
01114                 | __system___basic_get
01114     04 4C 05 F6 | 	mov	COUNT_, #4
01118     A9 00 A0 FD | 	call	#pushregs_
0111c     0B 19 02 F6 | 	mov	local01, arg05
01120     0C 15 02 FD | 	qmul	arg04, local01
01124     07 1B 02 F6 | 	mov	local02, arg01
01128     09 1D 02 F6 | 	mov	local03, arg03
0112c     00 10 0E F2 | 	cmp	arg02, #0 wz
01130     01 10 86 51 |  if_ne	sub	arg02, #1
01134     0D 0F 02 56 |  if_ne	mov	arg01, local02
01138     00 12 06 56 |  if_ne	mov	arg03, #0
0113c     18 1E 62 FD | 	getqx	local04
01140     AC 19 B0 5D |  if_ne	call	#__system__lseek
01144     0D 0F 02 F6 | 	mov	arg01, local02
01148     0E 11 02 F6 | 	mov	arg02, local03
0114c     0F 13 02 F6 | 	mov	arg03, local04
01150     EC 18 B0 FD | 	call	#__system__read
01154     FA 1E 02 F6 | 	mov	local04, result1
01158     01 1E 56 F2 | 	cmps	local04, #1 wc
0115c     10 00 90 CD |  if_b	jmp	#LR__0043
01160     0F 6D 02 F6 | 	mov	muldiva_, local04
01164     0C 6F 02 F6 | 	mov	muldivb_, local01
01168     BB 00 A0 FD | 	call	#divide_
0116c     37 1F 02 F6 | 	mov	local04, muldivb_
01170                 | LR__0043
01170     0F F5 01 F6 | 	mov	result1, local04
01174     A8 F0 03 F6 | 	mov	ptra, fp
01178     B3 00 A0 FD | 	call	#popregs_
0117c                 | __system___basic_get_ret
0117c     2D 00 64 FD | 	ret
01180                 | 
01180                 | __system___fmtchar
01180     00 4C 05 F6 | 	mov	COUNT_, #0
01184     A9 00 A0 FD | 	call	#pushregs_
01188     14 F0 07 F1 | 	add	ptra, #20
0118c     04 50 05 F1 | 	add	fp, #4
01190     A8 0E 62 FC | 	wrlong	arg01, fp
01194     04 50 05 F1 | 	add	fp, #4
01198     A8 10 62 FC | 	wrlong	arg02, fp
0119c     04 50 05 F1 | 	add	fp, #4
011a0     A8 12 62 FC | 	wrlong	arg03, fp
011a4     04 50 05 F1 | 	add	fp, #4
011a8     A8 12 42 FC | 	wrbyte	arg03, fp
011ac     01 50 05 F1 | 	add	fp, #1
011b0     A8 00 48 FC | 	wrbyte	#0, fp
011b4     0D 50 85 F1 | 	sub	fp, #13
011b8     A8 0E 02 FB | 	rdlong	arg01, fp
011bc     04 50 05 F1 | 	add	fp, #4
011c0     A8 10 02 FB | 	rdlong	arg02, fp
011c4     08 50 05 F1 | 	add	fp, #8
011c8     A8 12 02 F6 | 	mov	arg03, fp
011cc     10 50 85 F1 | 	sub	fp, #16
011d0     0C 00 B0 FD | 	call	#__system___fmtstr
011d4     A8 F0 03 F6 | 	mov	ptra, fp
011d8     B3 00 A0 FD | 	call	#popregs_
011dc                 | __system___fmtchar_ret
011dc     2D 00 64 FD | 	ret
011e0                 | 
011e0                 | __system___fmtstr
011e0     0A 4C 05 F6 | 	mov	COUNT_, #10
011e4     A9 00 A0 FD | 	call	#pushregs_
011e8     07 19 02 F6 | 	mov	local01, arg01
011ec     08 1B 02 F6 | 	mov	local02, arg02
011f0     09 1D 02 F6 | 	mov	local03, arg03
011f4     0D 1F E2 F8 | 	getbyte	local04, local02, #0
011f8     0E 0F 02 F6 | 	mov	arg01, local03
011fc     00 20 06 F6 | 	mov	local05, #0
01200     0C EE 9F FE | 	loc	pa,	#(@LR__0045-@LR__0044)
01204     8C 00 A0 FD | 	call	#FCACHE_LOAD_
01208                 | LR__0044
01208     07 F5 C9 FA | 	rdbyte	result1, arg01 wz
0120c     01 20 06 51 |  if_ne	add	local05, #1
01210     01 0E 06 51 |  if_ne	add	arg01, #1
01214     F0 FF 9F 5D |  if_ne	jmp	#LR__0044
01218                 | LR__0045
01218     10 23 02 F6 | 	mov	local06, local05
0121c     00 1E 0E F2 | 	cmp	local04, #0 wz
01220     0F 23 7A 53 |  if_ne	fles	local06, local04 wcz
01224     0D 11 02 F6 | 	mov	arg02, local02
01228     11 13 02 F6 | 	mov	arg03, local06
0122c     0C 0F 02 F6 | 	mov	arg01, local01
01230     02 14 06 F6 | 	mov	arg04, #2
01234     44 1D B0 FD | 	call	#__system___fmtpad
01238     FA 24 02 F6 | 	mov	local07, result1
0123c     00 24 56 F2 | 	cmps	local07, #0 wc
01240     12 F5 01 C6 |  if_b	mov	result1, local07
01244     78 00 90 CD |  if_b	jmp	#LR__0048
01248     00 26 06 F6 | 	mov	local08, #0
0124c                 | LR__0046
0124c     11 27 52 F2 | 	cmps	local08, local06 wc
01250     44 00 90 3D |  if_ae	jmp	#LR__0047
01254     0C 1F 02 F6 | 	mov	local04, local01
01258     0F 21 02 FB | 	rdlong	local05, local04
0125c     04 1E 06 F1 | 	add	local04, #4
01260     0F 1F 02 FB | 	rdlong	local04, local04
01264     0E 0F C2 FA | 	rdbyte	arg01, local03
01268     F1 28 02 F6 | 	mov	local09, objptr
0126c     10 E3 01 F6 | 	mov	objptr, local05
01270     01 1C 06 F1 | 	add	local03, #1
01274     2D 1E 62 FD | 	call	local04
01278     14 E3 01 F6 | 	mov	objptr, local09
0127c     FA 28 02 F6 | 	mov	local09, result1
01280     00 28 56 F2 | 	cmps	local09, #0 wc
01284     14 F5 01 C6 |  if_b	mov	result1, local09
01288     34 00 90 CD |  if_b	jmp	#LR__0048
0128c     14 25 02 F1 | 	add	local07, local09
01290     01 26 06 F1 | 	add	local08, #1
01294     B4 FF 9F FD | 	jmp	#LR__0046
01298                 | LR__0047
01298     0D 11 02 F6 | 	mov	arg02, local02
0129c     11 13 02 F6 | 	mov	arg03, local06
012a0     0C 0F 02 F6 | 	mov	arg01, local01
012a4     01 14 06 F6 | 	mov	arg04, #1
012a8     D0 1C B0 FD | 	call	#__system___fmtpad
012ac     FA 2A 02 F6 | 	mov	local10, result1
012b0     00 2A 56 F2 | 	cmps	local10, #0 wc
012b4     15 F5 01 C6 |  if_b	mov	result1, local10
012b8     15 25 02 31 |  if_ae	add	local07, local10
012bc     12 F5 01 36 |  if_ae	mov	result1, local07
012c0                 | LR__0048
012c0     A8 F0 03 F6 | 	mov	ptra, fp
012c4     B3 00 A0 FD | 	call	#popregs_
012c8                 | __system___fmtstr_ret
012c8     2D 00 64 FD | 	ret
012cc                 | 
012cc                 | __system___fmtnum
012cc     03 4C 05 F6 | 	mov	COUNT_, #3
012d0     A9 00 A0 FD | 	call	#pushregs_
012d4     70 F0 07 F1 | 	add	ptra, #112
012d8     04 50 05 F1 | 	add	fp, #4
012dc     A8 0E 62 FC | 	wrlong	arg01, fp
012e0     04 50 05 F1 | 	add	fp, #4
012e4     A8 10 62 FC | 	wrlong	arg02, fp
012e8     04 50 05 F1 | 	add	fp, #4
012ec     A8 12 62 FC | 	wrlong	arg03, fp
012f0     04 50 05 F1 | 	add	fp, #4
012f4     A8 14 62 FC | 	wrlong	arg04, fp
012f8     04 50 05 F1 | 	add	fp, #4
012fc     A8 F4 01 F6 | 	mov	result1, fp
01300     44 50 05 F1 | 	add	fp, #68
01304     A8 F4 61 FC | 	wrlong	result1, fp
01308     04 50 05 F1 | 	add	fp, #4
0130c     A8 00 68 FC | 	wrlong	#0, fp
01310     54 50 85 F1 | 	sub	fp, #84
01314     A8 F4 01 FB | 	rdlong	result1, fp
01318     10 F4 45 F0 | 	shr	result1, #16
0131c     3F F4 05 F5 | 	and	result1, #63
01320     58 50 05 F1 | 	add	fp, #88
01324     A8 F4 61 FC | 	wrlong	result1, fp
01328     58 50 85 F1 | 	sub	fp, #88
0132c     A8 F4 01 FB | 	rdlong	result1, fp
01330     FA F4 E1 F8 | 	getbyte	result1, result1, #0
01334     5C 50 05 F1 | 	add	fp, #92
01338     A8 F4 61 FC | 	wrlong	result1, fp
0133c     5C 50 85 F1 | 	sub	fp, #92
01340     A8 F4 01 FB | 	rdlong	result1, fp
01344     1A F4 45 F0 | 	shr	result1, #26
01348     03 F4 05 F5 | 	and	result1, #3
0134c     60 50 05 F1 | 	add	fp, #96
01350     A8 F4 61 FC | 	wrlong	result1, fp
01354     08 50 85 F1 | 	sub	fp, #8
01358     A8 18 02 FB | 	rdlong	local01, fp
0135c     60 50 85 F1 | 	sub	fp, #96
01360     01 18 56 F2 | 	cmps	local01, #1 wc
01364     60 50 05 31 |  if_ae	add	fp, #96
01368     A8 18 02 3B |  if_ae	rdlong	local01, fp
0136c     01 18 86 31 |  if_ae	sub	local01, #1
01370     A8 18 62 3C |  if_ae	wrlong	local01, fp
01374     60 50 85 31 |  if_ae	sub	fp, #96
01378     64 50 05 F1 | 	add	fp, #100
0137c     A8 18 02 FB | 	rdlong	local01, fp
01380     64 50 85 F1 | 	sub	fp, #100
01384     41 18 56 F2 | 	cmps	local01, #65 wc
01388     64 50 05 C1 |  if_b	add	fp, #100
0138c     A8 18 02 CB |  if_b	rdlong	local01, fp
01390     64 50 85 C1 |  if_b	sub	fp, #100
01394     0C 19 0A C6 |  if_b	mov	local01, local01 wz
01398     64 50 05 B1 |  if_nc_or_z	add	fp, #100
0139c     A8 80 68 BC |  if_nc_or_z	wrlong	#64, fp
013a0     64 50 85 B1 |  if_nc_or_z	sub	fp, #100
013a4     68 50 05 F1 | 	add	fp, #104
013a8     A8 18 02 FB | 	rdlong	local01, fp
013ac     68 50 85 F1 | 	sub	fp, #104
013b0     03 18 0E F2 | 	cmp	local01, #3 wz
013b4     68 50 05 A1 |  if_e	add	fp, #104
013b8     A8 00 68 AC |  if_e	wrlong	#0, fp
013bc     68 50 85 A1 |  if_e	sub	fp, #104
013c0     30 00 90 AD |  if_e	jmp	#LR__0050
013c4     0C 50 05 F1 | 	add	fp, #12
013c8     A8 18 02 FB | 	rdlong	local01, fp
013cc     0C 50 85 F1 | 	sub	fp, #12
013d0     00 18 56 F2 | 	cmps	local01, #0 wc
013d4     1C 00 90 3D |  if_ae	jmp	#LR__0049
013d8     68 50 05 F1 | 	add	fp, #104
013dc     A8 08 68 FC | 	wrlong	#4, fp
013e0     5C 50 85 F1 | 	sub	fp, #92
013e4     A8 18 02 FB | 	rdlong	local01, fp
013e8     0C 19 62 F6 | 	neg	local01, local01
013ec     A8 18 62 FC | 	wrlong	local01, fp
013f0     0C 50 85 F1 | 	sub	fp, #12
013f4                 | LR__0049
013f4                 | LR__0050
013f4     68 50 05 F1 | 	add	fp, #104
013f8     A8 18 0A FB | 	rdlong	local01, fp wz
013fc     68 50 85 F1 | 	sub	fp, #104
01400     E8 00 90 AD |  if_e	jmp	#LR__0057
01404     5C 50 05 F1 | 	add	fp, #92
01408     A8 18 02 FB | 	rdlong	local01, fp
0140c     01 18 06 F1 | 	add	local01, #1
01410     A8 18 62 FC | 	wrlong	local01, fp
01414     04 50 05 F1 | 	add	fp, #4
01418     A8 18 02 FB | 	rdlong	local01, fp
0141c     04 50 05 F1 | 	add	fp, #4
01420     A8 12 02 FB | 	rdlong	arg03, fp
01424     64 50 85 F1 | 	sub	fp, #100
01428     09 19 0A F2 | 	cmp	local01, arg03 wz
0142c     38 00 90 5D |  if_ne	jmp	#LR__0052
01430     60 50 05 F1 | 	add	fp, #96
01434     A8 18 02 FB | 	rdlong	local01, fp
01438     01 18 8E F1 | 	sub	local01, #1 wz
0143c     A8 18 62 FC | 	wrlong	local01, fp
01440     60 50 85 F1 | 	sub	fp, #96
01444     20 00 90 5D |  if_ne	jmp	#LR__0051
01448     04 50 05 F1 | 	add	fp, #4
0144c     A8 0E 02 FB | 	rdlong	arg01, fp
01450     04 50 05 F1 | 	add	fp, #4
01454     A8 10 02 FB | 	rdlong	arg02, fp
01458     08 50 85 F1 | 	sub	fp, #8
0145c     23 12 06 F6 | 	mov	arg03, #35
01460     1C FD BF FD | 	call	#__system___fmtchar
01464     6C 01 90 FD | 	jmp	#LR__0062
01468                 | LR__0051
01468                 | LR__0052
01468     68 50 05 F1 | 	add	fp, #104
0146c     A8 18 02 FB | 	rdlong	local01, fp
01470     68 50 85 F1 | 	sub	fp, #104
01474     02 18 0E F2 | 	cmp	local01, #2 wz
01478     20 00 90 5D |  if_ne	jmp	#LR__0053
0147c     58 50 05 F1 | 	add	fp, #88
01480     A8 18 02 FB | 	rdlong	local01, fp
01484     0C F5 01 F6 | 	mov	result1, local01
01488     01 F4 05 F1 | 	add	result1, #1
0148c     A8 F4 61 FC | 	wrlong	result1, fp
01490     58 50 85 F1 | 	sub	fp, #88
01494     0C 41 48 FC | 	wrbyte	#32, local01
01498     50 00 90 FD | 	jmp	#LR__0056
0149c                 | LR__0053
0149c     68 50 05 F1 | 	add	fp, #104
014a0     A8 18 02 FB | 	rdlong	local01, fp
014a4     68 50 85 F1 | 	sub	fp, #104
014a8     04 18 0E F2 | 	cmp	local01, #4 wz
014ac     20 00 90 5D |  if_ne	jmp	#LR__0054
014b0     58 50 05 F1 | 	add	fp, #88
014b4     A8 18 02 FB | 	rdlong	local01, fp
014b8     0C F5 01 F6 | 	mov	result1, local01
014bc     01 F4 05 F1 | 	add	result1, #1
014c0     A8 F4 61 FC | 	wrlong	result1, fp
014c4     58 50 85 F1 | 	sub	fp, #88
014c8     0C 5B 48 FC | 	wrbyte	#45, local01
014cc     1C 00 90 FD | 	jmp	#LR__0055
014d0                 | LR__0054
014d0     58 50 05 F1 | 	add	fp, #88
014d4     A8 18 02 FB | 	rdlong	local01, fp
014d8     0C F5 01 F6 | 	mov	result1, local01
014dc     01 F4 05 F1 | 	add	result1, #1
014e0     A8 F4 61 FC | 	wrlong	result1, fp
014e4     58 50 85 F1 | 	sub	fp, #88
014e8     0C 57 48 FC | 	wrbyte	#43, local01
014ec                 | LR__0055
014ec                 | LR__0056
014ec                 | LR__0057
014ec     58 50 05 F1 | 	add	fp, #88
014f0     A8 0E 02 FB | 	rdlong	arg01, fp
014f4     4C 50 85 F1 | 	sub	fp, #76
014f8     A8 10 02 FB | 	rdlong	arg02, fp
014fc     04 50 05 F1 | 	add	fp, #4
01500     A8 12 02 FB | 	rdlong	arg03, fp
01504     50 50 05 F1 | 	add	fp, #80
01508     A8 14 02 FB | 	rdlong	arg04, fp
0150c     00 16 06 F6 | 	mov	arg05, #0
01510     58 50 85 F1 | 	sub	fp, #88
01514     A8 18 02 FB | 	rdlong	local01, fp
01518     08 50 85 F1 | 	sub	fp, #8
0151c     1D 18 2E F4 | 	testbn	local01, #29 wz
01520     01 16 06 56 |  if_ne	mov	arg05, #1
01524     14 1B B0 FD | 	call	#__system___uitoa
01528     FA 1A 02 F6 | 	mov	local02, result1
0152c     5C 50 05 F1 | 	add	fp, #92
01530     A8 18 02 FB | 	rdlong	local01, fp
01534     0D 19 02 F1 | 	add	local01, local02
01538     A8 18 62 FC | 	wrlong	local01, fp
0153c     08 50 05 F1 | 	add	fp, #8
01540     A8 1C 02 FB | 	rdlong	local03, fp
01544     64 50 85 F1 | 	sub	fp, #100
01548     0E 19 5A F2 | 	cmps	local01, local03 wcz
0154c     64 00 90 ED |  if_be	jmp	#LR__0061
01550     EC EA 9F FE | 	loc	pa,	#(@LR__0059-@LR__0058)
01554     8C 00 A0 FD | 	call	#FCACHE_LOAD_
01558                 | LR__0058
01558     64 50 05 F1 | 	add	fp, #100
0155c     A8 1A 02 FB | 	rdlong	local02, fp
01560     0D 1D 02 F6 | 	mov	local03, local02
01564     01 1C 86 F1 | 	sub	local03, #1
01568     A8 1C 62 FC | 	wrlong	local03, fp
0156c     64 50 85 F1 | 	sub	fp, #100
01570     01 1A 56 F2 | 	cmps	local02, #1 wc
01574     20 00 90 CD |  if_b	jmp	#LR__0060
01578     58 50 05 F1 | 	add	fp, #88
0157c     A8 1A 02 FB | 	rdlong	local02, fp
01580     0D 1D 02 F6 | 	mov	local03, local02
01584     01 1C 06 F1 | 	add	local03, #1
01588     A8 1C 62 FC | 	wrlong	local03, fp
0158c     58 50 85 F1 | 	sub	fp, #88
01590     0D 47 48 FC | 	wrbyte	#35, local02
01594     C0 FF 9F FD | 	jmp	#LR__0058
01598                 | LR__0059
01598                 | LR__0060
01598     58 50 05 F1 | 	add	fp, #88
0159c     A8 1A 02 FB | 	rdlong	local02, fp
015a0     0D 1D 02 F6 | 	mov	local03, local02
015a4     01 1C 06 F1 | 	add	local03, #1
015a8     A8 1C 62 FC | 	wrlong	local03, fp
015ac     58 50 85 F1 | 	sub	fp, #88
015b0     0D 01 48 FC | 	wrbyte	#0, local02
015b4                 | LR__0061
015b4     04 50 05 F1 | 	add	fp, #4
015b8     A8 0E 02 FB | 	rdlong	arg01, fp
015bc     04 50 05 F1 | 	add	fp, #4
015c0     A8 10 02 FB | 	rdlong	arg02, fp
015c4     0C 50 05 F1 | 	add	fp, #12
015c8     A8 12 02 F6 | 	mov	arg03, fp
015cc     14 50 85 F1 | 	sub	fp, #20
015d0     0C FC BF FD | 	call	#__system___fmtstr
015d4                 | LR__0062
015d4     A8 F0 03 F6 | 	mov	ptra, fp
015d8     B3 00 A0 FD | 	call	#popregs_
015dc                 | __system___fmtnum_ret
015dc     2D 00 64 FD | 	ret
015e0                 | 
015e0                 | __system___gc_ptrs
015e0     02 4C 05 F6 | 	mov	COUNT_, #2
015e4     A9 00 A0 FD | 	call	#pushregs_
015e8     ED 18 02 F6 | 	mov	local01, __heap_ptr
015ec     0C 1B 02 F6 | 	mov	local02, local01
015f0     07 00 00 FF 
015f4     F8 1B 06 F1 | 	add	local02, ##4088
015f8     0C F7 09 FB | 	rdlong	result2, local01 wz
015fc     74 00 90 5D |  if_ne	jmp	#LR__0063
01600     0D F7 01 F6 | 	mov	result2, local02
01604     0C F7 81 F1 | 	sub	result2, local01
01608     0C 03 58 FC | 	wrword	#1, local01
0160c     0C F5 01 F6 | 	mov	result1, local01
01610     02 F4 05 F1 | 	add	result1, #2
01614     36 00 80 FF 
01618     FA 20 59 FC | 	wrword	##27792, result1
0161c     0C F5 01 F6 | 	mov	result1, local01
01620     04 F4 05 F1 | 	add	result1, #4
01624     FA 00 58 FC | 	wrword	#0, result1
01628     0C F5 01 F6 | 	mov	result1, local01
0162c     06 F4 05 F1 | 	add	result1, #6
01630     FA 02 58 FC | 	wrword	#1, result1
01634     10 18 06 F1 | 	add	local01, #16
01638     FB F6 51 F6 | 	abs	result2, result2 wc
0163c     04 F6 45 F0 | 	shr	result2, #4
01640     FB F6 81 F6 | 	negc	result2, result2
01644     0C F7 51 FC | 	wrword	result2, local01
01648     0C F7 01 F6 | 	mov	result2, local01
0164c     02 F6 05 F1 | 	add	result2, #2
01650     36 00 80 FF 
01654     FB 1E 59 FC | 	wrword	##27791, result2
01658     0C F7 01 F6 | 	mov	result2, local01
0165c     04 F6 05 F1 | 	add	result2, #4
01660     FB 00 58 FC | 	wrword	#0, result2
01664     0C F7 01 F6 | 	mov	result2, local01
01668     06 F6 05 F1 | 	add	result2, #6
0166c     FB 00 58 FC | 	wrword	#0, result2
01670     10 18 86 F1 | 	sub	local01, #16
01674                 | LR__0063
01674     0D F7 01 F6 | 	mov	result2, local02
01678     0C F5 01 F6 | 	mov	result1, local01
0167c     A8 F0 03 F6 | 	mov	ptra, fp
01680     B3 00 A0 FD | 	call	#popregs_
01684                 | __system___gc_ptrs_ret
01684     2D 00 64 FD | 	ret
01688                 | 
01688                 | __system___gc_nextBlockPtr
01688     02 4C 05 F6 | 	mov	COUNT_, #2
0168c     A9 00 A0 FD | 	call	#pushregs_
01690     07 19 02 F6 | 	mov	local01, arg01
01694     0C 1B EA FA | 	rdword	local02, local01 wz
01698     10 00 90 5D |  if_ne	jmp	#LR__0064
0169c     5D 00 00 FF 
016a0     96 0E 06 F6 | 	mov	arg01, ##@LR__0733
016a4     E8 01 B0 FD | 	call	#__system___gc_errmsg
016a8     0C 00 90 FD | 	jmp	#LR__0065
016ac                 | LR__0064
016ac     0C F5 01 F6 | 	mov	result1, local01
016b0     04 1A 66 F0 | 	shl	local02, #4
016b4     0D F5 01 F1 | 	add	result1, local02
016b8                 | LR__0065
016b8     A8 F0 03 F6 | 	mov	ptra, fp
016bc     B3 00 A0 FD | 	call	#popregs_
016c0                 | __system___gc_nextBlockPtr_ret
016c0     2D 00 64 FD | 	ret
016c4                 | 
016c4                 | __system___gc_tryalloc
016c4     0D 4C 05 F6 | 	mov	COUNT_, #13
016c8     A9 00 A0 FD | 	call	#pushregs_
016cc     07 19 02 F6 | 	mov	local01, arg01
016d0     08 1B 02 F6 | 	mov	local02, arg02
016d4     08 FF BF FD | 	call	#__system___gc_ptrs
016d8     FA 1C 02 F6 | 	mov	local03, result1
016dc     FB 1E 02 F6 | 	mov	local04, result2
016e0     0E 21 02 F6 | 	mov	local05, local03
016e4     00 22 06 F6 | 	mov	local06, #0
016e8     58 E9 9F FE | 	loc	pa,	#(@LR__0067-@LR__0066)
016ec     8C 00 A0 FD | 	call	#FCACHE_LOAD_
016f0                 | LR__0066
016f0     10 25 02 F6 | 	mov	local07, local05
016f4     06 20 06 F1 | 	add	local05, #6
016f8     10 11 EA FA | 	rdword	arg02, local05 wz
016fc     0E 0F 02 F6 | 	mov	arg01, local03
01700     00 F4 05 A6 |  if_e	mov	result1, #0
01704     04 10 66 50 |  if_ne	shl	arg02, #4
01708     08 0F 02 51 |  if_ne	add	arg01, arg02
0170c     07 F5 01 56 |  if_ne	mov	result1, arg01
01710     FA 26 02 F6 | 	mov	local08, result1
01714     13 21 0A F6 | 	mov	local05, local08 wz
01718     10 27 02 56 |  if_ne	mov	local08, local05
0171c     13 23 E2 5A |  if_ne	rdword	local06, local08
01720     00 20 0E F2 | 	cmp	local05, #0 wz
01724     0F 21 52 52 |  if_ne	cmps	local05, local04 wc
01728     08 00 90 1D |  if_a	jmp	#LR__0068
0172c     11 19 5A 52 |  if_ne	cmps	local01, local06 wcz
01730     BC FF 9F 1D |  if_a	jmp	#LR__0066
01734                 | LR__0067
01734                 | LR__0068
01734     00 20 0E F2 | 	cmp	local05, #0 wz
01738     10 F5 01 A6 |  if_e	mov	result1, local05
0173c     44 01 90 AD |  if_e	jmp	#LR__0071
01740     10 27 02 F6 | 	mov	local08, local05
01744     06 26 06 F1 | 	add	local08, #6
01748     13 29 E2 FA | 	rdword	local09, local08
0174c     11 19 52 F2 | 	cmps	local01, local06 wc
01750     C0 00 90 3D |  if_ae	jmp	#LR__0070
01754     10 19 52 FC | 	wrword	local01, local05
01758     10 0F 02 F6 | 	mov	arg01, local05
0175c     0C 29 02 F6 | 	mov	local09, local01
01760     04 28 66 F0 | 	shl	local09, #4
01764     14 0F 02 F1 | 	add	arg01, local09
01768     11 27 02 F6 | 	mov	local08, local06
0176c     0C 27 82 F1 | 	sub	local08, local01
01770     07 27 52 FC | 	wrword	local08, arg01
01774     07 27 02 F6 | 	mov	local08, arg01
01778     02 26 06 F1 | 	add	local08, #2
0177c     36 00 80 FF 
01780     13 1F 59 FC | 	wrword	##27791, local08
01784     10 11 0A F6 | 	mov	arg02, local05 wz
01788     00 F4 05 A6 |  if_e	mov	result1, #0
0178c     0E 11 82 51 |  if_ne	sub	arg02, local03
01790     04 10 46 50 |  if_ne	shr	arg02, #4
01794     08 F5 01 56 |  if_ne	mov	result1, arg02
01798     07 29 02 F6 | 	mov	local09, arg01
0179c     04 28 06 F1 | 	add	local09, #4
017a0     14 F5 51 FC | 	wrword	result1, local09
017a4     10 27 02 F6 | 	mov	local08, local05
017a8     06 26 06 F1 | 	add	local08, #6
017ac     07 29 02 F6 | 	mov	local09, arg01
017b0     13 2B E2 FA | 	rdword	local10, local08
017b4     06 28 06 F1 | 	add	local09, #6
017b8     14 2B 52 FC | 	wrword	local10, local09
017bc     07 2D 02 F6 | 	mov	local11, arg01
017c0     16 11 0A F6 | 	mov	arg02, local11 wz
017c4     00 F4 05 A6 |  if_e	mov	result1, #0
017c8     0E 11 82 51 |  if_ne	sub	arg02, local03
017cc     04 10 46 50 |  if_ne	shr	arg02, #4
017d0     08 F5 01 56 |  if_ne	mov	result1, arg02
017d4     FA 28 02 F6 | 	mov	local09, result1
017d8     AC FE BF FD | 	call	#__system___gc_nextBlockPtr
017dc     FA 2E 0A F6 | 	mov	local12, result1 wz
017e0     30 00 90 AD |  if_e	jmp	#LR__0069
017e4     0F 2F 52 F2 | 	cmps	local12, local04 wc
017e8     28 00 90 3D |  if_ae	jmp	#LR__0069
017ec     0E 0F 02 F6 | 	mov	arg01, local03
017f0     16 11 0A F6 | 	mov	arg02, local11 wz
017f4     00 F4 05 A6 |  if_e	mov	result1, #0
017f8     07 11 82 51 |  if_ne	sub	arg02, arg01
017fc     04 10 46 50 |  if_ne	shr	arg02, #4
01800     08 F5 01 56 |  if_ne	mov	result1, arg02
01804     FA 26 02 F6 | 	mov	local08, result1
01808     17 31 02 F6 | 	mov	local13, local12
0180c     04 30 06 F1 | 	add	local13, #4
01810     18 27 52 FC | 	wrword	local08, local13
01814                 | LR__0069
01814                 | LR__0070
01814     06 24 06 F1 | 	add	local07, #6
01818     12 29 52 FC | 	wrword	local09, local07
0181c     36 00 00 FF 
01820     80 26 06 F6 | 	mov	local08, ##27776
01824     0D 27 42 F5 | 	or	local08, local02
01828     00 F4 05 F6 | 	mov	result1, #0
0182c     01 F4 61 FD | 	cogid	result1
01830     FA 26 42 F5 | 	or	local08, result1
01834     10 2B 02 F6 | 	mov	local10, local05
01838     02 2A 06 F1 | 	add	local10, #2
0183c     15 27 52 FC | 	wrword	local08, local10
01840     0E 27 02 F6 | 	mov	local08, local03
01844     08 26 06 F1 | 	add	local08, #8
01848     10 31 02 F6 | 	mov	local13, local05
0184c     13 2B E2 FA | 	rdword	local10, local08
01850     06 30 06 F1 | 	add	local13, #6
01854     18 2B 52 FC | 	wrword	local10, local13
01858     10 11 0A F6 | 	mov	arg02, local05 wz
0185c     00 F4 05 A6 |  if_e	mov	result1, #0
01860     0E 11 82 51 |  if_ne	sub	arg02, local03
01864     04 10 46 50 |  if_ne	shr	arg02, #4
01868     08 F5 01 56 |  if_ne	mov	result1, arg02
0186c     08 1C 06 F1 | 	add	local03, #8
01870     0E F5 51 FC | 	wrword	result1, local03
01874     10 F5 01 F6 | 	mov	result1, local05
01878     08 F4 05 F1 | 	add	result1, #8
0187c     00 C0 31 FF 
01880     00 F4 45 F5 | 	or	result1, ##1669332992
01884                 | LR__0071
01884     A8 F0 03 F6 | 	mov	ptra, fp
01888     B3 00 A0 FD | 	call	#popregs_
0188c                 | __system___gc_tryalloc_ret
0188c     2D 00 64 FD | 	ret
01890                 | 
01890                 | __system___gc_errmsg
01890     01 4C 05 F6 | 	mov	COUNT_, #1
01894     A9 00 A0 FD | 	call	#pushregs_
01898     07 19 02 F6 | 	mov	local01, arg01
0189c                 | LR__0072
0189c     0C 0F CA FA | 	rdbyte	arg01, local01 wz
018a0     01 18 06 F1 | 	add	local01, #1
018a4     08 00 90 AD |  if_e	jmp	#LR__0073
018a8     D0 F2 BF FD | 	call	#__system___tx
018ac     EC FF 9F FD | 	jmp	#LR__0072
018b0                 | LR__0073
018b0     00 F4 05 F6 | 	mov	result1, #0
018b4     A8 F0 03 F6 | 	mov	ptra, fp
018b8     B3 00 A0 FD | 	call	#popregs_
018bc                 | __system___gc_errmsg_ret
018bc     2D 00 64 FD | 	ret
018c0                 | 
018c0                 | __system___gc_alloc_managed
018c0     02 4C 05 F6 | 	mov	COUNT_, #2
018c4     A9 00 A0 FD | 	call	#pushregs_
018c8     07 19 02 F6 | 	mov	local01, arg01
018cc     00 10 06 F6 | 	mov	arg02, #0
018d0     30 00 B0 FD | 	call	#__system___gc_doalloc
018d4     FA 1A 0A F6 | 	mov	local02, result1 wz
018d8     18 00 90 5D |  if_ne	jmp	#LR__0074
018dc     01 18 56 F2 | 	cmps	local01, #1 wc
018e0     10 00 90 CD |  if_b	jmp	#LR__0074
018e4     5D 00 00 FF 
018e8     B2 0E 06 F6 | 	mov	arg01, ##@LR__0734
018ec     A0 FF BF FD | 	call	#__system___gc_errmsg
018f0     04 00 90 FD | 	jmp	#LR__0075
018f4                 | LR__0074
018f4     0D F5 01 F6 | 	mov	result1, local02
018f8                 | LR__0075
018f8     A8 F0 03 F6 | 	mov	ptra, fp
018fc     B3 00 A0 FD | 	call	#popregs_
01900                 | __system___gc_alloc_managed_ret
01900     2D 00 64 FD | 	ret
01904                 | 
01904                 | __system___gc_doalloc
01904     06 4C 05 F6 | 	mov	COUNT_, #6
01908     A9 00 A0 FD | 	call	#pushregs_
0190c     07 19 0A F6 | 	mov	local01, arg01 wz
01910     08 1B 02 F6 | 	mov	local02, arg02
01914     00 F4 05 A6 |  if_e	mov	result1, #0
01918     90 00 90 AD |  if_e	jmp	#LR__0083
0191c     17 18 06 F1 | 	add	local01, #23
01920     0F 18 26 F5 | 	andn	local01, #15
01924     04 18 46 F0 | 	shr	local01, #4
01928     14 EE 05 F1 | 	add	ptr___system__dat__, #20
0192c     F7 0E 02 F6 | 	mov	arg01, ptr___system__dat__
01930     14 EE 85 F1 | 	sub	ptr___system__dat__, #20
01934     08 F2 BF FD | 	call	#__system___lockmem
01938     0C 0F 02 F6 | 	mov	arg01, local01
0193c     0D 11 02 F6 | 	mov	arg02, local02
01940     80 FD BF FD | 	call	#__system___gc_tryalloc
01944     FA 1C 0A F6 | 	mov	local03, result1 wz
01948     14 00 90 5D |  if_ne	jmp	#LR__0076
0194c     74 03 B0 FD | 	call	#__system___gc_docollect
01950     0C 0F 02 F6 | 	mov	arg01, local01
01954     0D 11 02 F6 | 	mov	arg02, local02
01958     68 FD BF FD | 	call	#__system___gc_tryalloc
0195c     FA 1C 02 F6 | 	mov	local03, result1
01960                 | LR__0076
01960     14 EE 05 F1 | 	add	ptr___system__dat__, #20
01964     F7 0E 02 F6 | 	mov	arg01, ptr___system__dat__
01968     14 EE 85 F1 | 	sub	ptr___system__dat__, #20
0196c     07 01 68 FC | 	wrlong	#0, arg01
01970     00 1C 0E F2 | 	cmp	local03, #0 wz
01974     30 00 90 AD |  if_e	jmp	#LR__0082
01978     04 18 66 F0 | 	shl	local01, #4
0197c     08 18 86 F1 | 	sub	local01, #8
01980     0C 1F 52 F6 | 	abs	local04, local01 wc
01984     02 1E 46 F0 | 	shr	local04, #2
01988     0F 21 8A F6 | 	negc	local05, local04 wz
0198c     0E 23 02 F6 | 	mov	local06, local03
01990     14 00 90 AD |  if_e	jmp	#LR__0081
01994     74 E6 9F FE | 	loc	pa,	#(@LR__0079-@LR__0077)
01998     8C 00 A0 FD | 	call	#FCACHE_LOAD_
0199c                 | LR__0077
0199c     10 05 D8 FC | 	rep	@LR__0080, local05
019a0                 | LR__0078
019a0     11 01 68 FC | 	wrlong	#0, local06
019a4     04 22 06 F1 | 	add	local06, #4
019a8                 | LR__0079
019a8                 | LR__0080
019a8                 | LR__0081
019a8                 | LR__0082
019a8     0E F5 01 F6 | 	mov	result1, local03
019ac                 | LR__0083
019ac     A8 F0 03 F6 | 	mov	ptra, fp
019b0     B3 00 A0 FD | 	call	#popregs_
019b4                 | __system___gc_doalloc_ret
019b4     2D 00 64 FD | 	ret
019b8                 | 
019b8                 | __system___gc_isvalidptr
019b8     09 F9 01 F6 | 	mov	_var01, arg03
019bc     FC FA 01 F6 | 	mov	_var02, _var01
019c0     00 F8 7F FF 
019c4     00 FA 05 F5 | 	and	_var02, ##-1048576
019c8     00 C0 31 FF 
019cc     00 FA 0D F2 | 	cmp	_var02, ##1669332992 wz
019d0     00 F4 05 56 |  if_ne	mov	result1, #0
019d4     58 00 90 5D |  if_ne	jmp	#__system___gc_isvalidptr_ret
019d8     08 F8 85 F1 | 	sub	_var01, #8
019dc     74 F9 05 F4 | 	bitl	_var01, #372
019e0     07 F9 51 F2 | 	cmps	_var01, arg01 wc
019e4     08 00 90 CD |  if_b	jmp	#LR__0084
019e8     08 F9 51 F2 | 	cmps	_var01, arg02 wc
019ec     08 00 90 CD |  if_b	jmp	#LR__0085
019f0                 | LR__0084
019f0     00 F4 05 F6 | 	mov	result1, #0
019f4     38 00 90 FD | 	jmp	#__system___gc_isvalidptr_ret
019f8                 | LR__0085
019f8     FC FA 01 F6 | 	mov	_var02, _var01
019fc     07 FB 61 F5 | 	xor	_var02, arg01
01a00     0F FA 0D F5 | 	and	_var02, #15 wz
01a04     00 F4 05 56 |  if_ne	mov	result1, #0
01a08     24 00 90 5D |  if_ne	jmp	#__system___gc_isvalidptr_ret
01a0c     FC FA 01 F6 | 	mov	_var02, _var01
01a10     02 FA 05 F1 | 	add	_var02, #2
01a14     FD FA E1 FA | 	rdword	_var02, _var02
01a18     7F 00 00 FF 
01a1c     C0 FB 05 F5 | 	and	_var02, ##65472
01a20     36 00 00 FF 
01a24     80 FA 0D F2 | 	cmp	_var02, ##27776 wz
01a28     00 F4 05 56 |  if_ne	mov	result1, #0
01a2c     FC F4 01 A6 |  if_e	mov	result1, _var01
01a30                 | __system___gc_isvalidptr_ret
01a30     2D 00 64 FD | 	ret
01a34                 | 
01a34                 | __system___gc_free
01a34     01 4C 05 F6 | 	mov	COUNT_, #1
01a38     A9 00 A0 FD | 	call	#pushregs_
01a3c     07 19 02 F6 | 	mov	local01, arg01
01a40     9C FB BF FD | 	call	#__system___gc_ptrs
01a44     FA 0E 02 F6 | 	mov	arg01, result1
01a48     FB 10 02 F6 | 	mov	arg02, result2
01a4c     0C 13 02 F6 | 	mov	arg03, local01
01a50     64 FF BF FD | 	call	#__system___gc_isvalidptr
01a54     FA 18 0A F6 | 	mov	local01, result1 wz
01a58     28 00 90 AD |  if_e	jmp	#LR__0086
01a5c     14 EE 05 F1 | 	add	ptr___system__dat__, #20
01a60     F7 0E 02 F6 | 	mov	arg01, ptr___system__dat__
01a64     14 EE 85 F1 | 	sub	ptr___system__dat__, #20
01a68     D4 F0 BF FD | 	call	#__system___lockmem
01a6c     0C 0F 02 F6 | 	mov	arg01, local01
01a70     1C 00 B0 FD | 	call	#__system___gc_dofree
01a74     14 EE 05 F1 | 	add	ptr___system__dat__, #20
01a78     F7 0E 02 F6 | 	mov	arg01, ptr___system__dat__
01a7c     14 EE 85 F1 | 	sub	ptr___system__dat__, #20
01a80     07 01 68 FC | 	wrlong	#0, arg01
01a84                 | LR__0086
01a84     A8 F0 03 F6 | 	mov	ptra, fp
01a88     B3 00 A0 FD | 	call	#popregs_
01a8c                 | __system___gc_free_ret
01a8c     2D 00 64 FD | 	ret
01a90                 | 
01a90                 | __system___gc_dofree
01a90     0B 4C 05 F6 | 	mov	COUNT_, #11
01a94     A9 00 A0 FD | 	call	#pushregs_
01a98     07 19 02 F6 | 	mov	local01, arg01
01a9c     40 FB BF FD | 	call	#__system___gc_ptrs
01aa0     FA 1A 02 F6 | 	mov	local02, result1
01aa4     FB 1C 02 F6 | 	mov	local03, result2
01aa8     0C 0F 02 F6 | 	mov	arg01, local01
01aac     02 0E 06 F1 | 	add	arg01, #2
01ab0     36 00 80 FF 
01ab4     07 1F 59 FC | 	wrword	##27791, arg01
01ab8     0C 1F 02 F6 | 	mov	local04, local01
01abc     0C 0F 02 F6 | 	mov	arg01, local01
01ac0     C4 FB BF FD | 	call	#__system___gc_nextBlockPtr
01ac4     FA 20 02 F6 | 	mov	local05, result1
01ac8     7C E5 9F FE | 	loc	pa,	#(@LR__0088-@LR__0087)
01acc     8C 00 A0 FD | 	call	#FCACHE_LOAD_
01ad0                 | LR__0087
01ad0     04 1E 06 F1 | 	add	local04, #4
01ad4     0F 11 EA FA | 	rdword	arg02, local04 wz
01ad8     0D 0F 02 F6 | 	mov	arg01, local02
01adc     00 F4 05 A6 |  if_e	mov	result1, #0
01ae0     04 10 66 50 |  if_ne	shl	arg02, #4
01ae4     08 0F 02 51 |  if_ne	add	arg01, arg02
01ae8     07 F5 01 56 |  if_ne	mov	result1, arg01
01aec     FA 1E 0A F6 | 	mov	local04, result1 wz
01af0     24 00 90 AD |  if_e	jmp	#LR__0089
01af4     0F 0F 02 F6 | 	mov	arg01, local04
01af8     00 F4 05 F6 | 	mov	result1, #0
01afc     02 0E 06 F1 | 	add	arg01, #2
01b00     07 0F E2 FA | 	rdword	arg01, arg01
01b04     36 00 00 FF 
01b08     8F 0E 0E F2 | 	cmp	arg01, ##27791 wz
01b0c     01 F4 65 A6 |  if_e	neg	result1, #1
01b10     FA 10 0A F6 | 	mov	arg02, result1 wz
01b14     B8 FF 9F AD |  if_e	jmp	#LR__0087
01b18                 | LR__0088
01b18                 | LR__0089
01b18     00 1E 0E F2 | 	cmp	local04, #0 wz
01b1c     0D 1F 02 A6 |  if_e	mov	local04, local02
01b20     0F 11 02 F6 | 	mov	arg02, local04
01b24     06 10 06 F1 | 	add	arg02, #6
01b28     0C 0F 02 F6 | 	mov	arg01, local01
01b2c     08 11 E2 FA | 	rdword	arg02, arg02
01b30     06 0E 06 F1 | 	add	arg01, #6
01b34     07 11 52 FC | 	wrword	arg02, arg01
01b38     0C 11 0A F6 | 	mov	arg02, local01 wz
01b3c     00 F4 05 A6 |  if_e	mov	result1, #0
01b40     0D 11 82 51 |  if_ne	sub	arg02, local02
01b44     04 10 46 50 |  if_ne	shr	arg02, #4
01b48     08 F5 01 56 |  if_ne	mov	result1, arg02
01b4c     0F 0F 02 F6 | 	mov	arg01, local04
01b50     06 0E 06 F1 | 	add	arg01, #6
01b54     07 F5 51 FC | 	wrword	result1, arg01
01b58     0D 1F 0A F2 | 	cmp	local04, local02 wz
01b5c     84 00 90 AD |  if_e	jmp	#LR__0092
01b60     0F 0F 02 F6 | 	mov	arg01, local04
01b64     20 FB BF FD | 	call	#__system___gc_nextBlockPtr
01b68     0C F5 09 F2 | 	cmp	result1, local01 wz
01b6c     74 00 90 5D |  if_ne	jmp	#LR__0091
01b70     0F 21 E2 FA | 	rdword	local05, local04
01b74     0C F7 E1 FA | 	rdword	result2, local01
01b78     FB 20 02 F1 | 	add	local05, result2
01b7c     0F 21 52 FC | 	wrword	local05, local04
01b80     0C 21 02 F6 | 	mov	local05, local01
01b84     02 20 06 F1 | 	add	local05, #2
01b88     10 01 58 FC | 	wrword	#0, local05
01b8c     0C 0F 02 F6 | 	mov	arg01, local01
01b90     F4 FA BF FD | 	call	#__system___gc_nextBlockPtr
01b94     FA 20 02 F6 | 	mov	local05, result1
01b98     0E 21 52 F2 | 	cmps	local05, local03 wc
01b9c     20 00 90 3D |  if_ae	jmp	#LR__0090
01ba0     0F 11 0A F6 | 	mov	arg02, local04 wz
01ba4     00 F4 05 A6 |  if_e	mov	result1, #0
01ba8     0D 11 82 51 |  if_ne	sub	arg02, local02
01bac     04 10 46 50 |  if_ne	shr	arg02, #4
01bb0     08 F5 01 56 |  if_ne	mov	result1, arg02
01bb4     10 F7 01 F6 | 	mov	result2, local05
01bb8     04 F6 05 F1 | 	add	result2, #4
01bbc     FB F4 51 FC | 	wrword	result1, result2
01bc0                 | LR__0090
01bc0     0C F7 01 F6 | 	mov	result2, local01
01bc4     06 F6 05 F1 | 	add	result2, #6
01bc8     0F F5 01 F6 | 	mov	result1, local04
01bcc     FB F6 E1 FA | 	rdword	result2, result2
01bd0     06 F4 05 F1 | 	add	result1, #6
01bd4     FA F6 51 FC | 	wrword	result2, result1
01bd8     06 18 06 F1 | 	add	local01, #6
01bdc     0C 01 58 FC | 	wrword	#0, local01
01be0     0F 19 02 F6 | 	mov	local01, local04
01be4                 | LR__0091
01be4                 | LR__0092
01be4     0C 0F 02 F6 | 	mov	arg01, local01
01be8     9C FA BF FD | 	call	#__system___gc_nextBlockPtr
01bec     FA 22 0A F6 | 	mov	local06, result1 wz
01bf0     C0 00 90 AD |  if_e	jmp	#LR__0094
01bf4     0E 23 52 F2 | 	cmps	local06, local03 wc
01bf8     B8 00 90 3D |  if_ae	jmp	#LR__0094
01bfc     11 0F 02 F6 | 	mov	arg01, local06
01c00     00 F4 05 F6 | 	mov	result1, #0
01c04     02 0E 06 F1 | 	add	arg01, #2
01c08     07 0F E2 FA | 	rdword	arg01, arg01
01c0c     36 00 00 FF 
01c10     8F 0E 0E F2 | 	cmp	arg01, ##27791 wz
01c14     01 F4 65 A6 |  if_e	neg	result1, #1
01c18     00 F4 0D F2 | 	cmp	result1, #0 wz
01c1c     94 00 90 AD |  if_e	jmp	#LR__0094
01c20     0C 1F 02 F6 | 	mov	local04, local01
01c24     0F 21 E2 FA | 	rdword	local05, local04
01c28     11 19 02 F6 | 	mov	local01, local06
01c2c     0C 25 E2 FA | 	rdword	local07, local01
01c30     12 21 02 F1 | 	add	local05, local07
01c34     0F 27 02 F6 | 	mov	local08, local04
01c38     13 21 52 FC | 	wrword	local05, local08
01c3c     0C 21 02 F6 | 	mov	local05, local01
01c40     06 20 06 F1 | 	add	local05, #6
01c44     0F F7 01 F6 | 	mov	result2, local04
01c48     10 29 E2 FA | 	rdword	local09, local05
01c4c     06 F6 05 F1 | 	add	result2, #6
01c50     FB 28 52 FC | 	wrword	local09, result2
01c54     0C 21 02 F6 | 	mov	local05, local01
01c58     02 20 06 F1 | 	add	local05, #2
01c5c     10 55 59 FC | 	wrword	#170, local05
01c60     0C 21 02 F6 | 	mov	local05, local01
01c64     06 20 06 F1 | 	add	local05, #6
01c68     00 2A 06 F6 | 	mov	local10, #0
01c6c     10 01 58 FC | 	wrword	#0, local05
01c70     0C 0F 02 F6 | 	mov	arg01, local01
01c74     10 FA BF FD | 	call	#__system___gc_nextBlockPtr
01c78     FA 2C 02 F6 | 	mov	local11, result1
01c7c     16 21 0A F6 | 	mov	local05, local11 wz
01c80     30 00 90 AD |  if_e	jmp	#LR__0093
01c84     0E 21 52 F2 | 	cmps	local05, local03 wc
01c88     28 00 90 3D |  if_ae	jmp	#LR__0093
01c8c     0D 0F 02 F6 | 	mov	arg01, local02
01c90     0F 11 0A F6 | 	mov	arg02, local04 wz
01c94     00 F4 05 A6 |  if_e	mov	result1, #0
01c98     07 11 82 51 |  if_ne	sub	arg02, arg01
01c9c     04 10 46 50 |  if_ne	shr	arg02, #4
01ca0     08 F5 01 56 |  if_ne	mov	result1, arg02
01ca4     FA 2C 02 F6 | 	mov	local11, result1
01ca8     10 2B 02 F6 | 	mov	local10, local05
01cac     04 2A 06 F1 | 	add	local10, #4
01cb0     15 2D 52 FC | 	wrword	local11, local10
01cb4                 | LR__0093
01cb4                 | LR__0094
01cb4     10 F5 01 F6 | 	mov	result1, local05
01cb8     A8 F0 03 F6 | 	mov	ptra, fp
01cbc     B3 00 A0 FD | 	call	#popregs_
01cc0                 | __system___gc_dofree_ret
01cc0     2D 00 64 FD | 	ret
01cc4                 | 
01cc4                 | __system___gc_docollect
01cc4     09 4C 05 F6 | 	mov	COUNT_, #9
01cc8     A9 00 A0 FD | 	call	#pushregs_
01ccc     10 F9 BF FD | 	call	#__system___gc_ptrs
01cd0     FB 18 02 F6 | 	mov	local01, result2
01cd4     FA 1A 02 F6 | 	mov	local02, result1
01cd8     0D 0F 02 F6 | 	mov	arg01, local02
01cdc     A8 F9 BF FD | 	call	#__system___gc_nextBlockPtr
01ce0     FA 1C 0A F6 | 	mov	local03, result1 wz
01ce4     00 1E 06 F6 | 	mov	local04, #0
01ce8     01 1E 62 FD | 	cogid	local04
01cec     34 00 90 AD |  if_e	jmp	#LR__0096
01cf0                 | LR__0095
01cf0     0C 1D 52 F2 | 	cmps	local03, local01 wc
01cf4     2C 00 90 3D |  if_ae	jmp	#LR__0096
01cf8     0E 21 02 F6 | 	mov	local05, local03
01cfc     02 20 06 F1 | 	add	local05, #2
01d00     10 23 E2 FA | 	rdword	local06, local05
01d04     20 22 26 F5 | 	andn	local06, #32
01d08     0E 25 02 F6 | 	mov	local07, local03
01d0c     02 24 06 F1 | 	add	local07, #2
01d10     12 23 52 FC | 	wrword	local06, local07
01d14     0E 0F 02 F6 | 	mov	arg01, local03
01d18     6C F9 BF FD | 	call	#__system___gc_nextBlockPtr
01d1c     FA 1C 0A F6 | 	mov	local03, result1 wz
01d20     CC FF 9F 5D |  if_ne	jmp	#LR__0095
01d24                 | LR__0096
01d24     00 22 06 F6 | 	mov	local06, #0
01d28     00 0E 06 F6 | 	mov	arg01, #0
01d2c     B0 ED BF FD | 	call	#__system____topofstack
01d30     FA 10 02 F6 | 	mov	arg02, result1
01d34     11 0F 02 F6 | 	mov	arg01, local06
01d38     90 00 B0 FD | 	call	#__system___gc_markhub
01d3c     1C 01 B0 FD | 	call	#__system___gc_markcog
01d40     0D 0F 02 F6 | 	mov	arg01, local02
01d44     40 F9 BF FD | 	call	#__system___gc_nextBlockPtr
01d48     FA 26 0A F6 | 	mov	local08, result1 wz
01d4c     10 00 90 5D |  if_ne	jmp	#LR__0097
01d50     5D 00 00 FF 
01d54     CF 0E 06 F6 | 	mov	arg01, ##@LR__0735
01d58     34 FB BF FD | 	call	#__system___gc_errmsg
01d5c     60 00 90 FD | 	jmp	#LR__0101
01d60                 | LR__0097
01d60                 | LR__0098
01d60     13 1D 02 F6 | 	mov	local03, local08
01d64     0E 0F 02 F6 | 	mov	arg01, local03
01d68     1C F9 BF FD | 	call	#__system___gc_nextBlockPtr
01d6c     FA 26 02 F6 | 	mov	local08, result1
01d70     0E 23 02 F6 | 	mov	local06, local03
01d74     02 22 06 F1 | 	add	local06, #2
01d78     11 23 E2 FA | 	rdword	local06, local06
01d7c     20 22 CE F7 | 	test	local06, #32 wz
01d80     30 00 90 5D |  if_ne	jmp	#LR__0100
01d84     11 21 02 F6 | 	mov	local05, local06
01d88     10 20 0E F5 | 	and	local05, #16 wz
01d8c     24 00 90 5D |  if_ne	jmp	#LR__0100
01d90     11 23 42 F8 | 	getnib	local06, local06, #0
01d94     11 29 02 F6 | 	mov	local09, local06
01d98     0F 29 0A F2 | 	cmp	local09, local04 wz
01d9c     0E 28 0E 52 |  if_ne	cmp	local09, #14 wz
01da0     10 00 90 5D |  if_ne	jmp	#LR__0099
01da4     0E 0F 02 F6 | 	mov	arg01, local03
01da8     E4 FC BF FD | 	call	#__system___gc_dofree
01dac     FA 22 02 F6 | 	mov	local06, result1
01db0     11 27 02 F6 | 	mov	local08, local06
01db4                 | LR__0099
01db4                 | LR__0100
01db4     00 26 0E F2 | 	cmp	local08, #0 wz
01db8     0C 27 52 52 |  if_ne	cmps	local08, local01 wc
01dbc     A0 FF 9F 4D |  if_c_and_nz	jmp	#LR__0098
01dc0                 | LR__0101
01dc0     A8 F0 03 F6 | 	mov	ptra, fp
01dc4     B3 00 A0 FD | 	call	#popregs_
01dc8                 | __system___gc_docollect_ret
01dc8     2D 00 64 FD | 	ret
01dcc                 | 
01dcc                 | __system___gc_markhub
01dcc     04 4C 05 F6 | 	mov	COUNT_, #4
01dd0     A9 00 A0 FD | 	call	#pushregs_
01dd4     07 19 02 F6 | 	mov	local01, arg01
01dd8     08 1B 02 F6 | 	mov	local02, arg02
01ddc     00 F8 BF FD | 	call	#__system___gc_ptrs
01de0     FA 1C 02 F6 | 	mov	local03, result1
01de4     FB 1E 02 F6 | 	mov	local04, result2
01de8                 | LR__0102
01de8     0D 19 52 F2 | 	cmps	local01, local02 wc
01dec     60 00 90 3D |  if_ae	jmp	#LR__0103
01df0     0C 13 02 FB | 	rdlong	arg03, local01
01df4     04 18 06 F1 | 	add	local01, #4
01df8     0F 11 02 F6 | 	mov	arg02, local04
01dfc     0E 0F 02 F6 | 	mov	arg01, local03
01e00     B4 FB BF FD | 	call	#__system___gc_isvalidptr
01e04     FA F6 09 F6 | 	mov	result2, result1 wz
01e08     DC FF 9F AD |  if_e	jmp	#LR__0102
01e0c     FB 0E 02 F6 | 	mov	arg01, result2
01e10     00 F4 05 F6 | 	mov	result1, #0
01e14     02 0E 06 F1 | 	add	arg01, #2
01e18     07 0F E2 FA | 	rdword	arg01, arg01
01e1c     36 00 00 FF 
01e20     8F 0E 0E F2 | 	cmp	arg01, ##27791 wz
01e24     01 F4 65 A6 |  if_e	neg	result1, #1
01e28     00 F4 0D F2 | 	cmp	result1, #0 wz
01e2c     B8 FF 9F 5D |  if_ne	jmp	#LR__0102
01e30     FB 12 02 F6 | 	mov	arg03, result2
01e34     02 12 06 F1 | 	add	arg03, #2
01e38     09 13 E2 FA | 	rdword	arg03, arg03
01e3c     0F 12 26 F5 | 	andn	arg03, #15
01e40     2E 12 46 F5 | 	or	arg03, #46
01e44     02 F6 05 F1 | 	add	result2, #2
01e48     FB 12 52 FC | 	wrword	arg03, result2
01e4c     98 FF 9F FD | 	jmp	#LR__0102
01e50                 | LR__0103
01e50     A8 F0 03 F6 | 	mov	ptra, fp
01e54     B3 00 A0 FD | 	call	#popregs_
01e58                 | __system___gc_markhub_ret
01e58     2D 00 64 FD | 	ret
01e5c                 | 
01e5c                 | __system___gc_markcog
01e5c     04 4C 05 F6 | 	mov	COUNT_, #4
01e60     A9 00 A0 FD | 	call	#pushregs_
01e64     78 F7 BF FD | 	call	#__system___gc_ptrs
01e68     FA 18 02 F6 | 	mov	local01, result1
01e6c     FB 1A 02 F6 | 	mov	local02, result2
01e70     00 1C 06 F6 | 	mov	local03, #0
01e74                 | LR__0104
01e74     F0 1F 06 F6 | 	mov	local04, #496
01e78     0E 1F 82 F1 | 	sub	local04, local03
01e7c     F0 1F 06 F1 | 	add	local04, #496
01e80                 | 	'.live	local04
01e80     00 1E 96 F9 | 	alts	local04, #0
01e84     0F 1F 02 F6 | 	mov	local04, local04
01e88     0C 0F 02 F6 | 	mov	arg01, local01
01e8c     0D 11 02 F6 | 	mov	arg02, local02
01e90     0F 13 02 F6 | 	mov	arg03, local04
01e94     20 FB BF FD | 	call	#__system___gc_isvalidptr
01e98     00 F4 0D F2 | 	cmp	result1, #0 wz
01e9c     18 00 90 AD |  if_e	jmp	#LR__0105
01ea0     FA 1E 02 F6 | 	mov	local04, result1
01ea4     02 1E 06 F1 | 	add	local04, #2
01ea8     0F 1F E2 FA | 	rdword	local04, local04
01eac     20 1E 46 F5 | 	or	local04, #32
01eb0     02 F4 05 F1 | 	add	result1, #2
01eb4     FA 1E 52 FC | 	wrword	local04, result1
01eb8                 | LR__0105
01eb8     01 1C 06 F1 | 	add	local03, #1
01ebc     F0 1D 56 F2 | 	cmps	local03, #496 wc
01ec0     B0 FF 9F CD |  if_b	jmp	#LR__0104
01ec4     A8 F0 03 F6 | 	mov	ptra, fp
01ec8     B3 00 A0 FD | 	call	#popregs_
01ecc                 | __system___gc_markcog_ret
01ecc     2D 00 64 FD | 	ret
01ed0                 | 
01ed0                 | __system___openraw
01ed0     0C 4C 05 F6 | 	mov	COUNT_, #12
01ed4     A9 00 A0 FD | 	call	#pushregs_
01ed8     34 F0 07 F1 | 	add	ptra, #52
01edc     04 50 05 F1 | 	add	fp, #4
01ee0     A8 0E 62 FC | 	wrlong	arg01, fp
01ee4     04 50 05 F1 | 	add	fp, #4
01ee8     A8 10 62 FC | 	wrlong	arg02, fp
01eec     04 50 05 F1 | 	add	fp, #4
01ef0     A8 12 62 FC | 	wrlong	arg03, fp
01ef4     04 50 05 F1 | 	add	fp, #4
01ef8     A8 14 62 FC | 	wrlong	arg04, fp
01efc     0C 50 05 F1 | 	add	fp, #12
01f00     A8 08 68 FC | 	wrlong	#4, fp
01f04     18 50 85 F1 | 	sub	fp, #24
01f08     A8 12 02 FB | 	rdlong	arg03, fp
01f0c     1C 50 05 F1 | 	add	fp, #28
01f10     A8 12 62 FC | 	wrlong	arg03, fp
01f14     40 EF 05 F1 | 	add	ptr___system__dat__, #320
01f18     F7 0E 02 F6 | 	mov	arg01, ptr___system__dat__
01f1c     40 EF 85 F1 | 	sub	ptr___system__dat__, #320
01f20     04 50 05 F1 | 	add	fp, #4
01f24     A8 0E 62 FC | 	wrlong	arg01, fp
01f28     1C 50 85 F1 | 	sub	fp, #28
01f2c     A8 10 02 FB | 	rdlong	arg02, fp
01f30     08 50 85 F1 | 	sub	fp, #8
01f34     00 12 06 F6 | 	mov	arg03, #0
01f38     B0 EE BF FD | 	call	#__system____getvfsforfile
01f3c     18 50 05 F1 | 	add	fp, #24
01f40     A8 F4 61 FC | 	wrlong	result1, fp
01f44     FA 12 0A F6 | 	mov	arg03, result1 wz
01f48     18 50 85 F1 | 	sub	fp, #24
01f4c     18 50 05 51 |  if_ne	add	fp, #24
01f50     A8 18 02 5B |  if_ne	rdlong	local01, fp
01f54     18 50 85 51 |  if_ne	sub	fp, #24
01f58     0C 0F 0A 5B |  if_ne	rdlong	arg01, local01 wz
01f5c     1C EE 05 A1 |  if_e	add	ptr___system__dat__, #28
01f60     F7 20 68 AC |  if_e	wrlong	#16, ptr___system__dat__
01f64     1C EE 85 A1 |  if_e	sub	ptr___system__dat__, #28
01f68     01 F4 65 A6 |  if_e	neg	result1, #1
01f6c     6C 04 90 AD |  if_e	jmp	#LR__0120
01f70     20 50 05 F1 | 	add	fp, #32
01f74     A8 0E 02 FB | 	rdlong	arg01, fp
01f78     20 50 85 F1 | 	sub	fp, #32
01f7c     00 10 06 F6 | 	mov	arg02, #0
01f80     30 12 06 F6 | 	mov	arg03, #48
01f84     07 1B 02 F6 | 	mov	local02, arg01
01f88     99 00 A0 FD | 	call	#\builtin_bytefill_
01f8c     18 50 05 F1 | 	add	fp, #24
01f90     A8 1C 02 FB | 	rdlong	local03, fp
01f94     0E F5 01 FB | 	rdlong	result1, local03
01f98     FA 1E 02 FB | 	rdlong	local04, result1
01f9c     04 F4 05 F1 | 	add	result1, #4
01fa0     FA 20 02 FB | 	rdlong	local05, result1
01fa4     10 23 02 F6 | 	mov	local06, local05
01fa8     08 50 05 F1 | 	add	fp, #8
01fac     A8 24 02 FB | 	rdlong	local07, fp
01fb0     04 50 05 F1 | 	add	fp, #4
01fb4     A8 26 02 FB | 	rdlong	local08, fp
01fb8     18 50 85 F1 | 	sub	fp, #24
01fbc     A8 28 02 FB | 	rdlong	local09, fp
01fc0     0C 50 85 F1 | 	sub	fp, #12
01fc4     12 0F 02 F6 | 	mov	arg01, local07
01fc8     13 11 02 F6 | 	mov	arg02, local08
01fcc     14 13 02 F6 | 	mov	arg03, local09
01fd0     F1 2A 02 F6 | 	mov	local10, objptr
01fd4     0F E3 01 F6 | 	mov	objptr, local04
01fd8     2D 22 62 FD | 	call	local06
01fdc     15 E3 01 F6 | 	mov	objptr, local10
01fe0     14 50 05 F1 | 	add	fp, #20
01fe4     A8 F4 61 FC | 	wrlong	result1, fp
01fe8     14 50 85 F1 | 	sub	fp, #20
01fec     00 F4 0D F2 | 	cmp	result1, #0 wz
01ff0     88 00 90 AD |  if_e	jmp	#LR__0106
01ff4     0C 50 05 F1 | 	add	fp, #12
01ff8     A8 22 02 FB | 	rdlong	local06, fp
01ffc     0C 50 85 F1 | 	sub	fp, #12
02000     04 22 CE F7 | 	test	local06, #4 wz
02004     74 00 90 AD |  if_e	jmp	#LR__0106
02008     18 50 05 F1 | 	add	fp, #24
0200c     A8 1C 02 FB | 	rdlong	local03, fp
02010     0E 19 02 F6 | 	mov	local01, local03
02014     04 18 06 F1 | 	add	local01, #4
02018     0C 21 02 FB | 	rdlong	local05, local01
0201c     04 18 86 F1 | 	sub	local01, #4
02020     10 23 02 F6 | 	mov	local06, local05
02024     11 1F 02 FB | 	rdlong	local04, local06
02028     04 22 06 F1 | 	add	local06, #4
0202c     11 25 02 FB | 	rdlong	local07, local06
02030     12 2D 02 F6 | 	mov	local11, local07
02034     08 50 05 F1 | 	add	fp, #8
02038     A8 26 02 FB | 	rdlong	local08, fp
0203c     04 50 05 F1 | 	add	fp, #4
02040     A8 28 02 FB | 	rdlong	local09, fp
02044     14 50 85 F1 | 	sub	fp, #20
02048     A8 2A 02 FB | 	rdlong	local10, fp
0204c     10 50 85 F1 | 	sub	fp, #16
02050     13 0F 02 F6 | 	mov	arg01, local08
02054     14 11 02 F6 | 	mov	arg02, local09
02058     15 13 02 F6 | 	mov	arg03, local10
0205c     F1 2E 02 F6 | 	mov	local12, objptr
02060     0F E3 01 F6 | 	mov	objptr, local04
02064     2D 2C 62 FD | 	call	local11
02068     17 E3 01 F6 | 	mov	objptr, local12
0206c     FA 22 02 F6 | 	mov	local06, result1
02070     14 50 05 F1 | 	add	fp, #20
02074     A8 22 62 FC | 	wrlong	local06, fp
02078     14 50 85 F1 | 	sub	fp, #20
0207c                 | LR__0106
0207c     14 50 05 F1 | 	add	fp, #20
02080     A8 22 0A FB | 	rdlong	local06, fp wz
02084     14 50 85 F1 | 	sub	fp, #20
02088     30 03 90 5D |  if_ne	jmp	#LR__0119
0208c     0C 50 05 F1 | 	add	fp, #12
02090     A8 22 02 FB | 	rdlong	local06, fp
02094     03 22 0E F5 | 	and	local06, #3 wz
02098     1C 50 05 F1 | 	add	fp, #28
0209c     A8 22 62 FC | 	wrlong	local06, fp
020a0     28 50 85 F1 | 	sub	fp, #40
020a4     1C 50 05 51 |  if_ne	add	fp, #28
020a8     A8 22 02 5B |  if_ne	rdlong	local06, fp
020ac     02 22 46 55 |  if_ne	or	local06, #2
020b0     A8 22 62 5C |  if_ne	wrlong	local06, fp
020b4     1C 50 85 51 |  if_ne	sub	fp, #28
020b8     28 50 05 F1 | 	add	fp, #40
020bc     A8 22 02 FB | 	rdlong	local06, fp
020c0     28 50 85 F1 | 	sub	fp, #40
020c4     01 22 0E F2 | 	cmp	local06, #1 wz
020c8     1C 50 05 51 |  if_ne	add	fp, #28
020cc     A8 22 02 5B |  if_ne	rdlong	local06, fp
020d0     01 22 46 55 |  if_ne	or	local06, #1
020d4     A8 22 62 5C |  if_ne	wrlong	local06, fp
020d8     1C 50 85 51 |  if_ne	sub	fp, #28
020dc     0C 50 05 F1 | 	add	fp, #12
020e0     A8 22 02 FB | 	rdlong	local06, fp
020e4     0C 50 85 F1 | 	sub	fp, #12
020e8     20 22 CE F7 | 	test	local06, #32 wz
020ec     1C 50 05 51 |  if_ne	add	fp, #28
020f0     A8 22 02 5B |  if_ne	rdlong	local06, fp
020f4     C0 22 46 55 |  if_ne	or	local06, #192
020f8     A8 22 62 5C |  if_ne	wrlong	local06, fp
020fc     1C 50 85 51 |  if_ne	sub	fp, #28
02100     20 50 05 F1 | 	add	fp, #32
02104     A8 22 02 FB | 	rdlong	local06, fp
02108     04 50 85 F1 | 	sub	fp, #4
0210c     A8 2C 02 FB | 	rdlong	local11, fp
02110     08 22 06 F1 | 	add	local06, #8
02114     11 2D 62 FC | 	wrlong	local11, local06
02118     04 50 05 F1 | 	add	fp, #4
0211c     A8 22 02 FB | 	rdlong	local06, fp
02120     20 50 85 F1 | 	sub	fp, #32
02124     10 22 06 F1 | 	add	local06, #16
02128     11 2D 0A FB | 	rdlong	local11, local06 wz
0212c     24 00 90 5D |  if_ne	jmp	#LR__0107
02130     20 50 05 F1 | 	add	fp, #32
02134     A8 22 02 FB | 	rdlong	local06, fp
02138     08 50 85 F1 | 	sub	fp, #8
0213c     A8 2C 02 FB | 	rdlong	local11, fp
02140     18 50 85 F1 | 	sub	fp, #24
02144     0C 2C 06 F1 | 	add	local11, #12
02148     16 1D 02 FB | 	rdlong	local03, local11
0214c     10 22 06 F1 | 	add	local06, #16
02150     11 1D 62 FC | 	wrlong	local03, local06
02154                 | LR__0107
02154     20 50 05 F1 | 	add	fp, #32
02158     A8 22 02 FB | 	rdlong	local06, fp
0215c     20 50 85 F1 | 	sub	fp, #32
02160     14 22 06 F1 | 	add	local06, #20
02164     11 2D 0A FB | 	rdlong	local11, local06 wz
02168     24 00 90 5D |  if_ne	jmp	#LR__0108
0216c     20 50 05 F1 | 	add	fp, #32
02170     A8 22 02 FB | 	rdlong	local06, fp
02174     08 50 85 F1 | 	sub	fp, #8
02178     A8 2C 02 FB | 	rdlong	local11, fp
0217c     18 50 85 F1 | 	sub	fp, #24
02180     10 2C 06 F1 | 	add	local11, #16
02184     16 1D 02 FB | 	rdlong	local03, local11
02188     14 22 06 F1 | 	add	local06, #20
0218c     11 1D 62 FC | 	wrlong	local03, local06
02190                 | LR__0108
02190     20 50 05 F1 | 	add	fp, #32
02194     A8 22 02 FB | 	rdlong	local06, fp
02198     20 50 85 F1 | 	sub	fp, #32
0219c     20 22 06 F1 | 	add	local06, #32
021a0     11 2D 0A FB | 	rdlong	local11, local06 wz
021a4     24 00 90 5D |  if_ne	jmp	#LR__0109
021a8     20 50 05 F1 | 	add	fp, #32
021ac     A8 22 02 FB | 	rdlong	local06, fp
021b0     08 50 85 F1 | 	sub	fp, #8
021b4     A8 2C 02 FB | 	rdlong	local11, fp
021b8     18 50 85 F1 | 	sub	fp, #24
021bc     08 2C 06 F1 | 	add	local11, #8
021c0     16 1D 02 FB | 	rdlong	local03, local11
021c4     20 22 06 F1 | 	add	local06, #32
021c8     11 1D 62 FC | 	wrlong	local03, local06
021cc                 | LR__0109
021cc     20 50 05 F1 | 	add	fp, #32
021d0     A8 22 02 FB | 	rdlong	local06, fp
021d4     20 50 85 F1 | 	sub	fp, #32
021d8     24 22 06 F1 | 	add	local06, #36
021dc     11 2D 0A FB | 	rdlong	local11, local06 wz
021e0     24 00 90 5D |  if_ne	jmp	#LR__0110
021e4     20 50 05 F1 | 	add	fp, #32
021e8     A8 22 02 FB | 	rdlong	local06, fp
021ec     08 50 85 F1 | 	sub	fp, #8
021f0     A8 2C 02 FB | 	rdlong	local11, fp
021f4     18 50 85 F1 | 	sub	fp, #24
021f8     18 2C 06 F1 | 	add	local11, #24
021fc     16 1D 02 FB | 	rdlong	local03, local11
02200     24 22 06 F1 | 	add	local06, #36
02204     11 1D 62 FC | 	wrlong	local03, local06
02208                 | LR__0110
02208     20 50 05 F1 | 	add	fp, #32
0220c     A8 22 02 FB | 	rdlong	local06, fp
02210     20 50 85 F1 | 	sub	fp, #32
02214     2C 22 06 F1 | 	add	local06, #44
02218     11 2D 0A FB | 	rdlong	local11, local06 wz
0221c     24 00 90 5D |  if_ne	jmp	#LR__0111
02220     20 50 05 F1 | 	add	fp, #32
02224     A8 22 02 FB | 	rdlong	local06, fp
02228     08 50 85 F1 | 	sub	fp, #8
0222c     A8 2C 02 FB | 	rdlong	local11, fp
02230     18 50 85 F1 | 	sub	fp, #24
02234     14 2C 06 F1 | 	add	local11, #20
02238     16 1D 02 FB | 	rdlong	local03, local11
0223c     2C 22 06 F1 | 	add	local06, #44
02240     11 1D 62 FC | 	wrlong	local03, local06
02244                 | LR__0111
02244     20 50 05 F1 | 	add	fp, #32
02248     A8 22 02 FB | 	rdlong	local06, fp
0224c     20 50 85 F1 | 	sub	fp, #32
02250     18 22 06 F1 | 	add	local06, #24
02254     11 2D 0A FB | 	rdlong	local11, local06 wz
02258     B0 00 90 5D |  if_ne	jmp	#LR__0114
0225c     20 50 05 F1 | 	add	fp, #32
02260     A8 0E 02 FB | 	rdlong	arg01, fp
02264     07 19 02 F6 | 	mov	local01, arg01
02268     24 18 06 F1 | 	add	local01, #36
0226c     0C 23 02 FB | 	rdlong	local06, local01
02270     11 1F 02 FB | 	rdlong	local04, local06
02274     04 22 06 F1 | 	add	local06, #4
02278     11 2D 02 FB | 	rdlong	local11, local06
0227c     10 50 05 F1 | 	add	fp, #16
02280     A8 12 02 F6 | 	mov	arg03, fp
02284     30 50 85 F1 | 	sub	fp, #48
02288     00 11 06 F6 | 	mov	arg02, #256
0228c     F1 2E 02 F6 | 	mov	local12, objptr
02290     0F E3 01 F6 | 	mov	objptr, local04
02294     2D 2C 62 FD | 	call	local11
02298     17 E3 01 F6 | 	mov	objptr, local12
0229c     2C 50 05 F1 | 	add	fp, #44
022a0     A8 F4 61 FC | 	wrlong	result1, fp
022a4     2C 50 85 F1 | 	sub	fp, #44
022a8     00 F4 0D F2 | 	cmp	result1, #0 wz
022ac     3C 00 90 5D |  if_ne	jmp	#LR__0112
022b0     30 50 05 F1 | 	add	fp, #48
022b4     A8 2C 02 FB | 	rdlong	local11, fp
022b8     30 50 85 F1 | 	sub	fp, #48
022bc     02 2C CE F7 | 	test	local11, #2 wz
022c0     28 00 90 AD |  if_e	jmp	#LR__0112
022c4     20 50 05 F1 | 	add	fp, #32
022c8     A8 22 02 FB | 	rdlong	local06, fp
022cc     20 50 85 F1 | 	sub	fp, #32
022d0     F1 0E 02 F6 | 	mov	arg01, objptr
022d4     F6 10 02 F6 | 	mov	arg02, ptr___system____default_putc_terminal_
022d8     2C E8 BF FD | 	call	#__system___make_methodptr
022dc     FA 2C 02 F6 | 	mov	local11, result1
022e0     18 22 06 F1 | 	add	local06, #24
022e4     11 2D 62 FC | 	wrlong	local11, local06
022e8     20 00 90 FD | 	jmp	#LR__0113
022ec                 | LR__0112
022ec     20 50 05 F1 | 	add	fp, #32
022f0     A8 22 02 FB | 	rdlong	local06, fp
022f4     20 50 85 F1 | 	sub	fp, #32
022f8     F1 0E 02 F6 | 	mov	arg01, objptr
022fc     F5 10 02 F6 | 	mov	arg02, ptr___system____default_putc_
02300     04 E8 BF FD | 	call	#__system___make_methodptr
02304     18 22 06 F1 | 	add	local06, #24
02308     11 F5 61 FC | 	wrlong	result1, local06
0230c                 | LR__0113
0230c                 | LR__0114
0230c     20 50 05 F1 | 	add	fp, #32
02310     A8 22 02 FB | 	rdlong	local06, fp
02314     20 50 85 F1 | 	sub	fp, #32
02318     1C 22 06 F1 | 	add	local06, #28
0231c     11 2D 0A FB | 	rdlong	local11, local06 wz
02320     20 00 90 5D |  if_ne	jmp	#LR__0115
02324     20 50 05 F1 | 	add	fp, #32
02328     A8 22 02 FB | 	rdlong	local06, fp
0232c     20 50 85 F1 | 	sub	fp, #32
02330     F1 0E 02 F6 | 	mov	arg01, objptr
02334     F4 10 02 F6 | 	mov	arg02, ptr___system____default_getc_
02338     CC E7 BF FD | 	call	#__system___make_methodptr
0233c     1C 22 06 F1 | 	add	local06, #28
02340     11 F5 61 FC | 	wrlong	result1, local06
02344                 | LR__0115
02344     20 50 05 F1 | 	add	fp, #32
02348     A8 22 02 FB | 	rdlong	local06, fp
0234c     20 50 85 F1 | 	sub	fp, #32
02350     28 22 06 F1 | 	add	local06, #40
02354     11 2D 0A FB | 	rdlong	local11, local06 wz
02358     60 00 90 5D |  if_ne	jmp	#LR__0118
0235c     18 50 05 F1 | 	add	fp, #24
02360     A8 22 02 FB | 	rdlong	local06, fp
02364     18 50 85 F1 | 	sub	fp, #24
02368     1C 22 06 F1 | 	add	local06, #28
0236c     11 2D 0A FB | 	rdlong	local11, local06 wz
02370     28 00 90 AD |  if_e	jmp	#LR__0116
02374     20 50 05 F1 | 	add	fp, #32
02378     A8 22 02 FB | 	rdlong	local06, fp
0237c     08 50 85 F1 | 	sub	fp, #8
02380     A8 2C 02 FB | 	rdlong	local11, fp
02384     18 50 85 F1 | 	sub	fp, #24
02388     1C 2C 06 F1 | 	add	local11, #28
0238c     16 1D 02 FB | 	rdlong	local03, local11
02390     28 22 06 F1 | 	add	local06, #40
02394     11 1D 62 FC | 	wrlong	local03, local06
02398     20 00 90 FD | 	jmp	#LR__0117
0239c                 | LR__0116
0239c     20 50 05 F1 | 	add	fp, #32
023a0     A8 22 02 FB | 	rdlong	local06, fp
023a4     20 50 85 F1 | 	sub	fp, #32
023a8     F1 0E 02 F6 | 	mov	arg01, objptr
023ac     F3 10 02 F6 | 	mov	arg02, ptr___system____default_flush_
023b0     54 E7 BF FD | 	call	#__system___make_methodptr
023b4     28 22 06 F1 | 	add	local06, #40
023b8     11 F5 61 FC | 	wrlong	result1, local06
023bc                 | LR__0117
023bc                 | LR__0118
023bc                 | LR__0119
023bc     14 50 05 F1 | 	add	fp, #20
023c0     A8 22 0A FB | 	rdlong	local06, fp wz
023c4     00 0E 06 A6 |  if_e	mov	arg01, #0
023c8     1C EE 05 A1 |  if_e	add	ptr___system__dat__, #28
023cc     F7 0E 62 AC |  if_e	wrlong	arg01, ptr___system__dat__
023d0     1C EE 85 A1 |  if_e	sub	ptr___system__dat__, #28
023d4     A8 F4 01 FB | 	rdlong	result1, fp
023d8     14 50 85 F1 | 	sub	fp, #20
023dc                 | LR__0120
023dc     A8 F0 03 F6 | 	mov	ptra, fp
023e0     B3 00 A0 FD | 	call	#popregs_
023e4                 | __system___openraw_ret
023e4     2D 00 64 FD | 	ret
023e8                 | 
023e8                 | __system___closeraw
023e8     05 4C 05 F6 | 	mov	COUNT_, #5
023ec     A9 00 A0 FD | 	call	#pushregs_
023f0     07 19 02 F6 | 	mov	local01, arg01
023f4     00 1A 06 F6 | 	mov	local02, #0
023f8     08 18 06 F1 | 	add	local01, #8
023fc     0C F5 09 FB | 	rdlong	result1, local01 wz
02400     08 18 86 F1 | 	sub	local01, #8
02404     1C EE 05 A1 |  if_e	add	ptr___system__dat__, #28
02408     F7 0A 68 AC |  if_e	wrlong	#5, ptr___system__dat__
0240c     1C EE 85 A1 |  if_e	sub	ptr___system__dat__, #28
02410     01 F4 65 A6 |  if_e	neg	result1, #1
02414     90 00 90 AD |  if_e	jmp	#LR__0123
02418     28 18 06 F1 | 	add	local01, #40
0241c     0C F5 09 FB | 	rdlong	result1, local01 wz
02420     28 18 86 F1 | 	sub	local01, #40
02424     2C 00 90 AD |  if_e	jmp	#LR__0121
02428     28 18 06 F1 | 	add	local01, #40
0242c     0C 0F 02 FB | 	rdlong	arg01, local01
02430     28 18 86 F1 | 	sub	local01, #40
02434     07 1D 02 FB | 	rdlong	local03, arg01
02438     04 0E 06 F1 | 	add	arg01, #4
0243c     07 1F 02 FB | 	rdlong	local04, arg01
02440     0C 0F 02 F6 | 	mov	arg01, local01
02444     F1 20 02 F6 | 	mov	local05, objptr
02448     0E E3 01 F6 | 	mov	objptr, local03
0244c     2D 1E 62 FD | 	call	local04
02450     10 E3 01 F6 | 	mov	objptr, local05
02454                 | LR__0121
02454     20 18 06 F1 | 	add	local01, #32
02458     0C 21 0A FB | 	rdlong	local05, local01 wz
0245c     20 18 86 F1 | 	sub	local01, #32
02460     30 00 90 AD |  if_e	jmp	#LR__0122
02464     20 18 06 F1 | 	add	local01, #32
02468     0C 21 02 FB | 	rdlong	local05, local01
0246c     20 18 86 F1 | 	sub	local01, #32
02470     10 1D 02 FB | 	rdlong	local03, local05
02474     04 20 06 F1 | 	add	local05, #4
02478     10 1F 02 FB | 	rdlong	local04, local05
0247c     0C 0F 02 F6 | 	mov	arg01, local01
02480     F1 20 02 F6 | 	mov	local05, objptr
02484     0E E3 01 F6 | 	mov	objptr, local03
02488     2D 1E 62 FD | 	call	local04
0248c     10 E3 01 F6 | 	mov	objptr, local05
02490     FA 1A 02 F6 | 	mov	local02, result1
02494                 | LR__0122
02494     0C 0F 02 F6 | 	mov	arg01, local01
02498     00 10 06 F6 | 	mov	arg02, #0
0249c     30 12 06 F6 | 	mov	arg03, #48
024a0     99 00 A0 FD | 	call	#\builtin_bytefill_
024a4     0D F5 01 F6 | 	mov	result1, local02
024a8                 | LR__0123
024a8     A8 F0 03 F6 | 	mov	ptra, fp
024ac     B3 00 A0 FD | 	call	#popregs_
024b0                 | __system___closeraw_ret
024b0     2D 00 64 FD | 	ret
024b4                 | 
024b4                 | __system___vfs_open_sdcardx
024b4     02 4C 05 F6 | 	mov	COUNT_, #2
024b8     A9 00 A0 FD | 	call	#pushregs_
024bc     02 00 00 FF 
024c0     88 EE 05 F1 | 	add	ptr___system__dat__, ##1160
024c4     07 19 02 F6 | 	mov	local01, arg01
024c8     08 1B 02 F6 | 	mov	local02, arg02
024cc     09 F5 01 F6 | 	mov	result1, arg03
024d0     0A 17 02 F6 | 	mov	arg05, arg04
024d4     00 0E 06 F6 | 	mov	arg01, #0
024d8     0C 11 02 F6 | 	mov	arg02, local01
024dc     0D 13 02 F6 | 	mov	arg03, local02
024e0     FA 14 02 F6 | 	mov	arg04, result1
024e4     F1 1A 02 F6 | 	mov	local02, objptr
024e8     F7 E2 01 F6 | 	mov	objptr, ptr___system__dat__
024ec     02 00 00 FF 
024f0     88 EE 85 F1 | 	sub	ptr___system__dat__, ##1160
024f4     E0 1D B0 FD | 	call	#_ff_cc_disk_setpins
024f8     0D E3 01 F6 | 	mov	objptr, local02
024fc     FA 1A 0A F6 | 	mov	local02, result1 wz
02500     38 00 90 5D |  if_ne	jmp	#LR__0124
02504     02 00 00 FF 
02508     88 EE 05 F1 | 	add	ptr___system__dat__, ##1160
0250c     F7 1A 02 F6 | 	mov	local02, ptr___system__dat__
02510     F7 0E 02 F6 | 	mov	arg01, ptr___system__dat__
02514     02 00 00 FF 
02518     88 EE 85 F1 | 	sub	ptr___system__dat__, ##1160
0251c     5D 00 00 FF 
02520     E8 10 06 F6 | 	mov	arg02, ##@LR__0736
02524     00 12 06 F6 | 	mov	arg03, #0
02528     F1 18 02 F6 | 	mov	local01, objptr
0252c     0D E3 01 F6 | 	mov	objptr, local02
02530     D4 57 B0 FD | 	call	#_ff_cc_f_mount
02534     0C E3 01 F6 | 	mov	objptr, local01
02538     FA 1A 02 F6 | 	mov	local02, result1
0253c                 | LR__0124
0253c     00 1A 0E F2 | 	cmp	local02, #0 wz
02540     18 00 90 AD |  if_e	jmp	#LR__0125
02544     0D 0F 6A F6 | 	neg	arg01, local02 wz
02548     1C EE 05 F1 | 	add	ptr___system__dat__, #28
0254c     F7 0E 62 FC | 	wrlong	arg01, ptr___system__dat__
02550     1C EE 85 F1 | 	sub	ptr___system__dat__, #28
02554     00 F4 05 F6 | 	mov	result1, #0
02558     14 00 90 FD | 	jmp	#LR__0126
0255c                 | LR__0125
0255c                 | ' get_vfs()
0255c                 | ' {
0255c                 | '     return &fat_vfs;
0255c     01 00 00 FF 
02560     CC F0 05 F1 | 	add	ptr__ff_cc_dat__, ##716
02564     F8 F4 01 F6 | 	mov	result1, ptr__ff_cc_dat__
02568     01 00 00 FF 
0256c     CC F0 85 F1 | 	sub	ptr__ff_cc_dat__, ##716
02570                 | LR__0126
02570     A8 F0 03 F6 | 	mov	ptra, fp
02574     B3 00 A0 FD | 	call	#popregs_
02578                 | __system___vfs_open_sdcardx_ret
02578     2D 00 64 FD | 	ret
0257c                 | 
0257c                 | __system____default_getc
0257c     03 4C 05 F6 | 	mov	COUNT_, #3
02580     A9 00 A0 FD | 	call	#pushregs_
02584     07 19 02 F6 | 	mov	local01, arg01
02588     0C 1B 02 FB | 	rdlong	local02, local01
0258c     08 1A 06 F1 | 	add	local02, #8
02590     0D 1D 02 FB | 	rdlong	local03, local02
02594     08 1A 86 F1 | 	sub	local02, #8
02598     02 1C CE F7 | 	test	local03, #2 wz
0259c     0C 0F 02 56 |  if_ne	mov	arg01, local01
025a0     80 01 B0 5D |  if_ne	call	#__system____default_flush
025a4     08 1A 06 F1 | 	add	local02, #8
025a8     0D 1D 02 FB | 	rdlong	local03, local02
025ac     01 1C 46 F5 | 	or	local03, #1
025b0     0D 1D 62 FC | 	wrlong	local03, local02
025b4     08 1A 86 F1 | 	sub	local02, #8
025b8     0D 1D 0A FB | 	rdlong	local03, local02 wz
025bc     0C 00 90 5D |  if_ne	jmp	#LR__0127
025c0     0C 0F 02 F6 | 	mov	arg01, local01
025c4     74 10 B0 FD | 	call	#__system____default_filbuf
025c8     FA 1C 02 F6 | 	mov	local03, result1
025cc                 | LR__0127
025cc     01 1C 56 F2 | 	cmps	local03, #1 wc
025d0     01 F4 65 C6 |  if_b	neg	result1, #1
025d4     1C 00 90 CD |  if_b	jmp	#LR__0128
025d8     01 1C 86 F1 | 	sub	local03, #1
025dc     0D 1D 62 FC | 	wrlong	local03, local02
025e0     04 1A 06 F1 | 	add	local02, #4
025e4     0D 1D 02 FB | 	rdlong	local03, local02
025e8     0E F5 C1 FA | 	rdbyte	result1, local03
025ec     01 1C 06 F1 | 	add	local03, #1
025f0     0D 1D 62 FC | 	wrlong	local03, local02
025f4                 | LR__0128
025f4     A8 F0 03 F6 | 	mov	ptra, fp
025f8     B3 00 A0 FD | 	call	#popregs_
025fc                 | __system____default_getc_ret
025fc     2D 00 64 FD | 	ret
02600                 | 
02600                 | __system____default_putc
02600     04 4C 05 F6 | 	mov	COUNT_, #4
02604     A9 00 A0 FD | 	call	#pushregs_
02608     07 19 02 F6 | 	mov	local01, arg01
0260c     08 1B 02 F6 | 	mov	local02, arg02
02610     0D 1D 02 FB | 	rdlong	local03, local02
02614     08 1C 06 F1 | 	add	local03, #8
02618     0E 1F 02 FB | 	rdlong	local04, local03
0261c     08 1C 86 F1 | 	sub	local03, #8
02620     01 1E CE F7 | 	test	local04, #1 wz
02624     0D 0F 02 56 |  if_ne	mov	arg01, local02
02628     F8 00 B0 5D |  if_ne	call	#__system____default_flush
0262c     08 1C 06 F1 | 	add	local03, #8
02630     0E 1F 02 FB | 	rdlong	local04, local03
02634     02 1E 46 F5 | 	or	local04, #2
02638     0E 1F 62 FC | 	wrlong	local04, local03
0263c     08 1C 86 F1 | 	sub	local03, #8
02640     0E 1F 02 FB | 	rdlong	local04, local03
02644     0F 0F 02 F6 | 	mov	arg01, local04
02648     0C 1C 06 F1 | 	add	local03, #12
0264c     0E 0F 02 F1 | 	add	arg01, local03
02650     07 19 42 FC | 	wrbyte	local01, arg01
02654     0C 19 E2 F8 | 	getbyte	local01, local01, #0
02658     01 1E 06 F1 | 	add	local04, #1
0265c     0C 1C 86 F1 | 	sub	local03, #12
02660     0E 1F 62 FC | 	wrlong	local04, local03
02664     02 00 00 FF 
02668     00 1E 0E F2 | 	cmp	local04, ##1024 wz
0266c     10 00 90 5D |  if_ne	jmp	#LR__0129
02670     0D 0F 02 F6 | 	mov	arg01, local02
02674     AC 00 B0 FD | 	call	#__system____default_flush
02678     00 F4 0D F2 | 	cmp	result1, #0 wz
0267c     01 18 66 56 |  if_ne	neg	local01, #1
02680                 | LR__0129
02680     0C F5 01 F6 | 	mov	result1, local01
02684     A8 F0 03 F6 | 	mov	ptra, fp
02688     B3 00 A0 FD | 	call	#popregs_
0268c                 | __system____default_putc_ret
0268c     2D 00 64 FD | 	ret
02690                 | 
02690                 | __system____default_putc_terminal
02690     04 4C 05 F6 | 	mov	COUNT_, #4
02694     A9 00 A0 FD | 	call	#pushregs_
02698     07 19 02 F6 | 	mov	local01, arg01
0269c     08 1B 02 F6 | 	mov	local02, arg02
026a0     0D 1D 02 FB | 	rdlong	local03, local02
026a4     08 1C 06 F1 | 	add	local03, #8
026a8     0E 1F 02 FB | 	rdlong	local04, local03
026ac     08 1C 86 F1 | 	sub	local03, #8
026b0     01 1E CE F7 | 	test	local04, #1 wz
026b4     0D 0F 02 56 |  if_ne	mov	arg01, local02
026b8     68 00 B0 5D |  if_ne	call	#__system____default_flush
026bc     08 1C 06 F1 | 	add	local03, #8
026c0     0E 1F 02 FB | 	rdlong	local04, local03
026c4     02 1E 46 F5 | 	or	local04, #2
026c8     0E 1F 62 FC | 	wrlong	local04, local03
026cc     08 1C 86 F1 | 	sub	local03, #8
026d0     0E 1F 02 FB | 	rdlong	local04, local03
026d4     0F 0F 02 F6 | 	mov	arg01, local04
026d8     0C 1C 06 F1 | 	add	local03, #12
026dc     0E 0F 02 F1 | 	add	arg01, local03
026e0     07 19 42 FC | 	wrbyte	local01, arg01
026e4     0C 19 E2 F8 | 	getbyte	local01, local01, #0
026e8     0C 1C 86 F1 | 	sub	local03, #12
026ec     01 1E 06 F1 | 	add	local04, #1
026f0     0E 1F 62 FC | 	wrlong	local04, local03
026f4     0A 18 0E F2 | 	cmp	local01, #10 wz
026f8     02 00 00 5F 
026fc     00 1E 0E 52 |  if_ne	cmp	local04, ##1024 wz
02700     10 00 90 5D |  if_ne	jmp	#LR__0130
02704     0D 0F 02 F6 | 	mov	arg01, local02
02708     18 00 B0 FD | 	call	#__system____default_flush
0270c     00 F4 0D F2 | 	cmp	result1, #0 wz
02710     01 18 66 56 |  if_ne	neg	local01, #1
02714                 | LR__0130
02714     0C F5 01 F6 | 	mov	result1, local01
02718     A8 F0 03 F6 | 	mov	ptra, fp
0271c     B3 00 A0 FD | 	call	#popregs_
02720                 | __system____default_putc_terminal_ret
02720     2D 00 64 FD | 	ret
02724                 | 
02724                 | __system____default_flush
02724     0D 4C 05 F6 | 	mov	COUNT_, #13
02728     A9 00 A0 FD | 	call	#pushregs_
0272c     07 19 02 F6 | 	mov	local01, arg01
02730     0C 1B 02 FB | 	rdlong	local02, local01
02734     0D 1D 02 FB | 	rdlong	local03, local02
02738     08 1A 06 F1 | 	add	local02, #8
0273c     0D 1F 02 FB | 	rdlong	local04, local02
02740     08 1A 86 F1 | 	sub	local02, #8
02744     02 1E CE F7 | 	test	local04, #2 wz
02748     B8 00 90 AD |  if_e	jmp	#LR__0133
0274c     01 1C 56 F2 | 	cmps	local03, #1 wc
02750     24 01 90 CD |  if_b	jmp	#LR__0135
02754     08 18 06 F1 | 	add	local01, #8
02758     0C 1F 02 FB | 	rdlong	local04, local01
0275c     08 18 86 F1 | 	sub	local01, #8
02760     40 1E CE F7 | 	test	local04, #64 wz
02764     5C 00 90 AD |  if_e	jmp	#LR__0132
02768     08 18 06 F1 | 	add	local01, #8
0276c     0C 1F 02 FB | 	rdlong	local04, local01
02770     08 18 86 F1 | 	sub	local01, #8
02774     80 1E CE F7 | 	test	local04, #128 wz
02778     48 00 90 AD |  if_e	jmp	#LR__0131
0277c     2C 18 06 F1 | 	add	local01, #44
02780     0C 1F 02 FB | 	rdlong	local04, local01
02784     2C 18 86 F1 | 	sub	local01, #44
02788     0F 21 02 FB | 	rdlong	local05, local04
0278c     04 1E 06 F1 | 	add	local04, #4
02790     0F 1F 02 FB | 	rdlong	local04, local04
02794     0C 0F 02 F6 | 	mov	arg01, local01
02798     00 10 06 F6 | 	mov	arg02, #0
0279c     02 12 06 F6 | 	mov	arg03, #2
027a0     F1 22 02 F6 | 	mov	local06, objptr
027a4     10 E3 01 F6 | 	mov	objptr, local05
027a8     2D 1E 62 FD | 	call	local04
027ac     11 E3 01 F6 | 	mov	objptr, local06
027b0     08 18 06 F1 | 	add	local01, #8
027b4     0C 1F 02 FB | 	rdlong	local04, local01
027b8     80 1E 26 F5 | 	andn	local04, #128
027bc     0C 1F 62 FC | 	wrlong	local04, local01
027c0     08 18 86 F1 | 	sub	local01, #8
027c4                 | LR__0131
027c4                 | LR__0132
027c4     14 18 06 F1 | 	add	local01, #20
027c8     0C 1F 02 FB | 	rdlong	local04, local01
027cc     14 18 86 F1 | 	sub	local01, #20
027d0     0F 21 02 FB | 	rdlong	local05, local04
027d4     04 1E 06 F1 | 	add	local04, #4
027d8     0F 25 02 FB | 	rdlong	local07, local04
027dc     0C 1A 06 F1 | 	add	local02, #12
027e0     0D 11 02 F6 | 	mov	arg02, local02
027e4     0C 1A 86 F1 | 	sub	local02, #12
027e8     0C 0F 02 F6 | 	mov	arg01, local01
027ec     0E 13 02 F6 | 	mov	arg03, local03
027f0     F1 22 02 F6 | 	mov	local06, objptr
027f4     10 E3 01 F6 | 	mov	objptr, local05
027f8     2D 24 62 FD | 	call	local07
027fc     11 E3 01 F6 | 	mov	objptr, local06
02800     74 00 90 FD | 	jmp	#LR__0135
02804                 | LR__0133
02804     08 1A 06 F1 | 	add	local02, #8
02808     0D 1F 02 FB | 	rdlong	local04, local02
0280c     08 1A 86 F1 | 	sub	local02, #8
02810     01 1E CE F7 | 	test	local04, #1 wz
02814     60 00 90 AD |  if_e	jmp	#LR__0134
02818     00 1C 0E F2 | 	cmp	local03, #0 wz
0281c     58 00 90 AD |  if_e	jmp	#LR__0134
02820     2C 18 06 F1 | 	add	local01, #44
02824     0C 27 02 FB | 	rdlong	local08, local01
02828     2C 18 86 F1 | 	sub	local01, #44
0282c     13 1F 02 F6 | 	mov	local04, local08
02830     0F 21 02 FB | 	rdlong	local05, local04
02834     04 1E 06 F1 | 	add	local04, #4
02838     0F 29 02 FB | 	rdlong	local09, local04
0283c     14 25 02 F6 | 	mov	local07, local09
02840     0C 2B 02 F6 | 	mov	local10, local01
02844     0E 2D 62 F6 | 	neg	local11, local03
02848     01 2E 06 F6 | 	mov	local12, #1
0284c     15 0F 02 F6 | 	mov	arg01, local10
02850     16 11 02 F6 | 	mov	arg02, local11
02854     01 12 06 F6 | 	mov	arg03, #1
02858     F1 22 02 F6 | 	mov	local06, objptr
0285c     10 E3 01 F6 | 	mov	objptr, local05
02860     2D 24 62 FD | 	call	local07
02864     11 E3 01 F6 | 	mov	objptr, local06
02868     FA 1E 02 F6 | 	mov	local04, result1
0286c     0F 31 02 F6 | 	mov	local13, local04
02870     00 30 56 F2 | 	cmps	local13, #0 wc
02874     0E 31 02 36 |  if_ae	mov	local13, local03
02878                 | LR__0134
02878                 | LR__0135
02878     0D 01 68 FC | 	wrlong	#0, local02
0287c     04 1A 06 F1 | 	add	local02, #4
02880     0D 01 68 FC | 	wrlong	#0, local02
02884     04 1A 06 F1 | 	add	local02, #4
02888     0D 01 68 FC | 	wrlong	#0, local02
0288c     00 F4 05 F6 | 	mov	result1, #0
02890     A8 F0 03 F6 | 	mov	ptra, fp
02894     B3 00 A0 FD | 	call	#popregs_
02898                 | __system____default_flush_ret
02898     2D 00 64 FD | 	ret
0289c                 | 
0289c                 | __system__stat
0289c     04 4C 05 F6 | 	mov	COUNT_, #4
028a0     A9 00 A0 FD | 	call	#pushregs_
028a4     07 13 02 F6 | 	mov	arg03, arg01
028a8     08 19 02 F6 | 	mov	local01, arg02
028ac     40 EF 05 F1 | 	add	ptr___system__dat__, #320
028b0     F7 1A 02 F6 | 	mov	local02, ptr___system__dat__
028b4     0D 0F 02 F6 | 	mov	arg01, local02
028b8     09 11 02 F6 | 	mov	arg02, arg03
028bc     00 12 06 F6 | 	mov	arg03, #0
028c0     40 EF 85 F1 | 	sub	ptr___system__dat__, #320
028c4     24 E5 BF FD | 	call	#__system____getvfsforfile
028c8     FA 1C 0A F6 | 	mov	local03, result1 wz
028cc     2C 1C 06 51 |  if_ne	add	local03, #44
028d0     0E 0F 02 5B |  if_ne	rdlong	arg01, local03
028d4     2C 1C 86 51 |  if_ne	sub	local03, #44
028d8     07 0F 0A 56 |  if_ne	mov	arg01, arg01 wz
028dc     1C EE 05 A1 |  if_e	add	ptr___system__dat__, #28
028e0     F7 20 68 AC |  if_e	wrlong	#16, ptr___system__dat__
028e4     1C EE 85 A1 |  if_e	sub	ptr___system__dat__, #28
028e8     01 F4 65 A6 |  if_e	neg	result1, #1
028ec     3C 00 90 AD |  if_e	jmp	#LR__0136
028f0     0C 0F 02 F6 | 	mov	arg01, local01
028f4     00 10 06 F6 | 	mov	arg02, #0
028f8     30 12 06 F6 | 	mov	arg03, #48
028fc     99 00 A0 FD | 	call	#\builtin_bytefill_
02900     2C 1C 06 F1 | 	add	local03, #44
02904     0E 1D 02 FB | 	rdlong	local03, local03
02908     0E 1F 02 FB | 	rdlong	local04, local03
0290c     04 1C 06 F1 | 	add	local03, #4
02910     0E 1D 02 FB | 	rdlong	local03, local03
02914     0D 0F 02 F6 | 	mov	arg01, local02
02918     0C 11 02 F6 | 	mov	arg02, local01
0291c     F1 1A 02 F6 | 	mov	local02, objptr
02920     0F E3 01 F6 | 	mov	objptr, local04
02924     2D 1C 62 FD | 	call	local03
02928     0D E3 01 F6 | 	mov	objptr, local02
0292c                 | LR__0136
0292c     A8 F0 03 F6 | 	mov	ptra, fp
02930     B3 00 A0 FD | 	call	#popregs_
02934                 | __system__stat_ret
02934     2D 00 64 FD | 	ret
02938                 | 
02938                 | __system__open
02938     05 4C 05 F6 | 	mov	COUNT_, #5
0293c     A9 00 A0 FD | 	call	#pushregs_
02940     07 19 02 F6 | 	mov	local01, arg01
02944     08 1B 02 F6 | 	mov	local02, arg02
02948     09 1D 02 F6 | 	mov	local03, arg03
0294c     01 00 00 FF 
02950     48 EE 05 F1 | 	add	ptr___system__dat__, ##584
02954     F7 1E 02 F6 | 	mov	local04, ptr___system__dat__
02958     00 20 06 F6 | 	mov	local05, #0
0295c     01 00 00 FF 
02960     48 EE 85 F1 | 	sub	ptr___system__dat__, ##584
02964     C4 D6 9F FE | 	loc	pa,	#(@LR__0138-@LR__0137)
02968     8C 00 A0 FD | 	call	#FCACHE_LOAD_
0296c                 | LR__0137
0296c     0A 20 56 F2 | 	cmps	local05, #10 wc
02970     24 00 90 3D |  if_ae	jmp	#LR__0139
02974     10 F5 01 F6 | 	mov	result1, local05
02978     01 F4 65 F0 | 	shl	result1, #1
0297c     10 F5 01 F1 | 	add	result1, local05
02980     04 F4 65 F0 | 	shl	result1, #4
02984     0F F5 01 F1 | 	add	result1, local04
02988     08 F4 05 F1 | 	add	result1, #8
0298c     FA F4 09 FB | 	rdlong	result1, result1 wz
02990     01 20 06 51 |  if_ne	add	local05, #1
02994     D4 FF 9F 5D |  if_ne	jmp	#LR__0137
02998                 | LR__0138
02998                 | LR__0139
02998     0A 20 0E F2 | 	cmp	local05, #10 wz
0299c     1C EE 05 A1 |  if_e	add	ptr___system__dat__, #28
029a0     F7 16 68 AC |  if_e	wrlong	#11, ptr___system__dat__
029a4     1C EE 85 A1 |  if_e	sub	ptr___system__dat__, #28
029a8     01 F4 65 A6 |  if_e	neg	result1, #1
029ac     2C 00 90 AD |  if_e	jmp	#LR__0140
029b0     10 0F 02 F6 | 	mov	arg01, local05
029b4     01 0E 66 F0 | 	shl	arg01, #1
029b8     10 0F 02 F1 | 	add	arg01, local05
029bc     04 0E 66 F0 | 	shl	arg01, #4
029c0     0F 0F 02 F1 | 	add	arg01, local04
029c4     0C 11 02 F6 | 	mov	arg02, local01
029c8     0D 13 02 F6 | 	mov	arg03, local02
029cc     0E 15 02 F6 | 	mov	arg04, local03
029d0     FC F4 BF FD | 	call	#__system___openraw
029d4     FA F4 09 F6 | 	mov	result1, result1 wz
029d8     10 F5 01 A6 |  if_e	mov	result1, local05
029dc                 | LR__0140
029dc     A8 F0 03 F6 | 	mov	ptra, fp
029e0     B3 00 A0 FD | 	call	#popregs_
029e4                 | __system__open_ret
029e4     2D 00 64 FD | 	ret
029e8                 | 
029e8                 | __system__write
029e8     01 4C 05 F6 | 	mov	COUNT_, #1
029ec     A9 00 A0 FD | 	call	#pushregs_
029f0     07 19 02 F6 | 	mov	local01, arg01
029f4     0A 18 16 F2 | 	cmp	local01, #10 wc
029f8     1C EE 05 31 |  if_ae	add	ptr___system__dat__, #28
029fc     F7 0A 68 3C |  if_ae	wrlong	#5, ptr___system__dat__
02a00     1C EE 85 31 |  if_ae	sub	ptr___system__dat__, #28
02a04     01 F4 65 36 |  if_ae	neg	result1, #1
02a08     28 00 90 3D |  if_ae	jmp	#LR__0141
02a0c     0C 0F 02 F6 | 	mov	arg01, local01
02a10     01 0E 66 F0 | 	shl	arg01, #1
02a14     0C 0F 02 F1 | 	add	arg01, local01
02a18     04 0E 66 F0 | 	shl	arg01, #4
02a1c     01 00 00 FF 
02a20     48 EE 05 F1 | 	add	ptr___system__dat__, ##584
02a24     F7 0E 02 F1 | 	add	arg01, ptr___system__dat__
02a28     01 00 00 FF 
02a2c     48 EE 85 F1 | 	sub	ptr___system__dat__, ##584
02a30     80 07 B0 FD | 	call	#__system___vfswrite
02a34                 | LR__0141
02a34     A8 F0 03 F6 | 	mov	ptra, fp
02a38     B3 00 A0 FD | 	call	#popregs_
02a3c                 | __system__write_ret
02a3c     2D 00 64 FD | 	ret
02a40                 | 
02a40                 | __system__read
02a40     01 4C 05 F6 | 	mov	COUNT_, #1
02a44     A9 00 A0 FD | 	call	#pushregs_
02a48     07 19 02 F6 | 	mov	local01, arg01
02a4c     0A 18 16 F2 | 	cmp	local01, #10 wc
02a50     1C EE 05 31 |  if_ae	add	ptr___system__dat__, #28
02a54     F7 0A 68 3C |  if_ae	wrlong	#5, ptr___system__dat__
02a58     1C EE 85 31 |  if_ae	sub	ptr___system__dat__, #28
02a5c     01 F4 65 36 |  if_ae	neg	result1, #1
02a60     28 00 90 3D |  if_ae	jmp	#LR__0142
02a64     0C 0F 02 F6 | 	mov	arg01, local01
02a68     01 0E 66 F0 | 	shl	arg01, #1
02a6c     0C 0F 02 F1 | 	add	arg01, local01
02a70     04 0E 66 F0 | 	shl	arg01, #4
02a74     01 00 00 FF 
02a78     48 EE 05 F1 | 	add	ptr___system__dat__, ##584
02a7c     F7 0E 02 F1 | 	add	arg01, ptr___system__dat__
02a80     01 00 00 FF 
02a84     48 EE 85 F1 | 	sub	ptr___system__dat__, ##584
02a88     CC 08 B0 FD | 	call	#__system___vfsread
02a8c                 | LR__0142
02a8c     A8 F0 03 F6 | 	mov	ptra, fp
02a90     B3 00 A0 FD | 	call	#popregs_
02a94                 | __system__read_ret
02a94     2D 00 64 FD | 	ret
02a98                 | 
02a98                 | __system__close
02a98     01 4C 05 F6 | 	mov	COUNT_, #1
02a9c     A9 00 A0 FD | 	call	#pushregs_
02aa0     07 19 02 F6 | 	mov	local01, arg01
02aa4     0A 18 16 F2 | 	cmp	local01, #10 wc
02aa8     1C EE 05 31 |  if_ae	add	ptr___system__dat__, #28
02aac     F7 0A 68 3C |  if_ae	wrlong	#5, ptr___system__dat__
02ab0     1C EE 85 31 |  if_ae	sub	ptr___system__dat__, #28
02ab4     01 F4 65 36 |  if_ae	neg	result1, #1
02ab8     28 00 90 3D |  if_ae	jmp	#LR__0143
02abc     0C 0F 02 F6 | 	mov	arg01, local01
02ac0     01 0E 66 F0 | 	shl	arg01, #1
02ac4     0C 0F 02 F1 | 	add	arg01, local01
02ac8     04 0E 66 F0 | 	shl	arg01, #4
02acc     01 00 00 FF 
02ad0     48 EE 05 F1 | 	add	ptr___system__dat__, ##584
02ad4     F7 0E 02 F1 | 	add	arg01, ptr___system__dat__
02ad8     01 00 00 FF 
02adc     48 EE 85 F1 | 	sub	ptr___system__dat__, ##584
02ae0     04 F9 BF FD | 	call	#__system___closeraw
02ae4                 | LR__0143
02ae4     A8 F0 03 F6 | 	mov	ptra, fp
02ae8     B3 00 A0 FD | 	call	#popregs_
02aec                 | __system__close_ret
02aec     2D 00 64 FD | 	ret
02af0                 | 
02af0                 | __system__lseek
02af0     06 4C 05 F6 | 	mov	COUNT_, #6
02af4     A9 00 A0 FD | 	call	#pushregs_
02af8     0A 0E 16 F2 | 	cmp	arg01, #10 wc
02afc     1C EE 05 31 |  if_ae	add	ptr___system__dat__, #28
02b00     F7 0A 68 3C |  if_ae	wrlong	#5, ptr___system__dat__
02b04     1C EE 85 31 |  if_ae	sub	ptr___system__dat__, #28
02b08     01 F4 65 36 |  if_ae	neg	result1, #1
02b0c     C0 00 90 3D |  if_ae	jmp	#LR__0145
02b10     07 19 02 F6 | 	mov	local01, arg01
02b14     01 18 66 F0 | 	shl	local01, #1
02b18     07 19 02 F1 | 	add	local01, arg01
02b1c     04 18 66 F0 | 	shl	local01, #4
02b20     01 00 00 FF 
02b24     48 EE 05 F1 | 	add	ptr___system__dat__, ##584
02b28     F7 18 02 F1 | 	add	local01, ptr___system__dat__
02b2c     2C 18 06 F1 | 	add	local01, #44
02b30     0C 0F 0A FB | 	rdlong	arg01, local01 wz
02b34     2C 18 86 F1 | 	sub	local01, #44
02b38     01 00 00 FF 
02b3c     48 EE 85 F1 | 	sub	ptr___system__dat__, ##584
02b40     1C EE 05 A1 |  if_e	add	ptr___system__dat__, #28
02b44     F7 20 68 AC |  if_e	wrlong	#16, ptr___system__dat__
02b48     1C EE 85 A1 |  if_e	sub	ptr___system__dat__, #28
02b4c     01 F4 65 A6 |  if_e	neg	result1, #1
02b50     7C 00 90 AD |  if_e	jmp	#LR__0145
02b54     08 18 06 F1 | 	add	local01, #8
02b58     0C 1B 02 FB | 	rdlong	local02, local01
02b5c     08 18 86 F1 | 	sub	local01, #8
02b60     40 1A CE F7 | 	test	local02, #64 wz
02b64     08 18 06 51 |  if_ne	add	local01, #8
02b68     0C 1B 02 5B |  if_ne	rdlong	local02, local01
02b6c     80 1A 46 55 |  if_ne	or	local02, #128
02b70     0C 1B 62 5C |  if_ne	wrlong	local02, local01
02b74     08 18 86 51 |  if_ne	sub	local01, #8
02b78     2C 18 06 F1 | 	add	local01, #44
02b7c     0C 1B 02 FB | 	rdlong	local02, local01
02b80     2C 18 86 F1 | 	sub	local01, #44
02b84     0D 1D 02 FB | 	rdlong	local03, local02
02b88     04 1A 06 F1 | 	add	local02, #4
02b8c     0D 1F 02 FB | 	rdlong	local04, local02
02b90     0C 0F 02 F6 | 	mov	arg01, local01
02b94     F1 20 02 F6 | 	mov	local05, objptr
02b98     0E E3 01 F6 | 	mov	objptr, local03
02b9c     2D 1E 62 FD | 	call	local04
02ba0     10 E3 01 F6 | 	mov	objptr, local05
02ba4     FA 22 02 F6 | 	mov	local06, result1
02ba8     00 22 56 F2 | 	cmps	local06, #0 wc
02bac     1C 00 90 3D |  if_ae	jmp	#LR__0144
02bb0     11 0F 6A F6 | 	neg	arg01, local06 wz
02bb4     1C EE 05 F1 | 	add	ptr___system__dat__, #28
02bb8     F7 0E 62 FC | 	wrlong	arg01, ptr___system__dat__
02bbc     1C EE 85 F1 | 	sub	ptr___system__dat__, #28
02bc0     01 F4 65 56 |  if_ne	neg	result1, #1
02bc4     00 F4 05 A6 |  if_e	mov	result1, #0
02bc8     04 00 90 FD | 	jmp	#LR__0145
02bcc                 | LR__0144
02bcc     11 F5 01 F6 | 	mov	result1, local06
02bd0                 | LR__0145
02bd0     A8 F0 03 F6 | 	mov	ptra, fp
02bd4     B3 00 A0 FD | 	call	#popregs_
02bd8                 | __system__lseek_ret
02bd8     2D 00 64 FD | 	ret
02bdc                 | 
02bdc                 | __system__ioctl
02bdc     05 4C 05 F6 | 	mov	COUNT_, #5
02be0     A9 00 A0 FD | 	call	#pushregs_
02be4     08 19 02 F6 | 	mov	local01, arg02
02be8     09 1B 02 F6 | 	mov	local02, arg03
02bec     8C 01 B0 FD | 	call	#__system____getftab
02bf0     FA 12 0A F6 | 	mov	arg03, result1 wz
02bf4     1C EE 05 A1 |  if_e	add	ptr___system__dat__, #28
02bf8     F7 0A 68 AC |  if_e	wrlong	#5, ptr___system__dat__
02bfc     1C EE 85 A1 |  if_e	sub	ptr___system__dat__, #28
02c00     01 F4 65 A6 |  if_e	neg	result1, #1
02c04     5C 00 90 AD |  if_e	jmp	#LR__0147
02c08     24 12 06 F1 | 	add	arg03, #36
02c0c     09 0F 02 FB | 	rdlong	arg01, arg03
02c10     24 12 86 F1 | 	sub	arg03, #36
02c14     07 1D 02 FB | 	rdlong	local03, arg01
02c18     04 0E 06 F1 | 	add	arg01, #4
02c1c     07 1F 02 FB | 	rdlong	local04, arg01
02c20     09 0F 02 F6 | 	mov	arg01, arg03
02c24     0C 11 02 F6 | 	mov	arg02, local01
02c28     0D 13 02 F6 | 	mov	arg03, local02
02c2c     F1 20 02 F6 | 	mov	local05, objptr
02c30     0E E3 01 F6 | 	mov	objptr, local03
02c34     2D 1E 62 FD | 	call	local04
02c38     10 E3 01 F6 | 	mov	objptr, local05
02c3c     FA 0E 0A F6 | 	mov	arg01, result1 wz
02c40     1C 00 90 AD |  if_e	jmp	#LR__0146
02c44     1C EE 05 F1 | 	add	ptr___system__dat__, #28
02c48     F7 0E 62 FC | 	wrlong	arg01, ptr___system__dat__
02c4c     1C EE 85 F1 | 	sub	ptr___system__dat__, #28
02c50     00 0E 0E F2 | 	cmp	arg01, #0 wz
02c54     01 F4 65 56 |  if_ne	neg	result1, #1
02c58     00 F4 05 A6 |  if_e	mov	result1, #0
02c5c     04 00 90 FD | 	jmp	#LR__0147
02c60                 | LR__0146
02c60     00 F4 05 F6 | 	mov	result1, #0
02c64                 | LR__0147
02c64     A8 F0 03 F6 | 	mov	ptra, fp
02c68     B3 00 A0 FD | 	call	#popregs_
02c6c                 | __system__ioctl_ret
02c6c     2D 00 64 FD | 	ret
02c70                 | 
02c70                 | __system__chdir
02c70     00 4C 05 F6 | 	mov	COUNT_, #0
02c74     A9 00 A0 FD | 	call	#pushregs_
02c78     40 F0 07 F1 | 	add	ptra, #64
02c7c     04 50 05 F1 | 	add	fp, #4
02c80     A8 0E 62 FC | 	wrlong	arg01, fp
02c84     04 50 05 F1 | 	add	fp, #4
02c88     A8 10 02 F6 | 	mov	arg02, fp
02c8c     08 50 85 F1 | 	sub	fp, #8
02c90     08 FC BF FD | 	call	#__system__stat
02c94     3C 50 05 F1 | 	add	fp, #60
02c98     A8 F4 61 FC | 	wrlong	result1, fp
02c9c     3C 50 85 F1 | 	sub	fp, #60
02ca0     00 F4 0D F2 | 	cmp	result1, #0 wz
02ca4     3C 50 05 51 |  if_ne	add	fp, #60
02ca8     A8 F4 01 5B |  if_ne	rdlong	result1, fp
02cac     3C 50 85 51 |  if_ne	sub	fp, #60
02cb0     BC 00 90 5D |  if_ne	jmp	#LR__0150
02cb4     10 50 05 F1 | 	add	fp, #16
02cb8     A8 12 02 FB | 	rdlong	arg03, fp
02cbc     10 50 85 F1 | 	sub	fp, #16
02cc0     78 00 00 FF 
02cc4     00 12 06 F5 | 	and	arg03, ##61440
02cc8     08 00 00 FF 
02ccc     00 12 0E F2 | 	cmp	arg03, ##4096 wz
02cd0     1C EE 05 51 |  if_ne	add	ptr___system__dat__, #28
02cd4     F7 1A 68 5C |  if_ne	wrlong	#13, ptr___system__dat__
02cd8     1C EE 85 51 |  if_ne	sub	ptr___system__dat__, #28
02cdc     01 F4 65 56 |  if_ne	neg	result1, #1
02ce0     8C 00 90 5D |  if_ne	jmp	#LR__0150
02ce4     04 50 05 F1 | 	add	fp, #4
02ce8     A8 12 02 FB | 	rdlong	arg03, fp
02cec     04 50 85 F1 | 	sub	fp, #4
02cf0     09 13 C2 FA | 	rdbyte	arg03, arg03
02cf4     2F 12 0E F2 | 	cmp	arg03, #47 wz
02cf8     24 00 90 5D |  if_ne	jmp	#LR__0148
02cfc     40 EE 05 F1 | 	add	ptr___system__dat__, #64
02d00     F7 0E 02 F6 | 	mov	arg01, ptr___system__dat__
02d04     40 EE 85 F1 | 	sub	ptr___system__dat__, #64
02d08     04 50 05 F1 | 	add	fp, #4
02d0c     A8 10 02 FB | 	rdlong	arg02, fp
02d10     04 50 85 F1 | 	sub	fp, #4
02d14     00 13 06 F6 | 	mov	arg03, #256
02d18     94 00 B0 FD | 	call	#__system__strncpy
02d1c     4C 00 90 FD | 	jmp	#LR__0149
02d20                 | LR__0148
02d20     40 EF 05 F1 | 	add	ptr___system__dat__, #320
02d24     F7 0E 02 F6 | 	mov	arg01, ptr___system__dat__
02d28     38 50 05 F1 | 	add	fp, #56
02d2c     A8 0E 62 FC | 	wrlong	arg01, fp
02d30     38 50 85 F1 | 	sub	fp, #56
02d34     00 EF 85 F1 | 	sub	ptr___system__dat__, #256
02d38     F7 10 02 F6 | 	mov	arg02, ptr___system__dat__
02d3c     40 EE 85 F1 | 	sub	ptr___system__dat__, #64
02d40     00 13 06 F6 | 	mov	arg03, #256
02d44     68 00 B0 FD | 	call	#__system__strncpy
02d48     38 50 05 F1 | 	add	fp, #56
02d4c     A8 0E 02 FB | 	rdlong	arg01, fp
02d50     34 50 85 F1 | 	sub	fp, #52
02d54     A8 10 02 FB | 	rdlong	arg02, fp
02d58     04 50 85 F1 | 	sub	fp, #4
02d5c     40 EE 05 F1 | 	add	ptr___system__dat__, #64
02d60     F7 12 02 F6 | 	mov	arg03, ptr___system__dat__
02d64     40 EE 85 F1 | 	sub	ptr___system__dat__, #64
02d68     80 E0 BF FD | 	call	#__system____getvfsforfile
02d6c                 | LR__0149
02d6c     00 F4 05 F6 | 	mov	result1, #0
02d70                 | LR__0150
02d70     A8 F0 03 F6 | 	mov	ptra, fp
02d74     B3 00 A0 FD | 	call	#popregs_
02d78                 | __system__chdir_ret
02d78     2D 00 64 FD | 	ret
02d7c                 | 
02d7c                 | __system____getftab
02d7c     0A 0E 16 F2 | 	cmp	arg01, #10 wc
02d80     00 F4 05 36 |  if_ae	mov	result1, #0
02d84     24 00 90 3D |  if_ae	jmp	#__system____getftab_ret
02d88     07 F5 01 F6 | 	mov	result1, arg01
02d8c     01 F4 65 F0 | 	shl	result1, #1
02d90     07 F5 01 F1 | 	add	result1, arg01
02d94     04 F4 65 F0 | 	shl	result1, #4
02d98     01 00 00 FF 
02d9c     48 EE 05 F1 | 	add	ptr___system__dat__, ##584
02da0     F7 F4 01 F1 | 	add	result1, ptr___system__dat__
02da4     01 00 00 FF 
02da8     48 EE 85 F1 | 	sub	ptr___system__dat__, ##584
02dac                 | __system____getftab_ret
02dac     2D 00 64 FD | 	ret
02db0                 | 
02db0                 | __system__strncpy
02db0     07 F9 01 F6 | 	mov	_var01, arg01
02db4                 | LR__0151
02db4     01 12 86 F1 | 	sub	arg03, #1
02db8     00 12 56 F2 | 	cmps	arg03, #0 wc
02dbc     18 00 90 CD |  if_b	jmp	#LR__0152
02dc0     08 F5 C1 FA | 	rdbyte	result1, arg02
02dc4     FC F4 41 FC | 	wrbyte	result1, _var01
02dc8     01 10 06 F1 | 	add	arg02, #1
02dcc     FC F4 C9 FA | 	rdbyte	result1, _var01 wz
02dd0     01 F8 05 F1 | 	add	_var01, #1
02dd4     DC FF 9F 5D |  if_ne	jmp	#LR__0151
02dd8                 | LR__0152
02dd8     3C D2 9F FE | 	loc	pa,	#(@LR__0154-@LR__0153)
02ddc     8C 00 A0 FD | 	call	#FCACHE_LOAD_
02de0                 | LR__0153
02de0     01 12 86 F1 | 	sub	arg03, #1
02de4     00 12 56 F2 | 	cmps	arg03, #0 wc
02de8     FC FA 01 36 |  if_ae	mov	_var02, _var01
02dec     01 F8 05 31 |  if_ae	add	_var01, #1
02df0     FD 00 48 3C |  if_ae	wrbyte	#0, _var02
02df4     E8 FF 9F 3D |  if_ae	jmp	#LR__0153
02df8                 | LR__0154
02df8     07 F5 01 F6 | 	mov	result1, arg01
02dfc                 | __system__strncpy_ret
02dfc     2D 00 64 FD | 	ret
02e00                 | 
02e00                 | __system__strncat
02e00     07 F9 01 F6 | 	mov	_var01, arg01
02e04     08 FB 01 F6 | 	mov	_var02, arg02
02e08     09 FD 01 F6 | 	mov	_var03, arg03
02e0c     FD FE 09 F6 | 	mov	_var04, _var02 wz
02e10     6C 00 90 AD |  if_e	jmp	#LR__0159
02e14     01 FC 15 F2 | 	cmp	_var03, #1 wc
02e18     64 00 90 CD |  if_b	jmp	#LR__0159
02e1c     FC 00 02 F6 | 	mov	_var05, _var01
02e20     2C D2 9F FE | 	loc	pa,	#(@LR__0157-@LR__0155)
02e24     8C 00 A0 FD | 	call	#FCACHE_LOAD_
02e28                 | LR__0155
02e28     00 03 CA FA | 	rdbyte	_var06, _var05 wz
02e2c     01 00 06 51 |  if_ne	add	_var05, #1
02e30     F4 FF 9F 5D |  if_ne	jmp	#LR__0155
02e34     FE 04 02 F6 | 	mov	_var07, _var03
02e38                 | LR__0156
02e38     FF 06 02 F6 | 	mov	_var08, _var04
02e3c     FF 08 02 F6 | 	mov	_var09, _var04
02e40     01 08 06 F1 | 	add	_var09, #1
02e44     04 FF 01 F6 | 	mov	_var04, _var09
02e48     03 0B C2 FA | 	rdbyte	_var10, _var08
02e4c     05 03 02 F6 | 	mov	_var06, _var10
02e50     07 02 4E F7 | 	zerox	_var06, #7 wz
02e54     20 00 90 AD |  if_e	jmp	#LR__0158
02e58     02 0D 02 F6 | 	mov	_var11, _var07
02e5c     01 0C 86 F1 | 	sub	_var11, #1
02e60     06 05 02 F6 | 	mov	_var07, _var11
02e64     00 04 56 F2 | 	cmps	_var07, #0 wc
02e68     00 03 02 36 |  if_ae	mov	_var06, _var05
02e6c     01 00 06 31 |  if_ae	add	_var05, #1
02e70     01 0B 42 3C |  if_ae	wrbyte	_var10, _var06
02e74     C0 FF 9F 3D |  if_ae	jmp	#LR__0156
02e78                 | LR__0157
02e78                 | LR__0158
02e78     00 02 06 F6 | 	mov	_var06, #0
02e7c     00 01 48 FC | 	wrbyte	#0, _var05
02e80                 | LR__0159
02e80     FC F4 01 F6 | 	mov	result1, _var01
02e84                 | __system__strncat_ret
02e84     2D 00 64 FD | 	ret
02e88                 | 
02e88                 | __system__strncmp
02e88     07 F9 09 F6 | 	mov	_var01, arg01 wz
02e8c     14 00 90 5D |  if_ne	jmp	#LR__0160
02e90     00 10 0E F2 | 	cmp	arg02, #0 wz
02e94     01 FA 65 56 |  if_ne	neg	_var02, #1
02e98     00 FA 05 A6 |  if_e	mov	_var02, #0
02e9c     FD F4 01 F6 | 	mov	result1, _var02
02ea0     88 00 90 FD | 	jmp	#__system__strncmp_ret
02ea4                 | LR__0160
02ea4     00 10 0E F2 | 	cmp	arg02, #0 wz
02ea8     01 F4 05 A6 |  if_e	mov	result1, #1
02eac     7C 00 90 AD |  if_e	jmp	#__system__strncmp_ret
02eb0     09 FD 01 F6 | 	mov	_var03, arg03
02eb4     84 D1 9F FE | 	loc	pa,	#(@LR__0162-@LR__0161)
02eb8     8C 00 A0 FD | 	call	#FCACHE_LOAD_
02ebc                 | LR__0161
02ebc     FC FE C1 FA | 	rdbyte	_var04, _var01
02ec0     08 01 02 F6 | 	mov	_var05, arg02
02ec4     08 03 02 F6 | 	mov	_var06, arg02
02ec8     01 02 06 F1 | 	add	_var06, #1
02ecc     01 11 02 F6 | 	mov	arg02, _var06
02ed0     00 05 C2 FA | 	rdbyte	_var07, _var05
02ed4     FE FA 01 F6 | 	mov	_var02, _var03
02ed8     01 FA 85 F1 | 	sub	_var02, #1
02edc     FD FC 01 F6 | 	mov	_var03, _var02
02ee0     00 FC 55 F2 | 	cmps	_var03, #0 wc
02ee4     01 F8 05 F1 | 	add	_var01, #1
02ee8     00 FE 0D 32 |  if_ae	cmp	_var04, #0 wz
02eec     08 00 90 2D |  if_nc_and_z	jmp	#LR__0163
02ef0     02 FF 09 32 |  if_ae	cmp	_var04, _var07 wz
02ef4     C4 FF 9F 2D |  if_nc_and_z	jmp	#LR__0161
02ef8                 | LR__0162
02ef8                 | LR__0163
02ef8     00 FC 55 F2 | 	cmps	_var03, #0 wc
02efc     00 F4 05 C6 |  if_b	mov	result1, #0
02f00     28 00 90 CD |  if_b	jmp	#__system__strncmp_ret
02f04     02 FF 09 F2 | 	cmp	_var04, _var07 wz
02f08     00 F4 05 A6 |  if_e	mov	result1, #0
02f0c     1C 00 90 AD |  if_e	jmp	#__system__strncmp_ret
02f10     00 FE 0D F2 | 	cmp	_var04, #0 wz
02f14     01 F4 65 A6 |  if_e	neg	result1, #1
02f18     10 00 90 AD |  if_e	jmp	#__system__strncmp_ret
02f1c     00 04 0E F2 | 	cmp	_var07, #0 wz
02f20     01 F4 05 A6 |  if_e	mov	result1, #1
02f24     FF F4 01 56 |  if_ne	mov	result1, _var04
02f28     02 F5 81 51 |  if_ne	sub	result1, _var07
02f2c                 | __system__strncmp_ret
02f2c     2D 00 64 FD | 	ret
02f30                 | 
02f30                 | __system___strrev
02f30     07 F9 C9 FA | 	rdbyte	_var01, arg01 wz
02f34     40 00 90 AD |  if_e	jmp	#__system___strrev_ret
02f38     07 FB 01 F6 | 	mov	_var02, arg01
02f3c     F4 D0 9F FE | 	loc	pa,	#(@LR__0166-@LR__0164)
02f40     8C 00 A0 FD | 	call	#FCACHE_LOAD_
02f44                 | LR__0164
02f44     FD F8 C9 FA | 	rdbyte	_var01, _var02 wz
02f48     01 FA 05 51 |  if_ne	add	_var02, #1
02f4c     F4 FF 9F 5D |  if_ne	jmp	#LR__0164
02f50     01 FA 85 F1 | 	sub	_var02, #1
02f54                 | LR__0165
02f54     07 FB 59 F2 | 	cmps	_var02, arg01 wcz
02f58     1C 00 90 ED |  if_be	jmp	#LR__0167
02f5c     07 F9 C1 FA | 	rdbyte	_var01, arg01
02f60     FD FC C1 FA | 	rdbyte	_var03, _var02
02f64     07 FD 41 FC | 	wrbyte	_var03, arg01
02f68     FD F8 41 FC | 	wrbyte	_var01, _var02
02f6c     01 0E 06 F1 | 	add	arg01, #1
02f70     01 FA 85 F1 | 	sub	_var02, #1
02f74     DC FF 9F FD | 	jmp	#LR__0165
02f78                 | LR__0166
02f78                 | LR__0167
02f78                 | __system___strrev_ret
02f78     2D 00 64 FD | 	ret
02f7c                 | 
02f7c                 | __system___fmtpad
02f7c     07 4C 05 F6 | 	mov	COUNT_, #7
02f80     A9 00 A0 FD | 	call	#pushregs_
02f84     07 19 02 F6 | 	mov	local01, arg01
02f88     08 1B 02 F6 | 	mov	local02, arg02
02f8c     09 1D 02 F6 | 	mov	local03, arg03
02f90     0D 0F EA F8 | 	getbyte	arg01, local02, #1
02f94     16 1A 46 F0 | 	shr	local02, #22
02f98     03 1A 0E F5 | 	and	local02, #3 wz
02f9c     00 1E 06 F6 | 	mov	local04, #0
02fa0     01 1A 06 A6 |  if_e	mov	local02, #1
02fa4     0A 1B CA F7 | 	test	local02, arg04 wz
02fa8     00 F4 05 A6 |  if_e	mov	result1, #0
02fac     80 00 90 AD |  if_e	jmp	#LR__0171
02fb0     07 1D C2 F2 | 	subr	local03, arg01
02fb4     01 1C 56 F2 | 	cmps	local03, #1 wc
02fb8     00 F4 05 C6 |  if_b	mov	result1, #0
02fbc     70 00 90 CD |  if_b	jmp	#LR__0171
02fc0     03 1A 0E F2 | 	cmp	local02, #3 wz
02fc4     18 00 90 5D |  if_ne	jmp	#LR__0168
02fc8     01 14 0E F2 | 	cmp	arg04, #1 wz
02fcc     6E 1A 62 FD | 	wrz	local02
02fd0     0D 1D 02 F1 | 	add	local03, local02
02fd4     0E 1D 52 F6 | 	abs	local03, local03 wc
02fd8     01 1C 46 F0 | 	shr	local03, #1
02fdc     0E 1D 82 F6 | 	negc	local03, local03
02fe0                 | LR__0168
02fe0     00 20 06 F6 | 	mov	local05, #0
02fe4                 | LR__0169
02fe4     0E 21 52 F2 | 	cmps	local05, local03 wc
02fe8     40 00 90 3D |  if_ae	jmp	#LR__0170
02fec     0C 23 02 F6 | 	mov	local06, local01
02ff0     11 25 02 FB | 	rdlong	local07, local06
02ff4     04 22 06 F1 | 	add	local06, #4
02ff8     11 23 02 FB | 	rdlong	local06, local06
02ffc     20 0E 06 F6 | 	mov	arg01, #32
03000     F1 1A 02 F6 | 	mov	local02, objptr
03004     12 E3 01 F6 | 	mov	objptr, local07
03008     2D 22 62 FD | 	call	local06
0300c     0D E3 01 F6 | 	mov	objptr, local02
03010     FA 22 02 F6 | 	mov	local06, result1
03014     00 22 56 F2 | 	cmps	local06, #0 wc
03018     11 F5 01 C6 |  if_b	mov	result1, local06
0301c     10 00 90 CD |  if_b	jmp	#LR__0171
03020     11 1F 02 F1 | 	add	local04, local06
03024     01 20 06 F1 | 	add	local05, #1
03028     B8 FF 9F FD | 	jmp	#LR__0169
0302c                 | LR__0170
0302c     0F F5 01 F6 | 	mov	result1, local04
03030                 | LR__0171
03030     A8 F0 03 F6 | 	mov	ptra, fp
03034     B3 00 A0 FD | 	call	#popregs_
03038                 | __system___fmtpad_ret
03038     2D 00 64 FD | 	ret
0303c                 | 
0303c                 | __system___uitoa
0303c     08 4C 05 F6 | 	mov	COUNT_, #8
03040     A9 00 A0 FD | 	call	#pushregs_
03044     07 19 02 F6 | 	mov	local01, arg01
03048     08 1B 02 F6 | 	mov	local02, arg02
0304c     09 1D 02 F6 | 	mov	local03, arg03
03050     0A 1F 02 F6 | 	mov	local04, arg04
03054     0B 21 0A F6 | 	mov	local05, arg05 wz
03058     0C 23 02 F6 | 	mov	local06, local01
0305c     00 24 06 F6 | 	mov	local07, #0
03060     37 26 06 56 |  if_ne	mov	local08, #55
03064     57 26 06 A6 |  if_e	mov	local08, #87
03068                 | LR__0172
03068     0E 1B 12 FD | 	qdiv	local02, local03
0306c     19 20 62 FD | 	getqy	local05
03070     0E 1B 12 FD | 	qdiv	local02, local03
03074     0A 20 16 F2 | 	cmp	local05, #10 wc
03078     30 20 06 C1 |  if_b	add	local05, #48
0307c     13 21 02 31 |  if_ae	add	local05, local08
03080     11 21 42 FC | 	wrbyte	local05, local06
03084     01 24 06 F1 | 	add	local07, #1
03088     01 22 06 F1 | 	add	local06, #1
0308c     18 1A 62 FD | 	getqx	local02
03090     00 1A 0E F2 | 	cmp	local02, #0 wz
03094     D0 FF 9F 5D |  if_ne	jmp	#LR__0172
03098     0F 25 12 F2 | 	cmp	local07, local04 wc
0309c     C8 FF 9F CD |  if_b	jmp	#LR__0172
030a0     11 01 48 FC | 	wrbyte	#0, local06
030a4     0C 0F 02 F6 | 	mov	arg01, local01
030a8     84 FE BF FD | 	call	#__system___strrev
030ac     12 F5 01 F6 | 	mov	result1, local07
030b0     A8 F0 03 F6 | 	mov	ptra, fp
030b4     B3 00 A0 FD | 	call	#popregs_
030b8                 | __system___uitoa_ret
030b8     2D 00 64 FD | 	ret
030bc                 | 
030bc                 | __system___gettxfunc
030bc     02 4C 05 F6 | 	mov	COUNT_, #2
030c0     A9 00 A0 FD | 	call	#pushregs_
030c4     B4 FC BF FD | 	call	#__system____getftab
030c8     FA 18 0A F6 | 	mov	local01, result1 wz
030cc     08 18 06 51 |  if_ne	add	local01, #8
030d0     0C 1B 02 5B |  if_ne	rdlong	local02, local01
030d4     08 18 86 51 |  if_ne	sub	local01, #8
030d8     0D 1B 0A 56 |  if_ne	mov	local02, local02 wz
030dc     F2 10 02 56 |  if_ne	mov	arg02, ptr___struct__s_vfs_file_t_putchar_
030e0     0C 0F 02 56 |  if_ne	mov	arg01, local01
030e4     20 DA BF 5D |  if_ne	call	#__system___make_methodptr
030e8     A8 F0 03 F6 | 	mov	ptra, fp
030ec     B3 00 A0 FD | 	call	#popregs_
030f0                 | __system___gettxfunc_ret
030f0     2D 00 64 FD | 	ret
030f4                 | 
030f4                 | __system___getiolock_0110
030f4     02 4C 05 F6 | 	mov	COUNT_, #2
030f8     A9 00 A0 FD | 	call	#pushregs_
030fc     7C FC BF FD | 	call	#__system____getftab
03100     FA 18 0A F6 | 	mov	local01, result1 wz
03104     08 18 06 51 |  if_ne	add	local01, #8
03108     0C 1B 02 5B |  if_ne	rdlong	local02, local01
0310c     08 18 86 51 |  if_ne	sub	local01, #8
03110     0D 1B 0A 56 |  if_ne	mov	local02, local02 wz
03114     01 00 00 AF 
03118     40 EE 05 A1 |  if_e	add	ptr___system__dat__, ##576
0311c     F7 F4 01 A6 |  if_e	mov	result1, ptr___system__dat__
03120     01 00 00 AF 
03124     40 EE 85 A1 |  if_e	sub	ptr___system__dat__, ##576
03128     0C 18 06 51 |  if_ne	add	local01, #12
0312c     0C F5 01 56 |  if_ne	mov	result1, local01
03130     A8 F0 03 F6 | 	mov	ptra, fp
03134     B3 00 A0 FD | 	call	#popregs_
03138                 | __system___getiolock_0110_ret
03138     2D 00 64 FD | 	ret
0313c                 | 
0313c                 | __system___rxtxioctl_0135
0313c     02 4C 05 F6 | 	mov	COUNT_, #2
03140     A9 00 A0 FD | 	call	#pushregs_
03144     08 19 02 F6 | 	mov	local01, arg02
03148     09 1B 02 F6 | 	mov	local02, arg03
0314c     00 19 0E F2 | 	cmp	local01, #256 wz
03150     0C 00 90 AD |  if_e	jmp	#LR__0173
03154     01 19 0E F2 | 	cmp	local01, #257 wz
03158     1C 00 90 AD |  if_e	jmp	#LR__0174
0315c     30 00 90 FD | 	jmp	#LR__0175
03160                 | LR__0173
03160     08 EE 05 F1 | 	add	ptr___system__dat__, #8
03164     F7 F4 01 FB | 	rdlong	result1, ptr___system__dat__
03168     08 EE 85 F1 | 	sub	ptr___system__dat__, #8
0316c     0D F5 61 FC | 	wrlong	result1, local02
03170     00 F4 05 F6 | 	mov	result1, #0
03174     28 00 90 FD | 	jmp	#LR__0176
03178                 | LR__0174
03178     0D 0F 02 FB | 	rdlong	arg01, local02
0317c     08 EE 05 F1 | 	add	ptr___system__dat__, #8
03180     F7 0E 62 FC | 	wrlong	arg01, ptr___system__dat__
03184     08 EE 85 F1 | 	sub	ptr___system__dat__, #8
03188     00 F4 05 F6 | 	mov	result1, #0
0318c     10 00 90 FD | 	jmp	#LR__0176
03190                 | LR__0175
03190     1C EE 05 F1 | 	add	ptr___system__dat__, #28
03194     F7 14 68 FC | 	wrlong	#10, ptr___system__dat__
03198     1C EE 85 F1 | 	sub	ptr___system__dat__, #28
0319c     01 F4 65 F6 | 	neg	result1, #1
031a0                 | LR__0176
031a0     A8 F0 03 F6 | 	mov	ptra, fp
031a4     B3 00 A0 FD | 	call	#popregs_
031a8                 | __system___rxtxioctl_0135_ret
031a8     2D 00 64 FD | 	ret
031ac                 | 
031ac                 | __system____dummy_flush_0136
031ac     00 F4 05 F6 | 	mov	result1, #0
031b0                 | __system____dummy_flush_0136_ret
031b0     2D 00 64 FD | 	ret
031b4                 | 
031b4                 | __system___vfswrite
031b4     09 4C 05 F6 | 	mov	COUNT_, #9
031b8     A9 00 A0 FD | 	call	#pushregs_
031bc     07 19 02 F6 | 	mov	local01, arg01
031c0     08 1B 02 F6 | 	mov	local02, arg02
031c4     09 1D 02 F6 | 	mov	local03, arg03
031c8     0D 1F 02 F6 | 	mov	local04, local02
031cc     08 18 06 F1 | 	add	local01, #8
031d0     0C 0F 02 FB | 	rdlong	arg01, local01
031d4     08 18 86 F1 | 	sub	local01, #8
031d8     02 0E CE F7 | 	test	arg01, #2 wz
031dc     1C EE 05 A1 |  if_e	add	ptr___system__dat__, #28
031e0     F7 0C 68 AC |  if_e	wrlong	#6, ptr___system__dat__
031e4     1C EE 85 A1 |  if_e	sub	ptr___system__dat__, #28
031e8     01 F4 65 A6 |  if_e	neg	result1, #1
031ec     5C 01 90 AD |  if_e	jmp	#LR__0183
031f0     08 18 06 F1 | 	add	local01, #8
031f4     0C F5 01 FB | 	rdlong	result1, local01
031f8     08 18 86 F1 | 	sub	local01, #8
031fc     40 F4 CD F7 | 	test	result1, #64 wz
03200     5C 00 90 AD |  if_e	jmp	#LR__0178
03204     08 18 06 F1 | 	add	local01, #8
03208     0C F5 01 FB | 	rdlong	result1, local01
0320c     08 18 86 F1 | 	sub	local01, #8
03210     80 F4 CD F7 | 	test	result1, #128 wz
03214     48 00 90 AD |  if_e	jmp	#LR__0177
03218     2C 18 06 F1 | 	add	local01, #44
0321c     0C 13 02 FB | 	rdlong	arg03, local01
03220     2C 18 86 F1 | 	sub	local01, #44
03224     09 21 02 FB | 	rdlong	local05, arg03
03228     04 12 06 F1 | 	add	arg03, #4
0322c     09 23 02 FB | 	rdlong	local06, arg03
03230     0C 0F 02 F6 | 	mov	arg01, local01
03234     00 10 06 F6 | 	mov	arg02, #0
03238     02 12 06 F6 | 	mov	arg03, #2
0323c     F1 24 02 F6 | 	mov	local07, objptr
03240     10 E3 01 F6 | 	mov	objptr, local05
03244     2D 22 62 FD | 	call	local06
03248     12 E3 01 F6 | 	mov	objptr, local07
0324c     08 18 06 F1 | 	add	local01, #8
03250     0C 25 02 FB | 	rdlong	local07, local01
03254     80 24 26 F5 | 	andn	local07, #128
03258     0C 25 62 FC | 	wrlong	local07, local01
0325c     08 18 86 F1 | 	sub	local01, #8
03260                 | LR__0177
03260                 | LR__0178
03260     14 18 06 F1 | 	add	local01, #20
03264     0C 25 0A FB | 	rdlong	local07, local01 wz
03268     14 18 86 F1 | 	sub	local01, #20
0326c     74 00 90 AD |  if_e	jmp	#LR__0180
03270     14 18 06 F1 | 	add	local01, #20
03274     0C 25 02 FB | 	rdlong	local07, local01
03278     14 18 86 F1 | 	sub	local01, #20
0327c     12 21 02 FB | 	rdlong	local05, local07
03280     04 24 06 F1 | 	add	local07, #4
03284     12 23 02 FB | 	rdlong	local06, local07
03288     0D 11 02 F6 | 	mov	arg02, local02
0328c     0E 13 02 F6 | 	mov	arg03, local03
03290     0C 0F 02 F6 | 	mov	arg01, local01
03294     F1 24 02 F6 | 	mov	local07, objptr
03298     10 E3 01 F6 | 	mov	objptr, local05
0329c     2D 22 62 FD | 	call	local06
032a0     12 E3 01 F6 | 	mov	objptr, local07
032a4     FA 26 02 F6 | 	mov	local08, result1
032a8     00 26 56 F2 | 	cmps	local08, #0 wc
032ac     2C 00 90 3D |  if_ae	jmp	#LR__0179
032b0     08 18 06 F1 | 	add	local01, #8
032b4     0C 25 02 FB | 	rdlong	local07, local01
032b8     20 24 46 F5 | 	or	local07, #32
032bc     0C 25 62 FC | 	wrlong	local07, local01
032c0     1C EE 05 F1 | 	add	ptr___system__dat__, #28
032c4     F7 26 62 FC | 	wrlong	local08, ptr___system__dat__
032c8     1C EE 85 F1 | 	sub	ptr___system__dat__, #28
032cc     00 26 0E F2 | 	cmp	local08, #0 wz
032d0     01 F4 65 56 |  if_ne	neg	result1, #1
032d4     00 F4 05 A6 |  if_e	mov	result1, #0
032d8     70 00 90 FD | 	jmp	#LR__0183
032dc                 | LR__0179
032dc     13 F5 01 F6 | 	mov	result1, local08
032e0     68 00 90 FD | 	jmp	#LR__0183
032e4                 | LR__0180
032e4     18 18 06 F1 | 	add	local01, #24
032e8     0C 29 0A FB | 	rdlong	local09, local01 wz
032ec     18 18 86 F1 | 	sub	local01, #24
032f0     1C EE 05 A1 |  if_e	add	ptr___system__dat__, #28
032f4     F7 0C 68 AC |  if_e	wrlong	#6, ptr___system__dat__
032f8     1C EE 85 A1 |  if_e	sub	ptr___system__dat__, #28
032fc     01 F4 65 A6 |  if_e	neg	result1, #1
03300     48 00 90 AD |  if_e	jmp	#LR__0183
03304     00 26 06 F6 | 	mov	local08, #0
03308                 | LR__0181
03308     01 1C 16 F2 | 	cmp	local03, #1 wc
0330c     38 00 90 CD |  if_b	jmp	#LR__0182
03310     14 25 02 F6 | 	mov	local07, local09
03314     12 21 02 FB | 	rdlong	local05, local07
03318     04 24 06 F1 | 	add	local07, #4
0331c     12 23 02 FB | 	rdlong	local06, local07
03320     0F 0F C2 FA | 	rdbyte	arg01, local04
03324     0C 11 02 F6 | 	mov	arg02, local01
03328     F1 24 02 F6 | 	mov	local07, objptr
0332c     10 E3 01 F6 | 	mov	objptr, local05
03330     01 1E 06 F1 | 	add	local04, #1
03334     2D 22 62 FD | 	call	local06
03338     12 E3 01 F6 | 	mov	objptr, local07
0333c     FA 26 02 F1 | 	add	local08, result1
03340     01 1C 86 F1 | 	sub	local03, #1
03344     C0 FF 9F FD | 	jmp	#LR__0181
03348                 | LR__0182
03348     13 F5 01 F6 | 	mov	result1, local08
0334c                 | LR__0183
0334c     A8 F0 03 F6 | 	mov	ptra, fp
03350     B3 00 A0 FD | 	call	#popregs_
03354                 | __system___vfswrite_ret
03354     2D 00 64 FD | 	ret
03358                 | 
03358                 | __system___vfsread
03358     0B 4C 05 F6 | 	mov	COUNT_, #11
0335c     A9 00 A0 FD | 	call	#pushregs_
03360     28 F0 07 F1 | 	add	ptra, #40
03364     04 50 05 F1 | 	add	fp, #4
03368     A8 0E 62 FC | 	wrlong	arg01, fp
0336c     04 50 05 F1 | 	add	fp, #4
03370     A8 10 62 FC | 	wrlong	arg02, fp
03374     04 50 05 F1 | 	add	fp, #4
03378     A8 12 62 FC | 	wrlong	arg03, fp
0337c     04 50 85 F1 | 	sub	fp, #4
03380     A8 18 02 FB | 	rdlong	local01, fp
03384     14 50 05 F1 | 	add	fp, #20
03388     A8 18 62 FC | 	wrlong	local01, fp
0338c     04 50 05 F1 | 	add	fp, #4
03390     A8 00 68 FC | 	wrlong	#0, fp
03394     1C 50 85 F1 | 	sub	fp, #28
03398     A8 1A 02 FB | 	rdlong	local02, fp
0339c     04 50 85 F1 | 	sub	fp, #4
033a0     08 1A 06 F1 | 	add	local02, #8
033a4     0D 19 02 FB | 	rdlong	local01, local02
033a8     01 18 CE F7 | 	test	local01, #1 wz
033ac     1C EE 05 A1 |  if_e	add	ptr___system__dat__, #28
033b0     F7 0C 68 AC |  if_e	wrlong	#6, ptr___system__dat__
033b4     1C EE 85 A1 |  if_e	sub	ptr___system__dat__, #28
033b8     01 F4 65 A6 |  if_e	neg	result1, #1
033bc     70 02 90 AD |  if_e	jmp	#LR__0190
033c0     04 50 05 F1 | 	add	fp, #4
033c4     A8 18 02 FB | 	rdlong	local01, fp
033c8     04 50 85 F1 | 	sub	fp, #4
033cc     10 18 06 F1 | 	add	local01, #16
033d0     0C 19 0A FB | 	rdlong	local01, local01 wz
033d4     AC 00 90 AD |  if_e	jmp	#LR__0185
033d8     04 50 05 F1 | 	add	fp, #4
033dc     A8 0E 02 FB | 	rdlong	arg01, fp
033e0     07 1B 02 F6 | 	mov	local02, arg01
033e4     10 1A 06 F1 | 	add	local02, #16
033e8     0D 19 02 FB | 	rdlong	local01, local02
033ec     0C 1B 02 FB | 	rdlong	local02, local01
033f0     04 18 06 F1 | 	add	local01, #4
033f4     0C 19 02 FB | 	rdlong	local01, local01
033f8     04 50 05 F1 | 	add	fp, #4
033fc     A8 10 02 FB | 	rdlong	arg02, fp
03400     04 50 05 F1 | 	add	fp, #4
03404     A8 12 02 FB | 	rdlong	arg03, fp
03408     0C 50 85 F1 | 	sub	fp, #12
0340c     F1 1C 02 F6 | 	mov	local03, objptr
03410     0D E3 01 F6 | 	mov	objptr, local02
03414     2D 18 62 FD | 	call	local01
03418     0E E3 01 F6 | 	mov	objptr, local03
0341c     10 50 05 F1 | 	add	fp, #16
03420     A8 F4 61 FC | 	wrlong	result1, fp
03424     10 50 85 F1 | 	sub	fp, #16
03428     00 F4 55 F2 | 	cmps	result1, #0 wc
0342c     44 00 90 3D |  if_ae	jmp	#LR__0184
03430     04 50 05 F1 | 	add	fp, #4
03434     A8 1C 02 FB | 	rdlong	local03, fp
03438     0E 19 02 F6 | 	mov	local01, local03
0343c     08 1C 06 F1 | 	add	local03, #8
03440     0E 1D 02 FB | 	rdlong	local03, local03
03444     20 1C 46 F5 | 	or	local03, #32
03448     08 18 06 F1 | 	add	local01, #8
0344c     0C 1D 62 FC | 	wrlong	local03, local01
03450     0C 50 05 F1 | 	add	fp, #12
03454     A8 0E 0A FB | 	rdlong	arg01, fp wz
03458     10 50 85 F1 | 	sub	fp, #16
0345c     1C EE 05 F1 | 	add	ptr___system__dat__, #28
03460     F7 0E 62 FC | 	wrlong	arg01, ptr___system__dat__
03464     1C EE 85 F1 | 	sub	ptr___system__dat__, #28
03468     01 F4 65 56 |  if_ne	neg	result1, #1
0346c     00 F4 05 A6 |  if_e	mov	result1, #0
03470     BC 01 90 FD | 	jmp	#LR__0190
03474                 | LR__0184
03474     10 50 05 F1 | 	add	fp, #16
03478     A8 F4 01 FB | 	rdlong	result1, fp
0347c     10 50 85 F1 | 	sub	fp, #16
03480     AC 01 90 FD | 	jmp	#LR__0190
03484                 | LR__0185
03484     04 50 05 F1 | 	add	fp, #4
03488     A8 18 02 FB | 	rdlong	local01, fp
0348c     1C 18 06 F1 | 	add	local01, #28
03490     0C 19 0A FB | 	rdlong	local01, local01 wz
03494     14 50 05 F1 | 	add	fp, #20
03498     A8 18 62 FC | 	wrlong	local01, fp
0349c     18 50 85 F1 | 	sub	fp, #24
034a0     1C EE 05 A1 |  if_e	add	ptr___system__dat__, #28
034a4     F7 0C 68 AC |  if_e	wrlong	#6, ptr___system__dat__
034a8     1C EE 85 A1 |  if_e	sub	ptr___system__dat__, #28
034ac     01 F4 65 A6 |  if_e	neg	result1, #1
034b0     7C 01 90 AD |  if_e	jmp	#LR__0190
034b4     04 50 05 F1 | 	add	fp, #4
034b8     A8 18 02 FB | 	rdlong	local01, fp
034bc     04 50 85 F1 | 	sub	fp, #4
034c0     24 18 06 F1 | 	add	local01, #36
034c4     0C 1F 0A FB | 	rdlong	local04, local01 wz
034c8     90 00 90 AD |  if_e	jmp	#LR__0187
034cc     04 50 05 F1 | 	add	fp, #4
034d0     A8 20 02 FB | 	rdlong	local05, fp
034d4     10 23 02 F6 | 	mov	local06, local05
034d8     24 22 06 F1 | 	add	local06, #36
034dc     11 25 02 FB | 	rdlong	local07, local06
034e0     12 19 02 F6 | 	mov	local01, local07
034e4     0C 1B 02 FB | 	rdlong	local02, local01
034e8     04 18 06 F1 | 	add	local01, #4
034ec     0C 27 02 FB | 	rdlong	local08, local01
034f0     13 1F 02 F6 | 	mov	local04, local08
034f4     10 29 02 F6 | 	mov	local09, local05
034f8     00 2B 06 F6 | 	mov	local10, #256
034fc     20 50 05 F1 | 	add	fp, #32
03500     A8 2C 02 F6 | 	mov	local11, fp
03504     14 0F 02 F6 | 	mov	arg01, local09
03508     00 11 06 F6 | 	mov	arg02, #256
0350c     16 13 02 F6 | 	mov	arg03, local11
03510     F1 1C 02 F6 | 	mov	local03, objptr
03514     0D E3 01 F6 | 	mov	objptr, local02
03518     24 50 85 F1 | 	sub	fp, #36
0351c     2D 1E 62 FD | 	call	local04
03520     0E E3 01 F6 | 	mov	objptr, local03
03524     10 50 05 F1 | 	add	fp, #16
03528     A8 F4 61 FC | 	wrlong	result1, fp
0352c     FA 1A 0A F6 | 	mov	local02, result1 wz
03530     10 50 85 F1 | 	sub	fp, #16
03534     24 00 90 5D |  if_ne	jmp	#LR__0186
03538     24 50 05 F1 | 	add	fp, #36
0353c     A8 22 02 FB | 	rdlong	local06, fp
03540     24 50 85 F1 | 	sub	fp, #36
03544     11 1F 02 F6 | 	mov	local04, local06
03548     02 1E 0E F5 | 	and	local04, #2 wz
0354c     01 18 06 56 |  if_ne	mov	local01, #1
03550     20 50 05 51 |  if_ne	add	fp, #32
03554     A8 02 68 5C |  if_ne	wrlong	#1, fp
03558     20 50 85 51 |  if_ne	sub	fp, #32
0355c                 | LR__0186
0355c                 | LR__0187
0355c     10 50 05 F1 | 	add	fp, #16
03560     A8 00 68 FC | 	wrlong	#0, fp
03564     10 50 85 F1 | 	sub	fp, #16
03568                 | LR__0188
03568     0C 50 05 F1 | 	add	fp, #12
0356c     A8 18 02 FB | 	rdlong	local01, fp
03570     0C 50 85 F1 | 	sub	fp, #12
03574     01 18 16 F2 | 	cmp	local01, #1 wc
03578     A8 00 90 CD |  if_b	jmp	#LR__0189
0357c     18 50 05 F1 | 	add	fp, #24
03580     A8 18 02 FB | 	rdlong	local01, fp
03584     0C 1B 02 FB | 	rdlong	local02, local01
03588     04 18 06 F1 | 	add	local01, #4
0358c     0C 1F 02 FB | 	rdlong	local04, local01
03590     14 50 85 F1 | 	sub	fp, #20
03594     A8 0E 02 FB | 	rdlong	arg01, fp
03598     04 50 85 F1 | 	sub	fp, #4
0359c     F1 26 02 F6 | 	mov	local08, objptr
035a0     0D E3 01 F6 | 	mov	objptr, local02
035a4     2D 1E 62 FD | 	call	local04
035a8     13 E3 01 F6 | 	mov	objptr, local08
035ac     14 50 05 F1 | 	add	fp, #20
035b0     A8 F4 61 FC | 	wrlong	result1, fp
035b4     14 50 85 F1 | 	sub	fp, #20
035b8     00 F4 55 F2 | 	cmps	result1, #0 wc
035bc     64 00 90 CD |  if_b	jmp	#LR__0189
035c0     1C 50 05 F1 | 	add	fp, #28
035c4     A8 1A 02 FB | 	rdlong	local02, fp
035c8     0D 1F 02 F6 | 	mov	local04, local02
035cc     01 1E 06 F1 | 	add	local04, #1
035d0     A8 1E 62 FC | 	wrlong	local04, fp
035d4     08 50 85 F1 | 	sub	fp, #8
035d8     A8 20 02 FB | 	rdlong	local05, fp
035dc     0D 21 42 FC | 	wrbyte	local05, local02
035e0     04 50 85 F1 | 	sub	fp, #4
035e4     A8 18 02 FB | 	rdlong	local01, fp
035e8     01 18 06 F1 | 	add	local01, #1
035ec     A8 18 62 FC | 	wrlong	local01, fp
035f0     04 50 85 F1 | 	sub	fp, #4
035f4     A8 18 02 FB | 	rdlong	local01, fp
035f8     01 18 86 F1 | 	sub	local01, #1
035fc     A8 18 62 FC | 	wrlong	local01, fp
03600     14 50 05 F1 | 	add	fp, #20
03604     A8 18 0A FB | 	rdlong	local01, fp wz
03608     20 50 85 F1 | 	sub	fp, #32
0360c     58 FF 9F AD |  if_e	jmp	#LR__0188
03610     14 50 05 F1 | 	add	fp, #20
03614     A8 1E 02 FB | 	rdlong	local04, fp
03618     14 50 85 F1 | 	sub	fp, #20
0361c     0A 1E 0E F2 | 	cmp	local04, #10 wz
03620     44 FF 9F 5D |  if_ne	jmp	#LR__0188
03624                 | LR__0189
03624     10 50 05 F1 | 	add	fp, #16
03628     A8 F4 01 FB | 	rdlong	result1, fp
0362c     10 50 85 F1 | 	sub	fp, #16
03630                 | LR__0190
03630     A8 F0 03 F6 | 	mov	ptra, fp
03634     B3 00 A0 FD | 	call	#popregs_
03638                 | __system___vfsread_ret
03638     2D 00 64 FD | 	ret
0363c                 | 
0363c                 | __system____default_filbuf
0363c     04 4C 05 F6 | 	mov	COUNT_, #4
03640     A9 00 A0 FD | 	call	#pushregs_
03644     07 19 02 FB | 	rdlong	local01, arg01
03648     10 0E 06 F1 | 	add	arg01, #16
0364c     07 13 02 FB | 	rdlong	arg03, arg01
03650     10 0E 86 F1 | 	sub	arg01, #16
03654     09 1B 02 FB | 	rdlong	local02, arg03
03658     04 12 06 F1 | 	add	arg03, #4
0365c     09 1D 02 FB | 	rdlong	local03, arg03
03660     0C 18 06 F1 | 	add	local01, #12
03664     0C 11 02 F6 | 	mov	arg02, local01
03668     0C 18 86 F1 | 	sub	local01, #12
0366c     0A 12 C6 F9 | 	decod	arg03, #10
03670     F1 1E 02 F6 | 	mov	local04, objptr
03674     0D E3 01 F6 | 	mov	objptr, local02
03678     2D 1C 62 FD | 	call	local03
0367c     0F E3 01 F6 | 	mov	objptr, local04
03680     FA 1E 02 F6 | 	mov	local04, result1
03684     00 1E 56 F2 | 	cmps	local04, #0 wc
03688     01 F4 65 C6 |  if_b	neg	result1, #1
0368c     28 00 90 CD |  if_b	jmp	#LR__0191
03690     0C 1F 62 FC | 	wrlong	local04, local01
03694     0C 18 06 F1 | 	add	local01, #12
03698     0C 1D 02 F6 | 	mov	local03, local01
0369c     08 18 86 F1 | 	sub	local01, #8
036a0     0C 1D 62 FC | 	wrlong	local03, local01
036a4     04 18 06 F1 | 	add	local01, #4
036a8     0C 1D 02 FB | 	rdlong	local03, local01
036ac     01 1C 46 F5 | 	or	local03, #1
036b0     0C 1D 62 FC | 	wrlong	local03, local01
036b4     0F F5 01 F6 | 	mov	result1, local04
036b8                 | LR__0191
036b8     A8 F0 03 F6 | 	mov	ptra, fp
036bc     B3 00 A0 FD | 	call	#popregs_
036c0                 | __system____default_filbuf_ret
036c0     2D 00 64 FD | 	ret
036c4                 | 
036c4                 | _ff_cc_ff_oem2uni
036c4     00 F8 05 F6 | 	mov	_var01, #0
036c8     01 00 00 FF 
036cc     84 F1 05 F1 | 	add	ptr__ff_cc_dat__, ##900
036d0     F8 FA 01 F6 | 	mov	_var02, ptr__ff_cc_dat__
036d4     07 F5 31 F9 | 	getword	result1, arg01, #0
036d8     80 F4 15 F2 | 	cmp	result1, #128 wc
036dc     01 00 00 FF 
036e0     84 F1 85 F1 | 	sub	ptr__ff_cc_dat__, ##900
036e4     07 F9 01 C6 |  if_b	mov	_var01, arg01
036e8     2C 00 90 CD |  if_b	jmp	#LR__0193
036ec     08 11 32 F9 | 	getword	arg02, arg02, #0
036f0     01 00 00 FF 
036f4     52 11 0E F2 | 	cmp	arg02, ##850 wz
036f8     1C 00 90 5D |  if_ne	jmp	#LR__0192
036fc     07 F5 31 F9 | 	getword	result1, arg01, #0
03700     00 F5 15 F2 | 	cmp	result1, #256 wc
03704     07 0F 32 C9 |  if_b	getword	arg01, arg01, #0
03708     80 0E 86 C1 |  if_b	sub	arg01, #128
0370c     01 0E 66 C0 |  if_b	shl	arg01, #1
03710     FD 0E 02 C1 |  if_b	add	arg01, _var02
03714     07 F9 E1 CA |  if_b	rdword	_var01, arg01
03718                 | LR__0192
03718                 | LR__0193
03718                 | ' 		}
03718                 | ' 	}
03718                 | ' 
03718                 | ' 	return c;
03718     FC F4 01 F6 | 	mov	result1, _var01
0371c                 | _ff_cc_ff_oem2uni_ret
0371c     2D 00 64 FD | 	ret
03720                 | 
03720                 | _ff_cc_ff_uni2oem
03720     07 F9 01 F6 | 	mov	_var01, arg01
03724     08 FB 01 F6 | 	mov	_var02, arg02
03728     00 FC 05 F6 | 	mov	_var03, #0
0372c     01 00 00 FF 
03730     84 F1 05 F1 | 	add	ptr__ff_cc_dat__, ##900
03734     F8 FE 01 F6 | 	mov	_var04, ptr__ff_cc_dat__
03738     80 F8 15 F2 | 	cmp	_var01, #128 wc
0373c     01 00 00 FF 
03740     84 F1 85 F1 | 	sub	ptr__ff_cc_dat__, ##900
03744     FC FC 01 C6 |  if_b	mov	_var03, _var01
03748     74 00 90 CD |  if_b	jmp	#LR__0198
0374c     80 00 00 FF 
03750     00 F8 15 F2 | 	cmp	_var01, ##65536 wc
03754     68 00 90 3D |  if_ae	jmp	#LR__0197
03758     FD 00 32 F9 | 	getword	_var05, _var02, #0
0375c     01 00 00 FF 
03760     52 01 0E F2 | 	cmp	_var05, ##850 wz
03764     58 00 90 5D |  if_ne	jmp	#LR__0197
03768                 | ' 			for (c = 0; c < 0x80 && uni != p[c]; c++) ;
03768     00 FC 05 F6 | 	mov	_var03, #0
0376c     CC C8 9F FE | 	loc	pa,	#(@LR__0195-@LR__0194)
03770     8C 00 A0 FD | 	call	#FCACHE_LOAD_
03774                 | LR__0194
03774     FE 00 32 F9 | 	getword	_var05, _var03, #0
03778     80 00 16 F2 | 	cmp	_var05, #128 wc
0377c     30 00 90 3D |  if_ae	jmp	#LR__0196
03780     FE 02 02 F6 | 	mov	_var06, _var03
03784     01 05 02 F6 | 	mov	_var07, _var06
03788     01 04 66 F0 | 	shl	_var07, #1
0378c     FF 06 02 F6 | 	mov	_var08, _var04
03790     FF 04 02 F1 | 	add	_var07, _var04
03794     02 09 E2 FA | 	rdword	_var09, _var07
03798     04 F9 09 F2 | 	cmp	_var01, _var09 wz
0379c     FE 0A 02 56 |  if_ne	mov	_var10, _var03
037a0     FE 0C 02 56 |  if_ne	mov	_var11, _var03
037a4     01 0C 06 51 |  if_ne	add	_var11, #1
037a8     06 FD 01 56 |  if_ne	mov	_var03, _var11
037ac     C4 FF 9F 5D |  if_ne	jmp	#LR__0194
037b0                 | LR__0195
037b0                 | LR__0196
037b0     FE 00 32 F9 | 	getword	_var05, _var03, #0
037b4     80 00 06 F1 | 	add	_var05, #128
037b8     00 01 E2 F8 | 	getbyte	_var05, _var05, #0
037bc     00 FD 01 F6 | 	mov	_var03, _var05
037c0                 | LR__0197
037c0                 | LR__0198
037c0                 | ' 			c = (c + 0x80) & 0xFF;
037c0                 | ' 		}
037c0                 | ' 	}
037c0                 | ' 
037c0                 | ' 	return c;
037c0     FE F4 01 F6 | 	mov	result1, _var03
037c4                 | _ff_cc_ff_uni2oem_ret
037c4     2D 00 64 FD | 	ret
037c8                 | 
037c8                 | _ff_cc_ff_wtoupper
037c8     07 F9 01 F6 | 	mov	_var01, arg01
037cc     80 00 00 FF 
037d0     00 F8 15 F2 | 	cmp	_var01, ##65536 wc
037d4     74 01 90 3D |  if_ae	jmp	#LR__0212
037d8     FC FA 01 F6 | 	mov	_var02, _var01
037dc     FD F8 31 F9 | 	getword	_var01, _var02, #0
037e0     08 00 00 FF 
037e4     00 F8 15 F2 | 	cmp	_var01, ##4096 wc
037e8     02 00 00 CF 
037ec     84 F0 05 C1 |  if_b	add	ptr__ff_cc_dat__, ##1156
037f0     F8 FC 01 C6 |  if_b	mov	_var03, ptr__ff_cc_dat__
037f4     02 00 00 CF 
037f8     84 F0 85 C1 |  if_b	sub	ptr__ff_cc_dat__, ##1156
037fc     03 00 00 3F 
03800     76 F0 05 31 |  if_ae	add	ptr__ff_cc_dat__, ##1654
03804     F8 FC 01 36 |  if_ae	mov	_var03, ptr__ff_cc_dat__
03808     03 00 00 3F 
0380c     76 F0 85 31 |  if_ae	sub	ptr__ff_cc_dat__, ##1654
03810     FE FE 01 F6 | 	mov	_var04, _var03
03814                 | ' 		uc = (WORD)uni;
03814                 | ' 		p = uc < 0x1000 ? cvt1 : cvt2;
03814                 | ' 		for (;;) {
03814                 | LR__0199
03814     FF 00 E2 FA | 	rdword	_var05, _var04
03818     00 FD 01 F6 | 	mov	_var03, _var05
0381c     0F FC 4D F7 | 	zerox	_var03, #15 wz
03820     02 FE 05 F1 | 	add	_var04, #2
03824     20 01 90 AD |  if_e	jmp	#LR__0211
03828     FD FC 31 F9 | 	getword	_var03, _var02, #0
0382c     00 F9 31 F9 | 	getword	_var01, _var05, #0
03830     FC FC 11 F2 | 	cmp	_var03, _var01 wc
03834     10 01 90 CD |  if_b	jmp	#LR__0211
03838     FF 02 E2 FA | 	rdword	_var06, _var04
0383c     01 05 32 F9 | 	getword	_var07, _var06, #0
03840     08 04 46 F0 | 	shr	_var07, #8
03844     01 03 32 F9 | 	getword	_var06, _var06, #0
03848     01 03 E2 F8 | 	getbyte	_var06, _var06, #0
0384c     FD FC 31 F9 | 	getword	_var03, _var02, #0
03850     00 07 32 F9 | 	getword	_var08, _var05, #0
03854     01 09 32 F9 | 	getword	_var09, _var06, #0
03858     04 07 02 F1 | 	add	_var08, _var09
0385c     03 FD 51 F2 | 	cmps	_var03, _var08 wc
03860     02 FE 05 F1 | 	add	_var04, #2
03864     C4 00 90 3D |  if_ae	jmp	#LR__0210
03868                 | ' 				switch (cmd) {
03868     02 0B 32 F9 | 	getword	_var10, _var07, #0
0386c     09 0A 26 F3 | 	fle	_var10, #9
03870     30 0A 62 FD | 	jmprel	_var10
03874                 | LR__0200
03874     24 00 90 FD | 	jmp	#LR__0201
03878     3C 00 90 FD | 	jmp	#LR__0202
0387c     54 00 90 FD | 	jmp	#LR__0203
03880     5C 00 90 FD | 	jmp	#LR__0204
03884     64 00 90 FD | 	jmp	#LR__0205
03888     6C 00 90 FD | 	jmp	#LR__0206
0388c     74 00 90 FD | 	jmp	#LR__0207
03890     7C 00 90 FD | 	jmp	#LR__0208
03894     84 00 90 FD | 	jmp	#LR__0209
03898     AC 00 90 FD | 	jmp	#LR__0211
0389c                 | LR__0201
0389c     FD FA 31 F9 | 	getword	_var02, _var02, #0
038a0     00 01 32 F9 | 	getword	_var05, _var05, #0
038a4     00 FB 81 F1 | 	sub	_var02, _var05
038a8     01 FA 65 F0 | 	shl	_var02, #1
038ac     FF FA 01 F1 | 	add	_var02, _var04
038b0     FD FA E1 FA | 	rdword	_var02, _var02
038b4     90 00 90 FD | 	jmp	#LR__0211
038b8                 | LR__0202
038b8     FD FC 31 F9 | 	getword	_var03, _var02, #0
038bc     FD FA 31 F9 | 	getword	_var02, _var02, #0
038c0     00 01 32 F9 | 	getword	_var05, _var05, #0
038c4     00 FB 81 F1 | 	sub	_var02, _var05
038c8     01 FA 05 F5 | 	and	_var02, #1
038cc     FE FA C1 F2 | 	subr	_var02, _var03
038d0     74 00 90 FD | 	jmp	#LR__0211
038d4                 | LR__0203
038d4     FD FA 31 F9 | 	getword	_var02, _var02, #0
038d8     10 FA 85 F1 | 	sub	_var02, #16
038dc     68 00 90 FD | 	jmp	#LR__0211
038e0                 | LR__0204
038e0     FD FA 31 F9 | 	getword	_var02, _var02, #0
038e4     20 FA 85 F1 | 	sub	_var02, #32
038e8     5C 00 90 FD | 	jmp	#LR__0211
038ec                 | LR__0205
038ec     FD FA 31 F9 | 	getword	_var02, _var02, #0
038f0     30 FA 85 F1 | 	sub	_var02, #48
038f4     50 00 90 FD | 	jmp	#LR__0211
038f8                 | LR__0206
038f8     FD FA 31 F9 | 	getword	_var02, _var02, #0
038fc     1A FA 85 F1 | 	sub	_var02, #26
03900     44 00 90 FD | 	jmp	#LR__0211
03904                 | LR__0207
03904     FD FA 31 F9 | 	getword	_var02, _var02, #0
03908     08 FA 05 F1 | 	add	_var02, #8
0390c     38 00 90 FD | 	jmp	#LR__0211
03910                 | LR__0208
03910     FD FA 31 F9 | 	getword	_var02, _var02, #0
03914     50 FA 85 F1 | 	sub	_var02, #80
03918     2C 00 90 FD | 	jmp	#LR__0211
0391c                 | LR__0209
0391c     FD FA 31 F9 | 	getword	_var02, _var02, #0
03920     0E 00 00 FF 
03924     60 FA 85 F1 | 	sub	_var02, ##7264
03928                 | ' 				}
03928                 | ' 				break;
03928     1C 00 90 FD | 	jmp	#LR__0211
0392c                 | LR__0210
0392c     02 FD 01 F6 | 	mov	_var03, _var07
03930     0F FC 4D F7 | 	zerox	_var03, #15 wz
03934     01 09 02 A6 |  if_e	mov	_var09, _var06
03938     04 09 32 A9 |  if_e	getword	_var09, _var09, #0
0393c     01 08 66 A0 |  if_e	shl	_var09, #1
03940     04 FF 01 A1 |  if_e	add	_var04, _var09
03944     CC FE 9F FD | 	jmp	#LR__0199
03948                 | LR__0211
03948     FD F8 31 F9 | 	getword	_var01, _var02, #0
0394c                 | LR__0212
0394c                 | ' 		}
0394c                 | ' 		uni = uc;
0394c                 | ' 	}
0394c                 | ' 
0394c                 | ' 	return uni;
0394c     FC F4 01 F6 | 	mov	result1, _var01
03950                 | _ff_cc_ff_wtoupper_ret
03950     2D 00 64 FD | 	ret
03954                 | 
03954                 | _ff_cc_disk_initialize
03954     07 4C 05 F6 | 	mov	COUNT_, #7
03958     A9 00 A0 FD | 	call	#pushregs_
0395c     3C F0 07 F1 | 	add	ptra, #60
03960     04 50 05 F1 | 	add	fp, #4
03964     A8 0E 42 FC | 	wrbyte	arg01, fp
03968     03 00 00 FF 
0396c     38 F1 05 F1 | 	add	ptr__ff_cc_dat__, ##1848
03970     F8 0E 02 FB | 	rdlong	arg01, ptr__ff_cc_dat__
03974     28 50 05 F1 | 	add	fp, #40
03978     A8 0E 62 FC | 	wrlong	arg01, fp
0397c     04 F0 85 F1 | 	sub	ptr__ff_cc_dat__, #4
03980     F8 0E 02 FB | 	rdlong	arg01, ptr__ff_cc_dat__
03984     04 50 05 F1 | 	add	fp, #4
03988     A8 0E 62 FC | 	wrlong	arg01, fp
0398c     08 F0 05 F1 | 	add	ptr__ff_cc_dat__, #8
03990     F8 0E 02 FB | 	rdlong	arg01, ptr__ff_cc_dat__
03994     04 50 05 F1 | 	add	fp, #4
03998     A8 0E 62 FC | 	wrlong	arg01, fp
0399c     04 F0 05 F1 | 	add	ptr__ff_cc_dat__, #4
039a0     F8 0E 02 FB | 	rdlong	arg01, ptr__ff_cc_dat__
039a4     03 00 00 FF 
039a8     40 F1 85 F1 | 	sub	ptr__ff_cc_dat__, ##1856
039ac     04 50 05 F1 | 	add	fp, #4
039b0     A8 0E 62 FC | 	wrlong	arg01, fp
039b4     34 50 85 F1 | 	sub	fp, #52
039b8     A8 0E CA FA | 	rdbyte	arg01, fp wz
039bc     04 50 85 F1 | 	sub	fp, #4
039c0                 | ' #line 602 "/home/pik33/Programy/flexprop/include/filesys/fatfs/sdmm.cc"
039c0                 | '             return RES_NOTRDY;
039c0     03 F4 05 56 |  if_ne	mov	result1, #3
039c4     C8 04 90 5D |  if_ne	jmp	#LR__0226
039c8     13 00 00 FF 
039cc     10 0F 06 F6 | 	mov	arg01, ##10000
039d0     64 D2 BF FD | 	call	#__system___waitus
039d4     2C 50 05 F1 | 	add	fp, #44
039d8     A8 0E 02 FB | 	rdlong	arg01, fp
039dc     07 01 08 FC | 	wrpin	#0, arg01
039e0     04 50 05 F1 | 	add	fp, #4
039e4     A8 0E 02 FB | 	rdlong	arg01, fp
039e8     07 01 08 FC | 	wrpin	#0, arg01
039ec     04 50 05 F1 | 	add	fp, #4
039f0     A8 0E 02 FB | 	rdlong	arg01, fp
039f4     07 01 08 FC | 	wrpin	#0, arg01
039f8     04 50 05 F1 | 	add	fp, #4
039fc     A8 0E 02 FB | 	rdlong	arg01, fp
03a00     09 00 80 FF 
03a04     07 01 08 FC | 	wrpin	##4608, arg01
03a08     0C 50 85 F1 | 	sub	fp, #12
03a0c     A8 0E 02 FB | 	rdlong	arg01, fp
03a10     59 0E 62 FD | 	drvh	arg01
03a14     04 50 05 F1 | 	add	fp, #4
03a18     A8 0E 02 FB | 	rdlong	arg01, fp
03a1c     59 0E 62 FD | 	drvh	arg01
03a20     04 50 05 F1 | 	add	fp, #4
03a24     A8 0E 02 FB | 	rdlong	arg01, fp
03a28     59 0E 62 FD | 	drvh	arg01
03a2c     04 50 05 F1 | 	add	fp, #4
03a30     A8 0E 02 FB | 	rdlong	arg01, fp
03a34     59 0E 62 FD | 	drvh	arg01
03a38     08 50 85 F1 | 	sub	fp, #8
03a3c     A8 14 02 FB | 	rdlong	arg04, fp
03a40     40 14 62 FD | 	dirl	arg04
03a44     A0 03 80 FF 
03a48     0A 91 08 FC | 	wrpin	##475208, arg04
03a4c     00 04 80 FF 
03a50     0A 21 18 FC | 	wxpin	##524304, arg04
03a54     0A 01 28 FC | 	wypin	#0, arg04
03a58     41 14 62 FD | 	dirh	arg04
03a5c     04 50 05 F1 | 	add	fp, #4
03a60     A8 18 02 FB | 	rdlong	local01, fp
03a64     0C 15 82 F1 | 	sub	arg04, local01
03a68     07 14 06 F5 | 	and	arg04, #7
03a6c     18 14 66 F0 | 	shl	arg04, #24
03a70     78 10 06 F6 | 	mov	arg02, #120
03a74     0A 11 42 F5 | 	or	arg02, arg04
03a78     10 50 85 F1 | 	sub	fp, #16
03a7c     A8 10 62 FC | 	wrlong	arg02, fp
03a80     10 50 05 F1 | 	add	fp, #16
03a84     A8 0E 02 FB | 	rdlong	arg01, fp
03a88     10 10 26 F4 | 	bith	arg02, #16
03a8c     40 0E 62 FD | 	dirl	arg01
03a90     07 11 02 FC | 	wrpin	arg02, arg01
03a94     07 3F 18 FC | 	wxpin	#31, arg01
03a98     FF FF FF FF 
03a9c     07 FF 2B FC | 	wypin	##-1, arg01
03aa0     41 0E 62 FD | 	dirh	arg01
03aa4     04 50 85 F1 | 	sub	fp, #4
03aa8     A8 10 02 FB | 	rdlong	arg02, fp
03aac     08 50 05 F1 | 	add	fp, #8
03ab0     A8 1A 02 FB | 	rdlong	local02, fp
03ab4     0D 11 82 F1 | 	sub	arg02, local02
03ab8     07 10 06 F5 | 	and	arg02, #7
03abc     18 10 66 F0 | 	shl	arg02, #24
03ac0     1C 50 85 F1 | 	sub	fp, #28
03ac4     A8 10 62 FC | 	wrlong	arg02, fp
03ac8     29 00 00 FF 
03acc     7A 10 46 F5 | 	or	arg02, ##21114
03ad0     A8 10 62 FC | 	wrlong	arg02, fp
03ad4     1C 50 05 F1 | 	add	fp, #28
03ad8     A8 0E 02 FB | 	rdlong	arg01, fp
03adc     00 1C 06 F6 | 	mov	local03, #0
03ae0     27 12 06 F6 | 	mov	arg03, #39
03ae4     00 14 06 F6 | 	mov	arg04, #0
03ae8     40 0E 62 FD | 	dirl	arg01
03aec     07 11 02 FC | 	wrpin	arg02, arg01
03af0     07 4F 18 FC | 	wxpin	#39, arg01
03af4     07 01 28 FC | 	wypin	#0, arg01
03af8     41 0E 62 FD | 	dirh	arg01
03afc     28 50 85 F1 | 	sub	fp, #40
03b00     A8 0E 02 F6 | 	mov	arg01, fp
03b04     10 50 85 F1 | 	sub	fp, #16
03b08     0A 10 06 F6 | 	mov	arg02, #10
03b0c     00 78 B0 FD | 	call	#_ff_cc_rcvr_mmc_0660
03b10     00 0E 06 F6 | 	mov	arg01, #0
03b14     00 10 06 F6 | 	mov	arg02, #0
03b18     8C 7B B0 FD | 	call	#_ff_cc_send_cmd_0681
03b1c     08 79 B0 FD | 	call	#_ff_cc_deselect_0667
03b20     64 0E 06 F6 | 	mov	arg01, #100
03b24     10 D1 BF FD | 	call	#__system___waitus
03b28     10 50 05 F1 | 	add	fp, #16
03b2c     A8 0E 02 F6 | 	mov	arg01, fp
03b30     10 50 85 F1 | 	sub	fp, #16
03b34     0A 10 06 F6 | 	mov	arg02, #10
03b38     D4 77 B0 FD | 	call	#_ff_cc_rcvr_mmc_0660
03b3c     08 50 05 F1 | 	add	fp, #8
03b40     A8 00 48 FC | 	wrbyte	#0, fp
03b44     08 50 85 F1 | 	sub	fp, #8
03b48     00 0E 06 F6 | 	mov	arg01, #0
03b4c     00 10 06 F6 | 	mov	arg02, #0
03b50     54 7B B0 FD | 	call	#_ff_cc_send_cmd_0681
03b54     FA F4 E1 F8 | 	getbyte	result1, result1, #0
03b58     01 F4 0D F2 | 	cmp	result1, #1 wz
03b5c     14 02 90 5D |  if_ne	jmp	#LR__0223
03b60     64 0E 06 F6 | 	mov	arg01, #100
03b64     D0 D0 BF FD | 	call	#__system___waitus
03b68     08 0E 06 F6 | 	mov	arg01, #8
03b6c     AA 11 06 F6 | 	mov	arg02, #426
03b70     34 7B B0 FD | 	call	#_ff_cc_send_cmd_0681
03b74     FA F4 E1 F8 | 	getbyte	result1, result1, #0
03b78     01 F4 0D F2 | 	cmp	result1, #1 wz
03b7c     FC 00 90 5D |  if_ne	jmp	#LR__0215
03b80     10 50 05 F1 | 	add	fp, #16
03b84     A8 0E 02 F6 | 	mov	arg01, fp
03b88     10 50 85 F1 | 	sub	fp, #16
03b8c     04 10 06 F6 | 	mov	arg02, #4
03b90     7C 77 B0 FD | 	call	#_ff_cc_rcvr_mmc_0660
03b94     12 50 05 F1 | 	add	fp, #18
03b98     A8 1A C2 FA | 	rdbyte	local02, fp
03b9c     12 50 85 F1 | 	sub	fp, #18
03ba0     01 1A 0E F2 | 	cmp	local02, #1 wz
03ba4     CC 01 90 5D |  if_ne	jmp	#LR__0222
03ba8     13 50 05 F1 | 	add	fp, #19
03bac     A8 1A C2 FA | 	rdbyte	local02, fp
03bb0     13 50 85 F1 | 	sub	fp, #19
03bb4     AA 1A 0E F2 | 	cmp	local02, #170 wz
03bb8     B8 01 90 5D |  if_ne	jmp	#LR__0222
03bbc                 | ' 				for (tmr = 1000; tmr; tmr--) {
03bbc     1C 50 05 F1 | 	add	fp, #28
03bc0     01 00 80 FF 
03bc4     A8 D0 6B FC | 	wrlong	##1000, fp
03bc8     1C 50 85 F1 | 	sub	fp, #28
03bcc                 | LR__0213
03bcc     1C 50 05 F1 | 	add	fp, #28
03bd0     A8 1A 0A FB | 	rdlong	local02, fp wz
03bd4     1C 50 85 F1 | 	sub	fp, #28
03bd8     3C 00 90 AD |  if_e	jmp	#LR__0214
03bdc     A9 0E 06 F6 | 	mov	arg01, #169
03be0     1E 10 C6 F9 | 	decod	arg02, #30
03be4     C0 7A B0 FD | 	call	#_ff_cc_send_cmd_0681
03be8     FA 1C 02 F6 | 	mov	local03, result1
03bec     07 1C 4E F7 | 	zerox	local03, #7 wz
03bf0     24 00 90 AD |  if_e	jmp	#LR__0214
03bf4     01 00 00 FF 
03bf8     E8 0F 06 F6 | 	mov	arg01, ##1000
03bfc     38 D0 BF FD | 	call	#__system___waitus
03c00     1C 50 05 F1 | 	add	fp, #28
03c04     A8 1E 02 FB | 	rdlong	local04, fp
03c08     01 1E 86 F1 | 	sub	local04, #1
03c0c     A8 1E 62 FC | 	wrlong	local04, fp
03c10     1C 50 85 F1 | 	sub	fp, #28
03c14     B4 FF 9F FD | 	jmp	#LR__0213
03c18                 | LR__0214
03c18     1C 50 05 F1 | 	add	fp, #28
03c1c     A8 1E 02 FB | 	rdlong	local04, fp
03c20     1C 50 85 F1 | 	sub	fp, #28
03c24     0F 21 0A F6 | 	mov	local05, local04 wz
03c28     48 01 90 AD |  if_e	jmp	#LR__0222
03c2c     3A 0E 06 F6 | 	mov	arg01, #58
03c30     00 10 06 F6 | 	mov	arg02, #0
03c34     70 7A B0 FD | 	call	#_ff_cc_send_cmd_0681
03c38     FA 1A 02 F6 | 	mov	local02, result1
03c3c     07 1A 4E F7 | 	zerox	local02, #7 wz
03c40     30 01 90 5D |  if_ne	jmp	#LR__0222
03c44     10 50 05 F1 | 	add	fp, #16
03c48     A8 0E 02 F6 | 	mov	arg01, fp
03c4c     10 50 85 F1 | 	sub	fp, #16
03c50     04 10 06 F6 | 	mov	arg02, #4
03c54     B8 76 B0 FD | 	call	#_ff_cc_rcvr_mmc_0660
03c58     10 50 05 F1 | 	add	fp, #16
03c5c     A8 1E C2 FA | 	rdbyte	local04, fp
03c60     40 1E CE F7 | 	test	local04, #64 wz
03c64     0C 20 06 56 |  if_ne	mov	local05, #12
03c68     04 20 06 A6 |  if_e	mov	local05, #4
03c6c     08 50 85 F1 | 	sub	fp, #8
03c70     A8 20 42 FC | 	wrbyte	local05, fp
03c74     08 50 85 F1 | 	sub	fp, #8
03c78     F8 00 90 FD | 	jmp	#LR__0222
03c7c                 | LR__0215
03c7c     A9 0E 06 F6 | 	mov	arg01, #169
03c80     00 10 06 F6 | 	mov	arg02, #0
03c84     20 7A B0 FD | 	call	#_ff_cc_send_cmd_0681
03c88     FA F4 E1 F8 | 	getbyte	result1, result1, #0
03c8c     02 F4 15 F2 | 	cmp	result1, #2 wc
03c90     18 00 90 3D |  if_ae	jmp	#LR__0216
03c94     08 50 05 F1 | 	add	fp, #8
03c98     A8 04 48 FC | 	wrbyte	#2, fp
03c9c     04 50 05 F1 | 	add	fp, #4
03ca0     A8 52 49 FC | 	wrbyte	#169, fp
03ca4     0C 50 85 F1 | 	sub	fp, #12
03ca8     14 00 90 FD | 	jmp	#LR__0217
03cac                 | LR__0216
03cac     08 50 05 F1 | 	add	fp, #8
03cb0     A8 02 48 FC | 	wrbyte	#1, fp
03cb4     04 50 05 F1 | 	add	fp, #4
03cb8     A8 02 48 FC | 	wrbyte	#1, fp
03cbc     0C 50 85 F1 | 	sub	fp, #12
03cc0                 | LR__0217
03cc0                 | ' 				ty =  0x01 ; cmd =  (1) ;
03cc0                 | ' 			}
03cc0                 | ' 			for (tmr = 1000; tmr; tmr--) {
03cc0     1C 50 05 F1 | 	add	fp, #28
03cc4     01 00 80 FF 
03cc8     A8 D0 6B FC | 	wrlong	##1000, fp
03ccc     1C 50 85 F1 | 	sub	fp, #28
03cd0                 | LR__0218
03cd0     1C 50 05 F1 | 	add	fp, #28
03cd4     A8 20 0A FB | 	rdlong	local05, fp wz
03cd8     1C 50 85 F1 | 	sub	fp, #28
03cdc     54 00 90 AD |  if_e	jmp	#LR__0219
03ce0     0C 50 05 F1 | 	add	fp, #12
03ce4     A8 0E C2 FA | 	rdbyte	arg01, fp
03ce8     0C 50 85 F1 | 	sub	fp, #12
03cec     00 1E 06 F6 | 	mov	local04, #0
03cf0     00 10 06 F6 | 	mov	arg02, #0
03cf4     B0 79 B0 FD | 	call	#_ff_cc_send_cmd_0681
03cf8     FA 1C 02 F6 | 	mov	local03, result1
03cfc     07 1C 4E F7 | 	zerox	local03, #7 wz
03d00     30 00 90 AD |  if_e	jmp	#LR__0219
03d04     01 00 00 FF 
03d08     E8 0F 06 F6 | 	mov	arg01, ##1000
03d0c     28 CF BF FD | 	call	#__system___waitus
03d10     1C 50 05 F1 | 	add	fp, #28
03d14     A8 18 02 FB | 	rdlong	local01, fp
03d18     0C 1D 02 F6 | 	mov	local03, local01
03d1c     0C 23 02 F6 | 	mov	local06, local01
03d20     11 1F 02 F6 | 	mov	local04, local06
03d24     01 1E 86 F1 | 	sub	local04, #1
03d28     A8 1E 62 FC | 	wrlong	local04, fp
03d2c     1C 50 85 F1 | 	sub	fp, #28
03d30     9C FF 9F FD | 	jmp	#LR__0218
03d34                 | LR__0219
03d34     1C 50 05 F1 | 	add	fp, #28
03d38     A8 24 02 FB | 	rdlong	local07, fp
03d3c     1C 50 85 F1 | 	sub	fp, #28
03d40     12 21 0A F6 | 	mov	local05, local07 wz
03d44     20 00 90 AD |  if_e	jmp	#LR__0220
03d48     09 18 C6 F9 | 	decod	local01, #9
03d4c     10 0E 06 F6 | 	mov	arg01, #16
03d50     09 10 C6 F9 | 	decod	arg02, #9
03d54     50 79 B0 FD | 	call	#_ff_cc_send_cmd_0681
03d58     FA 1C 02 F6 | 	mov	local03, result1
03d5c     0E 1B 02 F6 | 	mov	local02, local03
03d60     07 1A 4E F7 | 	zerox	local02, #7 wz
03d64     0C 00 90 AD |  if_e	jmp	#LR__0221
03d68                 | LR__0220
03d68     08 50 05 F1 | 	add	fp, #8
03d6c     A8 00 48 FC | 	wrbyte	#0, fp
03d70     08 50 85 F1 | 	sub	fp, #8
03d74                 | LR__0221
03d74                 | LR__0222
03d74                 | LR__0223
03d74     08 50 05 F1 | 	add	fp, #8
03d78     A8 20 C2 FA | 	rdbyte	local05, fp
03d7c     03 00 00 FF 
03d80     45 F1 05 F1 | 	add	ptr__ff_cc_dat__, ##1861
03d84     F8 20 42 FC | 	wrbyte	local05, ptr__ff_cc_dat__
03d88     A8 24 CA FA | 	rdbyte	local07, fp wz
03d8c     00 20 06 56 |  if_ne	mov	local05, #0
03d90     01 20 06 A6 |  if_e	mov	local05, #1
03d94     20 50 05 F1 | 	add	fp, #32
03d98     A8 20 42 FC | 	wrbyte	local05, fp
03d9c     A8 20 C2 FA | 	rdbyte	local05, fp
03da0     28 50 85 F1 | 	sub	fp, #40
03da4     01 F0 85 F1 | 	sub	ptr__ff_cc_dat__, #1
03da8     F8 20 42 FC | 	wrbyte	local05, ptr__ff_cc_dat__
03dac     03 00 00 FF 
03db0     44 F1 85 F1 | 	sub	ptr__ff_cc_dat__, ##1860
03db4     70 76 B0 FD | 	call	#_ff_cc_deselect_0667
03db8     14 20 06 FB | 	rdlong	local05, #20
03dbc     1C 50 05 F1 | 	add	fp, #28
03dc0     A8 20 62 FC | 	wrlong	local05, fp
03dc4     04 50 05 F1 | 	add	fp, #4
03dc8     00 04 80 FF 
03dcc     A8 20 68 FC | 	wrlong	##524304, fp
03dd0     04 50 85 F1 | 	sub	fp, #4
03dd4     A8 20 02 FB | 	rdlong	local05, fp
03dd8     1C 50 85 F1 | 	sub	fp, #28
03ddc     68 78 04 FF 
03de0     81 21 16 F2 | 	cmp	local05, ##150000001 wc
03de4     20 50 05 C1 |  if_b	add	fp, #32
03de8     00 01 80 CF 
03dec     A8 08 68 CC |  if_b	wrlong	##131076, fp
03df0     20 50 85 C1 |  if_b	sub	fp, #32
03df4     5C 00 90 CD |  if_b	jmp	#LR__0225
03df8     1C 50 05 F1 | 	add	fp, #28
03dfc     A8 20 02 FB | 	rdlong	local05, fp
03e00     1C 50 85 F1 | 	sub	fp, #28
03e04     E1 F5 05 FF 
03e08     01 20 16 F2 | 	cmp	local05, ##200000001 wc
03e0c     20 50 05 C1 |  if_b	add	fp, #32
03e10     00 01 80 CF 
03e14     A8 0A 68 CC |  if_b	wrlong	##131077, fp
03e18     20 50 85 C1 |  if_b	sub	fp, #32
03e1c     34 00 90 CD |  if_b	jmp	#LR__0224
03e20     1C 50 05 F1 | 	add	fp, #28
03e24     A8 20 02 FB | 	rdlong	local05, fp
03e28     1C 50 85 F1 | 	sub	fp, #28
03e2c     3B 58 08 FF 
03e30     01 20 16 F2 | 	cmp	local05, ##280000001 wc
03e34     20 50 05 C1 |  if_b	add	fp, #32
03e38     00 01 80 CF 
03e3c     A8 0C 68 CC |  if_b	wrlong	##131078, fp
03e40     20 50 85 C1 |  if_b	sub	fp, #32
03e44     20 50 05 31 |  if_ae	add	fp, #32
03e48     80 01 80 3F 
03e4c     A8 0E 68 3C |  if_ae	wrlong	##196615, fp
03e50     20 50 85 31 |  if_ae	sub	fp, #32
03e54                 | LR__0224
03e54                 | LR__0225
03e54     24 50 05 F1 | 	add	fp, #36
03e58     A8 20 02 FB | 	rdlong	local05, fp
03e5c     1B 20 26 F4 | 	bith	local05, #27
03e60     A8 20 62 FC | 	wrlong	local05, fp
03e64     0C 50 05 F1 | 	add	fp, #12
03e68     A8 0E 02 FB | 	rdlong	arg01, fp
03e6c     10 50 85 F1 | 	sub	fp, #16
03e70     A8 10 02 FB | 	rdlong	arg02, fp
03e74     07 11 12 FC | 	wxpin	arg02, arg01
03e78     14 50 05 F1 | 	add	fp, #20
03e7c     A8 0E 02 FB | 	rdlong	arg01, fp
03e80     07 21 02 FC | 	wrpin	local05, arg01
03e84                 | ' 
03e84                 | ' 	m_txsp |= P_INVERT_B;
03e84                 | ' #line 710 "/home/pik33/Programy/flexprop/include/filesys/fatfs/sdmm.cc"
03e84                 | ' 	_wxpin( PIN_CLK, tmout );
03e84                 | ' 	_wrpin( PIN_DI, m_txsp );
03e84                 | ' #line 718 "/home/pik33/Programy/flexprop/include/filesys/fatfs/sdmm.cc"
03e84                 | ' 	return s;
03e84     0C 50 85 F1 | 	sub	fp, #12
03e88     A8 F4 C1 FA | 	rdbyte	result1, fp
03e8c     28 50 85 F1 | 	sub	fp, #40
03e90                 | LR__0226
03e90     A8 F0 03 F6 | 	mov	ptra, fp
03e94     B3 00 A0 FD | 	call	#popregs_
03e98                 | _ff_cc_disk_initialize_ret
03e98     2D 00 64 FD | 	ret
03e9c                 | 
03e9c                 | _ff_cc_disk_read
03e9c     05 4C 05 F6 | 	mov	COUNT_, #5
03ea0     A9 00 A0 FD | 	call	#pushregs_
03ea4     08 19 02 F6 | 	mov	local01, arg02
03ea8     0A 1B 02 F6 | 	mov	local02, arg04
03eac     09 1D 02 F6 | 	mov	local03, arg03
03eb0     00 0E 0E F2 | 	cmp	arg01, #0 wz
03eb4     01 F4 05 56 |  if_ne	mov	result1, #1
03eb8                 | ' 
03eb8                 | ' 	return Stat;
03eb8     03 00 00 AF 
03ebc     44 F1 05 A1 |  if_e	add	ptr__ff_cc_dat__, ##1860
03ec0     F8 F4 C1 AA |  if_e	rdbyte	result1, ptr__ff_cc_dat__
03ec4     03 00 00 AF 
03ec8     44 F1 85 A1 |  if_e	sub	ptr__ff_cc_dat__, ##1860
03ecc     01 F4 0D F5 | 	and	result1, #1 wz
03ed0     03 F4 05 56 |  if_ne	mov	result1, #3
03ed4     84 00 90 5D |  if_ne	jmp	#LR__0229
03ed8     03 00 00 FF 
03edc     45 F1 05 F1 | 	add	ptr__ff_cc_dat__, ##1861
03ee0     F8 1E C2 FA | 	rdbyte	local04, ptr__ff_cc_dat__
03ee4     03 00 00 FF 
03ee8     45 F1 85 F1 | 	sub	ptr__ff_cc_dat__, ##1861
03eec     08 1E 0E F5 | 	and	local04, #8 wz
03ef0     09 1C 66 A0 |  if_e	shl	local03, #9
03ef4     02 1A 16 F2 | 	cmp	local02, #2 wc
03ef8     12 1E 06 36 |  if_ae	mov	local04, #18
03efc     11 1E 06 C6 |  if_b	mov	local04, #17
03f00     0E 11 02 F6 | 	mov	arg02, local03
03f04     0F 0F 02 F6 | 	mov	arg01, local04
03f08     9C 77 B0 FD | 	call	#_ff_cc_send_cmd_0681
03f0c     FA 20 02 F6 | 	mov	local05, result1
03f10     07 20 4E F7 | 	zerox	local05, #7 wz
03f14     30 00 90 5D |  if_ne	jmp	#LR__0228
03f18                 | ' 		do {
03f18                 | LR__0227
03f18     0C 0F 02 F6 | 	mov	arg01, local01
03f1c     09 10 C6 F9 | 	decod	arg02, #9
03f20     D8 75 B0 FD | 	call	#_ff_cc_rcvr_datablock_0675
03f24     00 F4 0D F2 | 	cmp	result1, #0 wz
03f28     01 00 00 5F 
03f2c     00 18 06 51 |  if_ne	add	local01, ##512
03f30     F9 1B 6E 5B |  if_ne	djnz	local02, #LR__0227
03f34     0F 1F E2 F8 | 	getbyte	local04, local04, #0
03f38     12 1E 0E F2 | 	cmp	local04, #18 wz
03f3c     0C 0E 06 A6 |  if_e	mov	arg01, #12
03f40     00 10 06 A6 |  if_e	mov	arg02, #0
03f44     60 77 B0 AD |  if_e	call	#_ff_cc_send_cmd_0681
03f48                 | LR__0228
03f48     DC 74 B0 FD | 	call	#_ff_cc_deselect_0667
03f4c                 | ' 	}
03f4c                 | ' 	deselect();
03f4c                 | ' 
03f4c                 | ' 	return count ? RES_ERROR : RES_OK;
03f4c     00 1A 0E F2 | 	cmp	local02, #0 wz
03f50     01 20 06 56 |  if_ne	mov	local05, #1
03f54     00 20 06 A6 |  if_e	mov	local05, #0
03f58     10 F5 01 F6 | 	mov	result1, local05
03f5c                 | LR__0229
03f5c     A8 F0 03 F6 | 	mov	ptra, fp
03f60     B3 00 A0 FD | 	call	#popregs_
03f64                 | _ff_cc_disk_read_ret
03f64     2D 00 64 FD | 	ret
03f68                 | 
03f68                 | _ff_cc_disk_write
03f68     06 4C 05 F6 | 	mov	COUNT_, #6
03f6c     A9 00 A0 FD | 	call	#pushregs_
03f70     07 19 02 F6 | 	mov	local01, arg01
03f74     08 1B 02 F6 | 	mov	local02, arg02
03f78     09 1D 02 F6 | 	mov	local03, arg03
03f7c     0A 1F 02 F6 | 	mov	local04, arg04
03f80     0E 21 02 F6 | 	mov	local05, local03
03f84     0C 0F 0A F6 | 	mov	arg01, local01 wz
03f88     01 F4 05 56 |  if_ne	mov	result1, #1
03f8c                 | ' 
03f8c                 | ' 	return Stat;
03f8c     03 00 00 AF 
03f90     44 F1 05 A1 |  if_e	add	ptr__ff_cc_dat__, ##1860
03f94     F8 F4 C1 AA |  if_e	rdbyte	result1, ptr__ff_cc_dat__
03f98     03 00 00 AF 
03f9c     44 F1 85 A1 |  if_e	sub	ptr__ff_cc_dat__, ##1860
03fa0     01 F4 0D F5 | 	and	result1, #1 wz
03fa4     03 F4 05 56 |  if_ne	mov	result1, #3
03fa8     D0 00 90 5D |  if_ne	jmp	#LR__0234
03fac     03 00 00 FF 
03fb0     45 F1 05 F1 | 	add	ptr__ff_cc_dat__, ##1861
03fb4     F8 22 C2 FA | 	rdbyte	local06, ptr__ff_cc_dat__
03fb8     03 00 00 FF 
03fbc     45 F1 85 F1 | 	sub	ptr__ff_cc_dat__, ##1861
03fc0     08 22 0E F5 | 	and	local06, #8 wz
03fc4     09 20 66 A0 |  if_e	shl	local05, #9
03fc8     01 1E 0E F2 | 	cmp	local04, #1 wz
03fcc     2C 00 90 5D |  if_ne	jmp	#LR__0230
03fd0     10 11 02 F6 | 	mov	arg02, local05
03fd4     18 0E 06 F6 | 	mov	arg01, #24
03fd8     CC 76 B0 FD | 	call	#_ff_cc_send_cmd_0681
03fdc     07 F4 4D F7 | 	zerox	result1, #7 wz
03fe0     84 00 90 5D |  if_ne	jmp	#LR__0233
03fe4     0D 0F 02 F6 | 	mov	arg01, local02
03fe8     FE 10 06 F6 | 	mov	arg02, #254
03fec     EC 75 B0 FD | 	call	#_ff_cc_xmit_datablock_0677
03ff0     00 F4 0D F2 | 	cmp	result1, #0 wz
03ff4     00 1E 06 56 |  if_ne	mov	local04, #0
03ff8     6C 00 90 FD | 	jmp	#LR__0233
03ffc                 | LR__0230
03ffc     03 00 00 FF 
04000     45 F1 05 F1 | 	add	ptr__ff_cc_dat__, ##1861
04004     F8 22 C2 FA | 	rdbyte	local06, ptr__ff_cc_dat__
04008     03 00 00 FF 
0400c     45 F1 85 F1 | 	sub	ptr__ff_cc_dat__, ##1861
04010     06 22 CE F7 | 	test	local06, #6 wz
04014     97 0E 06 56 |  if_ne	mov	arg01, #151
04018     0F 11 02 56 |  if_ne	mov	arg02, local04
0401c     88 76 B0 5D |  if_ne	call	#_ff_cc_send_cmd_0681
04020     10 11 02 F6 | 	mov	arg02, local05
04024     19 0E 06 F6 | 	mov	arg01, #25
04028     7C 76 B0 FD | 	call	#_ff_cc_send_cmd_0681
0402c     FA 22 02 F6 | 	mov	local06, result1
04030     07 22 4E F7 | 	zerox	local06, #7 wz
04034     30 00 90 5D |  if_ne	jmp	#LR__0232
04038                 | ' 			do {
04038                 | LR__0231
04038     0D 0F 02 F6 | 	mov	arg01, local02
0403c     FC 10 06 F6 | 	mov	arg02, #252
04040     98 75 B0 FD | 	call	#_ff_cc_xmit_datablock_0677
04044     00 F4 0D F2 | 	cmp	result1, #0 wz
04048     01 00 00 5F 
0404c     00 1A 06 51 |  if_ne	add	local02, ##512
04050     F9 1F 6E 5B |  if_ne	djnz	local04, #LR__0231
04054     00 0E 06 F6 | 	mov	arg01, #0
04058     FD 10 06 F6 | 	mov	arg02, #253
0405c     7C 75 B0 FD | 	call	#_ff_cc_xmit_datablock_0677
04060     00 F4 0D F2 | 	cmp	result1, #0 wz
04064     01 1E 06 A6 |  if_e	mov	local04, #1
04068                 | LR__0232
04068                 | LR__0233
04068     BC 73 B0 FD | 	call	#_ff_cc_deselect_0667
0406c                 | ' 				count = 1;
0406c                 | ' 		}
0406c                 | ' 	}
0406c                 | ' 	deselect();
0406c                 | ' 
0406c                 | ' 	return count ? RES_ERROR : RES_OK;
0406c     00 1E 0E F2 | 	cmp	local04, #0 wz
04070     01 22 06 56 |  if_ne	mov	local06, #1
04074     00 22 06 A6 |  if_e	mov	local06, #0
04078     11 F5 01 F6 | 	mov	result1, local06
0407c                 | LR__0234
0407c     A8 F0 03 F6 | 	mov	ptra, fp
04080     B3 00 A0 FD | 	call	#popregs_
04084                 | _ff_cc_disk_write_ret
04084     2D 00 64 FD | 	ret
04088                 | 
04088                 | _ff_cc_disk_ioctl
04088     04 4C 05 F6 | 	mov	COUNT_, #4
0408c     A9 00 A0 FD | 	call	#pushregs_
04090     30 F0 07 F1 | 	add	ptra, #48
04094     04 50 05 F1 | 	add	fp, #4
04098     A8 0E 42 FC | 	wrbyte	arg01, fp
0409c     04 50 05 F1 | 	add	fp, #4
040a0     A8 10 42 FC | 	wrbyte	arg02, fp
040a4     04 50 05 F1 | 	add	fp, #4
040a8     A8 12 62 FC | 	wrlong	arg03, fp
040ac     08 50 85 F1 | 	sub	fp, #8
040b0     A8 18 C2 FA | 	rdbyte	local01, fp
040b4     04 50 85 F1 | 	sub	fp, #4
040b8     0C 0F 0A F6 | 	mov	arg01, local01 wz
040bc     01 F4 05 56 |  if_ne	mov	result1, #1
040c0                 | ' 
040c0                 | ' 	return Stat;
040c0     03 00 00 AF 
040c4     44 F1 05 A1 |  if_e	add	ptr__ff_cc_dat__, ##1860
040c8     F8 F4 C1 AA |  if_e	rdbyte	result1, ptr__ff_cc_dat__
040cc     03 00 00 AF 
040d0     44 F1 85 A1 |  if_e	sub	ptr__ff_cc_dat__, ##1860
040d4     FA 1A E2 F8 | 	getbyte	local02, result1, #0
040d8     01 1A CE F7 | 	test	local02, #1 wz
040dc     03 F4 05 56 |  if_ne	mov	result1, #3
040e0     E8 01 90 5D |  if_ne	jmp	#LR__0243
040e4     10 50 05 F1 | 	add	fp, #16
040e8     A8 02 68 FC | 	wrlong	#1, fp
040ec                 | ' 
040ec                 | ' 	res = RES_ERROR;
040ec                 | ' 	switch (ctrl) {
040ec     08 50 85 F1 | 	sub	fp, #8
040f0     A8 1A C2 FA | 	rdbyte	local02, fp
040f4     08 50 85 F1 | 	sub	fp, #8
040f8     0D 1D E2 F8 | 	getbyte	local03, local02, #0
040fc     04 1C 26 F3 | 	fle	local03, #4
04100     30 1C 62 FD | 	jmprel	local03
04104                 | LR__0235
04104     10 00 90 FD | 	jmp	#LR__0236
04108     24 00 90 FD | 	jmp	#LR__0237
0410c     9C 01 90 FD | 	jmp	#LR__0241
04110     7C 01 90 FD | 	jmp	#LR__0240
04114     94 01 90 FD | 	jmp	#LR__0241
04118                 | LR__0236
04118     54 73 B0 FD | 	call	#_ff_cc_select_0671
0411c     00 F4 0D F2 | 	cmp	result1, #0 wz
04120     10 50 05 51 |  if_ne	add	fp, #16
04124     A8 00 68 5C |  if_ne	wrlong	#0, fp
04128     10 50 85 51 |  if_ne	sub	fp, #16
0412c                 | ' 			break;
0412c     8C 01 90 FD | 	jmp	#LR__0242
04130                 | LR__0237
04130     09 0E 06 F6 | 	mov	arg01, #9
04134     00 10 06 F6 | 	mov	arg02, #0
04138     6C 75 B0 FD | 	call	#_ff_cc_send_cmd_0681
0413c     07 F4 4D F7 | 	zerox	result1, #7 wz
04140     78 01 90 5D |  if_ne	jmp	#LR__0242
04144     18 50 05 F1 | 	add	fp, #24
04148     A8 0E 02 F6 | 	mov	arg01, fp
0414c     18 50 85 F1 | 	sub	fp, #24
04150     10 10 06 F6 | 	mov	arg02, #16
04154     A4 73 B0 FD | 	call	#_ff_cc_rcvr_datablock_0675
04158     00 F4 0D F2 | 	cmp	result1, #0 wz
0415c     5C 01 90 AD |  if_e	jmp	#LR__0242
04160     18 50 05 F1 | 	add	fp, #24
04164     A8 1C C2 FA | 	rdbyte	local03, fp
04168     18 50 85 F1 | 	sub	fp, #24
0416c     06 1C 46 F0 | 	shr	local03, #6
04170     01 1C 0E F2 | 	cmp	local03, #1 wz
04174     5C 00 90 5D |  if_ne	jmp	#LR__0238
04178     21 50 05 F1 | 	add	fp, #33
0417c     A8 1C C2 FA | 	rdbyte	local03, fp
04180     01 50 85 F1 | 	sub	fp, #1
04184     A8 1A C2 FA | 	rdbyte	local02, fp
04188     0D 1B 32 F9 | 	getword	local02, local02, #0
0418c     08 1A 66 F0 | 	shl	local02, #8
04190     0D 1D 02 F1 | 	add	local03, local02
04194     01 50 85 F1 | 	sub	fp, #1
04198     A8 1A C2 FA | 	rdbyte	local02, fp
0419c     3F 1A 06 F5 | 	and	local02, #63
041a0     10 1A 66 F0 | 	shl	local02, #16
041a4     0D 1D 02 F1 | 	add	local03, local02
041a8     01 1C 06 F1 | 	add	local03, #1
041ac     09 50 05 F1 | 	add	fp, #9
041b0     A8 1C 62 FC | 	wrlong	local03, fp
041b4     1C 50 85 F1 | 	sub	fp, #28
041b8     A8 1C 02 FB | 	rdlong	local03, fp
041bc     1C 50 05 F1 | 	add	fp, #28
041c0     A8 1A 02 FB | 	rdlong	local02, fp
041c4     28 50 85 F1 | 	sub	fp, #40
041c8     0A 1A 66 F0 | 	shl	local02, #10
041cc     0E 1B 62 FC | 	wrlong	local02, local03
041d0     AC 00 90 FD | 	jmp	#LR__0239
041d4                 | LR__0238
041d4     1D 50 05 F1 | 	add	fp, #29
041d8     A8 1C C2 FA | 	rdbyte	local03, fp
041dc     0E 1D 42 F8 | 	getnib	local03, local03, #0
041e0     05 50 05 F1 | 	add	fp, #5
041e4     A8 1A C2 FA | 	rdbyte	local02, fp
041e8     80 1A 06 F5 | 	and	local02, #128
041ec     07 1A C6 F0 | 	sar	local02, #7
041f0     0D 1D 02 F1 | 	add	local03, local02
041f4     01 50 85 F1 | 	sub	fp, #1
041f8     A8 1A C2 FA | 	rdbyte	local02, fp
041fc     03 1A 06 F5 | 	and	local02, #3
04200     01 1A 66 F0 | 	shl	local02, #1
04204     0D 1D 02 F1 | 	add	local03, local02
04208     02 1C 06 F1 | 	add	local03, #2
0420c     0D 50 85 F1 | 	sub	fp, #13
04210     A8 1C 42 FC | 	wrbyte	local03, fp
04214     0C 50 05 F1 | 	add	fp, #12
04218     A8 1C C2 FA | 	rdbyte	local03, fp
0421c     06 1C 46 F0 | 	shr	local03, #6
04220     01 50 85 F1 | 	sub	fp, #1
04224     A8 1A C2 FA | 	rdbyte	local02, fp
04228     0D 1B 32 F9 | 	getword	local02, local02, #0
0422c     02 1A 66 F0 | 	shl	local02, #2
04230     0D 1D 02 F1 | 	add	local03, local02
04234     01 50 85 F1 | 	sub	fp, #1
04238     A8 1A C2 FA | 	rdbyte	local02, fp
0423c     03 1A 06 F5 | 	and	local02, #3
04240     0D 1B 32 F9 | 	getword	local02, local02, #0
04244     0A 1A 66 F0 | 	shl	local02, #10
04248     0D 1D 02 F1 | 	add	local03, local02
0424c     01 1C 06 F1 | 	add	local03, #1
04250     0A 50 05 F1 | 	add	fp, #10
04254     A8 1C 62 FC | 	wrlong	local03, fp
04258     1C 50 85 F1 | 	sub	fp, #28
0425c     A8 1C 02 FB | 	rdlong	local03, fp
04260     1C 50 05 F1 | 	add	fp, #28
04264     A8 1A 02 FB | 	rdlong	local02, fp
04268     14 50 85 F1 | 	sub	fp, #20
0426c     A8 18 C2 FA | 	rdbyte	local01, fp
04270     14 50 85 F1 | 	sub	fp, #20
04274     09 18 86 F1 | 	sub	local01, #9
04278     0C 1B 62 F0 | 	shl	local02, local01
0427c     0E 1B 62 FC | 	wrlong	local02, local03
04280                 | LR__0239
04280     10 50 05 F1 | 	add	fp, #16
04284     A8 00 68 FC | 	wrlong	#0, fp
04288     10 50 85 F1 | 	sub	fp, #16
0428c                 | ' 					n = (csd[5] & 15) + ((csd[10] & 128) >> 7) + ((csd[9] & 3) << 1) + 2;
0428c                 | ' 					cs = (csd[8] >> 6) + ((WORD)csd[7] << 2) + ((WORD)(csd[6] & 3) << 10) + 1;
0428c                 | ' 					*(LBA_t*)buff = cs << (n - 9);
0428c                 | ' 				}
0428c                 | ' 				res = RES_OK;
0428c                 | ' 			}
0428c                 | ' 			break;
0428c     2C 00 90 FD | 	jmp	#LR__0242
04290                 | LR__0240
04290     0C 50 05 F1 | 	add	fp, #12
04294     A8 1C 02 FB | 	rdlong	local03, fp
04298     0E 01 69 FC | 	wrlong	#128, local03
0429c     04 50 05 F1 | 	add	fp, #4
042a0     A8 00 68 FC | 	wrlong	#0, fp
042a4     10 50 85 F1 | 	sub	fp, #16
042a8                 | ' 			*(DWORD*)buff = 128;
042a8                 | ' 			res = RES_OK;
042a8                 | ' 			break;
042a8     10 00 90 FD | 	jmp	#LR__0242
042ac                 | LR__0241
042ac     04 1E 06 F6 | 	mov	local04, #4
042b0     10 50 05 F1 | 	add	fp, #16
042b4     A8 08 68 FC | 	wrlong	#4, fp
042b8     10 50 85 F1 | 	sub	fp, #16
042bc                 | LR__0242
042bc     68 71 B0 FD | 	call	#_ff_cc_deselect_0667
042c0                 | ' 			res = RES_PARERR;
042c0                 | ' 	}
042c0                 | ' 
042c0                 | ' 	deselect();
042c0                 | ' 
042c0                 | ' 	return res;
042c0     10 50 05 F1 | 	add	fp, #16
042c4     A8 F4 01 FB | 	rdlong	result1, fp
042c8     10 50 85 F1 | 	sub	fp, #16
042cc                 | LR__0243
042cc     A8 F0 03 F6 | 	mov	ptra, fp
042d0     B3 00 A0 FD | 	call	#popregs_
042d4                 | _ff_cc_disk_ioctl_ret
042d4     2D 00 64 FD | 	ret
042d8                 | 
042d8                 | _ff_cc_disk_setpins
042d8     00 0E 0E F2 | 	cmp	arg01, #0 wz
042dc     01 F4 65 56 |  if_ne	neg	result1, #1
042e0     30 00 90 5D |  if_ne	jmp	#_ff_cc_disk_setpins_ret
042e4     03 00 00 FF 
042e8     34 F1 05 F1 | 	add	ptr__ff_cc_dat__, ##1844
042ec     F8 10 62 FC | 	wrlong	arg02, ptr__ff_cc_dat__
042f0     04 F0 05 F1 | 	add	ptr__ff_cc_dat__, #4
042f4     F8 12 62 FC | 	wrlong	arg03, ptr__ff_cc_dat__
042f8     04 F0 05 F1 | 	add	ptr__ff_cc_dat__, #4
042fc     F8 14 62 FC | 	wrlong	arg04, ptr__ff_cc_dat__
04300     04 F0 05 F1 | 	add	ptr__ff_cc_dat__, #4
04304     F8 16 62 FC | 	wrlong	arg05, ptr__ff_cc_dat__
04308     03 00 00 FF 
0430c     40 F1 85 F1 | 	sub	ptr__ff_cc_dat__, ##1856
04310     00 F4 05 F6 | 	mov	result1, #0
04314                 | _ff_cc_disk_setpins_ret
04314     2D 00 64 FD | 	ret
04318                 | 
04318                 | _ff_cc_ld_word_0191
04318     01 0E 06 F1 | 	add	arg01, #1
0431c     07 F5 C1 FA | 	rdbyte	result1, arg01
04320     01 0E 86 F1 | 	sub	arg01, #1
04324     FA F4 31 F9 | 	getword	result1, result1, #0
04328     08 F4 65 F0 | 	shl	result1, #8
0432c     07 0F C2 FA | 	rdbyte	arg01, arg01
04330     07 F5 41 F5 | 	or	result1, arg01
04334                 | ' {
04334                 | ' 	WORD rv;
04334                 | ' 
04334                 | ' 	rv = ptr[1];
04334                 | ' 	rv = rv << 8 | ptr[0];
04334                 | ' 	return rv;
04334                 | _ff_cc_ld_word_0191_ret
04334     2D 00 64 FD | 	ret
04338                 | 
04338                 | _ff_cc_ld_dword_0193
04338     03 0E 06 F1 | 	add	arg01, #3
0433c     07 F5 C1 FA | 	rdbyte	result1, arg01
04340     08 F4 65 F0 | 	shl	result1, #8
04344     01 0E 86 F1 | 	sub	arg01, #1
04348     07 F9 C1 FA | 	rdbyte	_var01, arg01
0434c     FC F4 41 F5 | 	or	result1, _var01
04350     08 F4 65 F0 | 	shl	result1, #8
04354     01 0E 86 F1 | 	sub	arg01, #1
04358     07 F9 C1 FA | 	rdbyte	_var01, arg01
0435c     01 0E 86 F1 | 	sub	arg01, #1
04360     FC F4 41 F5 | 	or	result1, _var01
04364     08 F4 65 F0 | 	shl	result1, #8
04368     07 F9 C1 FA | 	rdbyte	_var01, arg01
0436c     FC F4 41 F5 | 	or	result1, _var01
04370                 | ' {
04370                 | ' 	DWORD rv;
04370                 | ' 
04370                 | ' 	rv = ptr[3];
04370                 | ' 	rv = rv << 8 | ptr[2];
04370                 | ' 	rv = rv << 8 | ptr[1];
04370                 | ' 	rv = rv << 8 | ptr[0];
04370                 | ' 	return rv;
04370                 | _ff_cc_ld_dword_0193_ret
04370     2D 00 64 FD | 	ret
04374                 | 
04374                 | _ff_cc_st_word_0194
04374     08 F9 31 F9 | 	getword	_var01, arg02, #0
04378     07 F9 41 FC | 	wrbyte	_var01, arg01
0437c     08 11 32 F9 | 	getword	arg02, arg02, #0
04380     08 10 46 F0 | 	shr	arg02, #8
04384     01 0E 06 F1 | 	add	arg01, #1
04388     08 11 32 F9 | 	getword	arg02, arg02, #0
0438c     07 11 42 FC | 	wrbyte	arg02, arg01
04390                 | _ff_cc_st_word_0194_ret
04390     2D 00 64 FD | 	ret
04394                 | 
04394                 | _ff_cc_st_dword_0195
04394     07 11 42 FC | 	wrbyte	arg02, arg01
04398     08 10 46 F0 | 	shr	arg02, #8
0439c     01 0E 06 F1 | 	add	arg01, #1
043a0     07 11 42 FC | 	wrbyte	arg02, arg01
043a4     08 10 46 F0 | 	shr	arg02, #8
043a8     01 0E 06 F1 | 	add	arg01, #1
043ac     07 11 42 FC | 	wrbyte	arg02, arg01
043b0     08 10 46 F0 | 	shr	arg02, #8
043b4     01 0E 06 F1 | 	add	arg01, #1
043b8     07 11 42 FC | 	wrbyte	arg02, arg01
043bc                 | _ff_cc_st_dword_0195_ret
043bc     2D 00 64 FD | 	ret
043c0                 | 
043c0                 | _ff_cc_mem_cpy_0198
043c0     00 12 0E F2 | 	cmp	arg03, #0 wz
043c4     24 00 90 AD |  if_e	jmp	#LR__0248
043c8                 | ' 		do {
043c8     50 BC 9F FE | 	loc	pa,	#(@LR__0246-@LR__0244)
043cc     8C 00 A0 FD | 	call	#FCACHE_LOAD_
043d0                 | LR__0244
043d0     09 0D D8 FC | 	rep	@LR__0247, arg03
043d4                 | LR__0245
043d4     08 13 02 F6 | 	mov	arg03, arg02
043d8     01 12 06 F1 | 	add	arg03, #1
043dc     08 F9 C1 FA | 	rdbyte	_var01, arg02
043e0     09 11 02 F6 | 	mov	arg02, arg03
043e4     07 F9 41 FC | 	wrbyte	_var01, arg01
043e8     01 0E 06 F1 | 	add	arg01, #1
043ec                 | LR__0246
043ec                 | LR__0247
043ec                 | LR__0248
043ec                 | _ff_cc_mem_cpy_0198_ret
043ec     2D 00 64 FD | 	ret
043f0                 | 
043f0                 | _ff_cc_mem_cmp_0204
043f0     30 BC 9F FE | 	loc	pa,	#(@LR__0250-@LR__0249)
043f4     8C 00 A0 FD | 	call	#FCACHE_LOAD_
043f8                 | ' 
043f8                 | ' 	do {
043f8                 | LR__0249
043f8     07 F9 C1 FA | 	rdbyte	_var01, arg01
043fc     08 FB C1 FA | 	rdbyte	_var02, arg02
04400     FD F8 81 F1 | 	sub	_var01, _var02
04404     01 12 8E F1 | 	sub	arg03, #1 wz
04408     01 0E 06 F1 | 	add	arg01, #1
0440c     01 10 06 F1 | 	add	arg02, #1
04410     08 00 90 AD |  if_e	jmp	#LR__0251
04414     00 F8 0D F2 | 	cmp	_var01, #0 wz
04418     DC FF 9F AD |  if_e	jmp	#LR__0249
0441c                 | LR__0250
0441c                 | LR__0251
0441c                 | ' 
0441c                 | ' 	return r;
0441c     FC F4 01 F6 | 	mov	result1, _var01
04420                 | _ff_cc_mem_cmp_0204_ret
04420     2D 00 64 FD | 	ret
04424                 | 
04424                 | _ff_cc_tchar2uni_0212
04424     03 4C 05 F6 | 	mov	COUNT_, #3
04428     A9 00 A0 FD | 	call	#pushregs_
0442c     07 19 02 F6 | 	mov	local01, arg01
04430     0C 1B 02 FB | 	rdlong	local02, local01
04434     0D 1D C2 FA | 	rdbyte	local03, local02
04438     0E 0F 32 F9 | 	getword	arg01, local03, #0
0443c     01 1A 06 F1 | 	add	local02, #1
04440     07 0E 4E F7 | 	zerox	arg01, #7 wz
04444     00 F4 05 56 |  if_ne	mov	result1, #0
04448                 | ' 
04448                 | ' 	return 0;
04448     00 F4 05 A6 |  if_e	mov	result1, #0
0444c     00 F4 0D F2 | 	cmp	result1, #0 wz
04450     34 00 90 AD |  if_e	jmp	#LR__0252
04454     0D 11 C2 FA | 	rdbyte	arg02, local02
04458     08 0F 02 F6 | 	mov	arg01, arg02
0445c     01 1A 06 F1 | 	add	local02, #1
04460     07 0E 4E F7 | 	zerox	arg01, #7 wz
04464     00 F4 05 56 |  if_ne	mov	result1, #0
04468                 | ' 
04468                 | ' 	return 0;
04468     00 F4 05 A6 |  if_e	mov	result1, #0
0446c     00 F4 0D F2 | 	cmp	result1, #0 wz
04470     01 F4 65 A6 |  if_e	neg	result1, #1
04474     48 00 90 AD |  if_e	jmp	#LR__0254
04478     0E 1D 32 F9 | 	getword	local03, local03, #0
0447c     08 1C 66 F0 | 	shl	local03, #8
04480     08 11 E2 F8 | 	getbyte	arg02, arg02, #0
04484     08 1D 02 F1 | 	add	local03, arg02
04488                 | LR__0252
04488     0E 11 02 F6 | 	mov	arg02, local03
0448c     0F 10 4E F7 | 	zerox	arg02, #15 wz
04490     24 00 90 AD |  if_e	jmp	#LR__0253
04494     0E 0F 02 F6 | 	mov	arg01, local03
04498     01 00 00 FF 
0449c     52 11 06 F6 | 	mov	arg02, ##850
044a0     20 F2 BF FD | 	call	#_ff_cc_ff_oem2uni
044a4     FA 1C 02 F6 | 	mov	local03, result1
044a8     0E 11 02 F6 | 	mov	arg02, local03
044ac     0F 10 4E F7 | 	zerox	arg02, #15 wz
044b0     01 F4 65 A6 |  if_e	neg	result1, #1
044b4     08 00 90 AD |  if_e	jmp	#LR__0254
044b8                 | LR__0253
044b8     0E F5 31 F9 | 	getword	result1, local03, #0
044bc     0C 1B 62 FC | 	wrlong	local02, local01
044c0                 | ' 	}
044c0                 | ' 	uc = wc;
044c0                 | ' 
044c0                 | ' 
044c0                 | ' 	*str = p;
044c0                 | ' 	return uc;
044c0                 | LR__0254
044c0     A8 F0 03 F6 | 	mov	ptra, fp
044c4     B3 00 A0 FD | 	call	#popregs_
044c8                 | _ff_cc_tchar2uni_0212_ret
044c8     2D 00 64 FD | 	ret
044cc                 | 
044cc                 | _ff_cc_put_utf_0214
044cc     05 4C 05 F6 | 	mov	COUNT_, #5
044d0     A9 00 A0 FD | 	call	#pushregs_
044d4     08 19 02 F6 | 	mov	local01, arg02
044d8     09 1B 02 F6 | 	mov	local02, arg03
044dc     01 00 00 FF 
044e0     52 11 06 F6 | 	mov	arg02, ##850
044e4     38 F2 BF FD | 	call	#_ff_cc_ff_uni2oem
044e8     FA 1C 02 F6 | 	mov	local03, result1
044ec     0E 13 32 F9 | 	getword	arg03, local03, #0
044f0     00 13 16 F2 | 	cmp	arg03, #256 wc
044f4     2C 00 90 CD |  if_b	jmp	#LR__0255
044f8     02 1A 16 F2 | 	cmp	local02, #2 wc
044fc     00 F4 05 C6 |  if_b	mov	result1, #0
04500     40 00 90 CD |  if_b	jmp	#LR__0256
04504     0E F5 31 F9 | 	getword	result1, local03, #0
04508     08 F4 45 F0 | 	shr	result1, #8
0450c     0C F5 41 FC | 	wrbyte	result1, local01
04510     01 18 06 F1 | 	add	local01, #1
04514     0E 1D 32 F9 | 	getword	local03, local03, #0
04518     0C 1D 42 FC | 	wrbyte	local03, local01
0451c                 | ' 		*buf++ = (TCHAR)wc;
0451c                 | ' 		return 2;
0451c     02 F4 05 F6 | 	mov	result1, #2
04520     20 00 90 FD | 	jmp	#LR__0256
04524                 | LR__0255
04524     0E 1F 02 F6 | 	mov	local04, local03
04528     0F 1E 4E F7 | 	zerox	local04, #15 wz
0452c     01 1A 16 52 |  if_ne	cmp	local02, #1 wc
04530     00 F4 05 E6 |  if_be	mov	result1, #0
04534     0C 1F 02 16 |  if_a	mov	local04, local01
04538     0E 21 32 19 |  if_a	getword	local05, local03, #0
0453c     0F 21 42 1C |  if_a	wrbyte	local05, local04
04540                 | ' 	*buf++ = (TCHAR)wc;
04540                 | ' 	return 1;
04540     01 F4 05 16 |  if_a	mov	result1, #1
04544                 | LR__0256
04544     A8 F0 03 F6 | 	mov	ptra, fp
04548     B3 00 A0 FD | 	call	#popregs_
0454c                 | _ff_cc_put_utf_0214_ret
0454c     2D 00 64 FD | 	ret
04550                 | 
04550                 | _ff_cc_sync_window_0216
04550     03 4C 05 F6 | 	mov	COUNT_, #3
04554     A9 00 A0 FD | 	call	#pushregs_
04558     07 19 02 F6 | 	mov	local01, arg01
0455c     00 1A 06 F6 | 	mov	local02, #0
04560     03 18 06 F1 | 	add	local01, #3
04564     0C 1D CA FA | 	rdbyte	local03, local01 wz
04568     03 18 86 F1 | 	sub	local01, #3
0456c     A4 00 90 AD |  if_e	jmp	#LR__0259
04570     01 18 06 F1 | 	add	local01, #1
04574     0C 0F C2 FA | 	rdbyte	arg01, local01
04578     33 18 06 F1 | 	add	local01, #51
0457c     0C 11 02 F6 | 	mov	arg02, local01
04580     04 18 86 F1 | 	sub	local01, #4
04584     0C 13 02 FB | 	rdlong	arg03, local01
04588     30 18 86 F1 | 	sub	local01, #48
0458c     01 14 06 F6 | 	mov	arg04, #1
04590     D4 F9 BF FD | 	call	#_ff_cc_disk_write
04594     00 F4 0D F2 | 	cmp	result1, #0 wz
04598     74 00 90 5D |  if_ne	jmp	#LR__0257
0459c     03 18 06 F1 | 	add	local01, #3
045a0     0C 01 48 FC | 	wrbyte	#0, local01
045a4     2D 18 06 F1 | 	add	local01, #45
045a8     0C 1D 02 FB | 	rdlong	local03, local01
045ac     0C 18 86 F1 | 	sub	local01, #12
045b0     0C F5 01 FB | 	rdlong	result1, local01
045b4     FA 1C 82 F1 | 	sub	local03, result1
045b8     08 18 86 F1 | 	sub	local01, #8
045bc     0C 15 02 FB | 	rdlong	arg04, local01
045c0     1C 18 86 F1 | 	sub	local01, #28
045c4     0A 1D 12 F2 | 	cmp	local03, arg04 wc
045c8     48 00 90 3D |  if_ae	jmp	#LR__0258
045cc     02 18 06 F1 | 	add	local01, #2
045d0     0C 1D C2 FA | 	rdbyte	local03, local01
045d4     02 18 86 F1 | 	sub	local01, #2
045d8     02 1C 0E F2 | 	cmp	local03, #2 wz
045dc     34 00 90 5D |  if_ne	jmp	#LR__0258
045e0     01 18 06 F1 | 	add	local01, #1
045e4     0C 0F C2 FA | 	rdbyte	arg01, local01
045e8     33 18 06 F1 | 	add	local01, #51
045ec     0C 11 02 F6 | 	mov	arg02, local01
045f0     04 18 86 F1 | 	sub	local01, #4
045f4     0C 13 02 FB | 	rdlong	arg03, local01
045f8     14 18 86 F1 | 	sub	local01, #20
045fc     0C 1D 02 FB | 	rdlong	local03, local01
04600     0E 13 02 F1 | 	add	arg03, local03
04604     01 14 06 F6 | 	mov	arg04, #1
04608     5C F9 BF FD | 	call	#_ff_cc_disk_write
0460c     04 00 90 FD | 	jmp	#LR__0258
04610                 | LR__0257
04610     01 1A 06 F6 | 	mov	local02, #1
04614                 | LR__0258
04614                 | LR__0259
04614                 | ' 			res = FR_DISK_ERR;
04614                 | ' 		}
04614                 | ' 	}
04614                 | ' 	return res;
04614     0D F5 01 F6 | 	mov	result1, local02
04618     A8 F0 03 F6 | 	mov	ptra, fp
0461c     B3 00 A0 FD | 	call	#popregs_
04620                 | _ff_cc_sync_window_0216_ret
04620     2D 00 64 FD | 	ret
04624                 | 
04624                 | _ff_cc_move_window_0218
04624     03 4C 05 F6 | 	mov	COUNT_, #3
04628     A9 00 A0 FD | 	call	#pushregs_
0462c     07 19 02 F6 | 	mov	local01, arg01
04630     08 1B 02 F6 | 	mov	local02, arg02
04634     00 1C 06 F6 | 	mov	local03, #0
04638     30 18 06 F1 | 	add	local01, #48
0463c     0C 0F 02 FB | 	rdlong	arg01, local01
04640     30 18 86 F1 | 	sub	local01, #48
04644     07 1B 0A F2 | 	cmp	local02, arg01 wz
04648     44 00 90 AD |  if_e	jmp	#LR__0261
0464c     0C 0F 02 F6 | 	mov	arg01, local01
04650     FC FE BF FD | 	call	#_ff_cc_sync_window_0216
04654     FA 1C 0A F6 | 	mov	local03, result1 wz
04658     34 00 90 5D |  if_ne	jmp	#LR__0260
0465c     01 18 06 F1 | 	add	local01, #1
04660     0C 0F C2 FA | 	rdbyte	arg01, local01
04664     33 18 06 F1 | 	add	local01, #51
04668     0C 11 02 F6 | 	mov	arg02, local01
0466c     34 18 86 F1 | 	sub	local01, #52
04670     0D 13 02 F6 | 	mov	arg03, local02
04674     01 14 06 F6 | 	mov	arg04, #1
04678     20 F8 BF FD | 	call	#_ff_cc_disk_read
0467c     00 F4 0D F2 | 	cmp	result1, #0 wz
04680     01 1A 66 56 |  if_ne	neg	local02, #1
04684     01 1C 06 56 |  if_ne	mov	local03, #1
04688     30 18 06 F1 | 	add	local01, #48
0468c     0C 1B 62 FC | 	wrlong	local02, local01
04690                 | LR__0260
04690                 | LR__0261
04690                 | ' 				sect = (LBA_t)0 - 1;
04690                 | ' 				res = FR_DISK_ERR;
04690                 | ' 			}
04690                 | ' 			fs->winsect = sect;
04690                 | ' 		}
04690                 | ' 	}
04690                 | ' 	return res;
04690     0E F5 01 F6 | 	mov	result1, local03
04694     A8 F0 03 F6 | 	mov	ptra, fp
04698     B3 00 A0 FD | 	call	#popregs_
0469c                 | _ff_cc_move_window_0218_ret
0469c     2D 00 64 FD | 	ret
046a0                 | 
046a0                 | _ff_cc_sync_fs_0220
046a0     06 4C 05 F6 | 	mov	COUNT_, #6
046a4     A9 00 A0 FD | 	call	#pushregs_
046a8     07 19 02 F6 | 	mov	local01, arg01
046ac     A0 FE BF FD | 	call	#_ff_cc_sync_window_0216
046b0     FA 1A 0A F6 | 	mov	local02, result1 wz
046b4     3C 01 90 5D |  if_ne	jmp	#LR__0267
046b8     0C 13 C2 FA | 	rdbyte	arg03, local01
046bc     03 12 0E F2 | 	cmp	arg03, #3 wz
046c0     14 01 90 5D |  if_ne	jmp	#LR__0266
046c4     04 18 06 F1 | 	add	local01, #4
046c8     0C 13 C2 FA | 	rdbyte	arg03, local01
046cc     04 18 86 F1 | 	sub	local01, #4
046d0     01 12 0E F2 | 	cmp	arg03, #1 wz
046d4     00 01 90 5D |  if_ne	jmp	#LR__0266
046d8     34 18 06 F1 | 	add	local01, #52
046dc     0C 0F 02 F6 | 	mov	arg01, local01
046e0     34 18 86 F1 | 	sub	local01, #52
046e4     00 10 06 F6 | 	mov	arg02, #0
046e8     09 12 C6 F9 | 	decod	arg03, #9
046ec                 | ' {
046ec                 | ' 	BYTE *d = (BYTE*)dst;
046ec                 | ' 
046ec                 | ' 	do {
046ec     20 B9 9F FE | 	loc	pa,	#(@LR__0264-@LR__0262)
046f0     8C 00 A0 FD | 	call	#FCACHE_LOAD_
046f4                 | LR__0262
046f4     01 00 00 FF 
046f8     00 04 DC FC | 	rep	@LR__0265, ##512
046fc                 | LR__0263
046fc     07 11 42 FC | 	wrbyte	arg02, arg01
04700     01 0E 06 F1 | 	add	arg01, #1
04704                 | LR__0264
04704                 | LR__0265
04704     34 18 06 F1 | 	add	local01, #52
04708     0C 0F 02 F6 | 	mov	arg01, local01
0470c     34 18 86 F1 | 	sub	local01, #52
04710     FE 0F 06 F1 | 	add	arg01, #510
04714     55 00 00 FF 
04718     55 10 06 F6 | 	mov	arg02, ##43605
0471c     54 FC BF FD | 	call	#_ff_cc_st_word_0194
04720     34 18 06 F1 | 	add	local01, #52
04724     0C 0F 02 F6 | 	mov	arg01, local01
04728     34 18 86 F1 | 	sub	local01, #52
0472c     A9 B0 20 FF 
04730     52 10 06 F6 | 	mov	arg02, ##1096897106
04734     5C FC BF FD | 	call	#_ff_cc_st_dword_0195
04738     34 18 06 F1 | 	add	local01, #52
0473c     0C 0F 02 F6 | 	mov	arg01, local01
04740     34 18 86 F1 | 	sub	local01, #52
04744     E4 0F 06 F1 | 	add	arg01, #484
04748     B9 A0 30 FF 
0474c     72 10 06 F6 | 	mov	arg02, ##1631679090
04750     40 FC BF FD | 	call	#_ff_cc_st_dword_0195
04754     34 18 06 F1 | 	add	local01, #52
04758     0C 0F 02 F6 | 	mov	arg01, local01
0475c     E8 0F 06 F1 | 	add	arg01, #488
04760     20 18 86 F1 | 	sub	local01, #32
04764     0C 11 02 FB | 	rdlong	arg02, local01
04768     14 18 86 F1 | 	sub	local01, #20
0476c     24 FC BF FD | 	call	#_ff_cc_st_dword_0195
04770     34 18 06 F1 | 	add	local01, #52
04774     0C 0F 02 F6 | 	mov	arg01, local01
04778     EC 0F 06 F1 | 	add	arg01, #492
0477c     24 18 86 F1 | 	sub	local01, #36
04780     0C 11 02 FB | 	rdlong	arg02, local01
04784     10 18 86 F1 | 	sub	local01, #16
04788     08 FC BF FD | 	call	#_ff_cc_st_dword_0195
0478c     20 18 06 F1 | 	add	local01, #32
04790     0C 1D 02 FB | 	rdlong	local03, local01
04794     01 1C 06 F1 | 	add	local03, #1
04798     10 18 06 F1 | 	add	local01, #16
0479c     0C 1D 62 FC | 	wrlong	local03, local01
047a0     2F 18 86 F1 | 	sub	local01, #47
047a4     0C 0F C2 FA | 	rdbyte	arg01, local01
047a8     33 18 06 F1 | 	add	local01, #51
047ac     0C 1F 02 F6 | 	mov	local04, local01
047b0     01 20 06 F6 | 	mov	local05, #1
047b4     0F 11 02 F6 | 	mov	arg02, local04
047b8     0E 13 02 F6 | 	mov	arg03, local03
047bc     01 14 06 F6 | 	mov	arg04, #1
047c0     34 18 86 F1 | 	sub	local01, #52
047c4     A0 F7 BF FD | 	call	#_ff_cc_disk_write
047c8     00 22 06 F6 | 	mov	local06, #0
047cc     04 18 06 F1 | 	add	local01, #4
047d0     0C 01 48 FC | 	wrbyte	#0, local01
047d4     04 18 86 F1 | 	sub	local01, #4
047d8                 | LR__0266
047d8     01 18 06 F1 | 	add	local01, #1
047dc     0C 0F C2 FA | 	rdbyte	arg01, local01
047e0     00 10 06 F6 | 	mov	arg02, #0
047e4     00 12 06 F6 | 	mov	arg03, #0
047e8     9C F8 BF FD | 	call	#_ff_cc_disk_ioctl
047ec     00 F4 0D F2 | 	cmp	result1, #0 wz
047f0     01 1A 06 56 |  if_ne	mov	local02, #1
047f4                 | LR__0267
047f4                 | ' 	}
047f4                 | ' 
047f4                 | ' 	return res;
047f4     0D F5 01 F6 | 	mov	result1, local02
047f8     A8 F0 03 F6 | 	mov	ptra, fp
047fc     B3 00 A0 FD | 	call	#popregs_
04800                 | _ff_cc_sync_fs_0220_ret
04800     2D 00 64 FD | 	ret
04804                 | 
04804                 | _ff_cc_clst2sect_0221
04804     02 10 86 F1 | 	sub	arg02, #2
04808     18 0E 06 F1 | 	add	arg01, #24
0480c     07 F9 01 FB | 	rdlong	_var01, arg01
04810     18 0E 86 F1 | 	sub	arg01, #24
04814     02 F8 85 F1 | 	sub	_var01, #2
04818     FC 10 12 F2 | 	cmp	arg02, _var01 wc
0481c     00 F4 05 36 |  if_ae	mov	result1, #0
04820     1C 00 90 3D |  if_ae	jmp	#_ff_cc_clst2sect_0221_ret
04824     0A 0E 06 F1 | 	add	arg01, #10
04828     07 F9 E1 FA | 	rdword	_var01, arg01
0482c     08 F9 01 FD | 	qmul	_var01, arg02
04830                 | ' 	return fs->database + (LBA_t)fs->csize * clst;
04830     22 0E 06 F1 | 	add	arg01, #34
04834     07 F5 01 FB | 	rdlong	result1, arg01
04838     18 F8 61 FD | 	getqx	_var01
0483c     FC F4 01 F1 | 	add	result1, _var01
04840                 | _ff_cc_clst2sect_0221_ret
04840     2D 00 64 FD | 	ret
04844                 | 
04844                 | _ff_cc_get_fat_0226
04844     09 4C 05 F6 | 	mov	COUNT_, #9
04848     A9 00 A0 FD | 	call	#pushregs_
0484c     07 19 02 F6 | 	mov	local01, arg01
04850     08 1B 02 F6 | 	mov	local02, arg02
04854     0C 1D 02 FB | 	rdlong	local03, local01
04858     02 1A 16 F2 | 	cmp	local02, #2 wc
0485c     18 00 90 CD |  if_b	jmp	#LR__0268
04860     18 1C 06 F1 | 	add	local03, #24
04864     0E 1F 02 FB | 	rdlong	local04, local03
04868     18 1C 86 F1 | 	sub	local03, #24
0486c     0F 21 02 F6 | 	mov	local05, local04
04870     10 1B 12 F2 | 	cmp	local02, local05 wc
04874     08 00 90 CD |  if_b	jmp	#LR__0269
04878                 | LR__0268
04878     01 22 06 F6 | 	mov	local06, #1
0487c     6C 01 90 FD | 	jmp	#LR__0276
04880                 | LR__0269
04880     01 22 66 F6 | 	neg	local06, #1
04884                 | ' 		val = 0xFFFFFFFF;
04884                 | ' 
04884                 | ' 		switch (fs->fs_type) {
04884     0E 25 C2 FA | 	rdbyte	local07, local03
04888     01 24 86 F1 | 	sub	local07, #1
0488c     03 24 26 F3 | 	fle	local07, #3
04890     30 24 62 FD | 	jmprel	local07
04894                 | LR__0270
04894     0C 00 90 FD | 	jmp	#LR__0271
04898     B8 00 90 FD | 	jmp	#LR__0272
0489c     FC 00 90 FD | 	jmp	#LR__0273
048a0     44 01 90 FD | 	jmp	#LR__0274
048a4                 | LR__0271
048a4     0D 25 02 F6 | 	mov	local07, local02
048a8     0D 1F 02 F6 | 	mov	local04, local02
048ac     01 1E 46 F0 | 	shr	local04, #1
048b0     0F 25 02 F1 | 	add	local07, local04
048b4     0E 0F 02 F6 | 	mov	arg01, local03
048b8     12 1F 02 F6 | 	mov	local04, local07
048bc     09 1E 46 F0 | 	shr	local04, #9
048c0     24 1C 06 F1 | 	add	local03, #36
048c4     0E 11 02 FB | 	rdlong	arg02, local03
048c8     24 1C 86 F1 | 	sub	local03, #36
048cc     0F 11 02 F1 | 	add	arg02, local04
048d0     50 FD BF FD | 	call	#_ff_cc_move_window_0218
048d4     00 F4 0D F2 | 	cmp	result1, #0 wz
048d8     10 01 90 5D |  if_ne	jmp	#LR__0275
048dc     12 1F 02 F6 | 	mov	local04, local07
048e0     FF 1F 06 F5 | 	and	local04, #511
048e4     34 1C 06 F1 | 	add	local03, #52
048e8     0E 1F 02 F1 | 	add	local04, local03
048ec     0F 27 C2 FA | 	rdbyte	local08, local04
048f0     34 1C 86 F1 | 	sub	local03, #52
048f4     0E 0F 02 F6 | 	mov	arg01, local03
048f8     01 24 06 F1 | 	add	local07, #1
048fc     12 1F 02 F6 | 	mov	local04, local07
04900     09 1E 46 F0 | 	shr	local04, #9
04904     24 1C 06 F1 | 	add	local03, #36
04908     0E 11 02 FB | 	rdlong	arg02, local03
0490c     24 1C 86 F1 | 	sub	local03, #36
04910     0F 11 02 F1 | 	add	arg02, local04
04914     0C FD BF FD | 	call	#_ff_cc_move_window_0218
04918     00 F4 0D F2 | 	cmp	result1, #0 wz
0491c     CC 00 90 5D |  if_ne	jmp	#LR__0275
04920     FF 25 06 F5 | 	and	local07, #511
04924     34 1C 06 F1 | 	add	local03, #52
04928     0E 25 02 F1 | 	add	local07, local03
0492c     12 1F C2 FA | 	rdbyte	local04, local07
04930     08 1E 66 F0 | 	shl	local04, #8
04934     0F 27 42 F5 | 	or	local08, local04
04938     01 1A CE F7 | 	test	local02, #1 wz
0493c     04 26 46 50 |  if_ne	shr	local08, #4
04940     13 21 02 56 |  if_ne	mov	local05, local08
04944     0B 26 46 A7 |  if_e	zerox	local08, #11
04948     13 21 02 A6 |  if_e	mov	local05, local08
0494c     10 23 02 F6 | 	mov	local06, local05
04950                 | ' 			wc |= fs->win[bc %  ((UINT) 512 ) ] << 8;
04950                 | ' 			val = (clst & 1) ? (wc >> 4) : (wc & 0xFFF);
04950                 | ' 			break;
04950     98 00 90 FD | 	jmp	#LR__0275
04954                 | LR__0272
04954     0E 0F 02 F6 | 	mov	arg01, local03
04958     0D 27 02 F6 | 	mov	local08, local02
0495c     08 26 46 F0 | 	shr	local08, #8
04960     24 1C 06 F1 | 	add	local03, #36
04964     0E 11 02 FB | 	rdlong	arg02, local03
04968     24 1C 86 F1 | 	sub	local03, #36
0496c     13 11 02 F1 | 	add	arg02, local08
04970     B0 FC BF FD | 	call	#_ff_cc_move_window_0218
04974     00 F4 0D F2 | 	cmp	result1, #0 wz
04978     70 00 90 5D |  if_ne	jmp	#LR__0275
0497c     34 1C 06 F1 | 	add	local03, #52
04980     01 1A 66 F0 | 	shl	local02, #1
04984     FF 1B 06 F5 | 	and	local02, #511
04988     0D 1D 02 F1 | 	add	local03, local02
0498c     0E 0F 02 F6 | 	mov	arg01, local03
04990     84 F9 BF FD | 	call	#_ff_cc_ld_word_0191
04994     FA 22 32 F9 | 	getword	local06, result1, #0
04998                 | ' 			val = ld_word(fs->win + clst * 2 %  ((UINT) 512 ) );
04998                 | ' 			break;
04998     50 00 90 FD | 	jmp	#LR__0275
0499c                 | LR__0273
0499c     0E 0F 02 F6 | 	mov	arg01, local03
049a0     0D 29 02 F6 | 	mov	local09, local02
049a4     07 28 46 F0 | 	shr	local09, #7
049a8     24 1C 06 F1 | 	add	local03, #36
049ac     0E 11 02 FB | 	rdlong	arg02, local03
049b0     24 1C 86 F1 | 	sub	local03, #36
049b4     14 11 02 F1 | 	add	arg02, local09
049b8     68 FC BF FD | 	call	#_ff_cc_move_window_0218
049bc     00 F4 0D F2 | 	cmp	result1, #0 wz
049c0     28 00 90 5D |  if_ne	jmp	#LR__0275
049c4     34 1C 06 F1 | 	add	local03, #52
049c8     0E 0F 02 F6 | 	mov	arg01, local03
049cc     02 1A 66 F0 | 	shl	local02, #2
049d0     FF 1B 06 F5 | 	and	local02, #511
049d4     0D 0F 02 F1 | 	add	arg01, local02
049d8     5C F9 BF FD | 	call	#_ff_cc_ld_dword_0193
049dc     FA 22 02 F6 | 	mov	local06, result1
049e0     7C 22 06 F4 | 	bitl	local06, #124
049e4                 | ' 			val = ld_dword(fs->win + clst * 4 %  ((UINT) 512 ) ) & 0x0FFFFFFF;
049e4                 | ' 			break;
049e4     04 00 90 FD | 	jmp	#LR__0275
049e8                 | LR__0274
049e8     01 22 06 F6 | 	mov	local06, #1
049ec                 | LR__0275
049ec                 | LR__0276
049ec                 | ' 			val = 1;
049ec                 | ' 		}
049ec                 | ' 	}
049ec                 | ' 
049ec                 | ' 	return val;
049ec     11 F5 01 F6 | 	mov	result1, local06
049f0     A8 F0 03 F6 | 	mov	ptra, fp
049f4     B3 00 A0 FD | 	call	#popregs_
049f8                 | _ff_cc_get_fat_0226_ret
049f8     2D 00 64 FD | 	ret
049fc                 | 
049fc                 | _ff_cc_put_fat_0230
049fc     0F 4C 05 F6 | 	mov	COUNT_, #15
04a00     A9 00 A0 FD | 	call	#pushregs_
04a04     07 19 02 F6 | 	mov	local01, arg01
04a08     08 1B 02 F6 | 	mov	local02, arg02
04a0c     09 1D 02 F6 | 	mov	local03, arg03
04a10     02 1E 06 F6 | 	mov	local04, #2
04a14     02 1A 16 F2 | 	cmp	local02, #2 wc
04a18     9C 02 90 CD |  if_b	jmp	#LR__0285
04a1c     18 18 06 F1 | 	add	local01, #24
04a20     0C 21 02 FB | 	rdlong	local05, local01
04a24     18 18 86 F1 | 	sub	local01, #24
04a28     10 23 02 F6 | 	mov	local06, local05
04a2c     11 1B 12 F2 | 	cmp	local02, local06 wc
04a30     84 02 90 3D |  if_ae	jmp	#LR__0285
04a34                 | ' 		switch (fs->fs_type) {
04a34     0C 25 C2 FA | 	rdbyte	local07, local01
04a38     01 24 86 F1 | 	sub	local07, #1
04a3c     03 24 26 F3 | 	fle	local07, #3
04a40     30 24 62 FD | 	jmprel	local07
04a44                 | LR__0277
04a44     0C 00 90 FD | 	jmp	#LR__0278
04a48     3C 01 90 FD | 	jmp	#LR__0282
04a4c     B8 01 90 FD | 	jmp	#LR__0283
04a50     64 02 90 FD | 	jmp	#LR__0284
04a54                 | LR__0278
04a54     0D 27 02 F6 | 	mov	local08, local02
04a58     0D 21 02 F6 | 	mov	local05, local02
04a5c     01 20 46 F0 | 	shr	local05, #1
04a60     10 27 02 F1 | 	add	local08, local05
04a64     0C 0F 02 F6 | 	mov	arg01, local01
04a68     13 29 02 F6 | 	mov	local09, local08
04a6c     09 28 46 F0 | 	shr	local09, #9
04a70     24 18 06 F1 | 	add	local01, #36
04a74     0C 2B 02 FB | 	rdlong	local10, local01
04a78     24 18 86 F1 | 	sub	local01, #36
04a7c     15 2D 02 F6 | 	mov	local11, local10
04a80     14 2D 02 F1 | 	add	local11, local09
04a84     16 21 02 F6 | 	mov	local05, local11
04a88     10 11 02 F6 | 	mov	arg02, local05
04a8c     94 FB BF FD | 	call	#_ff_cc_move_window_0218
04a90     FA 22 02 F6 | 	mov	local06, result1
04a94     11 1F 0A F6 | 	mov	local04, local06 wz
04a98     1C 02 90 5D |  if_ne	jmp	#LR__0284
04a9c     34 18 06 F1 | 	add	local01, #52
04aa0     0C 2F 02 F6 | 	mov	local12, local01
04aa4     13 31 02 F6 | 	mov	local13, local08
04aa8     FF 31 06 F5 | 	and	local13, #511
04aac     18 2F 02 F1 | 	add	local12, local13
04ab0     01 1A CE F7 | 	test	local02, #1 wz
04ab4     34 18 86 F1 | 	sub	local01, #52
04ab8     01 26 06 F1 | 	add	local08, #1
04abc     18 00 90 AD |  if_e	jmp	#LR__0279
04ac0     17 23 C2 FA | 	rdbyte	local06, local12
04ac4     11 23 42 F8 | 	getnib	local06, local06, #0
04ac8     0E 29 E2 F8 | 	getbyte	local09, local03, #0
04acc     04 28 66 F0 | 	shl	local09, #4
04ad0     14 23 42 F5 | 	or	local06, local09
04ad4     04 00 90 FD | 	jmp	#LR__0280
04ad8                 | LR__0279
04ad8     0E 23 02 F6 | 	mov	local06, local03
04adc                 | LR__0280
04adc     17 23 42 FC | 	wrbyte	local06, local12
04ae0     03 18 06 F1 | 	add	local01, #3
04ae4     0C 03 48 FC | 	wrbyte	#1, local01
04ae8     03 18 86 F1 | 	sub	local01, #3
04aec     0C 0F 02 F6 | 	mov	arg01, local01
04af0     13 29 02 F6 | 	mov	local09, local08
04af4     09 28 46 F0 | 	shr	local09, #9
04af8     24 18 06 F1 | 	add	local01, #36
04afc     0C 2B 02 FB | 	rdlong	local10, local01
04b00     24 18 86 F1 | 	sub	local01, #36
04b04     15 2D 02 F6 | 	mov	local11, local10
04b08     14 2D 02 F1 | 	add	local11, local09
04b0c     16 21 02 F6 | 	mov	local05, local11
04b10     10 11 02 F6 | 	mov	arg02, local05
04b14     0C FB BF FD | 	call	#_ff_cc_move_window_0218
04b18     FA 22 02 F6 | 	mov	local06, result1
04b1c     11 1F 0A F6 | 	mov	local04, local06 wz
04b20     94 01 90 5D |  if_ne	jmp	#LR__0284
04b24     34 18 06 F1 | 	add	local01, #52
04b28     0C 2F 02 F6 | 	mov	local12, local01
04b2c     13 2D 02 F6 | 	mov	local11, local08
04b30     FF 2D 06 F5 | 	and	local11, #511
04b34     16 29 02 F6 | 	mov	local09, local11
04b38     16 2F 02 F1 | 	add	local12, local11
04b3c     0D 21 02 F6 | 	mov	local05, local02
04b40     01 20 0E F5 | 	and	local05, #1 wz
04b44     34 18 86 F1 | 	sub	local01, #52
04b48     0E 2D 02 56 |  if_ne	mov	local11, local03
04b4c     04 2C 46 50 |  if_ne	shr	local11, #4
04b50     16 23 02 56 |  if_ne	mov	local06, local11
04b54     18 00 90 5D |  if_ne	jmp	#LR__0281
04b58     17 29 C2 FA | 	rdbyte	local09, local12
04b5c     F0 28 06 F5 | 	and	local09, #240
04b60     0E 2B EA F8 | 	getbyte	local10, local03, #1
04b64     15 2B 42 F8 | 	getnib	local10, local10, #0
04b68     15 29 42 F5 | 	or	local09, local10
04b6c     14 23 02 F6 | 	mov	local06, local09
04b70                 | LR__0281
04b70     17 23 42 FC | 	wrbyte	local06, local12
04b74     01 22 06 F6 | 	mov	local06, #1
04b78     03 18 06 F1 | 	add	local01, #3
04b7c     0C 03 48 FC | 	wrbyte	#1, local01
04b80     03 18 86 F1 | 	sub	local01, #3
04b84                 | ' 			p = fs->win + bc %  ((UINT) 512 ) ;
04b84                 | ' 			*p = (clst & 1) ? (BYTE)(val >> 4) : ((*p & 0xF0) | ((BYTE)(val >> 8) & 0x0F));
04b84                 | ' 			fs->wflag = 1;
04b84                 | ' 			break;
04b84     30 01 90 FD | 	jmp	#LR__0284
04b88                 | LR__0282
04b88     0C 0F 02 F6 | 	mov	arg01, local01
04b8c     0D 29 02 F6 | 	mov	local09, local02
04b90     08 28 46 F0 | 	shr	local09, #8
04b94     24 18 06 F1 | 	add	local01, #36
04b98     0C 2B 02 FB | 	rdlong	local10, local01
04b9c     24 18 86 F1 | 	sub	local01, #36
04ba0     15 2D 02 F6 | 	mov	local11, local10
04ba4     14 2D 02 F1 | 	add	local11, local09
04ba8     16 21 02 F6 | 	mov	local05, local11
04bac     10 11 02 F6 | 	mov	arg02, local05
04bb0     70 FA BF FD | 	call	#_ff_cc_move_window_0218
04bb4     FA 22 02 F6 | 	mov	local06, result1
04bb8     11 1F 0A F6 | 	mov	local04, local06 wz
04bbc     F8 00 90 5D |  if_ne	jmp	#LR__0284
04bc0     34 18 06 F1 | 	add	local01, #52
04bc4     0C 2D 02 F6 | 	mov	local11, local01
04bc8     0D 29 02 F6 | 	mov	local09, local02
04bcc     01 28 66 F0 | 	shl	local09, #1
04bd0     14 2B 02 F6 | 	mov	local10, local09
04bd4     FF 2B 06 F5 | 	and	local10, #511
04bd8     15 31 02 F6 | 	mov	local13, local10
04bdc     16 0F 02 F6 | 	mov	arg01, local11
04be0     18 0F 02 F1 | 	add	arg01, local13
04be4     0E 21 02 F6 | 	mov	local05, local03
04be8     10 11 02 F6 | 	mov	arg02, local05
04bec     34 18 86 F1 | 	sub	local01, #52
04bf0     80 F7 BF FD | 	call	#_ff_cc_st_word_0194
04bf4     01 22 06 F6 | 	mov	local06, #1
04bf8     03 18 06 F1 | 	add	local01, #3
04bfc     0C 03 48 FC | 	wrbyte	#1, local01
04c00     03 18 86 F1 | 	sub	local01, #3
04c04                 | ' 			st_word(fs->win + clst * 2 %  ((UINT) 512 ) , (WORD)val);
04c04                 | ' 			fs->wflag = 1;
04c04                 | ' 			break;
04c04     B0 00 90 FD | 	jmp	#LR__0284
04c08                 | LR__0283
04c08     0C 0F 02 F6 | 	mov	arg01, local01
04c0c     0D 29 02 F6 | 	mov	local09, local02
04c10     07 28 46 F0 | 	shr	local09, #7
04c14     24 18 06 F1 | 	add	local01, #36
04c18     0C 2B 02 FB | 	rdlong	local10, local01
04c1c     24 18 86 F1 | 	sub	local01, #36
04c20     15 2D 02 F6 | 	mov	local11, local10
04c24     14 2D 02 F1 | 	add	local11, local09
04c28     16 21 02 F6 | 	mov	local05, local11
04c2c     10 11 02 F6 | 	mov	arg02, local05
04c30     F0 F9 BF FD | 	call	#_ff_cc_move_window_0218
04c34     FA 22 02 F6 | 	mov	local06, result1
04c38     11 1F 0A F6 | 	mov	local04, local06 wz
04c3c     78 00 90 5D |  if_ne	jmp	#LR__0284
04c40     7C 1C 06 F4 | 	bitl	local03, #124
04c44     34 18 06 F1 | 	add	local01, #52
04c48     0C 0F 02 F6 | 	mov	arg01, local01
04c4c     34 18 86 F1 | 	sub	local01, #52
04c50     0D 33 02 F6 | 	mov	local14, local02
04c54     02 32 66 F0 | 	shl	local14, #2
04c58     FF 33 06 F5 | 	and	local14, #511
04c5c     19 35 02 F6 | 	mov	local15, local14
04c60     19 0F 02 F1 | 	add	arg01, local14
04c64     D0 F6 BF FD | 	call	#_ff_cc_ld_dword_0193
04c68     00 00 78 FF 
04c6c     00 F4 05 F5 | 	and	result1, ##-268435456
04c70     FA 1C 42 F5 | 	or	local03, result1
04c74     34 18 06 F1 | 	add	local01, #52
04c78     0C 2D 02 F6 | 	mov	local11, local01
04c7c     0D 29 02 F6 | 	mov	local09, local02
04c80     02 28 66 F0 | 	shl	local09, #2
04c84     14 2B 02 F6 | 	mov	local10, local09
04c88     FF 2B 06 F5 | 	and	local10, #511
04c8c     15 31 02 F6 | 	mov	local13, local10
04c90     16 0F 02 F6 | 	mov	arg01, local11
04c94     18 0F 02 F1 | 	add	arg01, local13
04c98     0E 21 02 F6 | 	mov	local05, local03
04c9c     10 11 02 F6 | 	mov	arg02, local05
04ca0     34 18 86 F1 | 	sub	local01, #52
04ca4     EC F6 BF FD | 	call	#_ff_cc_st_dword_0195
04ca8     01 22 06 F6 | 	mov	local06, #1
04cac     03 18 06 F1 | 	add	local01, #3
04cb0     0C 03 48 FC | 	wrbyte	#1, local01
04cb4     03 18 86 F1 | 	sub	local01, #3
04cb8                 | ' 				val = (val & 0x0FFFFFFF) | (ld_dword(fs->win + clst * 4 %  ((UINT) 512 ) ) & 0xF0000000);
04cb8                 | ' 			}
04cb8                 | ' 			st_dword(fs->win + clst * 4 %  ((UINT) 512 ) , val);
04cb8                 | ' 			fs->wflag = 1;
04cb8                 | ' 			break;
04cb8                 | LR__0284
04cb8                 | LR__0285
04cb8                 | ' 		}
04cb8                 | ' 	}
04cb8                 | ' 	return res;
04cb8     0F F5 01 F6 | 	mov	result1, local04
04cbc     A8 F0 03 F6 | 	mov	ptra, fp
04cc0     B3 00 A0 FD | 	call	#popregs_
04cc4                 | _ff_cc_put_fat_0230_ret
04cc4     2D 00 64 FD | 	ret
04cc8                 | 
04cc8                 | _ff_cc_remove_chain_0234
04cc8     06 4C 05 F6 | 	mov	COUNT_, #6
04ccc     A9 00 A0 FD | 	call	#pushregs_
04cd0     07 19 02 F6 | 	mov	local01, arg01
04cd4     08 1B 02 F6 | 	mov	local02, arg02
04cd8     09 1D 02 F6 | 	mov	local03, arg03
04cdc     0C 1F 02 FB | 	rdlong	local04, local01
04ce0     02 1A 16 F2 | 	cmp	local02, #2 wc
04ce4     14 00 90 CD |  if_b	jmp	#LR__0286
04ce8     18 1E 06 F1 | 	add	local04, #24
04cec     0F F5 01 FB | 	rdlong	result1, local04
04cf0     18 1E 86 F1 | 	sub	local04, #24
04cf4     FA 1A 12 F2 | 	cmp	local02, result1 wc
04cf8     08 00 90 CD |  if_b	jmp	#LR__0287
04cfc                 | LR__0286
04cfc     02 F4 05 F6 | 	mov	result1, #2
04d00     D0 00 90 FD | 	jmp	#LR__0292
04d04                 | LR__0287
04d04     00 1C 0E F2 | 	cmp	local03, #0 wz
04d08     1C 00 90 AD |  if_e	jmp	#LR__0288
04d0c     0F 0F 02 F6 | 	mov	arg01, local04
04d10     0E 11 02 F6 | 	mov	arg02, local03
04d14     01 12 66 F6 | 	neg	arg03, #1
04d18     E0 FC BF FD | 	call	#_ff_cc_put_fat_0230
04d1c     FA 20 0A F6 | 	mov	local05, result1 wz
04d20     10 F5 01 56 |  if_ne	mov	result1, local05
04d24     AC 00 90 5D |  if_ne	jmp	#LR__0292
04d28                 | LR__0288
04d28                 | ' 	}
04d28                 | ' 
04d28                 | ' 
04d28                 | ' 	do {
04d28                 | LR__0289
04d28     0D 11 02 F6 | 	mov	arg02, local02
04d2c     0C 0F 02 F6 | 	mov	arg01, local01
04d30     10 FB BF FD | 	call	#_ff_cc_get_fat_0226
04d34     FA 22 0A F6 | 	mov	local06, result1 wz
04d38     94 00 90 AD |  if_e	jmp	#LR__0291
04d3c     01 22 0E F2 | 	cmp	local06, #1 wz
04d40     02 F4 05 A6 |  if_e	mov	result1, #2
04d44     8C 00 90 AD |  if_e	jmp	#LR__0292
04d48     FF FF 7F FF 
04d4c     FF 23 0E F2 | 	cmp	local06, ##-1 wz
04d50     01 F4 05 A6 |  if_e	mov	result1, #1
04d54     7C 00 90 AD |  if_e	jmp	#LR__0292
04d58     0D 11 02 F6 | 	mov	arg02, local02
04d5c     0F 0F 02 F6 | 	mov	arg01, local04
04d60     00 12 06 F6 | 	mov	arg03, #0
04d64     94 FC BF FD | 	call	#_ff_cc_put_fat_0230
04d68     FA 20 0A F6 | 	mov	local05, result1 wz
04d6c     10 F5 01 56 |  if_ne	mov	result1, local05
04d70     60 00 90 5D |  if_ne	jmp	#LR__0292
04d74     18 1E 06 F1 | 	add	local04, #24
04d78     0F 21 02 FB | 	rdlong	local05, local04
04d7c     02 20 86 F1 | 	sub	local05, #2
04d80     04 1E 86 F1 | 	sub	local04, #4
04d84     0F 1D 02 FB | 	rdlong	local03, local04
04d88     14 1E 86 F1 | 	sub	local04, #20
04d8c     10 1D 12 F2 | 	cmp	local03, local05 wc
04d90     24 00 90 3D |  if_ae	jmp	#LR__0290
04d94     14 1E 06 F1 | 	add	local04, #20
04d98     0F 21 02 FB | 	rdlong	local05, local04
04d9c     01 20 06 F1 | 	add	local05, #1
04da0     0F 21 62 FC | 	wrlong	local05, local04
04da4     10 1E 86 F1 | 	sub	local04, #16
04da8     0F 21 C2 FA | 	rdbyte	local05, local04
04dac     01 20 46 F5 | 	or	local05, #1
04db0     0F 21 42 FC | 	wrbyte	local05, local04
04db4     04 1E 86 F1 | 	sub	local04, #4
04db8                 | LR__0290
04db8     11 1B 02 F6 | 	mov	local02, local06
04dbc     18 1E 06 F1 | 	add	local04, #24
04dc0     0F 21 02 FB | 	rdlong	local05, local04
04dc4     18 1E 86 F1 | 	sub	local04, #24
04dc8     10 1B 12 F2 | 	cmp	local02, local05 wc
04dcc     58 FF 9F CD |  if_b	jmp	#LR__0289
04dd0                 | LR__0291
04dd0                 | ' #line 1531 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
04dd0                 | ' 	return FR_OK;
04dd0     00 F4 05 F6 | 	mov	result1, #0
04dd4                 | LR__0292
04dd4     A8 F0 03 F6 | 	mov	ptra, fp
04dd8     B3 00 A0 FD | 	call	#popregs_
04ddc                 | _ff_cc_remove_chain_0234_ret
04ddc     2D 00 64 FD | 	ret
04de0                 | 
04de0                 | _ff_cc_create_chain_0240
04de0     0A 4C 05 F6 | 	mov	COUNT_, #10
04de4     A9 00 A0 FD | 	call	#pushregs_
04de8     07 19 02 F6 | 	mov	local01, arg01
04dec     08 1B 0A F6 | 	mov	local02, arg02 wz
04df0     0C 1D 02 FB | 	rdlong	local03, local01
04df4     28 00 90 5D |  if_ne	jmp	#LR__0293
04df8     10 1C 06 F1 | 	add	local03, #16
04dfc     0E 1F 0A FB | 	rdlong	local04, local03 wz
04e00     10 1C 86 F1 | 	sub	local03, #16
04e04     18 1C 06 51 |  if_ne	add	local03, #24
04e08     0E 21 02 5B |  if_ne	rdlong	local05, local03
04e0c     18 1C 86 51 |  if_ne	sub	local03, #24
04e10     10 1F 12 52 |  if_ne	cmp	local04, local05 wc
04e14     50 00 90 4D |  if_c_and_nz	jmp	#LR__0294
04e18     01 1E 06 F6 | 	mov	local04, #1
04e1c     48 00 90 FD | 	jmp	#LR__0294
04e20                 | LR__0293
04e20     0D 11 02 F6 | 	mov	arg02, local02
04e24     0C 0F 02 F6 | 	mov	arg01, local01
04e28     18 FA BF FD | 	call	#_ff_cc_get_fat_0226
04e2c     FA 22 02 F6 | 	mov	local06, result1
04e30     02 22 16 F2 | 	cmp	local06, #2 wc
04e34     01 F4 05 C6 |  if_b	mov	result1, #1
04e38     C8 01 90 CD |  if_b	jmp	#LR__0304
04e3c     FF FF 7F FF 
04e40     FF 23 0E F2 | 	cmp	local06, ##-1 wz
04e44     11 F5 01 A6 |  if_e	mov	result1, local06
04e48     B8 01 90 AD |  if_e	jmp	#LR__0304
04e4c     18 1C 06 F1 | 	add	local03, #24
04e50     0E 21 02 FB | 	rdlong	local05, local03
04e54     18 1C 86 F1 | 	sub	local03, #24
04e58     10 23 12 F2 | 	cmp	local06, local05 wc
04e5c     11 F5 01 C6 |  if_b	mov	result1, local06
04e60     A0 01 90 CD |  if_b	jmp	#LR__0304
04e64     0D 1F 02 F6 | 	mov	local04, local02
04e68                 | LR__0294
04e68     14 1C 06 F1 | 	add	local03, #20
04e6c     0E 21 0A FB | 	rdlong	local05, local03 wz
04e70     14 1C 86 F1 | 	sub	local03, #20
04e74     00 F4 05 A6 |  if_e	mov	result1, #0
04e78     88 01 90 AD |  if_e	jmp	#LR__0304
04e7c     00 24 06 F6 | 	mov	local07, #0
04e80     0D 1F 0A F2 | 	cmp	local04, local02 wz
04e84     74 00 90 5D |  if_ne	jmp	#LR__0297
04e88     0F 25 02 F6 | 	mov	local07, local04
04e8c     01 24 06 F1 | 	add	local07, #1
04e90     18 1C 06 F1 | 	add	local03, #24
04e94     0E 21 02 FB | 	rdlong	local05, local03
04e98     18 1C 86 F1 | 	sub	local03, #24
04e9c     10 25 12 F2 | 	cmp	local07, local05 wc
04ea0     02 24 06 36 |  if_ae	mov	local07, #2
04ea4     12 11 02 F6 | 	mov	arg02, local07
04ea8     0C 0F 02 F6 | 	mov	arg01, local01
04eac     94 F9 BF FD | 	call	#_ff_cc_get_fat_0226
04eb0     FA 22 02 F6 | 	mov	local06, result1
04eb4     01 22 0E F2 | 	cmp	local06, #1 wz
04eb8     FF FF 7F 5F 
04ebc     FF 23 0E 52 |  if_ne	cmp	local06, ##-1 wz
04ec0     11 F5 01 A6 |  if_e	mov	result1, local06
04ec4     3C 01 90 AD |  if_e	jmp	#LR__0304
04ec8     00 22 0E F2 | 	cmp	local06, #0 wz
04ecc     2C 00 90 AD |  if_e	jmp	#LR__0296
04ed0     10 1C 06 F1 | 	add	local03, #16
04ed4     0E 23 02 FB | 	rdlong	local06, local03
04ed8     10 1C 86 F1 | 	sub	local03, #16
04edc     02 22 16 F2 | 	cmp	local06, #2 wc
04ee0     14 00 90 CD |  if_b	jmp	#LR__0295
04ee4     18 1C 06 F1 | 	add	local03, #24
04ee8     0E 21 02 FB | 	rdlong	local05, local03
04eec     18 1C 86 F1 | 	sub	local03, #24
04ef0     10 23 12 F2 | 	cmp	local06, local05 wc
04ef4     11 1F 02 C6 |  if_b	mov	local04, local06
04ef8                 | LR__0295
04ef8     00 24 06 F6 | 	mov	local07, #0
04efc                 | LR__0296
04efc                 | LR__0297
04efc     00 24 0E F2 | 	cmp	local07, #0 wz
04f00     60 00 90 5D |  if_ne	jmp	#LR__0300
04f04     0F 25 02 F6 | 	mov	local07, local04
04f08                 | ' 			ncl = scl;
04f08                 | ' 			for (;;) {
04f08                 | LR__0298
04f08     01 24 06 F1 | 	add	local07, #1
04f0c     18 1C 06 F1 | 	add	local03, #24
04f10     0E 21 02 FB | 	rdlong	local05, local03
04f14     18 1C 86 F1 | 	sub	local03, #24
04f18     10 25 12 F2 | 	cmp	local07, local05 wc
04f1c     02 24 06 36 |  if_ae	mov	local07, #2
04f20     0F 25 1A 32 |  if_ae	cmp	local07, local04 wcz
04f24     00 F4 05 16 |  if_a	mov	result1, #0
04f28     D8 00 90 1D |  if_a	jmp	#LR__0304
04f2c     12 11 02 F6 | 	mov	arg02, local07
04f30     0C 0F 02 F6 | 	mov	arg01, local01
04f34     0C F9 BF FD | 	call	#_ff_cc_get_fat_0226
04f38     FA 22 0A F6 | 	mov	local06, result1 wz
04f3c     24 00 90 AD |  if_e	jmp	#LR__0299
04f40     01 22 0E F2 | 	cmp	local06, #1 wz
04f44     FF FF 7F 5F 
04f48     FF 23 0E 52 |  if_ne	cmp	local06, ##-1 wz
04f4c     11 F5 01 A6 |  if_e	mov	result1, local06
04f50     B0 00 90 AD |  if_e	jmp	#LR__0304
04f54     0F 25 0A F2 | 	cmp	local07, local04 wz
04f58     00 F4 05 A6 |  if_e	mov	result1, #0
04f5c     A4 00 90 AD |  if_e	jmp	#LR__0304
04f60     A4 FF 9F FD | 	jmp	#LR__0298
04f64                 | LR__0299
04f64                 | LR__0300
04f64     0E 0F 02 F6 | 	mov	arg01, local03
04f68     12 11 02 F6 | 	mov	arg02, local07
04f6c     01 12 66 F6 | 	neg	arg03, #1
04f70     88 FA BF FD | 	call	#_ff_cc_put_fat_0230
04f74     FA 26 0A F6 | 	mov	local08, result1 wz
04f78     28 00 90 5D |  if_ne	jmp	#LR__0301
04f7c     00 1A 0E F2 | 	cmp	local02, #0 wz
04f80     20 00 90 AD |  if_e	jmp	#LR__0301
04f84     0D 29 02 F6 | 	mov	local09, local02
04f88     12 2B 02 F6 | 	mov	local10, local07
04f8c     0E 0F 02 F6 | 	mov	arg01, local03
04f90     14 11 02 F6 | 	mov	arg02, local09
04f94     15 13 02 F6 | 	mov	arg03, local10
04f98     60 FA BF FD | 	call	#_ff_cc_put_fat_0230
04f9c     FA 20 02 F6 | 	mov	local05, result1
04fa0     10 27 02 F6 | 	mov	local08, local05
04fa4                 | LR__0301
04fa4     00 26 0E F2 | 	cmp	local08, #0 wz
04fa8     4C 00 90 5D |  if_ne	jmp	#LR__0302
04fac     10 1C 06 F1 | 	add	local03, #16
04fb0     0E 25 62 FC | 	wrlong	local07, local03
04fb4     08 1C 06 F1 | 	add	local03, #8
04fb8     0E 21 02 FB | 	rdlong	local05, local03
04fbc     02 20 86 F1 | 	sub	local05, #2
04fc0     04 1C 86 F1 | 	sub	local03, #4
04fc4     0E 2B 02 FB | 	rdlong	local10, local03
04fc8     14 1C 86 F1 | 	sub	local03, #20
04fcc     10 2B 1A F2 | 	cmp	local10, local05 wcz
04fd0     14 1C 06 E1 |  if_be	add	local03, #20
04fd4     0E 2B 02 EB |  if_be	rdlong	local10, local03
04fd8     01 2A 86 E1 |  if_be	sub	local10, #1
04fdc     0E 2B 62 EC |  if_be	wrlong	local10, local03
04fe0     14 1C 86 E1 |  if_be	sub	local03, #20
04fe4     04 1C 06 F1 | 	add	local03, #4
04fe8     0E 21 C2 FA | 	rdbyte	local05, local03
04fec     01 20 46 F5 | 	or	local05, #1
04ff0     0E 21 42 FC | 	wrbyte	local05, local03
04ff4     08 00 90 FD | 	jmp	#LR__0303
04ff8                 | LR__0302
04ff8     01 26 0E F2 | 	cmp	local08, #1 wz
04ffc     01 24 C6 F6 | 	negz	local07, #1
05000                 | LR__0303
05000                 | ' 		ncl = (res == FR_DISK_ERR) ? 0xFFFFFFFF : 1;
05000                 | ' 	}
05000                 | ' 
05000                 | ' 	return ncl;
05000     12 F5 01 F6 | 	mov	result1, local07
05004                 | LR__0304
05004     A8 F0 03 F6 | 	mov	ptra, fp
05008     B3 00 A0 FD | 	call	#popregs_
0500c                 | _ff_cc_create_chain_0240_ret
0500c     2D 00 64 FD | 	ret
05010                 | 
05010                 | _ff_cc_dir_clear_0245
05010     06 4C 05 F6 | 	mov	COUNT_, #6
05014     A9 00 A0 FD | 	call	#pushregs_
05018     07 19 02 F6 | 	mov	local01, arg01
0501c     08 1B 02 F6 | 	mov	local02, arg02
05020     0C 0F 02 F6 | 	mov	arg01, local01
05024     28 F5 BF FD | 	call	#_ff_cc_sync_window_0216
05028     00 F4 0D F2 | 	cmp	result1, #0 wz
0502c     01 F4 05 56 |  if_ne	mov	result1, #1
05030     A8 00 90 5D |  if_ne	jmp	#LR__0311
05034     0C 0F 02 F6 | 	mov	arg01, local01
05038     0D 11 02 F6 | 	mov	arg02, local02
0503c     C4 F7 BF FD | 	call	#_ff_cc_clst2sect_0221
05040     FA 1C 02 F6 | 	mov	local03, result1
05044     30 18 06 F1 | 	add	local01, #48
05048     0C 1D 62 FC | 	wrlong	local03, local01
0504c     04 18 06 F1 | 	add	local01, #4
05050     0C 0F 02 F6 | 	mov	arg01, local01
05054     34 18 86 F1 | 	sub	local01, #52
05058     00 10 06 F6 | 	mov	arg02, #0
0505c                 | ' {
0505c                 | ' 	BYTE *d = (BYTE*)dst;
0505c                 | ' 
0505c                 | ' 	do {
0505c     B0 AF 9F FE | 	loc	pa,	#(@LR__0307-@LR__0305)
05060     8C 00 A0 FD | 	call	#FCACHE_LOAD_
05064                 | LR__0305
05064     01 00 00 FF 
05068     00 04 DC FC | 	rep	@LR__0308, ##512
0506c                 | LR__0306
0506c     07 11 42 FC | 	wrbyte	arg02, arg01
05070     01 0E 06 F1 | 	add	arg01, #1
05074                 | LR__0307
05074                 | LR__0308
05074     34 18 06 F1 | 	add	local01, #52
05078     0C 1F 02 F6 | 	mov	local04, local01
0507c                 | ' #line 1698 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
0507c                 | ' 	{
0507c                 | ' 		ibuf = fs->win; szb = 1;
0507c                 | ' 		for (n = 0; n < fs->csize && disk_write(fs->pdrv, ibuf, sect + n, szb) == RES_OK; n += szb) ;
0507c     00 20 06 F6 | 	mov	local05, #0
05080     34 18 86 F1 | 	sub	local01, #52
05084                 | LR__0309
05084     0A 18 06 F1 | 	add	local01, #10
05088     0C 23 E2 FA | 	rdword	local06, local01
0508c     0A 18 86 F1 | 	sub	local01, #10
05090     11 21 12 F2 | 	cmp	local05, local06 wc
05094     2C 00 90 3D |  if_ae	jmp	#LR__0310
05098     01 18 06 F1 | 	add	local01, #1
0509c     0C 0F C2 FA | 	rdbyte	arg01, local01
050a0     01 18 86 F1 | 	sub	local01, #1
050a4     0F 11 02 F6 | 	mov	arg02, local04
050a8     0E 13 02 F6 | 	mov	arg03, local03
050ac     10 13 02 F1 | 	add	arg03, local05
050b0     01 14 06 F6 | 	mov	arg04, #1
050b4     B0 EE BF FD | 	call	#_ff_cc_disk_write
050b8     00 F4 0D F2 | 	cmp	result1, #0 wz
050bc     01 20 06 A1 |  if_e	add	local05, #1
050c0     C0 FF 9F AD |  if_e	jmp	#LR__0309
050c4                 | LR__0310
050c4                 | ' 	}
050c4                 | ' 	return (n == fs->csize) ? FR_OK : FR_DISK_ERR;
050c4     0A 18 06 F1 | 	add	local01, #10
050c8     0C 1F E2 FA | 	rdword	local04, local01
050cc     0F 21 0A F2 | 	cmp	local05, local04 wz
050d0     00 22 06 A6 |  if_e	mov	local06, #0
050d4     01 22 06 56 |  if_ne	mov	local06, #1
050d8     11 F5 01 F6 | 	mov	result1, local06
050dc                 | LR__0311
050dc     A8 F0 03 F6 | 	mov	ptra, fp
050e0     B3 00 A0 FD | 	call	#popregs_
050e4                 | _ff_cc_dir_clear_0245_ret
050e4     2D 00 64 FD | 	ret
050e8                 | 
050e8                 | _ff_cc_dir_sdi_0249
050e8     06 4C 05 F6 | 	mov	COUNT_, #6
050ec     A9 00 A0 FD | 	call	#pushregs_
050f0     07 19 02 F6 | 	mov	local01, arg01
050f4     08 1B 02 F6 | 	mov	local02, arg02
050f8     0C 1D 02 FB | 	rdlong	local03, local01
050fc     00 10 00 FF 
05100     00 1A 16 F2 | 	cmp	local02, ##2097152 wc
05104     0D 1F 02 C6 |  if_b	mov	local04, local02
05108     1F 1E CE C7 |  if_b	test	local04, #31 wz
0510c                 | ' 		return FR_INT_ERR;
0510c     02 F4 05 76 |  if_nc_or_nz	mov	result1, #2
05110     40 01 90 7D |  if_nc_or_nz	jmp	#LR__0319
05114     10 18 06 F1 | 	add	local01, #16
05118     0C 1B 62 FC | 	wrlong	local02, local01
0511c     08 18 86 F1 | 	sub	local01, #8
05120     0C 21 0A FB | 	rdlong	local05, local01 wz
05124     08 18 86 F1 | 	sub	local01, #8
05128     18 00 90 5D |  if_ne	jmp	#LR__0312
0512c     0E 1F C2 FA | 	rdbyte	local04, local03
05130     03 1E 16 F2 | 	cmp	local04, #3 wc
05134     28 1C 06 31 |  if_ae	add	local03, #40
05138     0E 1F 02 3B |  if_ae	rdlong	local04, local03
0513c     28 1C 86 31 |  if_ae	sub	local03, #40
05140     0F 21 02 36 |  if_ae	mov	local05, local04
05144                 | LR__0312
05144     00 20 0E F2 | 	cmp	local05, #0 wz
05148     3C 00 90 5D |  if_ne	jmp	#LR__0313
0514c     0D 1F 02 F6 | 	mov	local04, local02
05150     05 1E 46 F0 | 	shr	local04, #5
05154     08 1C 06 F1 | 	add	local03, #8
05158     0E 11 E2 FA | 	rdword	arg02, local03
0515c     08 1C 86 F1 | 	sub	local03, #8
05160     08 1F 12 F2 | 	cmp	local04, arg02 wc
05164     02 F4 05 36 |  if_ae	mov	result1, #2
05168     E8 00 90 3D |  if_ae	jmp	#LR__0319
0516c     28 1C 06 F1 | 	add	local03, #40
05170     0E 1F 02 FB | 	rdlong	local04, local03
05174     28 1C 86 F1 | 	sub	local03, #40
05178     18 18 06 F1 | 	add	local01, #24
0517c     0C 1F 62 FC | 	wrlong	local04, local01
05180     18 18 86 F1 | 	sub	local01, #24
05184     7C 00 90 FD | 	jmp	#LR__0318
05188                 | LR__0313
05188     0A 1C 06 F1 | 	add	local03, #10
0518c     0E 23 E2 FA | 	rdword	local06, local03
05190     0A 1C 86 F1 | 	sub	local03, #10
05194     09 22 66 F0 | 	shl	local06, #9
05198                 | ' 		csz = (DWORD)fs->csize *  ((UINT) 512 ) ;
05198                 | ' 		while (ofs >= csz) {
05198                 | LR__0314
05198     11 1B 12 F2 | 	cmp	local02, local06 wc
0519c     4C 00 90 CD |  if_b	jmp	#LR__0317
051a0     0C 0F 02 F6 | 	mov	arg01, local01
051a4     10 11 02 F6 | 	mov	arg02, local05
051a8     98 F6 BF FD | 	call	#_ff_cc_get_fat_0226
051ac     FA 20 02 F6 | 	mov	local05, result1
051b0     FF FF 7F FF 
051b4     FF 21 0E F2 | 	cmp	local05, ##-1 wz
051b8     01 F4 05 A6 |  if_e	mov	result1, #1
051bc     94 00 90 AD |  if_e	jmp	#LR__0319
051c0     02 20 16 F2 | 	cmp	local05, #2 wc
051c4     14 00 90 CD |  if_b	jmp	#LR__0315
051c8     18 1C 06 F1 | 	add	local03, #24
051cc     0E 1F 02 FB | 	rdlong	local04, local03
051d0     18 1C 86 F1 | 	sub	local03, #24
051d4     0F 21 12 F2 | 	cmp	local05, local04 wc
051d8     08 00 90 CD |  if_b	jmp	#LR__0316
051dc                 | LR__0315
051dc     02 F4 05 F6 | 	mov	result1, #2
051e0     70 00 90 FD | 	jmp	#LR__0319
051e4                 | LR__0316
051e4     11 1B 82 F1 | 	sub	local02, local06
051e8     AC FF 9F FD | 	jmp	#LR__0314
051ec                 | LR__0317
051ec     0E 0F 02 F6 | 	mov	arg01, local03
051f0     10 11 02 F6 | 	mov	arg02, local05
051f4     0C F6 BF FD | 	call	#_ff_cc_clst2sect_0221
051f8     18 18 06 F1 | 	add	local01, #24
051fc     0C F5 61 FC | 	wrlong	result1, local01
05200     18 18 86 F1 | 	sub	local01, #24
05204                 | LR__0318
05204     14 18 06 F1 | 	add	local01, #20
05208     0C 21 62 FC | 	wrlong	local05, local01
0520c     04 18 06 F1 | 	add	local01, #4
05210     0C 1F 0A FB | 	rdlong	local04, local01 wz
05214     18 18 86 F1 | 	sub	local01, #24
05218     02 F4 05 A6 |  if_e	mov	result1, #2
0521c     34 00 90 AD |  if_e	jmp	#LR__0319
05220     0D F5 01 F6 | 	mov	result1, local02
05224     09 F4 45 F0 | 	shr	result1, #9
05228     18 18 06 F1 | 	add	local01, #24
0522c     0C 1F 02 FB | 	rdlong	local04, local01
05230     FA 1E 02 F1 | 	add	local04, result1
05234     0C 1F 62 FC | 	wrlong	local04, local01
05238     34 1C 06 F1 | 	add	local03, #52
0523c     0E 1F 02 F6 | 	mov	local04, local03
05240     FF 1B 06 F5 | 	and	local02, #511
05244     0D 1F 02 F1 | 	add	local04, local02
05248     04 18 06 F1 | 	add	local01, #4
0524c     0C 1F 62 FC | 	wrlong	local04, local01
05250                 | ' 	dp->sect += ofs /  ((UINT) 512 ) ;
05250                 | ' 	dp->dir = fs->win + (ofs %  ((UINT) 512 ) );
05250                 | ' 
05250                 | ' 	return FR_OK;
05250     00 F4 05 F6 | 	mov	result1, #0
05254                 | LR__0319
05254     A8 F0 03 F6 | 	mov	ptra, fp
05258     B3 00 A0 FD | 	call	#popregs_
0525c                 | _ff_cc_dir_sdi_0249_ret
0525c     2D 00 64 FD | 	ret
05260                 | 
05260                 | _ff_cc_dir_next_0253
05260     05 4C 05 F6 | 	mov	COUNT_, #5
05264     A9 00 A0 FD | 	call	#pushregs_
05268     07 19 02 F6 | 	mov	local01, arg01
0526c     08 1B 02 F6 | 	mov	local02, arg02
05270     0C 1D 02 FB | 	rdlong	local03, local01
05274     10 18 06 F1 | 	add	local01, #16
05278     0C 1F 02 FB | 	rdlong	local04, local01
0527c     10 18 86 F1 | 	sub	local01, #16
05280     20 1E 06 F1 | 	add	local04, #32
05284     00 10 00 FF 
05288     00 1E 16 F2 | 	cmp	local04, ##2097152 wc
0528c     18 18 06 31 |  if_ae	add	local01, #24
05290     0C 01 68 3C |  if_ae	wrlong	#0, local01
05294     18 18 86 31 |  if_ae	sub	local01, #24
05298     18 18 06 F1 | 	add	local01, #24
0529c     0C 11 0A FB | 	rdlong	arg02, local01 wz
052a0     18 18 86 F1 | 	sub	local01, #24
052a4     04 F4 05 A6 |  if_e	mov	result1, #4
052a8     68 01 90 AD |  if_e	jmp	#LR__0325
052ac     FF 1F CE F7 | 	test	local04, #511 wz
052b0     40 01 90 5D |  if_ne	jmp	#LR__0324
052b4     18 18 06 F1 | 	add	local01, #24
052b8     0C 11 02 FB | 	rdlong	arg02, local01
052bc     01 10 06 F1 | 	add	arg02, #1
052c0     0C 11 62 FC | 	wrlong	arg02, local01
052c4     04 18 86 F1 | 	sub	local01, #4
052c8     0C 11 0A FB | 	rdlong	arg02, local01 wz
052cc     14 18 86 F1 | 	sub	local01, #20
052d0     2C 00 90 5D |  if_ne	jmp	#LR__0320
052d4     0F 11 02 F6 | 	mov	arg02, local04
052d8     05 10 46 F0 | 	shr	arg02, #5
052dc     08 1C 06 F1 | 	add	local03, #8
052e0     0E 1B E2 FA | 	rdword	local02, local03
052e4     08 1C 86 F1 | 	sub	local03, #8
052e8     0D 11 12 F2 | 	cmp	arg02, local02 wc
052ec     18 18 06 31 |  if_ae	add	local01, #24
052f0     0C 01 68 3C |  if_ae	wrlong	#0, local01
052f4                 | ' 				dp->sect = 0; return FR_NO_FILE;
052f4     04 F4 05 36 |  if_ae	mov	result1, #4
052f8     18 01 90 3D |  if_ae	jmp	#LR__0325
052fc     F4 00 90 FD | 	jmp	#LR__0323
05300                 | LR__0320
05300     0F 0F 02 F6 | 	mov	arg01, local04
05304     09 0E 46 F0 | 	shr	arg01, #9
05308     0A 1C 06 F1 | 	add	local03, #10
0530c     0E 11 E2 FA | 	rdword	arg02, local03
05310     0A 1C 86 F1 | 	sub	local03, #10
05314     01 10 86 F1 | 	sub	arg02, #1
05318     08 0F CA F7 | 	test	arg01, arg02 wz
0531c     D4 00 90 5D |  if_ne	jmp	#LR__0322
05320     0C 0F 02 F6 | 	mov	arg01, local01
05324     14 18 06 F1 | 	add	local01, #20
05328     0C 11 02 FB | 	rdlong	arg02, local01
0532c     14 18 86 F1 | 	sub	local01, #20
05330     10 F5 BF FD | 	call	#_ff_cc_get_fat_0226
05334     FA 20 02 F6 | 	mov	local05, result1
05338     02 20 16 F2 | 	cmp	local05, #2 wc
0533c     02 F4 05 C6 |  if_b	mov	result1, #2
05340     D0 00 90 CD |  if_b	jmp	#LR__0325
05344     FF FF 7F FF 
05348     FF 21 0E F2 | 	cmp	local05, ##-1 wz
0534c     01 F4 05 A6 |  if_e	mov	result1, #1
05350     C0 00 90 AD |  if_e	jmp	#LR__0325
05354     18 1C 06 F1 | 	add	local03, #24
05358     0E 11 02 FB | 	rdlong	arg02, local03
0535c     18 1C 86 F1 | 	sub	local03, #24
05360     08 21 12 F2 | 	cmp	local05, arg02 wc
05364     68 00 90 CD |  if_b	jmp	#LR__0321
05368     00 1A 0E F2 | 	cmp	local02, #0 wz
0536c     18 18 06 A1 |  if_e	add	local01, #24
05370     0C 01 68 AC |  if_e	wrlong	#0, local01
05374                 | ' 						dp->sect = 0; return FR_NO_FILE;
05374     04 F4 05 A6 |  if_e	mov	result1, #4
05378     98 00 90 AD |  if_e	jmp	#LR__0325
0537c     0C 0F 02 F6 | 	mov	arg01, local01
05380     14 18 06 F1 | 	add	local01, #20
05384     0C 11 02 FB | 	rdlong	arg02, local01
05388     14 18 86 F1 | 	sub	local01, #20
0538c     50 FA BF FD | 	call	#_ff_cc_create_chain_0240
05390     FA 20 0A F6 | 	mov	local05, result1 wz
05394     07 F4 05 A6 |  if_e	mov	result1, #7
05398     78 00 90 AD |  if_e	jmp	#LR__0325
0539c     01 20 0E F2 | 	cmp	local05, #1 wz
053a0     02 F4 05 A6 |  if_e	mov	result1, #2
053a4     6C 00 90 AD |  if_e	jmp	#LR__0325
053a8     FF FF 7F FF 
053ac     FF 21 0E F2 | 	cmp	local05, ##-1 wz
053b0     01 F4 05 A6 |  if_e	mov	result1, #1
053b4     5C 00 90 AD |  if_e	jmp	#LR__0325
053b8     10 11 02 F6 | 	mov	arg02, local05
053bc     0E 0F 02 F6 | 	mov	arg01, local03
053c0     4C FC BF FD | 	call	#_ff_cc_dir_clear_0245
053c4     00 F4 0D F2 | 	cmp	result1, #0 wz
053c8     01 F4 05 56 |  if_ne	mov	result1, #1
053cc     44 00 90 5D |  if_ne	jmp	#LR__0325
053d0                 | LR__0321
053d0     14 18 06 F1 | 	add	local01, #20
053d4     0C 21 62 FC | 	wrlong	local05, local01
053d8     14 18 86 F1 | 	sub	local01, #20
053dc     0E 0F 02 F6 | 	mov	arg01, local03
053e0     10 11 02 F6 | 	mov	arg02, local05
053e4     1C F4 BF FD | 	call	#_ff_cc_clst2sect_0221
053e8     18 18 06 F1 | 	add	local01, #24
053ec     0C F5 61 FC | 	wrlong	result1, local01
053f0     18 18 86 F1 | 	sub	local01, #24
053f4                 | LR__0322
053f4                 | LR__0323
053f4                 | LR__0324
053f4     10 18 06 F1 | 	add	local01, #16
053f8     0C 1F 62 FC | 	wrlong	local04, local01
053fc     34 1C 06 F1 | 	add	local03, #52
05400     FF 1F 06 F5 | 	and	local04, #511
05404     0F 1D 02 F1 | 	add	local03, local04
05408     0C 18 06 F1 | 	add	local01, #12
0540c     0C 1D 62 FC | 	wrlong	local03, local01
05410                 | ' #line 1802 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
05410                 | ' 				}
05410                 | ' 				dp->clust = clst;
05410                 | ' 				dp->sect = clst2sect(fs, clst);
05410                 | ' 			}
05410                 | ' 		}
05410                 | ' 	}
05410                 | ' 	dp->dptr = ofs;
05410                 | ' 	dp->dir = fs->win + ofs %  ((UINT) 512 ) ;
05410                 | ' 
05410                 | ' 	return FR_OK;
05410     00 F4 05 F6 | 	mov	result1, #0
05414                 | LR__0325
05414     A8 F0 03 F6 | 	mov	ptra, fp
05418     B3 00 A0 FD | 	call	#popregs_
0541c                 | _ff_cc_dir_next_0253_ret
0541c     2D 00 64 FD | 	ret
05420                 | 
05420                 | _ff_cc_dir_alloc_0257
05420     0B 4C 05 F6 | 	mov	COUNT_, #11
05424     A9 00 A0 FD | 	call	#pushregs_
05428     07 19 02 F6 | 	mov	local01, arg01
0542c     08 1B 02 F6 | 	mov	local02, arg02
05430     0C 1D 02 FB | 	rdlong	local03, local01
05434     0C 0F 02 F6 | 	mov	arg01, local01
05438     00 10 06 F6 | 	mov	arg02, #0
0543c     A8 FC BF FD | 	call	#_ff_cc_dir_sdi_0249
05440     FA 1E 0A F6 | 	mov	local04, result1 wz
05444     80 00 90 5D |  if_ne	jmp	#LR__0331
05448     00 20 06 F6 | 	mov	local05, #0
0544c                 | ' 		n = 0;
0544c                 | ' 		do {
0544c                 | LR__0326
0544c     18 18 06 F1 | 	add	local01, #24
05450     0C 11 02 FB | 	rdlong	arg02, local01
05454     18 18 86 F1 | 	sub	local01, #24
05458     0E 0F 02 F6 | 	mov	arg01, local03
0545c     C4 F1 BF FD | 	call	#_ff_cc_move_window_0218
05460     FA 1E 0A F6 | 	mov	local04, result1 wz
05464     60 00 90 5D |  if_ne	jmp	#LR__0330
05468     1C 18 06 F1 | 	add	local01, #28
0546c     0C 23 02 FB | 	rdlong	local06, local01
05470     1C 18 86 F1 | 	sub	local01, #28
05474     11 25 C2 FA | 	rdbyte	local07, local06
05478     E5 24 0E F2 | 	cmp	local07, #229 wz
0547c     18 00 90 AD |  if_e	jmp	#LR__0327
05480     1C 18 06 F1 | 	add	local01, #28
05484     0C 27 02 FB | 	rdlong	local08, local01
05488     1C 18 86 F1 | 	sub	local01, #28
0548c     13 29 02 F6 | 	mov	local09, local08
05490     14 2B CA FA | 	rdbyte	local10, local09 wz
05494     10 00 90 5D |  if_ne	jmp	#LR__0328
05498                 | LR__0327
05498     01 20 06 F1 | 	add	local05, #1
0549c     0D 21 0A F2 | 	cmp	local05, local02 wz
054a0     24 00 90 AD |  if_e	jmp	#LR__0330
054a4     04 00 90 FD | 	jmp	#LR__0329
054a8                 | LR__0328
054a8     00 20 06 F6 | 	mov	local05, #0
054ac                 | LR__0329
054ac     01 2C 06 F6 | 	mov	local11, #1
054b0     0C 0F 02 F6 | 	mov	arg01, local01
054b4     01 10 06 F6 | 	mov	arg02, #1
054b8     A4 FD BF FD | 	call	#_ff_cc_dir_next_0253
054bc     FA 24 02 F6 | 	mov	local07, result1
054c0     12 1F 0A F6 | 	mov	local04, local07 wz
054c4     84 FF 9F AD |  if_e	jmp	#LR__0326
054c8                 | LR__0330
054c8                 | LR__0331
054c8     04 1E 0E F2 | 	cmp	local04, #4 wz
054cc     07 1E 06 A6 |  if_e	mov	local04, #7
054d0                 | ' 	return res;
054d0     0F F5 01 F6 | 	mov	result1, local04
054d4     A8 F0 03 F6 | 	mov	ptra, fp
054d8     B3 00 A0 FD | 	call	#popregs_
054dc                 | _ff_cc_dir_alloc_0257_ret
054dc     2D 00 64 FD | 	ret
054e0                 | 
054e0                 | _ff_cc_ld_clust_0259
054e0     03 4C 05 F6 | 	mov	COUNT_, #3
054e4     A9 00 A0 FD | 	call	#pushregs_
054e8     07 19 02 F6 | 	mov	local01, arg01
054ec     08 1B 02 F6 | 	mov	local02, arg02
054f0     0D 0F 02 F6 | 	mov	arg01, local02
054f4     1A 0E 06 F1 | 	add	arg01, #26
054f8     1C EE BF FD | 	call	#_ff_cc_ld_word_0191
054fc     FA 1C 32 F9 | 	getword	local03, result1, #0
05500     0C 19 C2 FA | 	rdbyte	local01, local01
05504     03 18 0E F2 | 	cmp	local01, #3 wz
05508     18 00 90 5D |  if_ne	jmp	#LR__0332
0550c     14 1A 06 F1 | 	add	local02, #20
05510     0D 0F 02 F6 | 	mov	arg01, local02
05514     00 EE BF FD | 	call	#_ff_cc_ld_word_0191
05518     FA F4 31 F9 | 	getword	result1, result1, #0
0551c     10 F4 65 F0 | 	shl	result1, #16
05520     FA 1C 42 F5 | 	or	local03, result1
05524                 | LR__0332
05524                 | ' 		cl |= (DWORD)ld_word(dir +  20 ) << 16;
05524                 | ' 	}
05524                 | ' 
05524                 | ' 	return cl;
05524     0E F5 01 F6 | 	mov	result1, local03
05528     A8 F0 03 F6 | 	mov	ptra, fp
0552c     B3 00 A0 FD | 	call	#popregs_
05530                 | _ff_cc_ld_clust_0259_ret
05530     2D 00 64 FD | 	ret
05534                 | 
05534                 | _ff_cc_st_clust_0260
05534     03 4C 05 F6 | 	mov	COUNT_, #3
05538     A9 00 A0 FD | 	call	#pushregs_
0553c     07 19 02 F6 | 	mov	local01, arg01
05540     08 1B 02 F6 | 	mov	local02, arg02
05544     09 1D 02 F6 | 	mov	local03, arg03
05548     0D 0F 02 F6 | 	mov	arg01, local02
0554c     1A 0E 06 F1 | 	add	arg01, #26
05550     0E 11 02 F6 | 	mov	arg02, local03
05554     1C EE BF FD | 	call	#_ff_cc_st_word_0194
05558     0C 19 C2 FA | 	rdbyte	local01, local01
0555c     03 18 0E F2 | 	cmp	local01, #3 wz
05560     14 1A 06 A1 |  if_e	add	local02, #20
05564     10 1C 46 A0 |  if_e	shr	local03, #16
05568     0D 0F 02 A6 |  if_e	mov	arg01, local02
0556c     0E 11 02 A6 |  if_e	mov	arg02, local03
05570     00 EE BF AD |  if_e	call	#_ff_cc_st_word_0194
05574     A8 F0 03 F6 | 	mov	ptra, fp
05578     B3 00 A0 FD | 	call	#popregs_
0557c                 | _ff_cc_st_clust_0260_ret
0557c     2D 00 64 FD | 	ret
05580                 | 
05580                 | _ff_cc_cmp_lfn_0265
05580     0E 4C 05 F6 | 	mov	COUNT_, #14
05584     A9 00 A0 FD | 	call	#pushregs_
05588     07 19 02 F6 | 	mov	local01, arg01
0558c     08 1B 02 F6 | 	mov	local02, arg02
05590     0D 0F 02 F6 | 	mov	arg01, local02
05594     1A 0E 06 F1 | 	add	arg01, #26
05598     7C ED BF FD | 	call	#_ff_cc_ld_word_0191
0559c     0F F4 4D F7 | 	zerox	result1, #15 wz
055a0     00 F4 05 56 |  if_ne	mov	result1, #0
055a4     F4 00 90 5D |  if_ne	jmp	#LR__0340
055a8     0D 1D C2 FA | 	rdbyte	local03, local02
055ac     3F 1C 06 F5 | 	and	local03, #63
055b0     01 1C 86 F1 | 	sub	local03, #1
055b4     0D 1C 06 FD | 	qmul	local03, #13
055b8                 | ' 
055b8                 | ' 	i = ((dir[ 0 ] & 0x3F) - 1) * 13;
055b8                 | ' 
055b8                 | ' 	for (wc = 1, s = 0; s < 13; s++) {
055b8     01 1E 06 F6 | 	mov	local04, #1
055bc     00 20 06 F6 | 	mov	local05, #0
055c0     18 22 62 FD | 	getqx	local06
055c4                 | LR__0333
055c4     0D 20 16 F2 | 	cmp	local05, #13 wc
055c8     A0 00 90 3D |  if_ae	jmp	#LR__0338
055cc     0D 0F 02 F6 | 	mov	arg01, local02
055d0     10 25 02 F6 | 	mov	local07, local05
055d4     06 F0 05 F1 | 	add	ptr__ff_cc_dat__, #6
055d8     F8 24 02 F1 | 	add	local07, ptr__ff_cc_dat__
055dc     12 27 C2 FA | 	rdbyte	local08, local07
055e0     13 0F 02 F1 | 	add	arg01, local08
055e4     06 F0 85 F1 | 	sub	ptr__ff_cc_dat__, #6
055e8     2C ED BF FD | 	call	#_ff_cc_ld_word_0191
055ec     FA 28 02 F6 | 	mov	local09, result1
055f0     0F 1D 02 F6 | 	mov	local03, local04
055f4     0F 1C 4E F7 | 	zerox	local03, #15 wz
055f8     54 00 90 AD |  if_e	jmp	#LR__0336
055fc     00 23 16 F2 | 	cmp	local06, #256 wc
05600     3C 00 90 3D |  if_ae	jmp	#LR__0334
05604     14 0F 32 F9 | 	getword	arg01, local09, #0
05608     BC E1 BF FD | 	call	#_ff_cc_ff_wtoupper
0560c     FA 1C 02 F6 | 	mov	local03, result1
05610     11 25 02 F6 | 	mov	local07, local06
05614     12 27 02 F6 | 	mov	local08, local07
05618     13 2B 02 F6 | 	mov	local10, local08
0561c     01 2A 66 F0 | 	shl	local10, #1
05620     0C 2D 02 F6 | 	mov	local11, local01
05624     0C 2B 02 F1 | 	add	local10, local01
05628     15 0F E2 FA | 	rdword	arg01, local10
0562c     01 22 06 F1 | 	add	local06, #1
05630     94 E1 BF FD | 	call	#_ff_cc_ff_wtoupper
05634     FA 2E 02 F6 | 	mov	local12, result1
05638     17 1D 0A F2 | 	cmp	local03, local12 wz
0563c     08 00 90 AD |  if_e	jmp	#LR__0335
05640                 | LR__0334
05640                 | ' 				return 0;
05640     00 F4 05 F6 | 	mov	result1, #0
05644     54 00 90 FD | 	jmp	#LR__0340
05648                 | LR__0335
05648     14 1F 02 F6 | 	mov	local04, local09
0564c     14 00 90 FD | 	jmp	#LR__0337
05650                 | LR__0336
05650     14 1D 32 F9 | 	getword	local03, local09, #0
05654     7F 00 00 FF 
05658     FF 1D 0E F2 | 	cmp	local03, ##65535 wz
0565c     00 F4 05 56 |  if_ne	mov	result1, #0
05660     38 00 90 5D |  if_ne	jmp	#LR__0340
05664                 | LR__0337
05664     01 20 06 F1 | 	add	local05, #1
05668     58 FF 9F FD | 	jmp	#LR__0333
0566c                 | LR__0338
0566c     0D 1D C2 FA | 	rdbyte	local03, local02
05670     40 1C 0E F5 | 	and	local03, #64 wz
05674     20 00 90 AD |  if_e	jmp	#LR__0339
05678     00 1E 0E F2 | 	cmp	local04, #0 wz
0567c     18 00 90 AD |  if_e	jmp	#LR__0339
05680     11 31 02 F6 | 	mov	local13, local06
05684     01 30 66 F0 | 	shl	local13, #1
05688     0C 31 02 F1 | 	add	local13, local01
0568c     18 33 EA FA | 	rdword	local14, local13 wz
05690     00 F4 05 56 |  if_ne	mov	result1, #0
05694     04 00 90 5D |  if_ne	jmp	#LR__0340
05698                 | LR__0339
05698                 | ' 
05698                 | ' 	return 1;
05698     01 F4 05 F6 | 	mov	result1, #1
0569c                 | LR__0340
0569c     A8 F0 03 F6 | 	mov	ptra, fp
056a0     B3 00 A0 FD | 	call	#popregs_
056a4                 | _ff_cc_cmp_lfn_0265_ret
056a4     2D 00 64 FD | 	ret
056a8                 | 
056a8                 | _ff_cc_pick_lfn_0270
056a8     0C 4C 05 F6 | 	mov	COUNT_, #12
056ac     A9 00 A0 FD | 	call	#pushregs_
056b0     07 19 02 F6 | 	mov	local01, arg01
056b4     08 1B 02 F6 | 	mov	local02, arg02
056b8     0D 0F 02 F6 | 	mov	arg01, local02
056bc     1A 0E 06 F1 | 	add	arg01, #26
056c0     54 EC BF FD | 	call	#_ff_cc_ld_word_0191
056c4     FA 1C 02 F6 | 	mov	local03, result1
056c8     0F 1C 4E F7 | 	zerox	local03, #15 wz
056cc     00 F4 05 56 |  if_ne	mov	result1, #0
056d0     E4 00 90 5D |  if_ne	jmp	#LR__0346
056d4     0D 1D C2 FA | 	rdbyte	local03, local02
056d8     40 1C 26 F5 | 	andn	local03, #64
056dc     01 1C 86 F1 | 	sub	local03, #1
056e0     0D 1C 06 FD | 	qmul	local03, #13
056e4                 | ' 
056e4                 | ' 	i = ((dir[ 0 ] & ~ 0x40 ) - 1) * 13;
056e4                 | ' 
056e4                 | ' 	for (wc = 1, s = 0; s < 13; s++) {
056e4     01 1E 06 F6 | 	mov	local04, #1
056e8     00 20 06 F6 | 	mov	local05, #0
056ec     18 22 62 FD | 	getqx	local06
056f0                 | LR__0341
056f0     0D 20 16 F2 | 	cmp	local05, #13 wc
056f4     7C 00 90 3D |  if_ae	jmp	#LR__0344
056f8     0D 0F 02 F6 | 	mov	arg01, local02
056fc     10 1D 02 F6 | 	mov	local03, local05
05700     06 F0 05 F1 | 	add	ptr__ff_cc_dat__, #6
05704     F8 24 02 F6 | 	mov	local07, ptr__ff_cc_dat__
05708     F8 1C 02 F1 | 	add	local03, ptr__ff_cc_dat__
0570c     0E 27 C2 FA | 	rdbyte	local08, local03
05710     13 0F 02 F1 | 	add	arg01, local08
05714     06 F0 85 F1 | 	sub	ptr__ff_cc_dat__, #6
05718     FC EB BF FD | 	call	#_ff_cc_ld_word_0191
0571c     FA 28 02 F6 | 	mov	local09, result1
05720     0F 1D 02 F6 | 	mov	local03, local04
05724     0F 1C 4E F7 | 	zerox	local03, #15 wz
05728     2C 00 90 AD |  if_e	jmp	#LR__0342
0572c     00 23 16 F2 | 	cmp	local06, #256 wc
05730     00 F4 05 36 |  if_ae	mov	result1, #0
05734     80 00 90 3D |  if_ae	jmp	#LR__0346
05738     11 1D 02 F6 | 	mov	local03, local06
0573c     01 1C 66 F0 | 	shl	local03, #1
05740     0C 25 02 F6 | 	mov	local07, local01
05744     0C 1D 02 F1 | 	add	local03, local01
05748     14 1F 02 F6 | 	mov	local04, local09
0574c     0E 1F 52 FC | 	wrword	local04, local03
05750     01 22 06 F1 | 	add	local06, #1
05754     14 00 90 FD | 	jmp	#LR__0343
05758                 | LR__0342
05758     14 1D 32 F9 | 	getword	local03, local09, #0
0575c     7F 00 00 FF 
05760     FF 1D 0E F2 | 	cmp	local03, ##65535 wz
05764     00 F4 05 56 |  if_ne	mov	result1, #0
05768     4C 00 90 5D |  if_ne	jmp	#LR__0346
0576c                 | LR__0343
0576c     01 20 06 F1 | 	add	local05, #1
05770     7C FF 9F FD | 	jmp	#LR__0341
05774                 | LR__0344
05774     0D 1D C2 FA | 	rdbyte	local03, local02
05778     40 1C CE F7 | 	test	local03, #64 wz
0577c     34 00 90 AD |  if_e	jmp	#LR__0345
05780     0F 1D 02 F6 | 	mov	local03, local04
05784     0F 1C 4E F7 | 	zerox	local03, #15 wz
05788     28 00 90 AD |  if_e	jmp	#LR__0345
0578c     00 23 16 F2 | 	cmp	local06, #256 wc
05790     00 F4 05 36 |  if_ae	mov	result1, #0
05794     20 00 90 3D |  if_ae	jmp	#LR__0346
05798     11 1D 02 F6 | 	mov	local03, local06
0579c     0E 2B 02 F6 | 	mov	local10, local03
057a0     01 2A 66 F0 | 	shl	local10, #1
057a4     0C 2D 02 F6 | 	mov	local11, local01
057a8     0C 2B 02 F1 | 	add	local10, local01
057ac     00 2E 06 F6 | 	mov	local12, #0
057b0     15 01 58 FC | 	wrword	#0, local10
057b4                 | LR__0345
057b4                 | ' 		lfnbuf[i] = 0;
057b4                 | ' 	}
057b4                 | ' 
057b4                 | ' 	return 1;
057b4     01 F4 05 F6 | 	mov	result1, #1
057b8                 | LR__0346
057b8     A8 F0 03 F6 | 	mov	ptra, fp
057bc     B3 00 A0 FD | 	call	#popregs_
057c0                 | _ff_cc_pick_lfn_0270_ret
057c0     2D 00 64 FD | 	ret
057c4                 | 
057c4                 | _ff_cc_put_lfn_0274
057c4     07 4C 05 F6 | 	mov	COUNT_, #7
057c8     A9 00 A0 FD | 	call	#pushregs_
057cc     07 19 02 F6 | 	mov	local01, arg01
057d0     08 1B 02 F6 | 	mov	local02, arg02
057d4     09 1D 02 F6 | 	mov	local03, arg03
057d8     0D 1A 06 F1 | 	add	local02, #13
057dc     0D 15 42 FC | 	wrbyte	arg04, local02
057e0     02 1A 86 F1 | 	sub	local02, #2
057e4     0D 1F 48 FC | 	wrbyte	#15, local02
057e8     01 1A 06 F1 | 	add	local02, #1
057ec     0D 01 48 FC | 	wrbyte	#0, local02
057f0     0C 1A 86 F1 | 	sub	local02, #12
057f4     0D 0F 02 F6 | 	mov	arg01, local02
057f8     1A 0E 06 F1 | 	add	arg01, #26
057fc     00 10 06 F6 | 	mov	arg02, #0
05800     70 EB BF FD | 	call	#_ff_cc_st_word_0194
05804     0E 1F E2 F8 | 	getbyte	local04, local03, #0
05808     01 1E 86 F1 | 	sub	local04, #1
0580c     0D 1E 06 FD | 	qmul	local04, #13
05810     00 20 06 F6 | 	mov	local05, #0
05814     00 22 06 F6 | 	mov	local06, #0
05818                 | ' 	BYTE* dir,
05818                 | ' 	BYTE ord,
05818                 | ' 	BYTE sum
05818                 | ' )
05818                 | ' {
05818                 | ' 	UINT i, s;
05818                 | ' 	WCHAR wc;
05818                 | ' 
05818                 | ' 
05818                 | ' 	dir[ 13 ] = sum;
05818                 | ' 	dir[ 11 ] =  0x0F ;
05818                 | ' 	dir[ 12 ] = 0;
05818                 | ' 	st_word(dir +  26 , 0);
05818                 | ' 
05818                 | ' 	i = (ord - 1) * 13;
05818                 | ' 	s = wc = 0;
05818                 | ' 	do {
05818     18 24 62 FD | 	getqx	local07
0581c                 | LR__0347
0581c     10 1F 32 F9 | 	getword	local04, local05, #0
05820     7F 00 00 FF 
05824     FF 1F 0E F2 | 	cmp	local04, ##65535 wz
05828     12 0F 02 56 |  if_ne	mov	arg01, local07
0582c     01 24 06 51 |  if_ne	add	local07, #1
05830     01 0E 66 50 |  if_ne	shl	arg01, #1
05834     0C 0F 02 51 |  if_ne	add	arg01, local01
05838     07 21 E2 5A |  if_ne	rdword	local05, arg01
0583c     0D 0F 02 F6 | 	mov	arg01, local02
05840     11 1F 02 F6 | 	mov	local04, local06
05844     06 F0 05 F1 | 	add	ptr__ff_cc_dat__, #6
05848     F8 1E 02 F1 | 	add	local04, ptr__ff_cc_dat__
0584c     0F 1F C2 FA | 	rdbyte	local04, local04
05850     0F 0F 02 F1 | 	add	arg01, local04
05854     10 11 02 F6 | 	mov	arg02, local05
05858     06 F0 85 F1 | 	sub	ptr__ff_cc_dat__, #6
0585c     14 EB BF FD | 	call	#_ff_cc_st_word_0194
05860     10 1F 02 F6 | 	mov	local04, local05
05864     0F 1E 4E F7 | 	zerox	local04, #15 wz
05868     0F 20 CE A9 |  if_e	bmask	local05, #15
0586c     01 22 06 F1 | 	add	local06, #1
05870     0D 22 16 F2 | 	cmp	local06, #13 wc
05874     A4 FF 9F CD |  if_b	jmp	#LR__0347
05878     10 21 32 F9 | 	getword	local05, local05, #0
0587c     7F 00 00 FF 
05880     FF 21 0E F2 | 	cmp	local05, ##65535 wz
05884     01 24 66 50 |  if_ne	shl	local07, #1
05888     0C 25 02 51 |  if_ne	add	local07, local01
0588c     12 25 EA 5A |  if_ne	rdword	local07, local07 wz
05890     0E 1D E2 A8 |  if_e	getbyte	local03, local03, #0
05894     40 1C 46 A5 |  if_e	or	local03, #64
05898     0D 1D 42 FC | 	wrbyte	local03, local02
0589c     A8 F0 03 F6 | 	mov	ptra, fp
058a0     B3 00 A0 FD | 	call	#popregs_
058a4                 | _ff_cc_put_lfn_0274_ret
058a4     2D 00 64 FD | 	ret
058a8                 | 
058a8                 | _ff_cc_gen_numname_0281
058a8     0B 4C 05 F6 | 	mov	COUNT_, #11
058ac     A9 00 A0 FD | 	call	#pushregs_
058b0     2C F0 07 F1 | 	add	ptra, #44
058b4     07 19 02 F6 | 	mov	local01, arg01
058b8     08 1B 02 F6 | 	mov	local02, arg02
058bc     09 1D 02 F6 | 	mov	local03, arg03
058c0     0A 1F 02 F6 | 	mov	local04, arg04
058c4     0C 0F 02 F6 | 	mov	arg01, local01
058c8     0D 11 02 F6 | 	mov	arg02, local02
058cc     0B 12 06 F6 | 	mov	arg03, #11
058d0     EC EA BF FD | 	call	#_ff_cc_mem_cpy_0198
058d4     06 1E 16 F2 | 	cmp	local04, #6 wc
058d8     50 00 90 CD |  if_b	jmp	#LR__0351
058dc     0F 21 02 F6 | 	mov	local05, local04
058e0                 | ' 		sreg = seq;
058e0                 | ' 		while (*lfn) {
058e0                 | LR__0348
058e0     0E 23 EA FA | 	rdword	local06, local03 wz
058e4     40 00 90 AD |  if_e	jmp	#LR__0350
058e8     0E 25 E2 FA | 	rdword	local07, local03
058ec                 | ' 			wc = *lfn++;
058ec                 | ' 			for (i = 0; i < 16; i++) {
058ec     00 26 06 F6 | 	mov	local08, #0
058f0     02 1C 06 F1 | 	add	local03, #2
058f4                 | LR__0349
058f4     10 26 16 F2 | 	cmp	local08, #16 wc
058f8     E4 FF 9F 3D |  if_ae	jmp	#LR__0348
058fc     01 20 66 F0 | 	shl	local05, #1
05900     12 23 32 F9 | 	getword	local06, local07, #0
05904     01 22 06 F5 | 	and	local06, #1
05908     11 21 02 F1 | 	add	local05, local06
0590c     12 25 32 F9 | 	getword	local07, local07, #0
05910     01 24 46 F0 | 	shr	local07, #1
05914     10 20 2E F4 | 	testbn	local05, #16 wz
05918     88 00 00 5F 
0591c     21 20 66 55 |  if_ne	xor	local05, ##69665
05920     01 26 06 F1 | 	add	local08, #1
05924     CC FF 9F FD | 	jmp	#LR__0349
05928                 | LR__0350
05928     10 1F 02 F6 | 	mov	local04, local05
0592c                 | LR__0351
0592c     07 26 06 F6 | 	mov	local08, #7
05930     04 A7 9F FE | 	loc	pa,	#(@LR__0353-@LR__0352)
05934     8C 00 A0 FD | 	call	#FCACHE_LOAD_
05938                 | ' 			}
05938                 | ' 		}
05938                 | ' 		seq = (UINT)sreg;
05938                 | ' 	}
05938                 | ' 
05938                 | ' 
05938                 | ' 	i = 7;
05938                 | ' 	do {
05938                 | LR__0352
05938     0F 29 42 F8 | 	getnib	local09, local04, #0
0593c     30 28 06 F1 | 	add	local09, #48
05940     14 23 E2 F8 | 	getbyte	local06, local09, #0
05944     3A 22 16 F2 | 	cmp	local06, #58 wc
05948     14 29 E2 38 |  if_ae	getbyte	local09, local09, #0
0594c     07 28 06 31 |  if_ae	add	local09, #7
05950     13 23 02 F6 | 	mov	local06, local08
05954     10 50 05 F1 | 	add	fp, #16
05958     A8 22 02 F1 | 	add	local06, fp
0595c     11 29 42 FC | 	wrbyte	local09, local06
05960     04 1E 4E F0 | 	shr	local04, #4 wz
05964     01 26 86 F1 | 	sub	local08, #1
05968     10 50 85 F1 | 	sub	fp, #16
0596c     C8 FF 9F 5D |  if_ne	jmp	#LR__0352
05970                 | LR__0353
05970     13 23 02 F6 | 	mov	local06, local08
05974     10 50 05 F1 | 	add	fp, #16
05978     A8 22 02 F1 | 	add	local06, fp
0597c     11 FD 48 FC | 	wrbyte	#126, local06
05980                 | ' 	ns[i] = '~';
05980                 | ' 
05980                 | ' 
05980                 | ' 	for (j = 0; j < i && dst[j] != ' '; j++) {
05980     00 2A 06 F6 | 	mov	local10, #0
05984     10 50 85 F1 | 	sub	fp, #16
05988     C8 A6 9F FE | 	loc	pa,	#(@LR__0356-@LR__0354)
0598c     8C 00 A0 FD | 	call	#FCACHE_LOAD_
05990                 | LR__0354
05990     13 2B 12 F2 | 	cmp	local10, local08 wc
05994     4C 00 90 3D |  if_ae	jmp	#LR__0357
05998     15 23 02 F6 | 	mov	local06, local10
0599c     0C 23 02 F1 | 	add	local06, local01
059a0     11 23 C2 FA | 	rdbyte	local06, local06
059a4     20 22 0E F2 | 	cmp	local06, #32 wz
059a8     38 00 90 AD |  if_e	jmp	#LR__0357
059ac     15 0F 02 F6 | 	mov	arg01, local10
059b0     0C 0F 02 F1 | 	add	arg01, local01
059b4     07 0F CA FA | 	rdbyte	arg01, arg01 wz
059b8     00 F4 05 56 |  if_ne	mov	result1, #0
059bc                 | ' 
059bc                 | ' 	return 0;
059bc     00 F4 05 A6 |  if_e	mov	result1, #0
059c0     00 F4 0D F2 | 	cmp	result1, #0 wz
059c4     14 00 90 AD |  if_e	jmp	#LR__0355
059c8     13 29 02 F6 | 	mov	local09, local08
059cc     01 28 86 F1 | 	sub	local09, #1
059d0     14 2B 0A F2 | 	cmp	local10, local09 wz
059d4     0C 00 90 AD |  if_e	jmp	#LR__0357
059d8     01 2A 06 F1 | 	add	local10, #1
059dc                 | LR__0355
059dc     01 2A 06 F1 | 	add	local10, #1
059e0     AC FF 9F FD | 	jmp	#LR__0354
059e4                 | LR__0356
059e4                 | LR__0357
059e4     58 A6 9F FE | 	loc	pa,	#(@LR__0361-@LR__0358)
059e8     8C 00 A0 FD | 	call	#FCACHE_LOAD_
059ec                 | ' 			j++;
059ec                 | ' 		}
059ec                 | ' 	}
059ec                 | ' 	do {
059ec                 | LR__0358
059ec     15 29 02 F6 | 	mov	local09, local10
059f0     0C 29 02 F1 | 	add	local09, local01
059f4     08 26 16 F2 | 	cmp	local08, #8 wc
059f8     01 2A 06 F1 | 	add	local10, #1
059fc     1C 00 90 3D |  if_ae	jmp	#LR__0359
05a00     13 25 02 F6 | 	mov	local07, local08
05a04     10 50 05 F1 | 	add	fp, #16
05a08     A8 24 02 F1 | 	add	local07, fp
05a0c     12 2D C2 FA | 	rdbyte	local11, local07
05a10     01 26 06 F1 | 	add	local08, #1
05a14     10 50 85 F1 | 	sub	fp, #16
05a18     04 00 90 FD | 	jmp	#LR__0360
05a1c                 | LR__0359
05a1c     20 2C 06 F6 | 	mov	local11, #32
05a20                 | LR__0360
05a20     14 2D 42 FC | 	wrbyte	local11, local09
05a24     08 2A 16 F2 | 	cmp	local10, #8 wc
05a28     C0 FF 9F CD |  if_b	jmp	#LR__0358
05a2c                 | LR__0361
05a2c     A8 F0 03 F6 | 	mov	ptra, fp
05a30     B3 00 A0 FD | 	call	#popregs_
05a34                 | _ff_cc_gen_numname_0281_ret
05a34     2D 00 64 FD | 	ret
05a38                 | 
05a38                 | _ff_cc_sum_sfn_0284
05a38     00 F8 05 F6 | 	mov	_var01, #0
05a3c                 | ' )
05a3c                 | ' {
05a3c                 | ' 	BYTE sum = 0;
05a3c                 | ' 	UINT n = 11;
05a3c                 | ' 
05a3c                 | ' 	do {
05a3c     E4 A5 9F FE | 	loc	pa,	#(@LR__0364-@LR__0362)
05a40     8C 00 A0 FD | 	call	#FCACHE_LOAD_
05a44                 | LR__0362
05a44     0B 10 DC FC | 	rep	@LR__0365, #11
05a48                 | LR__0363
05a48     FC F4 E1 F8 | 	getbyte	result1, _var01, #0
05a4c     01 F4 45 F0 | 	shr	result1, #1
05a50     FC F8 E1 F8 | 	getbyte	_var01, _var01, #0
05a54     07 F8 65 F0 | 	shl	_var01, #7
05a58     FC F4 01 F1 | 	add	result1, _var01
05a5c     07 F9 C1 FA | 	rdbyte	_var01, arg01
05a60     FA F8 01 F1 | 	add	_var01, result1
05a64     01 0E 06 F1 | 	add	arg01, #1
05a68                 | LR__0364
05a68                 | LR__0365
05a68                 | ' 	return sum;
05a68     FC F4 01 F6 | 	mov	result1, _var01
05a6c                 | _ff_cc_sum_sfn_0284_ret
05a6c     2D 00 64 FD | 	ret
05a70                 | 
05a70                 | _ff_cc_dir_read_0291
05a70     13 4C 05 F6 | 	mov	COUNT_, #19
05a74     A9 00 A0 FD | 	call	#pushregs_
05a78     07 19 02 F6 | 	mov	local01, arg01
05a7c     08 1B 02 F6 | 	mov	local02, arg02
05a80     04 1C 06 F6 | 	mov	local03, #4
05a84     0C 1F 02 FB | 	rdlong	local04, local01
05a88     FF 20 06 F6 | 	mov	local05, #255
05a8c     FF 22 06 F6 | 	mov	local06, #255
05a90                 | ' )
05a90                 | ' {
05a90                 | ' 	FRESULT res = FR_NO_FILE;
05a90                 | ' 	FATFS *fs = dp->obj.fs;
05a90                 | ' 	BYTE attr, b;
05a90                 | ' 
05a90                 | ' 	BYTE ord = 0xFF, sum = 0xFF;
05a90                 | ' 
05a90                 | ' 
05a90                 | ' 	while (dp->sect) {
05a90                 | LR__0366
05a90     18 18 06 F1 | 	add	local01, #24
05a94     0C F5 09 FB | 	rdlong	result1, local01 wz
05a98     18 18 86 F1 | 	sub	local01, #24
05a9c     B8 01 90 AD |  if_e	jmp	#LR__0376
05aa0     18 18 06 F1 | 	add	local01, #24
05aa4     0C 11 02 FB | 	rdlong	arg02, local01
05aa8     18 18 86 F1 | 	sub	local01, #24
05aac     0F 0F 02 F6 | 	mov	arg01, local04
05ab0     70 EB BF FD | 	call	#_ff_cc_move_window_0218
05ab4     FA 1C 0A F6 | 	mov	local03, result1 wz
05ab8     9C 01 90 5D |  if_ne	jmp	#LR__0376
05abc     1C 18 06 F1 | 	add	local01, #28
05ac0     0C 25 02 FB | 	rdlong	local07, local01
05ac4     1C 18 86 F1 | 	sub	local01, #28
05ac8     12 27 C2 FA | 	rdbyte	local08, local07
05acc     13 25 02 F6 | 	mov	local07, local08
05ad0     07 24 4E F7 | 	zerox	local07, #7 wz
05ad4     04 1C 06 A6 |  if_e	mov	local03, #4
05ad8                 | ' 			res = FR_NO_FILE; break;
05ad8     7C 01 90 AD |  if_e	jmp	#LR__0376
05adc     1C 18 06 F1 | 	add	local01, #28
05ae0     0C 29 02 FB | 	rdlong	local09, local01
05ae4     0B 28 06 F1 | 	add	local09, #11
05ae8     14 2B C2 FA | 	rdbyte	local10, local09
05aec     3F 2A 06 F5 | 	and	local10, #63
05af0     16 18 86 F1 | 	sub	local01, #22
05af4     0C 2B 42 FC | 	wrbyte	local10, local01
05af8     06 18 86 F1 | 	sub	local01, #6
05afc     13 25 E2 F8 | 	getbyte	local07, local08, #0
05b00     E5 24 0E F2 | 	cmp	local07, #229 wz
05b04     28 00 90 AD |  if_e	jmp	#LR__0367
05b08     13 29 E2 F8 | 	getbyte	local09, local08, #0
05b0c     2E 28 0E F2 | 	cmp	local09, #46 wz
05b10     1C 00 90 AD |  if_e	jmp	#LR__0367
05b14     00 2C 06 F6 | 	mov	local11, #0
05b18     15 2F E2 F8 | 	getbyte	local12, local10, #0
05b1c     20 2E 26 F5 | 	andn	local12, #32
05b20     08 2E 0E F2 | 	cmp	local12, #8 wz
05b24     01 2C 06 A6 |  if_e	mov	local11, #1
05b28     0D 2D 0A F2 | 	cmp	local11, local02 wz
05b2c     08 00 90 AD |  if_e	jmp	#LR__0368
05b30                 | LR__0367
05b30     FF 20 06 F6 | 	mov	local05, #255
05b34     0C 01 90 FD | 	jmp	#LR__0375
05b38                 | LR__0368
05b38     15 25 E2 F8 | 	getbyte	local07, local10, #0
05b3c     0F 24 0E F2 | 	cmp	local07, #15 wz
05b40     C0 00 90 5D |  if_ne	jmp	#LR__0372
05b44     13 25 E2 F8 | 	getbyte	local07, local08, #0
05b48     40 24 0E F5 | 	and	local07, #64 wz
05b4c     30 00 90 AD |  if_e	jmp	#LR__0369
05b50     1C 18 06 F1 | 	add	local01, #28
05b54     0C 25 02 FB | 	rdlong	local07, local01
05b58     0D 24 06 F1 | 	add	local07, #13
05b5c     12 23 C2 FA | 	rdbyte	local06, local07
05b60     13 27 E2 F8 | 	getbyte	local08, local08, #0
05b64     BF 26 06 F5 | 	and	local08, #191
05b68     13 21 02 F6 | 	mov	local05, local08
05b6c     0C 18 86 F1 | 	sub	local01, #12
05b70     0C 25 02 FB | 	rdlong	local07, local01
05b74     1C 18 06 F1 | 	add	local01, #28
05b78     0C 25 62 FC | 	wrlong	local07, local01
05b7c     2C 18 86 F1 | 	sub	local01, #44
05b80                 | LR__0369
05b80     13 29 E2 F8 | 	getbyte	local09, local08, #0
05b84     10 2D E2 F8 | 	getbyte	local11, local05, #0
05b88     16 29 0A F2 | 	cmp	local09, local11 wz
05b8c     68 00 90 5D |  if_ne	jmp	#LR__0370
05b90     11 2F E2 F8 | 	getbyte	local12, local06, #0
05b94     1C 18 06 F1 | 	add	local01, #28
05b98     0C 31 02 FB | 	rdlong	local13, local01
05b9c     1C 18 86 F1 | 	sub	local01, #28
05ba0     18 33 02 F6 | 	mov	local14, local13
05ba4     0D 32 06 F1 | 	add	local14, #13
05ba8     19 35 C2 FA | 	rdbyte	local15, local14
05bac     0D 32 86 F1 | 	sub	local14, #13
05bb0     1A 37 E2 F8 | 	getbyte	local16, local15, #0
05bb4     1B 2F 0A F2 | 	cmp	local12, local16 wz
05bb8     3C 00 90 5D |  if_ne	jmp	#LR__0370
05bbc     0C 1E 06 F1 | 	add	local04, #12
05bc0     0F 0F 02 FB | 	rdlong	arg01, local04
05bc4     0C 1E 86 F1 | 	sub	local04, #12
05bc8     1C 18 06 F1 | 	add	local01, #28
05bcc     0C 39 02 FB | 	rdlong	local17, local01
05bd0     1C 18 86 F1 | 	sub	local01, #28
05bd4     1C 3B 02 F6 | 	mov	local18, local17
05bd8     1D 11 02 F6 | 	mov	arg02, local18
05bdc     C8 FA BF FD | 	call	#_ff_cc_pick_lfn_0270
05be0     FA 3C 0A F6 | 	mov	local19, result1 wz
05be4     10 3B 02 56 |  if_ne	mov	local18, local05
05be8     1D 3B E2 58 |  if_ne	getbyte	local18, local18, #0
05bec     01 3A 86 51 |  if_ne	sub	local18, #1
05bf0     1D 25 02 56 |  if_ne	mov	local07, local18
05bf4     04 00 90 5D |  if_ne	jmp	#LR__0371
05bf8                 | LR__0370
05bf8     FF 24 06 F6 | 	mov	local07, #255
05bfc                 | LR__0371
05bfc     12 21 02 F6 | 	mov	local05, local07
05c00     40 00 90 FD | 	jmp	#LR__0374
05c04                 | LR__0372
05c04     10 25 02 F6 | 	mov	local07, local05
05c08     07 24 4E F7 | 	zerox	local07, #7 wz
05c0c     20 00 90 5D |  if_ne	jmp	#LR__0373
05c10     11 23 E2 F8 | 	getbyte	local06, local06, #0
05c14     1C 18 06 F1 | 	add	local01, #28
05c18     0C 0F 02 FB | 	rdlong	arg01, local01
05c1c     1C 18 86 F1 | 	sub	local01, #28
05c20     14 FE BF FD | 	call	#_ff_cc_sum_sfn_0284
05c24     FA F4 E1 F8 | 	getbyte	result1, result1, #0
05c28     FA 22 0A F2 | 	cmp	local06, result1 wz
05c2c     28 00 90 AD |  if_e	jmp	#LR__0376
05c30                 | LR__0373
05c30     2C 18 06 F1 | 	add	local01, #44
05c34     FF FF FF FF 
05c38     0C FF 6B FC | 	wrlong	##-1, local01
05c3c     2C 18 86 F1 | 	sub	local01, #44
05c40                 | ' 						dp->blk_ofs = 0xFFFFFFFF;
05c40                 | ' 					}
05c40                 | ' 					break;
05c40     14 00 90 FD | 	jmp	#LR__0376
05c44                 | LR__0374
05c44                 | LR__0375
05c44     0C 0F 02 F6 | 	mov	arg01, local01
05c48     00 10 06 F6 | 	mov	arg02, #0
05c4c     10 F6 BF FD | 	call	#_ff_cc_dir_next_0253
05c50     FA 1C 0A F6 | 	mov	local03, result1 wz
05c54     38 FE 9F AD |  if_e	jmp	#LR__0366
05c58                 | LR__0376
05c58     00 1C 0E F2 | 	cmp	local03, #0 wz
05c5c     18 18 06 51 |  if_ne	add	local01, #24
05c60     0C 01 68 5C |  if_ne	wrlong	#0, local01
05c64                 | ' 	return res;
05c64     0E F5 01 F6 | 	mov	result1, local03
05c68     A8 F0 03 F6 | 	mov	ptra, fp
05c6c     B3 00 A0 FD | 	call	#popregs_
05c70                 | _ff_cc_dir_read_0291_ret
05c70     2D 00 64 FD | 	ret
05c74                 | 
05c74                 | _ff_cc_dir_find_0298
05c74     12 4C 05 F6 | 	mov	COUNT_, #18
05c78     A9 00 A0 FD | 	call	#pushregs_
05c7c     07 19 02 F6 | 	mov	local01, arg01
05c80     0C 1B 02 FB | 	rdlong	local02, local01
05c84     0C 0F 02 F6 | 	mov	arg01, local01
05c88     00 10 06 F6 | 	mov	arg02, #0
05c8c     58 F4 BF FD | 	call	#_ff_cc_dir_sdi_0249
05c90     00 F4 0D F2 | 	cmp	result1, #0 wz
05c94     40 02 90 5D |  if_ne	jmp	#LR__0389
05c98     FF 1C 06 F6 | 	mov	local03, #255
05c9c     FF 1E 06 F6 | 	mov	local04, #255
05ca0     2C 18 06 F1 | 	add	local01, #44
05ca4     FF FF FF FF 
05ca8     0C FF 6B FC | 	wrlong	##-1, local01
05cac     2C 18 86 F1 | 	sub	local01, #44
05cb0                 | ' #line 2477 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
05cb0                 | ' 	ord = sum = 0xFF; dp->blk_ofs = 0xFFFFFFFF;
05cb0                 | ' 
05cb0                 | ' 	do {
05cb0                 | LR__0377
05cb0     18 18 06 F1 | 	add	local01, #24
05cb4     0C 11 02 FB | 	rdlong	arg02, local01
05cb8     18 18 86 F1 | 	sub	local01, #24
05cbc     0D 0F 02 F6 | 	mov	arg01, local02
05cc0     60 E9 BF FD | 	call	#_ff_cc_move_window_0218
05cc4     FA 20 0A F6 | 	mov	local05, result1 wz
05cc8     08 02 90 5D |  if_ne	jmp	#LR__0388
05ccc     1C 18 06 F1 | 	add	local01, #28
05cd0     0C 23 02 FB | 	rdlong	local06, local01
05cd4     1C 18 86 F1 | 	sub	local01, #28
05cd8     11 25 C2 FA | 	rdbyte	local07, local06
05cdc     12 23 02 F6 | 	mov	local06, local07
05ce0     07 22 4E F7 | 	zerox	local06, #7 wz
05ce4     04 20 06 A6 |  if_e	mov	local05, #4
05ce8                 | ' #line 2487 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
05ce8                 | '                     res = FR_NO_FILE; break;
05ce8     E8 01 90 AD |  if_e	jmp	#LR__0388
05cec     1C 18 06 F1 | 	add	local01, #28
05cf0     0C 27 02 FB | 	rdlong	local08, local01
05cf4     13 23 02 F6 | 	mov	local06, local08
05cf8     0B 22 06 F1 | 	add	local06, #11
05cfc     11 29 C2 FA | 	rdbyte	local09, local06
05d00     14 2B E2 F8 | 	getbyte	local10, local09, #0
05d04     3F 2A 06 F5 | 	and	local10, #63
05d08     16 18 86 F1 | 	sub	local01, #22
05d0c     0C 2B 42 FC | 	wrbyte	local10, local01
05d10     06 18 86 F1 | 	sub	local01, #6
05d14     12 23 E2 F8 | 	getbyte	local06, local07, #0
05d18     E5 22 0E F2 | 	cmp	local06, #229 wz
05d1c     18 00 90 AD |  if_e	jmp	#LR__0378
05d20     15 2D E2 F8 | 	getbyte	local11, local10, #0
05d24     08 2C 0E F5 | 	and	local11, #8 wz
05d28     24 00 90 AD |  if_e	jmp	#LR__0379
05d2c     15 27 E2 F8 | 	getbyte	local08, local10, #0
05d30     0F 26 0E F2 | 	cmp	local08, #15 wz
05d34     18 00 90 AD |  if_e	jmp	#LR__0379
05d38                 | LR__0378
05d38     FF 1E 06 F6 | 	mov	local04, #255
05d3c     2C 18 06 F1 | 	add	local01, #44
05d40     FF FF FF FF 
05d44     0C FF 6B FC | 	wrlong	##-1, local01
05d48     2C 18 86 F1 | 	sub	local01, #44
05d4c     68 01 90 FD | 	jmp	#LR__0387
05d50                 | LR__0379
05d50     15 23 E2 F8 | 	getbyte	local06, local10, #0
05d54     0F 22 0E F2 | 	cmp	local06, #15 wz
05d58     D4 00 90 5D |  if_ne	jmp	#LR__0383
05d5c     2B 18 06 F1 | 	add	local01, #43
05d60     0C 23 C2 FA | 	rdbyte	local06, local01
05d64     2B 18 86 F1 | 	sub	local01, #43
05d68     40 22 CE F7 | 	test	local06, #64 wz
05d6c     48 01 90 5D |  if_ne	jmp	#LR__0386
05d70     12 23 E2 F8 | 	getbyte	local06, local07, #0
05d74     40 22 0E F5 | 	and	local06, #64 wz
05d78     30 00 90 AD |  if_e	jmp	#LR__0380
05d7c     1C 18 06 F1 | 	add	local01, #28
05d80     0C 23 02 FB | 	rdlong	local06, local01
05d84     0D 22 06 F1 | 	add	local06, #13
05d88     11 1D C2 FA | 	rdbyte	local03, local06
05d8c     12 25 E2 F8 | 	getbyte	local07, local07, #0
05d90     BF 24 06 F5 | 	and	local07, #191
05d94     12 1F 02 F6 | 	mov	local04, local07
05d98     0C 18 86 F1 | 	sub	local01, #12
05d9c     0C 23 02 FB | 	rdlong	local06, local01
05da0     1C 18 06 F1 | 	add	local01, #28
05da4     0C 23 62 FC | 	wrlong	local06, local01
05da8     2C 18 86 F1 | 	sub	local01, #44
05dac                 | LR__0380
05dac     12 2D E2 F8 | 	getbyte	local11, local07, #0
05db0     0F 27 E2 F8 | 	getbyte	local08, local04, #0
05db4     13 2D 0A F2 | 	cmp	local11, local08 wz
05db8     68 00 90 5D |  if_ne	jmp	#LR__0381
05dbc     0E 29 E2 F8 | 	getbyte	local09, local03, #0
05dc0     1C 18 06 F1 | 	add	local01, #28
05dc4     0C 2F 02 FB | 	rdlong	local12, local01
05dc8     1C 18 86 F1 | 	sub	local01, #28
05dcc     17 31 02 F6 | 	mov	local13, local12
05dd0     0D 30 06 F1 | 	add	local13, #13
05dd4     18 33 C2 FA | 	rdbyte	local14, local13
05dd8     0D 30 86 F1 | 	sub	local13, #13
05ddc     19 35 E2 F8 | 	getbyte	local15, local14, #0
05de0     1A 29 0A F2 | 	cmp	local09, local15 wz
05de4     3C 00 90 5D |  if_ne	jmp	#LR__0381
05de8     0C 1A 06 F1 | 	add	local02, #12
05dec     0D 0F 02 FB | 	rdlong	arg01, local02
05df0     0C 1A 86 F1 | 	sub	local02, #12
05df4     1C 18 06 F1 | 	add	local01, #28
05df8     0C 37 02 FB | 	rdlong	local16, local01
05dfc     1C 18 86 F1 | 	sub	local01, #28
05e00     1B 39 02 F6 | 	mov	local17, local16
05e04     1C 11 02 F6 | 	mov	arg02, local17
05e08     74 F7 BF FD | 	call	#_ff_cc_cmp_lfn_0265
05e0c     FA 3A 0A F6 | 	mov	local18, result1 wz
05e10     0F 39 02 56 |  if_ne	mov	local17, local04
05e14     1C 39 E2 58 |  if_ne	getbyte	local17, local17, #0
05e18     01 38 86 51 |  if_ne	sub	local17, #1
05e1c     1C 23 02 56 |  if_ne	mov	local06, local17
05e20     04 00 90 5D |  if_ne	jmp	#LR__0382
05e24                 | LR__0381
05e24     FF 22 06 F6 | 	mov	local06, #255
05e28                 | LR__0382
05e28     11 1F 02 F6 | 	mov	local04, local06
05e2c     88 00 90 FD | 	jmp	#LR__0386
05e30                 | LR__0383
05e30     0F 23 02 F6 | 	mov	local06, local04
05e34     07 22 4E F7 | 	zerox	local06, #7 wz
05e38     28 00 90 5D |  if_ne	jmp	#LR__0384
05e3c     0E 2D E2 F8 | 	getbyte	local11, local03, #0
05e40     1C 18 06 F1 | 	add	local01, #28
05e44     0C 35 02 FB | 	rdlong	local15, local01
05e48     1C 18 86 F1 | 	sub	local01, #28
05e4c     1A 0F 02 F6 | 	mov	arg01, local15
05e50     E4 FB BF FD | 	call	#_ff_cc_sum_sfn_0284
05e54     FA 28 02 F6 | 	mov	local09, result1
05e58     14 27 E2 F8 | 	getbyte	local08, local09, #0
05e5c     13 2D 0A F2 | 	cmp	local11, local08 wz
05e60     70 00 90 AD |  if_e	jmp	#LR__0388
05e64                 | LR__0384
05e64     2B 18 06 F1 | 	add	local01, #43
05e68     0C 23 C2 FA | 	rdbyte	local06, local01
05e6c     2B 18 86 F1 | 	sub	local01, #43
05e70     01 22 0E F5 | 	and	local06, #1 wz
05e74     2C 00 90 5D |  if_ne	jmp	#LR__0385
05e78     1C 18 06 F1 | 	add	local01, #28
05e7c     0C 0F 02 FB | 	rdlong	arg01, local01
05e80     04 18 06 F1 | 	add	local01, #4
05e84     0C 29 02 F6 | 	mov	local09, local01
05e88     0B 34 06 F6 | 	mov	local15, #11
05e8c     14 11 02 F6 | 	mov	arg02, local09
05e90     0B 12 06 F6 | 	mov	arg03, #11
05e94     20 18 86 F1 | 	sub	local01, #32
05e98     54 E5 BF FD | 	call	#_ff_cc_mem_cmp_0204
05e9c     FA 26 0A F6 | 	mov	local08, result1 wz
05ea0     30 00 90 AD |  if_e	jmp	#LR__0388
05ea4                 | LR__0385
05ea4     FF 1E 06 F6 | 	mov	local04, #255
05ea8     2C 18 06 F1 | 	add	local01, #44
05eac     FF FF FF FF 
05eb0     0C FF 6B FC | 	wrlong	##-1, local01
05eb4     2C 18 86 F1 | 	sub	local01, #44
05eb8                 | LR__0386
05eb8                 | LR__0387
05eb8     00 2C 06 F6 | 	mov	local11, #0
05ebc     0C 0F 02 F6 | 	mov	arg01, local01
05ec0     00 10 06 F6 | 	mov	arg02, #0
05ec4     98 F3 BF FD | 	call	#_ff_cc_dir_next_0253
05ec8     FA 22 02 F6 | 	mov	local06, result1
05ecc     11 21 0A F6 | 	mov	local05, local06 wz
05ed0     DC FD 9F AD |  if_e	jmp	#LR__0377
05ed4                 | LR__0388
05ed4                 | ' 
05ed4                 | ' 	return res;
05ed4     10 F5 01 F6 | 	mov	result1, local05
05ed8                 | LR__0389
05ed8     A8 F0 03 F6 | 	mov	ptra, fp
05edc     B3 00 A0 FD | 	call	#popregs_
05ee0                 | _ff_cc_dir_find_0298_ret
05ee0     2D 00 64 FD | 	ret
05ee4                 | 
05ee4                 | _ff_cc_dir_register_0306
05ee4     0E 4C 05 F6 | 	mov	COUNT_, #14
05ee8     A9 00 A0 FD | 	call	#pushregs_
05eec     2C F0 07 F1 | 	add	ptra, #44
05ef0     04 50 05 F1 | 	add	fp, #4
05ef4     A8 0E 62 FC | 	wrlong	arg01, fp
05ef8     07 19 02 FB | 	rdlong	local01, arg01
05efc     08 50 05 F1 | 	add	fp, #8
05f00     A8 18 62 FC | 	wrlong	local01, fp
05f04     08 50 85 F1 | 	sub	fp, #8
05f08     A8 1A 02 FB | 	rdlong	local02, fp
05f0c     04 50 85 F1 | 	sub	fp, #4
05f10     2B 1A 06 F1 | 	add	local02, #43
05f14     0D 1D C2 FA | 	rdbyte	local03, local02
05f18     A0 1C CE F7 | 	test	local03, #160 wz
05f1c     06 F4 05 56 |  if_ne	mov	result1, #6
05f20     50 04 90 5D |  if_ne	jmp	#LR__0409
05f24                 | ' 	for (nlen = 0; fs->lfnbuf[nlen]; nlen++) ;
05f24     14 50 05 F1 | 	add	fp, #20
05f28     A8 00 68 FC | 	wrlong	#0, fp
05f2c     14 50 85 F1 | 	sub	fp, #20
05f30     1C A1 9F FE | 	loc	pa,	#(@LR__0391-@LR__0390)
05f34     8C 00 A0 FD | 	call	#FCACHE_LOAD_
05f38                 | LR__0390
05f38     0C 50 05 F1 | 	add	fp, #12
05f3c     A8 1A 02 FB | 	rdlong	local02, fp
05f40     0C 1A 06 F1 | 	add	local02, #12
05f44     0D 1F 02 FB | 	rdlong	local04, local02
05f48     08 50 05 F1 | 	add	fp, #8
05f4c     A8 20 02 FB | 	rdlong	local05, fp
05f50     14 50 85 F1 | 	sub	fp, #20
05f54     01 20 66 F0 | 	shl	local05, #1
05f58     0F 21 02 F1 | 	add	local05, local04
05f5c     10 23 EA FA | 	rdword	local06, local05 wz
05f60     24 00 90 AD |  if_e	jmp	#LR__0392
05f64     14 50 05 F1 | 	add	fp, #20
05f68     A8 24 02 FB | 	rdlong	local07, fp
05f6c     12 27 02 F6 | 	mov	local08, local07
05f70     12 29 02 F6 | 	mov	local09, local07
05f74     14 2B 02 F6 | 	mov	local10, local09
05f78     01 2A 06 F1 | 	add	local10, #1
05f7c     A8 2A 62 FC | 	wrlong	local10, fp
05f80     14 50 85 F1 | 	sub	fp, #20
05f84     B0 FF 9F FD | 	jmp	#LR__0390
05f88                 | LR__0391
05f88                 | LR__0392
05f88     1C 50 05 F1 | 	add	fp, #28
05f8c     A8 0E 02 F6 | 	mov	arg01, fp
05f90     18 50 85 F1 | 	sub	fp, #24
05f94     A8 10 02 FB | 	rdlong	arg02, fp
05f98     04 50 85 F1 | 	sub	fp, #4
05f9c     20 10 06 F1 | 	add	arg02, #32
05fa0     0C 12 06 F6 | 	mov	arg03, #12
05fa4     18 E4 BF FD | 	call	#_ff_cc_mem_cpy_0198
05fa8     27 50 05 F1 | 	add	fp, #39
05fac     A8 1C C2 FA | 	rdbyte	local03, fp
05fb0     27 50 85 F1 | 	sub	fp, #39
05fb4     01 1C CE F7 | 	test	local03, #1 wz
05fb8     F4 00 90 AD |  if_e	jmp	#LR__0395
05fbc     04 50 05 F1 | 	add	fp, #4
05fc0     A8 1C 02 FB | 	rdlong	local03, fp
05fc4     2B 1C 06 F1 | 	add	local03, #43
05fc8     0E 81 48 FC | 	wrbyte	#64, local03
05fcc                 | ' 		dp->fn[ 11 ] =  0x40 ;
05fcc                 | ' 		for (n = 1; n < 100; n++) {
05fcc     0C 50 05 F1 | 	add	fp, #12
05fd0     A8 02 68 FC | 	wrlong	#1, fp
05fd4     10 50 85 F1 | 	sub	fp, #16
05fd8                 | LR__0393
05fd8     10 50 05 F1 | 	add	fp, #16
05fdc     A8 1A 02 FB | 	rdlong	local02, fp
05fe0     10 50 85 F1 | 	sub	fp, #16
05fe4     64 1A 16 F2 | 	cmp	local02, #100 wc
05fe8     70 00 90 3D |  if_ae	jmp	#LR__0394
05fec     04 50 05 F1 | 	add	fp, #4
05ff0     A8 0E 02 FB | 	rdlong	arg01, fp
05ff4     20 0E 06 F1 | 	add	arg01, #32
05ff8     18 50 05 F1 | 	add	fp, #24
05ffc     A8 10 02 F6 | 	mov	arg02, fp
06000     10 50 85 F1 | 	sub	fp, #16
06004     A8 14 02 FB | 	rdlong	arg04, fp
06008     0C 14 06 F1 | 	add	arg04, #12
0600c     0A 13 02 FB | 	rdlong	arg03, arg04
06010     04 50 05 F1 | 	add	fp, #4
06014     A8 14 02 FB | 	rdlong	arg04, fp
06018     10 50 85 F1 | 	sub	fp, #16
0601c     88 F8 BF FD | 	call	#_ff_cc_gen_numname_0281
06020     04 50 05 F1 | 	add	fp, #4
06024     A8 0E 02 FB | 	rdlong	arg01, fp
06028     04 50 85 F1 | 	sub	fp, #4
0602c     44 FC BF FD | 	call	#_ff_cc_dir_find_0298
06030     08 50 05 F1 | 	add	fp, #8
06034     A8 F4 61 FC | 	wrlong	result1, fp
06038     FA 20 0A F6 | 	mov	local05, result1 wz
0603c     08 50 85 F1 | 	sub	fp, #8
06040     18 00 90 5D |  if_ne	jmp	#LR__0394
06044     10 50 05 F1 | 	add	fp, #16
06048     A8 2C 02 FB | 	rdlong	local11, fp
0604c     01 2C 06 F1 | 	add	local11, #1
06050     A8 2C 62 FC | 	wrlong	local11, fp
06054     10 50 85 F1 | 	sub	fp, #16
06058     7C FF 9F FD | 	jmp	#LR__0393
0605c                 | LR__0394
0605c     10 50 05 F1 | 	add	fp, #16
06060     A8 1C 02 FB | 	rdlong	local03, fp
06064     10 50 85 F1 | 	sub	fp, #16
06068     64 1C 0E F2 | 	cmp	local03, #100 wz
0606c     07 F4 05 A6 |  if_e	mov	result1, #7
06070     00 03 90 AD |  if_e	jmp	#LR__0409
06074     08 50 05 F1 | 	add	fp, #8
06078     A8 1C 02 FB | 	rdlong	local03, fp
0607c     08 50 85 F1 | 	sub	fp, #8
06080     04 1C 0E F2 | 	cmp	local03, #4 wz
06084     08 50 05 51 |  if_ne	add	fp, #8
06088     A8 F4 01 5B |  if_ne	rdlong	result1, fp
0608c     08 50 85 51 |  if_ne	sub	fp, #8
06090     E0 02 90 5D |  if_ne	jmp	#LR__0409
06094     04 50 05 F1 | 	add	fp, #4
06098     A8 1C 02 FB | 	rdlong	local03, fp
0609c     23 50 05 F1 | 	add	fp, #35
060a0     A8 18 C2 FA | 	rdbyte	local01, fp
060a4     27 50 85 F1 | 	sub	fp, #39
060a8     2B 1C 06 F1 | 	add	local03, #43
060ac     0E 19 42 FC | 	wrbyte	local01, local03
060b0                 | LR__0395
060b0     27 50 05 F1 | 	add	fp, #39
060b4     A8 1A C2 FA | 	rdbyte	local02, fp
060b8     27 50 85 F1 | 	sub	fp, #39
060bc     02 1A CE F7 | 	test	local02, #2 wz
060c0     20 00 90 AD |  if_e	jmp	#LR__0396
060c4     14 50 05 F1 | 	add	fp, #20
060c8     A8 2C 02 FB | 	rdlong	local11, fp
060cc     0C 2C 06 F1 | 	add	local11, #12
060d0     0D 2C 16 FD | 	qdiv	local11, #13
060d4     14 50 85 F1 | 	sub	fp, #20
060d8     18 1C 62 FD | 	getqx	local03
060dc     01 1C 06 F1 | 	add	local03, #1
060e0     04 00 90 FD | 	jmp	#LR__0397
060e4                 | LR__0396
060e4     01 1C 06 F6 | 	mov	local03, #1
060e8                 | LR__0397
060e8     18 50 05 F1 | 	add	fp, #24
060ec     A8 1C 62 FC | 	wrlong	local03, fp
060f0     14 50 85 F1 | 	sub	fp, #20
060f4     A8 0E 02 FB | 	rdlong	arg01, fp
060f8     0E 11 02 F6 | 	mov	arg02, local03
060fc     04 50 85 F1 | 	sub	fp, #4
06100     1C F3 BF FD | 	call	#_ff_cc_dir_alloc_0257
06104     08 50 05 F1 | 	add	fp, #8
06108     A8 F4 61 FC | 	wrlong	result1, fp
0610c     08 50 85 F1 | 	sub	fp, #8
06110     00 F4 0D F2 | 	cmp	result1, #0 wz
06114     80 01 90 5D |  if_ne	jmp	#LR__0402
06118     18 50 05 F1 | 	add	fp, #24
0611c     A8 2C 02 FB | 	rdlong	local11, fp
06120     01 2C 8E F1 | 	sub	local11, #1 wz
06124     A8 2C 62 FC | 	wrlong	local11, fp
06128     18 50 85 F1 | 	sub	fp, #24
0612c     68 01 90 AD |  if_e	jmp	#LR__0402
06130     04 50 05 F1 | 	add	fp, #4
06134     A8 2E 02 FB | 	rdlong	local12, fp
06138     17 0F 02 F6 | 	mov	arg01, local12
0613c     17 31 02 F6 | 	mov	local13, local12
06140     14 50 05 F1 | 	add	fp, #20
06144     A8 20 02 FB | 	rdlong	local05, fp
06148     18 50 85 F1 | 	sub	fp, #24
0614c     10 33 02 F6 | 	mov	local14, local05
06150     19 2D 02 F6 | 	mov	local11, local14
06154     05 2C 66 F0 | 	shl	local11, #5
06158     10 30 06 F1 | 	add	local13, #16
0615c     18 1F 02 FB | 	rdlong	local04, local13
06160     10 30 86 F1 | 	sub	local13, #16
06164     0F 19 02 F6 | 	mov	local01, local04
06168     16 19 82 F1 | 	sub	local01, local11
0616c     0C 11 02 F6 | 	mov	arg02, local01
06170     74 EF BF FD | 	call	#_ff_cc_dir_sdi_0249
06174     08 50 05 F1 | 	add	fp, #8
06178     A8 F4 61 FC | 	wrlong	result1, fp
0617c     FA 1A 02 F6 | 	mov	local02, result1
06180     08 50 85 F1 | 	sub	fp, #8
06184     0D 1D 0A F6 | 	mov	local03, local02 wz
06188     0C 01 90 5D |  if_ne	jmp	#LR__0401
0618c     04 50 05 F1 | 	add	fp, #4
06190     A8 0E 02 FB | 	rdlong	arg01, fp
06194     04 50 85 F1 | 	sub	fp, #4
06198     20 0E 06 F1 | 	add	arg01, #32
0619c     98 F8 BF FD | 	call	#_ff_cc_sum_sfn_0284
061a0     FA 1C 02 F6 | 	mov	local03, result1
061a4     28 50 05 F1 | 	add	fp, #40
061a8     A8 1C 42 FC | 	wrbyte	local03, fp
061ac     28 50 85 F1 | 	sub	fp, #40
061b0                 | ' 			sum = sum_sfn(dp->fn);
061b0                 | ' 			do {
061b0                 | LR__0398
061b0     0C 50 05 F1 | 	add	fp, #12
061b4     A8 0E 02 FB | 	rdlong	arg01, fp
061b8     08 50 85 F1 | 	sub	fp, #8
061bc     A8 30 02 FB | 	rdlong	local13, fp
061c0     04 50 85 F1 | 	sub	fp, #4
061c4     18 19 02 F6 | 	mov	local01, local13
061c8     18 18 06 F1 | 	add	local01, #24
061cc     0C 2F 02 FB | 	rdlong	local12, local01
061d0     18 18 86 F1 | 	sub	local01, #24
061d4     17 11 02 F6 | 	mov	arg02, local12
061d8     48 E4 BF FD | 	call	#_ff_cc_move_window_0218
061dc     08 50 05 F1 | 	add	fp, #8
061e0     A8 F4 61 FC | 	wrlong	result1, fp
061e4     FA 1A 02 F6 | 	mov	local02, result1
061e8     08 50 85 F1 | 	sub	fp, #8
061ec     0D 1D 0A F6 | 	mov	local03, local02 wz
061f0     A4 00 90 5D |  if_ne	jmp	#LR__0400
061f4     0C 50 05 F1 | 	add	fp, #12
061f8     A8 1A 02 FB | 	rdlong	local02, fp
061fc     0C 1A 06 F1 | 	add	local02, #12
06200     0D 0F 02 FB | 	rdlong	arg01, local02
06204     08 50 85 F1 | 	sub	fp, #8
06208     A8 18 02 FB | 	rdlong	local01, fp
0620c     1C 18 06 F1 | 	add	local01, #28
06210     0C 11 02 FB | 	rdlong	arg02, local01
06214     14 50 05 F1 | 	add	fp, #20
06218     A8 12 02 FB | 	rdlong	arg03, fp
0621c     10 50 05 F1 | 	add	fp, #16
06220     A8 2E C2 FA | 	rdbyte	local12, fp
06224     28 50 85 F1 | 	sub	fp, #40
06228     17 31 02 F6 | 	mov	local13, local12
0622c     18 15 02 F6 | 	mov	arg04, local13
06230     90 F5 BF FD | 	call	#_ff_cc_put_lfn_0274
06234     0C 50 05 F1 | 	add	fp, #12
06238     A8 1C 02 FB | 	rdlong	local03, fp
0623c     01 18 06 F6 | 	mov	local01, #1
06240     03 1C 06 F1 | 	add	local03, #3
06244     0E 03 48 FC | 	wrbyte	#1, local03
06248     08 50 85 F1 | 	sub	fp, #8
0624c     A8 0E 02 FB | 	rdlong	arg01, fp
06250     04 50 85 F1 | 	sub	fp, #4
06254     00 10 06 F6 | 	mov	arg02, #0
06258     04 F0 BF FD | 	call	#_ff_cc_dir_next_0253
0625c     08 50 05 F1 | 	add	fp, #8
06260     A8 F4 61 FC | 	wrlong	result1, fp
06264     FA 1A 02 F6 | 	mov	local02, result1
06268     08 50 85 F1 | 	sub	fp, #8
0626c     0D 1D 0A F6 | 	mov	local03, local02 wz
06270     24 00 90 5D |  if_ne	jmp	#LR__0399
06274     18 50 05 F1 | 	add	fp, #24
06278     A8 30 02 FB | 	rdlong	local13, fp
0627c     18 19 02 F6 | 	mov	local01, local13
06280     01 18 86 F1 | 	sub	local01, #1
06284     A8 18 62 FC | 	wrlong	local01, fp
06288     0C 2D 02 F6 | 	mov	local11, local01
0628c     18 50 85 F1 | 	sub	fp, #24
06290     16 2F 0A F6 | 	mov	local12, local11 wz
06294     18 FF 9F 5D |  if_ne	jmp	#LR__0398
06298                 | LR__0399
06298                 | LR__0400
06298                 | LR__0401
06298                 | LR__0402
06298     08 50 05 F1 | 	add	fp, #8
0629c     A8 1C 0A FB | 	rdlong	local03, fp wz
062a0     08 50 85 F1 | 	sub	fp, #8
062a4     C0 00 90 5D |  if_ne	jmp	#LR__0408
062a8     0C 50 05 F1 | 	add	fp, #12
062ac     A8 0E 02 FB | 	rdlong	arg01, fp
062b0     08 50 85 F1 | 	sub	fp, #8
062b4     A8 18 02 FB | 	rdlong	local01, fp
062b8     04 50 85 F1 | 	sub	fp, #4
062bc     18 18 06 F1 | 	add	local01, #24
062c0     0C 11 02 FB | 	rdlong	arg02, local01
062c4     5C E3 BF FD | 	call	#_ff_cc_move_window_0218
062c8     08 50 05 F1 | 	add	fp, #8
062cc     A8 F4 61 FC | 	wrlong	result1, fp
062d0     08 50 85 F1 | 	sub	fp, #8
062d4     00 F4 0D F2 | 	cmp	result1, #0 wz
062d8     8C 00 90 5D |  if_ne	jmp	#LR__0407
062dc     04 50 05 F1 | 	add	fp, #4
062e0     A8 1A 02 FB | 	rdlong	local02, fp
062e4     04 50 85 F1 | 	sub	fp, #4
062e8     1C 1A 06 F1 | 	add	local02, #28
062ec     0D 0F 02 FB | 	rdlong	arg01, local02
062f0     00 10 06 F6 | 	mov	arg02, #0
062f4                 | ' {
062f4                 | ' 	BYTE *d = (BYTE*)dst;
062f4                 | ' 
062f4                 | ' 	do {
062f4     14 9D 9F FE | 	loc	pa,	#(@LR__0405-@LR__0403)
062f8     8C 00 A0 FD | 	call	#FCACHE_LOAD_
062fc                 | LR__0403
062fc     20 04 DC FC | 	rep	@LR__0406, #32
06300                 | LR__0404
06300     07 11 42 FC | 	wrbyte	arg02, arg01
06304     01 0E 06 F1 | 	add	arg01, #1
06308                 | LR__0405
06308                 | LR__0406
06308     04 50 05 F1 | 	add	fp, #4
0630c     A8 10 02 FB | 	rdlong	arg02, fp
06310     08 19 02 F6 | 	mov	local01, arg02
06314     1C 18 06 F1 | 	add	local01, #28
06318     0C 0F 02 FB | 	rdlong	arg01, local01
0631c     04 50 85 F1 | 	sub	fp, #4
06320     20 10 06 F1 | 	add	arg02, #32
06324     0B 12 06 F6 | 	mov	arg03, #11
06328     94 E0 BF FD | 	call	#_ff_cc_mem_cpy_0198
0632c     04 50 05 F1 | 	add	fp, #4
06330     A8 2C 02 FB | 	rdlong	local11, fp
06334     16 1D 02 F6 | 	mov	local03, local11
06338     1C 1C 06 F1 | 	add	local03, #28
0633c     0E 19 02 FB | 	rdlong	local01, local03
06340     2B 2C 06 F1 | 	add	local11, #43
06344     16 2F C2 FA | 	rdbyte	local12, local11
06348     18 2E 06 F5 | 	and	local12, #24
0634c     0C 18 06 F1 | 	add	local01, #12
06350     0C 2F 42 FC | 	wrbyte	local12, local01
06354     08 50 05 F1 | 	add	fp, #8
06358     A8 1C 02 FB | 	rdlong	local03, fp
0635c     0C 50 85 F1 | 	sub	fp, #12
06360     03 1C 06 F1 | 	add	local03, #3
06364     0E 03 48 FC | 	wrbyte	#1, local03
06368                 | LR__0407
06368                 | LR__0408
06368                 | ' 			mem_set(dp->dir, 0,  32 );
06368                 | ' 			mem_cpy(dp->dir +  0 , dp->fn, 11);
06368                 | ' 
06368                 | ' 			dp->dir[ 12 ] = dp->fn[ 11 ] & ( 0x08  |  0x10 );
06368                 | ' 
06368                 | ' 			fs->wflag = 1;
06368                 | ' 		}
06368                 | ' 	}
06368                 | ' 
06368                 | ' 	return res;
06368     08 50 05 F1 | 	add	fp, #8
0636c     A8 F4 01 FB | 	rdlong	result1, fp
06370     08 50 85 F1 | 	sub	fp, #8
06374                 | LR__0409
06374     A8 F0 03 F6 | 	mov	ptra, fp
06378     B3 00 A0 FD | 	call	#popregs_
0637c                 | _ff_cc_dir_register_0306_ret
0637c     2D 00 64 FD | 	ret
06380                 | 
06380                 | _ff_cc_dir_remove_0310
06380     0A 4C 05 F6 | 	mov	COUNT_, #10
06384     A9 00 A0 FD | 	call	#pushregs_
06388     07 19 02 F6 | 	mov	local01, arg01
0638c     0C 1B 02 FB | 	rdlong	local02, local01
06390     10 18 06 F1 | 	add	local01, #16
06394     0C 1D 02 FB | 	rdlong	local03, local01
06398     1C 18 06 F1 | 	add	local01, #28
0639c     0C 11 02 FB | 	rdlong	arg02, local01
063a0     2C 18 86 F1 | 	sub	local01, #44
063a4     FF FF 7F FF 
063a8     FF 11 0E F2 | 	cmp	arg02, ##-1 wz
063ac     00 1E 06 A6 |  if_e	mov	local04, #0
063b0     24 00 90 AD |  if_e	jmp	#LR__0410
063b4     0C 0F 02 F6 | 	mov	arg01, local01
063b8     2C 18 06 F1 | 	add	local01, #44
063bc     0C 21 02 FB | 	rdlong	local05, local01
063c0     2C 18 86 F1 | 	sub	local01, #44
063c4     10 23 02 F6 | 	mov	local06, local05
063c8     11 11 02 F6 | 	mov	arg02, local06
063cc     18 ED BF FD | 	call	#_ff_cc_dir_sdi_0249
063d0     FA 24 02 F6 | 	mov	local07, result1
063d4     12 1F 02 F6 | 	mov	local04, local07
063d8                 | LR__0410
063d8     0F 27 0A F6 | 	mov	local08, local04 wz
063dc     70 00 90 5D |  if_ne	jmp	#LR__0413
063e0                 | ' 		do {
063e0                 | LR__0411
063e0     18 18 06 F1 | 	add	local01, #24
063e4     0C 11 02 FB | 	rdlong	arg02, local01
063e8     18 18 86 F1 | 	sub	local01, #24
063ec     0D 0F 02 F6 | 	mov	arg01, local02
063f0     30 E2 BF FD | 	call	#_ff_cc_move_window_0218
063f4     FA 26 0A F6 | 	mov	local08, result1 wz
063f8     4C 00 90 5D |  if_ne	jmp	#LR__0412
063fc     1C 18 06 F1 | 	add	local01, #28
06400     0C 1F 02 FB | 	rdlong	local04, local01
06404     E5 28 06 F6 | 	mov	local09, #229
06408     0F CB 49 FC | 	wrbyte	#229, local04
0640c     03 1A 06 F1 | 	add	local02, #3
06410     0D 03 48 FC | 	wrbyte	#1, local02
06414     03 1A 86 F1 | 	sub	local02, #3
06418     0C 18 86 F1 | 	sub	local01, #12
0641c     0C 1F 02 FB | 	rdlong	local04, local01
06420     10 18 86 F1 | 	sub	local01, #16
06424     0E 1F 12 F2 | 	cmp	local04, local03 wc
06428     1C 00 90 3D |  if_ae	jmp	#LR__0412
0642c     00 2A 06 F6 | 	mov	local10, #0
06430     0C 0F 02 F6 | 	mov	arg01, local01
06434     00 10 06 F6 | 	mov	arg02, #0
06438     24 EE BF FD | 	call	#_ff_cc_dir_next_0253
0643c     FA 1E 02 F6 | 	mov	local04, result1
06440     0F 27 0A F6 | 	mov	local08, local04 wz
06444     98 FF 9F AD |  if_e	jmp	#LR__0411
06448                 | LR__0412
06448     04 26 0E F2 | 	cmp	local08, #4 wz
0644c     02 26 06 A6 |  if_e	mov	local08, #2
06450                 | LR__0413
06450                 | ' 	}
06450                 | ' #line 2671 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
06450                 | ' 	return res;
06450     13 F5 01 F6 | 	mov	result1, local08
06454     A8 F0 03 F6 | 	mov	ptra, fp
06458     B3 00 A0 FD | 	call	#popregs_
0645c                 | _ff_cc_dir_remove_0310_ret
0645c     2D 00 64 FD | 	ret
06460                 | 
06460                 | _ff_cc_get_fileinfo_0317
06460     12 4C 05 F6 | 	mov	COUNT_, #18
06464     A9 00 A0 FD | 	call	#pushregs_
06468     07 19 02 F6 | 	mov	local01, arg01
0646c     08 1B 02 F6 | 	mov	local02, arg02
06470     0C 1D 02 FB | 	rdlong	local03, local01
06474     1C 1A 06 F1 | 	add	local02, #28
06478     0D 01 48 FC | 	wrbyte	#0, local02
0647c     1C 1A 86 F1 | 	sub	local02, #28
06480     18 18 06 F1 | 	add	local01, #24
06484     0C 1F 0A FB | 	rdlong	local04, local01 wz
06488     18 18 86 F1 | 	sub	local01, #24
0648c     5C 03 90 AD |  if_e	jmp	#LR__0427
06490     2C 18 06 F1 | 	add	local01, #44
06494     0C 21 02 FB | 	rdlong	local05, local01
06498     2C 18 86 F1 | 	sub	local01, #44
0649c     10 1F 02 F6 | 	mov	local04, local05
064a0     FF FF 7F FF 
064a4     FF 1F 0E F2 | 	cmp	local04, ##-1 wz
064a8     04 01 90 AD |  if_e	jmp	#LR__0417
064ac     00 22 06 F6 | 	mov	local06, #0
064b0     00 1E 06 F6 | 	mov	local04, #0
064b4     00 24 06 F6 | 	mov	local07, #0
064b8     00 26 06 F6 | 	mov	local08, #0
064bc                 | ' 			si = di = hs = 0;
064bc                 | ' 			while (fs->lfnbuf[si] != 0) {
064bc                 | LR__0414
064bc     0C 1C 06 F1 | 	add	local03, #12
064c0     0E 29 02 FB | 	rdlong	local09, local03
064c4     0C 1C 86 F1 | 	sub	local03, #12
064c8     13 2B 02 F6 | 	mov	local10, local08
064cc     15 2D 02 F6 | 	mov	local11, local10
064d0     01 2C 66 F0 | 	shl	local11, #1
064d4     14 2D 02 F1 | 	add	local11, local09
064d8     16 1F EA FA | 	rdword	local04, local11 wz
064dc     A8 00 90 AD |  if_e	jmp	#LR__0416
064e0     0C 1C 06 F1 | 	add	local03, #12
064e4     0E 2F 02 FB | 	rdlong	local12, local03
064e8     0C 1C 86 F1 | 	sub	local03, #12
064ec     13 29 02 F6 | 	mov	local09, local08
064f0     01 28 66 F0 | 	shl	local09, #1
064f4     17 29 02 F1 | 	add	local09, local12
064f8     14 31 E2 FA | 	rdword	local13, local09
064fc     11 1F 02 F6 | 	mov	local04, local06
06500     0F 1E 4E F7 | 	zerox	local04, #15 wz
06504     01 26 06 F1 | 	add	local08, #1
06508     24 00 90 5D |  if_ne	jmp	#LR__0415
0650c     18 21 32 F9 | 	getword	local05, local13, #0
06510     6C 00 00 FF 
06514     00 20 16 F2 | 	cmp	local05, ##55296 wc
06518     14 00 90 CD |  if_b	jmp	#LR__0415
0651c     18 33 32 F9 | 	getword	local14, local13, #0
06520     70 00 00 FF 
06524     00 32 16 F2 | 	cmp	local14, ##57344 wc
06528     18 23 02 C6 |  if_b	mov	local06, local13
0652c                 | ' 					hs = wc; continue;
0652c     8C FF 9F CD |  if_b	jmp	#LR__0414
06530                 | LR__0415
06530     11 0F 32 F9 | 	getword	arg01, local06, #0
06534     10 0E 66 F0 | 	shl	arg01, #16
06538     18 31 32 F9 | 	getword	local13, local13, #0
0653c     18 0F 42 F5 | 	or	arg01, local13
06540     12 29 02 F6 | 	mov	local09, local07
06544     1C 1A 06 F1 | 	add	local02, #28
06548     0D 29 02 F1 | 	add	local09, local02
0654c     14 11 02 F6 | 	mov	arg02, local09
06550     FF 2C 06 F6 | 	mov	local11, #255
06554     12 2D 82 F1 | 	sub	local11, local07
06558     16 2B 02 F6 | 	mov	local10, local11
0655c     15 13 02 F6 | 	mov	arg03, local10
06560     1C 1A 86 F1 | 	sub	local02, #28
06564     64 DF BF FD | 	call	#_ff_cc_put_utf_0214
06568     FA 30 E2 F8 | 	getbyte	local13, result1, #0
0656c     18 1F 02 F6 | 	mov	local04, local13
06570     0F 1E 4E F7 | 	zerox	local04, #15 wz
06574     00 24 06 A6 |  if_e	mov	local07, #0
06578     18 21 32 59 |  if_ne	getword	local05, local13, #0
0657c     10 25 02 51 |  if_ne	add	local07, local05
06580     00 22 06 56 |  if_ne	mov	local06, #0
06584     34 FF 9F 5D |  if_ne	jmp	#LR__0414
06588                 | LR__0416
06588     11 1F 02 F6 | 	mov	local04, local06
0658c     0F 1E 4E F7 | 	zerox	local04, #15 wz
06590     00 24 06 56 |  if_ne	mov	local07, #0
06594     12 1F 02 F6 | 	mov	local04, local07
06598     1C 1A 06 F1 | 	add	local02, #28
0659c     0D 21 02 F6 | 	mov	local05, local02
065a0     0D 1F 02 F1 | 	add	local04, local02
065a4     00 32 06 F6 | 	mov	local14, #0
065a8     0F 01 48 FC | 	wrbyte	#0, local04
065ac     1C 1A 86 F1 | 	sub	local02, #28
065b0                 | LR__0417
065b0     00 24 06 F6 | 	mov	local07, #0
065b4     00 26 06 F6 | 	mov	local08, #0
065b8                 | ' 			fno->fname[di] = 0;
065b8                 | ' 		}
065b8                 | ' 	}
065b8                 | ' 
065b8                 | ' 	si = di = 0;
065b8                 | ' 	while (si < 11) {
065b8                 | LR__0418
065b8     0B 26 16 F2 | 	cmp	local08, #11 wc
065bc     90 00 90 3D |  if_ae	jmp	#LR__0420
065c0     1C 18 06 F1 | 	add	local01, #28
065c4     0C 2F 02 FB | 	rdlong	local12, local01
065c8     1C 18 86 F1 | 	sub	local01, #28
065cc     13 29 02 F6 | 	mov	local09, local08
065d0     17 29 02 F1 | 	add	local09, local12
065d4     14 31 C2 FA | 	rdbyte	local13, local09
065d8     18 1F 32 F9 | 	getword	local04, local13, #0
065dc     20 1E 0E F2 | 	cmp	local04, #32 wz
065e0     01 26 06 F1 | 	add	local08, #1
065e4     D0 FF 9F AD |  if_e	jmp	#LR__0418
065e8     18 1F 32 F9 | 	getword	local04, local13, #0
065ec     05 1E 0E F2 | 	cmp	local04, #5 wz
065f0     E5 30 06 A6 |  if_e	mov	local13, #229
065f4     09 26 0E F2 | 	cmp	local08, #9 wz
065f8     34 00 90 5D |  if_ne	jmp	#LR__0419
065fc     0C 24 16 F2 | 	cmp	local07, #12 wc
06600     2C 00 90 3D |  if_ae	jmp	#LR__0419
06604     12 1F 02 F6 | 	mov	local04, local07
06608     12 21 02 F6 | 	mov	local05, local07
0660c     01 20 06 F1 | 	add	local05, #1
06610     10 25 02 F6 | 	mov	local07, local05
06614     0F 33 02 F6 | 	mov	local14, local04
06618     0C 1A 06 F1 | 	add	local02, #12
0661c     0D 2B 02 F6 | 	mov	local10, local02
06620     0D 33 02 F1 | 	add	local14, local02
06624     2E 2C 06 F6 | 	mov	local11, #46
06628     19 5D 48 FC | 	wrbyte	#46, local14
0662c     0C 1A 86 F1 | 	sub	local02, #12
06630                 | LR__0419
06630     12 33 02 F6 | 	mov	local14, local07
06634     0C 1A 06 F1 | 	add	local02, #12
06638     0D 33 02 F1 | 	add	local14, local02
0663c     18 31 32 F9 | 	getword	local13, local13, #0
06640     19 31 42 FC | 	wrbyte	local13, local14
06644     01 24 06 F1 | 	add	local07, #1
06648     0C 1A 86 F1 | 	sub	local02, #12
0664c     68 FF 9F FD | 	jmp	#LR__0418
06650                 | LR__0420
06650     12 1F 02 F6 | 	mov	local04, local07
06654     0C 1A 06 F1 | 	add	local02, #12
06658     0D 1F 02 F1 | 	add	local04, local02
0665c     0F 01 48 FC | 	wrbyte	#0, local04
06660     10 1A 06 F1 | 	add	local02, #16
06664     0D 1F C2 FA | 	rdbyte	local04, local02
06668     1C 1A 86 F1 | 	sub	local02, #28
0666c     07 1E 4E F7 | 	zerox	local04, #7 wz
06670     10 01 90 5D |  if_ne	jmp	#LR__0426
06674     00 24 0E F2 | 	cmp	local07, #0 wz
06678     1C 00 90 5D |  if_ne	jmp	#LR__0421
0667c     12 33 02 F6 | 	mov	local14, local07
06680     1C 1A 06 F1 | 	add	local02, #28
06684     0D 33 02 F1 | 	add	local14, local02
06688     19 7F 48 FC | 	wrbyte	#63, local14
0668c     01 24 06 F1 | 	add	local07, #1
06690     1C 1A 86 F1 | 	sub	local02, #28
06694     BC 00 90 FD | 	jmp	#LR__0425
06698                 | LR__0421
06698                 | ' 			for (si = di = 0, lcf =  0x08 ; fno->altname[si]; si++, di++) {
06698     00 24 06 F6 | 	mov	local07, #0
0669c     00 26 06 F6 | 	mov	local08, #0
066a0     08 34 06 F6 | 	mov	local15, #8
066a4                 | LR__0422
066a4     13 1F 02 F6 | 	mov	local04, local08
066a8     0C 1A 06 F1 | 	add	local02, #12
066ac     0D 21 02 F6 | 	mov	local05, local02
066b0     0D 1F 02 F1 | 	add	local04, local02
066b4     0F 33 CA FA | 	rdbyte	local14, local04 wz
066b8     0C 1A 86 F1 | 	sub	local02, #12
066bc     94 00 90 AD |  if_e	jmp	#LR__0424
066c0     13 2D 02 F6 | 	mov	local11, local08
066c4     0C 1A 06 F1 | 	add	local02, #12
066c8     0D 2D 02 F1 | 	add	local11, local02
066cc     16 31 C2 FA | 	rdbyte	local13, local11
066d0     18 2B 32 F9 | 	getword	local10, local13, #0
066d4     2E 2A 0E F2 | 	cmp	local10, #46 wz
066d8     0C 1A 86 F1 | 	sub	local02, #12
066dc     10 34 06 A6 |  if_e	mov	local15, #16
066e0     18 2B 32 F9 | 	getword	local10, local13, #0
066e4     41 2A 16 F2 | 	cmp	local10, #65 wc
066e8     44 00 90 CD |  if_b	jmp	#LR__0423
066ec     18 2D 32 F9 | 	getword	local11, local13, #0
066f0     5B 2C 16 F2 | 	cmp	local11, #91 wc
066f4     38 00 90 3D |  if_ae	jmp	#LR__0423
066f8     1C 18 06 F1 | 	add	local01, #28
066fc     0C 37 02 FB | 	rdlong	local16, local01
06700     1C 18 86 F1 | 	sub	local01, #28
06704     1B 2F 02 F6 | 	mov	local12, local16
06708     0C 2E 06 F1 | 	add	local12, #12
0670c     17 39 C2 FA | 	rdbyte	local17, local12
06710     0C 2E 86 F1 | 	sub	local12, #12
06714     1C 29 E2 F8 | 	getbyte	local09, local17, #0
06718     1A 3B E2 F8 | 	getbyte	local18, local15, #0
0671c     1D 29 0A F5 | 	and	local09, local18 wz
06720     18 2B 02 56 |  if_ne	mov	local10, local13
06724     15 2B 32 59 |  if_ne	getword	local10, local10, #0
06728     20 2A 06 51 |  if_ne	add	local10, #32
0672c     15 31 02 56 |  if_ne	mov	local13, local10
06730                 | LR__0423
06730     12 2B 02 F6 | 	mov	local10, local07
06734     1C 1A 06 F1 | 	add	local02, #28
06738     0D 2B 02 F1 | 	add	local10, local02
0673c     18 31 32 F9 | 	getword	local13, local13, #0
06740     15 31 42 FC | 	wrbyte	local13, local10
06744     01 26 06 F1 | 	add	local08, #1
06748     01 24 06 F1 | 	add	local07, #1
0674c     1C 1A 86 F1 | 	sub	local02, #28
06750     50 FF 9F FD | 	jmp	#LR__0422
06754                 | LR__0424
06754                 | LR__0425
06754     1C 1A 06 F1 | 	add	local02, #28
06758     0D 25 02 F1 | 	add	local07, local02
0675c     12 01 48 FC | 	wrbyte	#0, local07
06760     1C 18 06 F1 | 	add	local01, #28
06764     0C 1F 02 FB | 	rdlong	local04, local01
06768     1C 18 86 F1 | 	sub	local01, #28
0676c     0C 1E 06 F1 | 	add	local04, #12
06770     0F 33 CA FA | 	rdbyte	local14, local04 wz
06774     1C 1A 86 F1 | 	sub	local02, #28
06778     0C 1A 06 A1 |  if_e	add	local02, #12
0677c     0D 01 48 AC |  if_e	wrbyte	#0, local02
06780     0C 1A 86 A1 |  if_e	sub	local02, #12
06784                 | LR__0426
06784     1C 18 06 F1 | 	add	local01, #28
06788     0C 1F 02 FB | 	rdlong	local04, local01
0678c     0B 1E 06 F1 | 	add	local04, #11
06790     0F 33 C2 FA | 	rdbyte	local14, local04
06794     08 1A 06 F1 | 	add	local02, #8
06798     0D 33 42 FC | 	wrbyte	local14, local02
0679c     08 1A 86 F1 | 	sub	local02, #8
067a0     0C 0F 02 FB | 	rdlong	arg01, local01
067a4     1C 18 86 F1 | 	sub	local01, #28
067a8     1C 0E 06 F1 | 	add	arg01, #28
067ac     88 DB BF FD | 	call	#_ff_cc_ld_dword_0193
067b0     0D F5 61 FC | 	wrlong	result1, local02
067b4     1C 18 06 F1 | 	add	local01, #28
067b8     0C 0F 02 FB | 	rdlong	arg01, local01
067bc     1C 18 86 F1 | 	sub	local01, #28
067c0     16 0E 06 F1 | 	add	arg01, #22
067c4     50 DB BF FD | 	call	#_ff_cc_ld_word_0191
067c8     06 1A 06 F1 | 	add	local02, #6
067cc     0D F5 51 FC | 	wrword	result1, local02
067d0     06 1A 86 F1 | 	sub	local02, #6
067d4     1C 18 06 F1 | 	add	local01, #28
067d8     0C 0F 02 FB | 	rdlong	arg01, local01
067dc     18 0E 06 F1 | 	add	arg01, #24
067e0     34 DB BF FD | 	call	#_ff_cc_ld_word_0191
067e4     04 1A 06 F1 | 	add	local02, #4
067e8     0D F5 51 FC | 	wrword	result1, local02
067ec                 | LR__0427
067ec     A8 F0 03 F6 | 	mov	ptra, fp
067f0     B3 00 A0 FD | 	call	#popregs_
067f4                 | _ff_cc_get_fileinfo_0317_ret
067f4     2D 00 64 FD | 	ret
067f8                 | 
067f8                 | _ff_cc_create_name_0328
067f8     0D 4C 05 F6 | 	mov	COUNT_, #13
067fc     A9 00 A0 FD | 	call	#pushregs_
06800     34 F0 07 F1 | 	add	ptra, #52
06804     04 50 05 F1 | 	add	fp, #4
06808     A8 0E 62 FC | 	wrlong	arg01, fp
0680c     04 50 05 F1 | 	add	fp, #4
06810     A8 10 62 FC | 	wrlong	arg02, fp
06814     08 F5 01 FB | 	rdlong	result1, arg02
06818     28 50 05 F1 | 	add	fp, #40
0681c     A8 F4 61 FC | 	wrlong	result1, fp
06820     2C 50 85 F1 | 	sub	fp, #44
06824     A8 F4 01 FB | 	rdlong	result1, fp
06828     FA 18 02 FB | 	rdlong	local01, result1
0682c     0C 18 06 F1 | 	add	local01, #12
06830     0C 1B 02 FB | 	rdlong	local02, local01
06834     14 50 05 F1 | 	add	fp, #20
06838     A8 1A 62 FC | 	wrlong	local02, fp
0683c     14 50 05 F1 | 	add	fp, #20
06840     A8 00 68 FC | 	wrlong	#0, fp
06844     2C 50 85 F1 | 	sub	fp, #44
06848                 | ' 
06848                 | ' 
06848                 | ' 
06848                 | ' 	p = *path; lfn = dp->obj.fs->lfnbuf; di = 0;
06848                 | ' 	for (;;) {
06848                 | LR__0428
06848     30 50 05 F1 | 	add	fp, #48
0684c     A8 0E 02 F6 | 	mov	arg01, fp
06850     30 50 85 F1 | 	sub	fp, #48
06854     CC DB BF FD | 	call	#_ff_cc_tchar2uni_0212
06858     1C 50 05 F1 | 	add	fp, #28
0685c     A8 F4 61 FC | 	wrlong	result1, fp
06860     1C 50 85 F1 | 	sub	fp, #28
06864     FF FF 7F FF 
06868     FF F5 0D F2 | 	cmp	result1, ##-1 wz
0686c     06 F4 05 A6 |  if_e	mov	result1, #6
06870     D8 08 90 AD |  if_e	jmp	#LR__0475
06874     1C 50 05 F1 | 	add	fp, #28
06878     A8 18 02 FB | 	rdlong	local01, fp
0687c     1C 50 85 F1 | 	sub	fp, #28
06880     80 00 00 FF 
06884     00 18 16 F2 | 	cmp	local01, ##65536 wc
06888     3C 00 90 CD |  if_b	jmp	#LR__0429
0688c     18 50 05 F1 | 	add	fp, #24
06890     A8 1C 02 FB | 	rdlong	local03, fp
06894     14 50 05 F1 | 	add	fp, #20
06898     A8 1E 02 FB | 	rdlong	local04, fp
0689c     0F 19 02 F6 | 	mov	local01, local04
068a0     01 18 06 F1 | 	add	local01, #1
068a4     A8 18 62 FC | 	wrlong	local01, fp
068a8     01 1E 66 F0 | 	shl	local04, #1
068ac     0E 1F 02 F1 | 	add	local04, local03
068b0     10 50 85 F1 | 	sub	fp, #16
068b4     A8 20 02 FB | 	rdlong	local05, fp
068b8     1C 50 85 F1 | 	sub	fp, #28
068bc     10 23 02 F6 | 	mov	local06, local05
068c0     10 22 46 F0 | 	shr	local06, #16
068c4     0F 23 52 FC | 	wrword	local06, local04
068c8                 | LR__0429
068c8     1C 50 05 F1 | 	add	fp, #28
068cc     A8 1E 02 FB | 	rdlong	local04, fp
068d0     08 50 85 F1 | 	sub	fp, #8
068d4     A8 1E 52 FC | 	wrword	local04, fp
068d8     A8 1E E2 FA | 	rdword	local04, fp
068dc     14 50 85 F1 | 	sub	fp, #20
068e0     20 1E 16 F2 | 	cmp	local04, #32 wc
068e4     D4 00 90 CD |  if_b	jmp	#LR__0433
068e8     14 50 05 F1 | 	add	fp, #20
068ec     A8 1A E2 FA | 	rdword	local02, fp
068f0     14 50 85 F1 | 	sub	fp, #20
068f4     0D 19 32 F9 | 	getword	local01, local02, #0
068f8     2F 18 0E F2 | 	cmp	local01, #47 wz
068fc     BC 00 90 AD |  if_e	jmp	#LR__0433
06900     14 50 05 F1 | 	add	fp, #20
06904     A8 1E E2 FA | 	rdword	local04, fp
06908     14 50 85 F1 | 	sub	fp, #20
0690c     5C 1E 0E F2 | 	cmp	local04, #92 wz
06910     A8 00 90 AD |  if_e	jmp	#LR__0433
06914     14 50 05 F1 | 	add	fp, #20
06918     A8 1E E2 FA | 	rdword	local04, fp
0691c     14 50 85 F1 | 	sub	fp, #20
06920     80 1E 16 F2 | 	cmp	local04, #128 wc
06924     3C 00 90 3D |  if_ae	jmp	#LR__0432
06928     5D 00 00 FF 
0692c     EA 0E 06 F6 | 	mov	arg01, ##@LR__0737
06930     14 50 05 F1 | 	add	fp, #20
06934     A8 10 E2 FA | 	rdword	arg02, fp
06938     14 50 85 F1 | 	sub	fp, #20
0693c     D4 96 9F FE | 	loc	pa,	#(@LR__0431-@LR__0430)
06940     8C 00 A0 FD | 	call	#FCACHE_LOAD_
06944                 | ' {
06944                 | ' 	while (*str && *str != chr) str++;
06944                 | LR__0430
06944     07 F5 C9 FA | 	rdbyte	result1, arg01 wz
06948     07 25 C2 5A |  if_ne	rdbyte	local07, arg01
0694c     08 25 0A 52 |  if_ne	cmp	local07, arg02 wz
06950     01 0E 06 51 |  if_ne	add	arg01, #1
06954     EC FF 9F 5D |  if_ne	jmp	#LR__0430
06958                 | LR__0431
06958                 | ' 	return *str;
06958     07 F5 C9 FA | 	rdbyte	result1, arg01 wz
0695c     06 F4 05 56 |  if_ne	mov	result1, #6
06960     E8 07 90 5D |  if_ne	jmp	#LR__0475
06964                 | LR__0432
06964     2C 50 05 F1 | 	add	fp, #44
06968     A8 1E 02 FB | 	rdlong	local04, fp
0696c     2C 50 85 F1 | 	sub	fp, #44
06970     FF 1E 16 F2 | 	cmp	local04, #255 wc
06974     06 F4 05 36 |  if_ae	mov	result1, #6
06978     D0 07 90 3D |  if_ae	jmp	#LR__0475
0697c     18 50 05 F1 | 	add	fp, #24
06980     A8 1C 02 FB | 	rdlong	local03, fp
06984     14 50 05 F1 | 	add	fp, #20
06988     A8 1A 02 FB | 	rdlong	local02, fp
0698c     0D 23 02 F6 | 	mov	local06, local02
06990     01 22 06 F1 | 	add	local06, #1
06994     A8 22 62 FC | 	wrlong	local06, fp
06998     0D 27 02 F6 | 	mov	local08, local02
0699c     13 29 02 F6 | 	mov	local09, local08
069a0     01 28 66 F0 | 	shl	local09, #1
069a4     0E 29 02 F1 | 	add	local09, local03
069a8     18 50 85 F1 | 	sub	fp, #24
069ac     A8 22 E2 FA | 	rdword	local06, fp
069b0     14 50 85 F1 | 	sub	fp, #20
069b4     14 23 52 FC | 	wrword	local06, local09
069b8     8C FE 9F FD | 	jmp	#LR__0428
069bc                 | LR__0433
069bc     14 50 05 F1 | 	add	fp, #20
069c0     A8 1E E2 FA | 	rdword	local04, fp
069c4     14 50 85 F1 | 	sub	fp, #20
069c8     20 1E 16 F2 | 	cmp	local04, #32 wc
069cc     10 50 05 C1 |  if_b	add	fp, #16
069d0     A8 08 48 CC |  if_b	wrbyte	#4, fp
069d4     10 50 85 C1 |  if_b	sub	fp, #16
069d8     54 00 90 CD |  if_b	jmp	#LR__0437
069dc     10 50 05 F1 | 	add	fp, #16
069e0     A8 00 48 FC | 	wrbyte	#0, fp
069e4     10 50 85 F1 | 	sub	fp, #16
069e8                 | ' 		cf = 0;
069e8                 | ' 		while (*p == '/' || *p == '\\') p++;
069e8                 | LR__0434
069e8     30 50 05 F1 | 	add	fp, #48
069ec     A8 1E 02 FB | 	rdlong	local04, fp
069f0     30 50 85 F1 | 	sub	fp, #48
069f4     0F 1F C2 FA | 	rdbyte	local04, local04
069f8     2F 1E 0E F2 | 	cmp	local04, #47 wz
069fc     18 00 90 AD |  if_e	jmp	#LR__0435
06a00     30 50 05 F1 | 	add	fp, #48
06a04     A8 28 02 FB | 	rdlong	local09, fp
06a08     30 50 85 F1 | 	sub	fp, #48
06a0c     14 1B C2 FA | 	rdbyte	local02, local09
06a10     5C 1A 0E F2 | 	cmp	local02, #92 wz
06a14     18 00 90 5D |  if_ne	jmp	#LR__0436
06a18                 | LR__0435
06a18     30 50 05 F1 | 	add	fp, #48
06a1c     A8 18 02 FB | 	rdlong	local01, fp
06a20     01 18 06 F1 | 	add	local01, #1
06a24     A8 18 62 FC | 	wrlong	local01, fp
06a28     30 50 85 F1 | 	sub	fp, #48
06a2c     B8 FF 9F FD | 	jmp	#LR__0434
06a30                 | LR__0436
06a30                 | LR__0437
06a30     08 50 05 F1 | 	add	fp, #8
06a34     A8 1E 02 FB | 	rdlong	local04, fp
06a38     28 50 05 F1 | 	add	fp, #40
06a3c     A8 18 02 FB | 	rdlong	local01, fp
06a40     30 50 85 F1 | 	sub	fp, #48
06a44     0F 19 62 FC | 	wrlong	local01, local04
06a48     24 96 9F FE | 	loc	pa,	#(@LR__0439-@LR__0438)
06a4c     8C 00 A0 FD | 	call	#FCACHE_LOAD_
06a50                 | ' 	}
06a50                 | ' 	*path = p;
06a50                 | ' #line 2911 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
06a50                 | ' 	while (di) {
06a50                 | LR__0438
06a50     2C 50 05 F1 | 	add	fp, #44
06a54     A8 1E 0A FB | 	rdlong	local04, fp wz
06a58     2C 50 85 F1 | 	sub	fp, #44
06a5c     60 00 90 AD |  if_e	jmp	#LR__0440
06a60     18 50 05 F1 | 	add	fp, #24
06a64     A8 26 02 FB | 	rdlong	local08, fp
06a68     14 50 05 F1 | 	add	fp, #20
06a6c     A8 28 02 FB | 	rdlong	local09, fp
06a70     01 28 86 F1 | 	sub	local09, #1
06a74     01 28 66 F0 | 	shl	local09, #1
06a78     13 29 02 F1 | 	add	local09, local08
06a7c     14 29 E2 FA | 	rdword	local09, local09
06a80     18 50 85 F1 | 	sub	fp, #24
06a84     A8 28 52 FC | 	wrword	local09, fp
06a88     A8 1E E2 FA | 	rdword	local04, fp
06a8c     14 50 85 F1 | 	sub	fp, #20
06a90     20 1E 0E F2 | 	cmp	local04, #32 wz
06a94     14 50 05 51 |  if_ne	add	fp, #20
06a98     A8 18 E2 5A |  if_ne	rdword	local01, fp
06a9c     14 50 85 51 |  if_ne	sub	fp, #20
06aa0     2E 18 0E 52 |  if_ne	cmp	local01, #46 wz
06aa4     18 00 90 5D |  if_ne	jmp	#LR__0440
06aa8     2C 50 05 F1 | 	add	fp, #44
06aac     A8 18 02 FB | 	rdlong	local01, fp
06ab0     01 18 86 F1 | 	sub	local01, #1
06ab4     A8 18 62 FC | 	wrlong	local01, fp
06ab8     2C 50 85 F1 | 	sub	fp, #44
06abc     90 FF 9F FD | 	jmp	#LR__0438
06ac0                 | LR__0439
06ac0                 | LR__0440
06ac0     18 50 05 F1 | 	add	fp, #24
06ac4     A8 2A 02 FB | 	rdlong	local10, fp
06ac8     14 50 05 F1 | 	add	fp, #20
06acc     A8 2C 02 FB | 	rdlong	local11, fp
06ad0     01 2C 66 F0 | 	shl	local11, #1
06ad4     15 2D 02 F1 | 	add	local11, local10
06ad8     16 01 58 FC | 	wrword	#0, local11
06adc     A8 1E 0A FB | 	rdlong	local04, fp wz
06ae0     2C 50 85 F1 | 	sub	fp, #44
06ae4     06 F4 05 A6 |  if_e	mov	result1, #6
06ae8     60 06 90 AD |  if_e	jmp	#LR__0475
06aec                 | ' 
06aec                 | ' 
06aec                 | ' 	for (si = 0; lfn[si] == ' '; si++) ;
06aec     28 50 05 F1 | 	add	fp, #40
06af0     A8 00 68 FC | 	wrlong	#0, fp
06af4     28 50 85 F1 | 	sub	fp, #40
06af8     4C 95 9F FE | 	loc	pa,	#(@LR__0442-@LR__0441)
06afc     8C 00 A0 FD | 	call	#FCACHE_LOAD_
06b00                 | LR__0441
06b00     18 50 05 F1 | 	add	fp, #24
06b04     A8 28 02 FB | 	rdlong	local09, fp
06b08     10 50 05 F1 | 	add	fp, #16
06b0c     A8 26 02 FB | 	rdlong	local08, fp
06b10     28 50 85 F1 | 	sub	fp, #40
06b14     01 26 66 F0 | 	shl	local08, #1
06b18     14 27 02 F1 | 	add	local08, local09
06b1c     13 2F E2 FA | 	rdword	local12, local08
06b20     20 2E 0E F2 | 	cmp	local12, #32 wz
06b24     20 00 90 5D |  if_ne	jmp	#LR__0443
06b28     28 50 05 F1 | 	add	fp, #40
06b2c     A8 22 02 FB | 	rdlong	local06, fp
06b30     11 31 02 F6 | 	mov	local13, local06
06b34     18 21 02 F6 | 	mov	local05, local13
06b38     01 20 06 F1 | 	add	local05, #1
06b3c     A8 20 62 FC | 	wrlong	local05, fp
06b40     28 50 85 F1 | 	sub	fp, #40
06b44     B8 FF 9F FD | 	jmp	#LR__0441
06b48                 | LR__0442
06b48                 | LR__0443
06b48     28 50 05 F1 | 	add	fp, #40
06b4c     A8 2E 02 FB | 	rdlong	local12, fp
06b50     28 50 85 F1 | 	sub	fp, #40
06b54     01 2E 16 F2 | 	cmp	local12, #1 wc
06b58     38 00 90 3D |  if_ae	jmp	#LR__0444
06b5c     18 50 05 F1 | 	add	fp, #24
06b60     A8 2C 02 FB | 	rdlong	local11, fp
06b64     16 1B 02 F6 | 	mov	local02, local11
06b68     10 50 05 F1 | 	add	fp, #16
06b6c     A8 26 02 FB | 	rdlong	local08, fp
06b70     28 50 85 F1 | 	sub	fp, #40
06b74     13 2B 02 F6 | 	mov	local10, local08
06b78     15 29 02 F6 | 	mov	local09, local10
06b7c     01 28 66 F0 | 	shl	local09, #1
06b80     0D 1D 02 F6 | 	mov	local03, local02
06b84     0D 29 02 F1 | 	add	local09, local02
06b88     14 19 E2 FA | 	rdword	local01, local09
06b8c     2E 18 0E F2 | 	cmp	local01, #46 wz
06b90     14 00 90 5D |  if_ne	jmp	#LR__0445
06b94                 | LR__0444
06b94     10 50 05 F1 | 	add	fp, #16
06b98     A8 1E C2 FA | 	rdbyte	local04, fp
06b9c     03 1E 46 F5 | 	or	local04, #3
06ba0     A8 1E 42 FC | 	wrbyte	local04, fp
06ba4     10 50 85 F1 | 	sub	fp, #16
06ba8                 | LR__0445
06ba8     AC 94 9F FE | 	loc	pa,	#(@LR__0447-@LR__0446)
06bac     8C 00 A0 FD | 	call	#FCACHE_LOAD_
06bb0                 | ' 	while (di > 0 && lfn[di - 1] != '.') di--;
06bb0                 | LR__0446
06bb0     2C 50 05 F1 | 	add	fp, #44
06bb4     A8 1E 02 FB | 	rdlong	local04, fp
06bb8     2C 50 85 F1 | 	sub	fp, #44
06bbc     01 1E 16 F2 | 	cmp	local04, #1 wc
06bc0     44 00 90 CD |  if_b	jmp	#LR__0448
06bc4     18 50 05 F1 | 	add	fp, #24
06bc8     A8 22 02 FB | 	rdlong	local06, fp
06bcc     14 50 05 F1 | 	add	fp, #20
06bd0     A8 1C 02 FB | 	rdlong	local03, fp
06bd4     2C 50 85 F1 | 	sub	fp, #44
06bd8     01 1C 86 F1 | 	sub	local03, #1
06bdc     01 1C 66 F0 | 	shl	local03, #1
06be0     11 1D 02 F1 | 	add	local03, local06
06be4     0E 19 E2 FA | 	rdword	local01, local03
06be8     2E 18 0E F2 | 	cmp	local01, #46 wz
06bec     18 00 90 AD |  if_e	jmp	#LR__0448
06bf0     2C 50 05 F1 | 	add	fp, #44
06bf4     A8 18 02 FB | 	rdlong	local01, fp
06bf8     01 18 86 F1 | 	sub	local01, #1
06bfc     A8 18 62 FC | 	wrlong	local01, fp
06c00     2C 50 85 F1 | 	sub	fp, #44
06c04     A8 FF 9F FD | 	jmp	#LR__0446
06c08                 | LR__0447
06c08                 | LR__0448
06c08     04 50 05 F1 | 	add	fp, #4
06c0c     A8 0E 02 FB | 	rdlong	arg01, fp
06c10     04 50 85 F1 | 	sub	fp, #4
06c14     20 0E 06 F1 | 	add	arg01, #32
06c18     20 10 06 F6 | 	mov	arg02, #32
06c1c     0B 12 06 F6 | 	mov	arg03, #11
06c20                 | ' {
06c20                 | ' 	BYTE *d = (BYTE*)dst;
06c20                 | ' 
06c20                 | ' 	do {
06c20     E8 93 9F FE | 	loc	pa,	#(@LR__0451-@LR__0449)
06c24     8C 00 A0 FD | 	call	#FCACHE_LOAD_
06c28                 | LR__0449
06c28     0B 04 DC FC | 	rep	@LR__0452, #11
06c2c                 | LR__0450
06c2c     07 11 42 FC | 	wrbyte	arg02, arg01
06c30     01 0E 06 F1 | 	add	arg01, #1
06c34                 | LR__0451
06c34                 | LR__0452
06c34     0C 50 05 F1 | 	add	fp, #12
06c38     A8 00 48 FC | 	wrbyte	#0, fp
06c3c     A8 1E C2 FA | 	rdbyte	local04, fp
06c40     14 50 05 F1 | 	add	fp, #20
06c44     A8 1E 62 FC | 	wrlong	local04, fp
06c48     04 50 05 F1 | 	add	fp, #4
06c4c     A8 10 68 FC | 	wrlong	#8, fp
06c50     24 50 85 F1 | 	sub	fp, #36
06c54                 | ' 
06c54                 | ' 	mem_set(dp->fn, ' ', 11);
06c54                 | ' 	i = b = 0; ni = 8;
06c54                 | ' 	for (;;) {
06c54                 | LR__0453
06c54     18 50 05 F1 | 	add	fp, #24
06c58     A8 1C 02 FB | 	rdlong	local03, fp
06c5c     10 50 05 F1 | 	add	fp, #16
06c60     A8 28 02 FB | 	rdlong	local09, fp
06c64     14 2D 02 F6 | 	mov	local11, local09
06c68     01 2C 06 F1 | 	add	local11, #1
06c6c     A8 2C 62 FC | 	wrlong	local11, fp
06c70     01 28 66 F0 | 	shl	local09, #1
06c74     0E 29 02 F1 | 	add	local09, local03
06c78     14 23 E2 FA | 	rdword	local06, local09
06c7c     14 50 85 F1 | 	sub	fp, #20
06c80     A8 22 52 FC | 	wrword	local06, fp
06c84     A8 1E E2 FA | 	rdword	local04, fp
06c88     14 50 85 F1 | 	sub	fp, #20
06c8c     0F 1E 4E F7 | 	zerox	local04, #15 wz
06c90     A8 03 90 AD |  if_e	jmp	#LR__0471
06c94     14 50 05 F1 | 	add	fp, #20
06c98     A8 1E E2 FA | 	rdword	local04, fp
06c9c     14 50 85 F1 | 	sub	fp, #20
06ca0     20 1E 0E F2 | 	cmp	local04, #32 wz
06ca4     30 00 90 AD |  if_e	jmp	#LR__0454
06ca8     14 50 05 F1 | 	add	fp, #20
06cac     A8 18 E2 FA | 	rdword	local01, fp
06cb0     14 50 85 F1 | 	sub	fp, #20
06cb4     2E 18 0E F2 | 	cmp	local01, #46 wz
06cb8     34 00 90 5D |  if_ne	jmp	#LR__0455
06cbc     28 50 05 F1 | 	add	fp, #40
06cc0     A8 2A 02 FB | 	rdlong	local10, fp
06cc4     04 50 05 F1 | 	add	fp, #4
06cc8     A8 26 02 FB | 	rdlong	local08, fp
06ccc     2C 50 85 F1 | 	sub	fp, #44
06cd0     13 2B 0A F2 | 	cmp	local10, local08 wz
06cd4     18 00 90 AD |  if_e	jmp	#LR__0455
06cd8                 | LR__0454
06cd8     10 50 05 F1 | 	add	fp, #16
06cdc     A8 1E C2 FA | 	rdbyte	local04, fp
06ce0     03 1E 46 F5 | 	or	local04, #3
06ce4     A8 1E 42 FC | 	wrbyte	local04, fp
06ce8     10 50 85 F1 | 	sub	fp, #16
06cec                 | ' 			cf |=  0x01  |  0x02 ;
06cec                 | ' 			continue;
06cec     64 FF 9F FD | 	jmp	#LR__0453
06cf0                 | LR__0455
06cf0     20 50 05 F1 | 	add	fp, #32
06cf4     A8 2E 02 FB | 	rdlong	local12, fp
06cf8     17 1F 02 F6 | 	mov	local04, local12
06cfc     04 50 05 F1 | 	add	fp, #4
06d00     A8 1A 02 FB | 	rdlong	local02, fp
06d04     24 50 85 F1 | 	sub	fp, #36
06d08     0D 1F 12 F2 | 	cmp	local04, local02 wc
06d0c     20 00 90 3D |  if_ae	jmp	#LR__0456
06d10     28 50 05 F1 | 	add	fp, #40
06d14     A8 2A 02 FB | 	rdlong	local10, fp
06d18     04 50 05 F1 | 	add	fp, #4
06d1c     A8 28 02 FB | 	rdlong	local09, fp
06d20     2C 50 85 F1 | 	sub	fp, #44
06d24     14 27 02 F6 | 	mov	local08, local09
06d28     13 2B 0A F2 | 	cmp	local10, local08 wz
06d2c     AC 00 90 5D |  if_ne	jmp	#LR__0458
06d30                 | LR__0456
06d30     24 50 05 F1 | 	add	fp, #36
06d34     A8 1E 02 FB | 	rdlong	local04, fp
06d38     24 50 85 F1 | 	sub	fp, #36
06d3c     0B 1E 0E F2 | 	cmp	local04, #11 wz
06d40     18 00 90 5D |  if_ne	jmp	#LR__0457
06d44     10 50 05 F1 | 	add	fp, #16
06d48     A8 1E C2 FA | 	rdbyte	local04, fp
06d4c     03 1E 46 F5 | 	or	local04, #3
06d50     A8 1E 42 FC | 	wrbyte	local04, fp
06d54     10 50 85 F1 | 	sub	fp, #16
06d58                 | ' 				cf |=  0x01  |  0x02 ;
06d58                 | ' 				break;
06d58     E0 02 90 FD | 	jmp	#LR__0471
06d5c                 | LR__0457
06d5c     28 50 05 F1 | 	add	fp, #40
06d60     A8 1E 02 FB | 	rdlong	local04, fp
06d64     04 50 05 F1 | 	add	fp, #4
06d68     A8 18 02 FB | 	rdlong	local01, fp
06d6c     2C 50 85 F1 | 	sub	fp, #44
06d70     0C 1F 0A F2 | 	cmp	local04, local01 wz
06d74     10 50 05 51 |  if_ne	add	fp, #16
06d78     A8 1E C2 5A |  if_ne	rdbyte	local04, fp
06d7c     03 1E 46 55 |  if_ne	or	local04, #3
06d80     A8 1E 42 5C |  if_ne	wrbyte	local04, fp
06d84     10 50 85 51 |  if_ne	sub	fp, #16
06d88     28 50 05 F1 | 	add	fp, #40
06d8c     A8 1E 02 FB | 	rdlong	local04, fp
06d90     04 50 05 F1 | 	add	fp, #4
06d94     A8 18 02 FB | 	rdlong	local01, fp
06d98     2C 50 85 F1 | 	sub	fp, #44
06d9c     0C 1F 1A F2 | 	cmp	local04, local01 wcz
06da0     98 02 90 1D |  if_a	jmp	#LR__0471
06da4     2C 50 05 F1 | 	add	fp, #44
06da8     A8 1E 02 FB | 	rdlong	local04, fp
06dac     04 50 85 F1 | 	sub	fp, #4
06db0     A8 1E 62 FC | 	wrlong	local04, fp
06db4     08 50 85 F1 | 	sub	fp, #8
06db8     A8 10 68 FC | 	wrlong	#8, fp
06dbc     04 50 05 F1 | 	add	fp, #4
06dc0     A8 16 68 FC | 	wrlong	#11, fp
06dc4     18 50 85 F1 | 	sub	fp, #24
06dc8     A8 1E C2 FA | 	rdbyte	local04, fp
06dcc     02 1E 66 F0 | 	shl	local04, #2
06dd0     A8 1E 42 FC | 	wrbyte	local04, fp
06dd4     0C 50 85 F1 | 	sub	fp, #12
06dd8                 | ' 			si = di; i = 8; ni = 11; b <<= 2;
06dd8                 | ' 			continue;
06dd8     78 FE 9F FD | 	jmp	#LR__0453
06ddc                 | LR__0458
06ddc     14 50 05 F1 | 	add	fp, #20
06de0     A8 1E E2 FA | 	rdword	local04, fp
06de4     14 50 85 F1 | 	sub	fp, #20
06de8     80 1E 16 F2 | 	cmp	local04, #128 wc
06dec     6C 00 90 CD |  if_b	jmp	#LR__0460
06df0     10 50 05 F1 | 	add	fp, #16
06df4     A8 1E C2 FA | 	rdbyte	local04, fp
06df8     02 1E 46 F5 | 	or	local04, #2
06dfc     A8 1E 42 FC | 	wrbyte	local04, fp
06e00     04 50 05 F1 | 	add	fp, #4
06e04     A8 0E E2 FA | 	rdword	arg01, fp
06e08     14 50 85 F1 | 	sub	fp, #20
06e0c     01 00 00 FF 
06e10     52 11 06 F6 | 	mov	arg02, ##850
06e14     08 C9 BF FD | 	call	#_ff_cc_ff_uni2oem
06e18     14 50 05 F1 | 	add	fp, #20
06e1c     A8 F4 51 FC | 	wrword	result1, fp
06e20     A8 1E E2 FA | 	rdword	local04, fp
06e24     14 50 85 F1 | 	sub	fp, #20
06e28     80 1E CE F7 | 	test	local04, #128 wz
06e2c     2C 00 90 AD |  if_e	jmp	#LR__0459
06e30     14 50 05 F1 | 	add	fp, #20
06e34     A8 1A E2 FA | 	rdword	local02, fp
06e38     7F 1A 06 F5 | 	and	local02, #127
06e3c     01 00 00 FF 
06e40     14 F0 05 F1 | 	add	ptr__ff_cc_dat__, ##532
06e44     F8 1A 02 F1 | 	add	local02, ptr__ff_cc_dat__
06e48     0D 1F C2 FA | 	rdbyte	local04, local02
06e4c     A8 1E 52 FC | 	wrword	local04, fp
06e50     14 50 85 F1 | 	sub	fp, #20
06e54     01 00 00 FF 
06e58     14 F0 85 F1 | 	sub	ptr__ff_cc_dat__, ##532
06e5c                 | LR__0459
06e5c                 | LR__0460
06e5c     14 50 05 F1 | 	add	fp, #20
06e60     A8 1E E2 FA | 	rdword	local04, fp
06e64     14 50 85 F1 | 	sub	fp, #20
06e68     00 1F 16 F2 | 	cmp	local04, #256 wc
06e6c     84 00 90 CD |  if_b	jmp	#LR__0462
06e70     24 50 05 F1 | 	add	fp, #36
06e74     A8 1E 02 FB | 	rdlong	local04, fp
06e78     01 1E 86 F1 | 	sub	local04, #1
06e7c     04 50 85 F1 | 	sub	fp, #4
06e80     A8 18 02 FB | 	rdlong	local01, fp
06e84     20 50 85 F1 | 	sub	fp, #32
06e88     0F 19 12 F2 | 	cmp	local01, local04 wc
06e8c     28 00 90 CD |  if_b	jmp	#LR__0461
06e90     10 50 05 F1 | 	add	fp, #16
06e94     A8 1E C2 FA | 	rdbyte	local04, fp
06e98     03 1E 46 F5 | 	or	local04, #3
06e9c     A8 1E 42 FC | 	wrbyte	local04, fp
06ea0     14 50 05 F1 | 	add	fp, #20
06ea4     A8 1E 02 FB | 	rdlong	local04, fp
06ea8     04 50 85 F1 | 	sub	fp, #4
06eac     A8 1E 62 FC | 	wrlong	local04, fp
06eb0     20 50 85 F1 | 	sub	fp, #32
06eb4                 | ' 				cf |=  0x01  |  0x02 ;
06eb4                 | ' 				i = ni; continue;
06eb4     9C FD 9F FD | 	jmp	#LR__0453
06eb8                 | LR__0461
06eb8     04 50 05 F1 | 	add	fp, #4
06ebc     A8 28 02 FB | 	rdlong	local09, fp
06ec0     1C 50 05 F1 | 	add	fp, #28
06ec4     A8 26 02 FB | 	rdlong	local08, fp
06ec8     13 2D 02 F6 | 	mov	local11, local08
06ecc     01 2C 06 F1 | 	add	local11, #1
06ed0     A8 2C 62 FC | 	wrlong	local11, fp
06ed4     20 28 06 F1 | 	add	local09, #32
06ed8     14 27 02 F1 | 	add	local08, local09
06edc     0C 50 85 F1 | 	sub	fp, #12
06ee0     A8 1C E2 FA | 	rdword	local03, fp
06ee4     14 50 85 F1 | 	sub	fp, #20
06ee8     08 1C 46 F0 | 	shr	local03, #8
06eec     13 1D 42 FC | 	wrbyte	local03, local08
06ef0     10 01 90 FD | 	jmp	#LR__0470
06ef4                 | LR__0462
06ef4     14 50 05 F1 | 	add	fp, #20
06ef8     A8 1E E2 FA | 	rdword	local04, fp
06efc     14 50 85 F1 | 	sub	fp, #20
06f00     0F 1E 4E F7 | 	zerox	local04, #15 wz
06f04     44 00 90 AD |  if_e	jmp	#LR__0465
06f08     5D 00 00 FF 
06f0c     F3 0E 06 F6 | 	mov	arg01, ##@LR__0738
06f10     14 50 05 F1 | 	add	fp, #20
06f14     A8 2A E2 FA | 	rdword	local10, fp
06f18     14 50 85 F1 | 	sub	fp, #20
06f1c     15 2D 32 F9 | 	getword	local11, local10, #0
06f20     16 11 02 F6 | 	mov	arg02, local11
06f24     EC 90 9F FE | 	loc	pa,	#(@LR__0464-@LR__0463)
06f28     8C 00 A0 FD | 	call	#FCACHE_LOAD_
06f2c                 | ' {
06f2c                 | ' 	while (*str && *str != chr) str++;
06f2c                 | LR__0463
06f2c     07 F5 C9 FA | 	rdbyte	result1, arg01 wz
06f30     07 25 C2 5A |  if_ne	rdbyte	local07, arg01
06f34     08 25 0A 52 |  if_ne	cmp	local07, arg02 wz
06f38     01 0E 06 51 |  if_ne	add	arg01, #1
06f3c     EC FF 9F 5D |  if_ne	jmp	#LR__0463
06f40                 | LR__0464
06f40                 | ' 	return *str;
06f40     07 F5 C1 FA | 	rdbyte	result1, arg01
06f44     FA 18 0A F6 | 	mov	local01, result1 wz
06f48     20 00 90 AD |  if_e	jmp	#LR__0466
06f4c                 | LR__0465
06f4c     14 50 05 F1 | 	add	fp, #20
06f50     A8 BE 58 FC | 	wrword	#95, fp
06f54     04 50 85 F1 | 	sub	fp, #4
06f58     A8 1E C2 FA | 	rdbyte	local04, fp
06f5c     03 1E 46 F5 | 	or	local04, #3
06f60     A8 1E 42 FC | 	wrbyte	local04, fp
06f64     10 50 85 F1 | 	sub	fp, #16
06f68     98 00 90 FD | 	jmp	#LR__0469
06f6c                 | LR__0466
06f6c     14 50 05 F1 | 	add	fp, #20
06f70     A8 1E E2 FA | 	rdword	local04, fp
06f74     14 50 85 F1 | 	sub	fp, #20
06f78     41 1E 16 F2 | 	cmp	local04, #65 wc
06f7c     30 00 90 CD |  if_b	jmp	#LR__0467
06f80     14 50 05 F1 | 	add	fp, #20
06f84     A8 1A E2 FA | 	rdword	local02, fp
06f88     14 50 85 F1 | 	sub	fp, #20
06f8c     0D 19 32 F9 | 	getword	local01, local02, #0
06f90     5B 18 16 F2 | 	cmp	local01, #91 wc
06f94     18 00 90 3D |  if_ae	jmp	#LR__0467
06f98     0C 50 05 F1 | 	add	fp, #12
06f9c     A8 2E C2 FA | 	rdbyte	local12, fp
06fa0     17 1F E2 F8 | 	getbyte	local04, local12, #0
06fa4     02 1E 46 F5 | 	or	local04, #2
06fa8     A8 1E 42 FC | 	wrbyte	local04, fp
06fac     0C 50 85 F1 | 	sub	fp, #12
06fb0                 | LR__0467
06fb0     14 50 05 F1 | 	add	fp, #20
06fb4     A8 1E E2 FA | 	rdword	local04, fp
06fb8     14 50 85 F1 | 	sub	fp, #20
06fbc     61 1E 16 F2 | 	cmp	local04, #97 wc
06fc0     40 00 90 CD |  if_b	jmp	#LR__0468
06fc4     14 50 05 F1 | 	add	fp, #20
06fc8     A8 1A E2 FA | 	rdword	local02, fp
06fcc     14 50 85 F1 | 	sub	fp, #20
06fd0     0D 19 32 F9 | 	getword	local01, local02, #0
06fd4     7B 18 16 F2 | 	cmp	local01, #123 wc
06fd8     28 00 90 3D |  if_ae	jmp	#LR__0468
06fdc     0C 50 05 F1 | 	add	fp, #12
06fe0     A8 1E C2 FA | 	rdbyte	local04, fp
06fe4     01 1E 46 F5 | 	or	local04, #1
06fe8     A8 1E 42 FC | 	wrbyte	local04, fp
06fec     08 50 05 F1 | 	add	fp, #8
06ff0     A8 2E E2 FA | 	rdword	local12, fp
06ff4     17 1F 32 F9 | 	getword	local04, local12, #0
06ff8     20 1E 86 F1 | 	sub	local04, #32
06ffc     A8 1E 52 FC | 	wrword	local04, fp
07000     14 50 85 F1 | 	sub	fp, #20
07004                 | LR__0468
07004                 | LR__0469
07004                 | LR__0470
07004     04 50 05 F1 | 	add	fp, #4
07008     A8 28 02 FB | 	rdlong	local09, fp
0700c     1C 50 05 F1 | 	add	fp, #28
07010     A8 2C 02 FB | 	rdlong	local11, fp
07014     16 27 02 F6 | 	mov	local08, local11
07018     01 2C 06 F1 | 	add	local11, #1
0701c     A8 2C 62 FC | 	wrlong	local11, fp
07020     20 28 06 F1 | 	add	local09, #32
07024     14 27 02 F1 | 	add	local08, local09
07028     0C 50 85 F1 | 	sub	fp, #12
0702c     A8 1C E2 FA | 	rdword	local03, fp
07030     14 50 85 F1 | 	sub	fp, #20
07034     13 1D 42 FC | 	wrbyte	local03, local08
07038     18 FC 9F FD | 	jmp	#LR__0453
0703c                 | LR__0471
0703c     04 50 05 F1 | 	add	fp, #4
07040     A8 2E 02 FB | 	rdlong	local12, fp
07044     04 50 85 F1 | 	sub	fp, #4
07048     20 2E 06 F1 | 	add	local12, #32
0704c     17 1F C2 FA | 	rdbyte	local04, local12
07050     E5 1E 0E F2 | 	cmp	local04, #229 wz
07054     04 50 05 A1 |  if_e	add	fp, #4
07058     A8 1E 02 AB |  if_e	rdlong	local04, fp
0705c     04 50 85 A1 |  if_e	sub	fp, #4
07060     20 1E 06 A1 |  if_e	add	local04, #32
07064     0F 0B 48 AC |  if_e	wrbyte	#5, local04
07068     24 50 05 F1 | 	add	fp, #36
0706c     A8 1E 02 FB | 	rdlong	local04, fp
07070     24 50 85 F1 | 	sub	fp, #36
07074     08 1E 0E F2 | 	cmp	local04, #8 wz
07078     0C 50 05 A1 |  if_e	add	fp, #12
0707c     A8 1E C2 AA |  if_e	rdbyte	local04, fp
07080     02 1E 66 A0 |  if_e	shl	local04, #2
07084     A8 1E 42 AC |  if_e	wrbyte	local04, fp
07088     0C 50 85 A1 |  if_e	sub	fp, #12
0708c     0C 50 05 F1 | 	add	fp, #12
07090     A8 1E C2 FA | 	rdbyte	local04, fp
07094     0C 50 85 F1 | 	sub	fp, #12
07098     0C 1E 06 F5 | 	and	local04, #12
0709c     0C 1E 0E F2 | 	cmp	local04, #12 wz
070a0     18 00 90 AD |  if_e	jmp	#LR__0472
070a4     0C 50 05 F1 | 	add	fp, #12
070a8     A8 18 C2 FA | 	rdbyte	local01, fp
070ac     0C 50 85 F1 | 	sub	fp, #12
070b0     03 18 06 F5 | 	and	local01, #3
070b4     03 18 0E F2 | 	cmp	local01, #3 wz
070b8     14 00 90 5D |  if_ne	jmp	#LR__0473
070bc                 | LR__0472
070bc     10 50 05 F1 | 	add	fp, #16
070c0     A8 1E C2 FA | 	rdbyte	local04, fp
070c4     02 1E 46 F5 | 	or	local04, #2
070c8     A8 1E 42 FC | 	wrbyte	local04, fp
070cc     10 50 85 F1 | 	sub	fp, #16
070d0                 | LR__0473
070d0     10 50 05 F1 | 	add	fp, #16
070d4     A8 1E C2 FA | 	rdbyte	local04, fp
070d8     10 50 85 F1 | 	sub	fp, #16
070dc     02 1E CE F7 | 	test	local04, #2 wz
070e0     48 00 90 5D |  if_ne	jmp	#LR__0474
070e4     0C 50 05 F1 | 	add	fp, #12
070e8     A8 1E C2 FA | 	rdbyte	local04, fp
070ec     0C 50 85 F1 | 	sub	fp, #12
070f0     01 1E CE F7 | 	test	local04, #1 wz
070f4     10 50 05 51 |  if_ne	add	fp, #16
070f8     A8 1E C2 5A |  if_ne	rdbyte	local04, fp
070fc     10 1E 46 55 |  if_ne	or	local04, #16
07100     A8 1E 42 5C |  if_ne	wrbyte	local04, fp
07104     10 50 85 51 |  if_ne	sub	fp, #16
07108     0C 50 05 F1 | 	add	fp, #12
0710c     A8 1E C2 FA | 	rdbyte	local04, fp
07110     0C 50 85 F1 | 	sub	fp, #12
07114     04 1E CE F7 | 	test	local04, #4 wz
07118     10 50 05 51 |  if_ne	add	fp, #16
0711c     A8 1E C2 5A |  if_ne	rdbyte	local04, fp
07120     08 1E 46 55 |  if_ne	or	local04, #8
07124     A8 1E 42 5C |  if_ne	wrbyte	local04, fp
07128     10 50 85 51 |  if_ne	sub	fp, #16
0712c                 | LR__0474
0712c     04 50 05 F1 | 	add	fp, #4
07130     A8 1E 02 FB | 	rdlong	local04, fp
07134     0C 50 05 F1 | 	add	fp, #12
07138     A8 18 C2 FA | 	rdbyte	local01, fp
0713c     10 50 85 F1 | 	sub	fp, #16
07140     2B 1E 06 F1 | 	add	local04, #43
07144     0F 19 42 FC | 	wrbyte	local01, local04
07148                 | ' 	}
07148                 | ' 
07148                 | ' 	dp->fn[ 11 ] = cf;
07148                 | ' 
07148                 | ' 	return FR_OK;
07148     00 F4 05 F6 | 	mov	result1, #0
0714c                 | LR__0475
0714c     A8 F0 03 F6 | 	mov	ptra, fp
07150     B3 00 A0 FD | 	call	#popregs_
07154                 | _ff_cc_create_name_0328_ret
07154     2D 00 64 FD | 	ret
07158                 | 
07158                 | _ff_cc_follow_path_0332
07158     04 4C 05 F6 | 	mov	COUNT_, #4
0715c     A9 00 A0 FD | 	call	#pushregs_
07160     18 F0 07 F1 | 	add	ptra, #24
07164     04 50 05 F1 | 	add	fp, #4
07168     A8 0E 62 FC | 	wrlong	arg01, fp
0716c     04 50 05 F1 | 	add	fp, #4
07170     A8 10 62 FC | 	wrlong	arg02, fp
07174     04 50 85 F1 | 	sub	fp, #4
07178     A8 F4 01 FB | 	rdlong	result1, fp
0717c     FA 18 02 FB | 	rdlong	local01, result1
07180     10 50 05 F1 | 	add	fp, #16
07184     A8 18 62 FC | 	wrlong	local01, fp
07188     14 50 85 F1 | 	sub	fp, #20
0718c     B8 8E 9F FE | 	loc	pa,	#(@LR__0478-@LR__0476)
07190     8C 00 A0 FD | 	call	#FCACHE_LOAD_
07194                 | ' )
07194                 | ' {
07194                 | ' 	FRESULT res;
07194                 | ' 	BYTE ns;
07194                 | ' 	FATFS *fs = dp->obj.fs;
07194                 | ' #line 3083 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
07194                 | ' 	{
07194                 | ' 		while (*path == '/' || *path == '\\') path++;
07194                 | LR__0476
07194     08 50 05 F1 | 	add	fp, #8
07198     A8 18 02 FB | 	rdlong	local01, fp
0719c     08 50 85 F1 | 	sub	fp, #8
071a0     0C 19 C2 FA | 	rdbyte	local01, local01
071a4     2F 18 0E F2 | 	cmp	local01, #47 wz
071a8     18 00 90 AD |  if_e	jmp	#LR__0477
071ac     08 50 05 F1 | 	add	fp, #8
071b0     A8 18 02 FB | 	rdlong	local01, fp
071b4     08 50 85 F1 | 	sub	fp, #8
071b8     0C 19 C2 FA | 	rdbyte	local01, local01
071bc     5C 18 0E F2 | 	cmp	local01, #92 wz
071c0     18 00 90 5D |  if_ne	jmp	#LR__0479
071c4                 | LR__0477
071c4     08 50 05 F1 | 	add	fp, #8
071c8     A8 18 02 FB | 	rdlong	local01, fp
071cc     01 18 06 F1 | 	add	local01, #1
071d0     A8 18 62 FC | 	wrlong	local01, fp
071d4     08 50 85 F1 | 	sub	fp, #8
071d8     B8 FF 9F FD | 	jmp	#LR__0476
071dc                 | LR__0478
071dc                 | LR__0479
071dc     04 50 05 F1 | 	add	fp, #4
071e0     A8 18 02 FB | 	rdlong	local01, fp
071e4     08 18 06 F1 | 	add	local01, #8
071e8     0C 01 68 FC | 	wrlong	#0, local01
071ec     04 50 05 F1 | 	add	fp, #4
071f0     A8 18 02 FB | 	rdlong	local01, fp
071f4     08 50 85 F1 | 	sub	fp, #8
071f8     0C 19 C2 FA | 	rdbyte	local01, local01
071fc     20 18 16 F2 | 	cmp	local01, #32 wc
07200     30 00 90 3D |  if_ae	jmp	#LR__0480
07204     04 50 05 F1 | 	add	fp, #4
07208     A8 18 02 FB | 	rdlong	local01, fp
0720c     2B 18 06 F1 | 	add	local01, #43
07210     0C 01 49 FC | 	wrbyte	#128, local01
07214     A8 0E 02 FB | 	rdlong	arg01, fp
07218     04 50 85 F1 | 	sub	fp, #4
0721c     00 10 06 F6 | 	mov	arg02, #0
07220     C4 DE BF FD | 	call	#_ff_cc_dir_sdi_0249
07224     0C 50 05 F1 | 	add	fp, #12
07228     A8 F4 61 FC | 	wrlong	result1, fp
0722c     0C 50 85 F1 | 	sub	fp, #12
07230     1C 01 90 FD | 	jmp	#LR__0484
07234                 | LR__0480
07234                 | ' 		for (;;) {
07234                 | LR__0481
07234     04 50 05 F1 | 	add	fp, #4
07238     A8 0E 02 FB | 	rdlong	arg01, fp
0723c     04 50 05 F1 | 	add	fp, #4
07240     A8 10 02 F6 | 	mov	arg02, fp
07244     08 50 85 F1 | 	sub	fp, #8
07248     AC F5 BF FD | 	call	#_ff_cc_create_name_0328
0724c     0C 50 05 F1 | 	add	fp, #12
07250     A8 F4 61 FC | 	wrlong	result1, fp
07254     FA 18 0A F6 | 	mov	local01, result1 wz
07258     0C 50 85 F1 | 	sub	fp, #12
0725c     F0 00 90 5D |  if_ne	jmp	#LR__0483
07260     04 50 05 F1 | 	add	fp, #4
07264     A8 0E 02 FB | 	rdlong	arg01, fp
07268     04 50 85 F1 | 	sub	fp, #4
0726c     04 EA BF FD | 	call	#_ff_cc_dir_find_0298
07270     0C 50 05 F1 | 	add	fp, #12
07274     A8 F4 61 FC | 	wrlong	result1, fp
07278     08 50 85 F1 | 	sub	fp, #8
0727c     A8 18 02 FB | 	rdlong	local01, fp
07280     2B 18 06 F1 | 	add	local01, #43
07284     0C 19 C2 FA | 	rdbyte	local01, local01
07288     0C 50 05 F1 | 	add	fp, #12
0728c     A8 18 42 FC | 	wrbyte	local01, fp
07290     04 50 85 F1 | 	sub	fp, #4
07294     A8 18 0A FB | 	rdlong	local01, fp wz
07298     0C 50 85 F1 | 	sub	fp, #12
0729c     34 00 90 AD |  if_e	jmp	#LR__0482
072a0     0C 50 05 F1 | 	add	fp, #12
072a4     A8 18 02 FB | 	rdlong	local01, fp
072a8     0C 50 85 F1 | 	sub	fp, #12
072ac     04 18 0E F2 | 	cmp	local01, #4 wz
072b0     9C 00 90 5D |  if_ne	jmp	#LR__0483
072b4     10 50 05 F1 | 	add	fp, #16
072b8     A8 18 C2 FA | 	rdbyte	local01, fp
072bc     10 50 85 F1 | 	sub	fp, #16
072c0     04 18 CE F7 | 	test	local01, #4 wz
072c4     0C 50 05 A1 |  if_e	add	fp, #12
072c8     A8 0A 68 AC |  if_e	wrlong	#5, fp
072cc     0C 50 85 A1 |  if_e	sub	fp, #12
072d0                 | ' 					}
072d0                 | ' 				}
072d0                 | ' 				break;
072d0     7C 00 90 FD | 	jmp	#LR__0483
072d4                 | LR__0482
072d4     10 50 05 F1 | 	add	fp, #16
072d8     A8 18 C2 FA | 	rdbyte	local01, fp
072dc     10 50 85 F1 | 	sub	fp, #16
072e0     04 18 CE F7 | 	test	local01, #4 wz
072e4     68 00 90 5D |  if_ne	jmp	#LR__0483
072e8     04 50 05 F1 | 	add	fp, #4
072ec     A8 10 02 FB | 	rdlong	arg02, fp
072f0     04 50 85 F1 | 	sub	fp, #4
072f4     06 10 06 F1 | 	add	arg02, #6
072f8     08 11 C2 FA | 	rdbyte	arg02, arg02
072fc     10 10 CE F7 | 	test	arg02, #16 wz
07300     0C 50 05 A1 |  if_e	add	fp, #12
07304     A8 0A 68 AC |  if_e	wrlong	#5, fp
07308     0C 50 85 A1 |  if_e	sub	fp, #12
0730c                 | ' #line 3140 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
0730c                 | ' 				res = FR_NO_PATH; break;
0730c     40 00 90 AD |  if_e	jmp	#LR__0483
07310     04 50 05 F1 | 	add	fp, #4
07314     A8 1A 02 FB | 	rdlong	local02, fp
07318     0D 1D 02 F6 | 	mov	local03, local02
0731c     10 50 05 F1 | 	add	fp, #16
07320     A8 10 02 FB | 	rdlong	arg02, fp
07324     08 0F 02 F6 | 	mov	arg01, arg02
07328     34 10 06 F1 | 	add	arg02, #52
0732c     14 50 85 F1 | 	sub	fp, #20
07330     10 1A 06 F1 | 	add	local02, #16
07334     0D 1F 02 FB | 	rdlong	local04, local02
07338     FF 1F 06 F5 | 	and	local04, #511
0733c     0F 11 02 F1 | 	add	arg02, local04
07340     9C E1 BF FD | 	call	#_ff_cc_ld_clust_0259
07344     08 1C 06 F1 | 	add	local03, #8
07348     0E F5 61 FC | 	wrlong	result1, local03
0734c     E4 FE 9F FD | 	jmp	#LR__0481
07350                 | LR__0483
07350                 | LR__0484
07350                 | ' 			}
07350                 | ' #line 3150 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
07350                 | ' 			{
07350                 | ' 				dp->obj.sclust = ld_clust(fs, fs->win + dp->dptr %  ((UINT) 512 ) );
07350                 | ' 			}
07350                 | ' 		}
07350                 | ' 	}
07350                 | ' 
07350                 | ' 	return res;
07350     0C 50 05 F1 | 	add	fp, #12
07354     A8 F4 01 FB | 	rdlong	result1, fp
07358     0C 50 85 F1 | 	sub	fp, #12
0735c     A8 F0 03 F6 | 	mov	ptra, fp
07360     B3 00 A0 FD | 	call	#popregs_
07364                 | _ff_cc_follow_path_0332_ret
07364     2D 00 64 FD | 	ret
07368                 | 
07368                 | _ff_cc_get_ldnumber_0338
07368     07 F9 01 F6 | 	mov	_var01, arg01
0736c     01 FA 65 F6 | 	neg	_var02, #1
07370     FC FC 09 FB | 	rdlong	_var03, _var01 wz
07374     FE FE 01 F6 | 	mov	_var04, _var03
07378     01 F4 65 A6 |  if_e	neg	result1, #1
0737c     80 00 90 AD |  if_e	jmp	#_ff_cc_get_ldnumber_0338_ret
07380     9C 8C 9F FE | 	loc	pa,	#(@LR__0486-@LR__0485)
07384     8C 00 A0 FD | 	call	#FCACHE_LOAD_
07388                 | ' 	do tc = *tt++; while ((UINT)tc >= ( 1  ? ' ' : '!') && tc != ':');
07388                 | LR__0485
07388     FF 00 C2 FA | 	rdbyte	_var05, _var04
0738c     00 03 E2 F8 | 	getbyte	_var06, _var05, #0
07390     20 02 16 F2 | 	cmp	_var06, #32 wc
07394     01 FE 05 F1 | 	add	_var04, #1
07398     00 05 02 36 |  if_ae	mov	_var07, _var05
0739c     02 05 E2 38 |  if_ae	getbyte	_var07, _var07, #0
073a0     3A 04 0E 32 |  if_ae	cmp	_var07, #58 wz
073a4     E0 FF 9F 1D |  if_a	jmp	#LR__0485
073a8                 | LR__0486
073a8     00 03 E2 F8 | 	getbyte	_var06, _var05, #0
073ac     3A 02 0E F2 | 	cmp	_var06, #58 wz
073b0     48 00 90 5D |  if_ne	jmp	#LR__0488
073b4     01 06 06 F6 | 	mov	_var08, #1
073b8     FE 02 C2 FA | 	rdbyte	_var06, _var03
073bc     30 02 16 F2 | 	cmp	_var06, #48 wc
073c0     24 00 90 CD |  if_b	jmp	#LR__0487
073c4     FE 04 C2 FA | 	rdbyte	_var07, _var03
073c8     3A 04 16 F2 | 	cmp	_var07, #58 wc
073cc     18 00 90 3D |  if_ae	jmp	#LR__0487
073d0     FE 08 02 F6 | 	mov	_var09, _var03
073d4     02 08 06 F1 | 	add	_var09, #2
073d8     FF 08 0A F2 | 	cmp	_var09, _var04 wz
073dc     FE 02 C2 AA |  if_e	rdbyte	_var06, _var03
073e0     30 02 86 A1 |  if_e	sub	_var06, #48
073e4     01 07 02 A6 |  if_e	mov	_var08, _var06
073e8                 | LR__0487
073e8     01 06 56 F2 | 	cmps	_var08, #1 wc
073ec     03 FB 01 C6 |  if_b	mov	_var02, _var08
073f0     FC FE 61 CC |  if_b	wrlong	_var04, _var01
073f4                 | ' 			vol = i;
073f4                 | ' 			*path = tt;
073f4                 | ' 		}
073f4                 | ' 		return vol;
073f4     FD F4 01 F6 | 	mov	result1, _var02
073f8     04 00 90 FD | 	jmp	#_ff_cc_get_ldnumber_0338_ret
073fc                 | LR__0488
073fc                 | ' 	}
073fc                 | ' #line 3228 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
073fc                 | ' 	vol = 0;
073fc                 | ' 
073fc                 | ' 	return vol;
073fc     00 F4 05 F6 | 	mov	result1, #0
07400                 | _ff_cc_get_ldnumber_0338_ret
07400     2D 00 64 FD | 	ret
07404                 | 
07404                 | _ff_cc_check_fs_0339
07404     08 4C 05 F6 | 	mov	COUNT_, #8
07408     A9 00 A0 FD | 	call	#pushregs_
0740c     07 19 02 F6 | 	mov	local01, arg01
07410     08 1B 02 F6 | 	mov	local02, arg02
07414     03 18 06 F1 | 	add	local01, #3
07418     0C 01 48 FC | 	wrbyte	#0, local01
0741c     2D 18 06 F1 | 	add	local01, #45
07420     FF FF FF FF 
07424     0C FF 6B FC | 	wrlong	##-1, local01
07428     30 18 86 F1 | 	sub	local01, #48
0742c     0D 11 02 F6 | 	mov	arg02, local02
07430     0C 0F 02 F6 | 	mov	arg01, local01
07434     EC D1 BF FD | 	call	#_ff_cc_move_window_0218
07438     00 F4 0D F2 | 	cmp	result1, #0 wz
0743c     04 F4 05 56 |  if_ne	mov	result1, #4
07440     C4 00 90 5D |  if_ne	jmp	#LR__0491
07444     34 18 06 F1 | 	add	local01, #52
07448     0C 0F 02 F6 | 	mov	arg01, local01
0744c     FE 0F 06 F1 | 	add	arg01, #510
07450     34 18 86 F1 | 	sub	local01, #52
07454     C0 CE BF FD | 	call	#_ff_cc_ld_word_0191
07458     FA 1C 32 F9 | 	getword	local03, result1, #0
0745c     55 00 00 FF 
07460     55 1C 0E F2 | 	cmp	local03, ##43605 wz
07464     03 F4 05 56 |  if_ne	mov	result1, #3
07468     9C 00 90 5D |  if_ne	jmp	#LR__0491
0746c     34 18 06 F1 | 	add	local01, #52
07470     0C 1F C2 FA | 	rdbyte	local04, local01
07474     34 18 86 F1 | 	sub	local01, #52
07478     0F 1D E2 F8 | 	getbyte	local03, local04, #0
0747c     E9 1C 0E F2 | 	cmp	local03, #233 wz
07480     30 00 90 AD |  if_e	jmp	#LR__0489
07484     34 18 06 F1 | 	add	local01, #52
07488     0C 21 C2 FA | 	rdbyte	local05, local01
0748c     34 18 86 F1 | 	sub	local01, #52
07490     10 23 E2 F8 | 	getbyte	local06, local05, #0
07494     EB 22 0E F2 | 	cmp	local06, #235 wz
07498     18 00 90 AD |  if_e	jmp	#LR__0489
0749c     34 18 06 F1 | 	add	local01, #52
074a0     0C 25 C2 FA | 	rdbyte	local07, local01
074a4     34 18 86 F1 | 	sub	local01, #52
074a8     12 27 E2 F8 | 	getbyte	local08, local07, #0
074ac     E8 26 0E F2 | 	cmp	local08, #232 wz
074b0     50 00 90 5D |  if_ne	jmp	#LR__0490
074b4                 | LR__0489
074b4     34 18 06 F1 | 	add	local01, #52
074b8     0C 0F 02 F6 | 	mov	arg01, local01
074bc     34 18 86 F1 | 	sub	local01, #52
074c0     36 0E 06 F1 | 	add	arg01, #54
074c4     5D 00 00 FF 
074c8     06 11 06 F6 | 	mov	arg02, ##@LR__0740
074cc     03 12 06 F6 | 	mov	arg03, #3
074d0     1C CF BF FD | 	call	#_ff_cc_mem_cmp_0204
074d4     00 F4 0D F2 | 	cmp	result1, #0 wz
074d8     00 F4 05 A6 |  if_e	mov	result1, #0
074dc     28 00 90 AD |  if_e	jmp	#LR__0491
074e0     86 18 06 F1 | 	add	local01, #134
074e4     5D 00 00 FF 
074e8     0A 11 06 F6 | 	mov	arg02, ##@LR__0741
074ec     0C 0F 02 F6 | 	mov	arg01, local01
074f0     05 12 06 F6 | 	mov	arg03, #5
074f4     F8 CE BF FD | 	call	#_ff_cc_mem_cmp_0204
074f8     00 F4 0D F2 | 	cmp	result1, #0 wz
074fc     00 F4 05 A6 |  if_e	mov	result1, #0
07500     04 00 90 AD |  if_e	jmp	#LR__0491
07504                 | LR__0490
07504                 | ' 	}
07504                 | ' 	return 2;
07504     02 F4 05 F6 | 	mov	result1, #2
07508                 | LR__0491
07508     A8 F0 03 F6 | 	mov	ptra, fp
0750c     B3 00 A0 FD | 	call	#popregs_
07510                 | _ff_cc_check_fs_0339_ret
07510     2D 00 64 FD | 	ret
07514                 | 
07514                 | _ff_cc_find_volume_0343
07514     0C 4C 05 F6 | 	mov	COUNT_, #12
07518     A9 00 A0 FD | 	call	#pushregs_
0751c     24 F0 07 F1 | 	add	ptra, #36
07520     07 19 02 F6 | 	mov	local01, arg01
07524     08 1B 02 F6 | 	mov	local02, arg02
07528     0C 0F 02 F6 | 	mov	arg01, local01
0752c     00 10 06 F6 | 	mov	arg02, #0
07530     D0 FE BF FD | 	call	#_ff_cc_check_fs_0339
07534     FA 1C 02 F6 | 	mov	local03, result1
07538     0E 1F 02 F6 | 	mov	local04, local03
0753c     02 1E 0E F2 | 	cmp	local04, #2 wz
07540     10 00 90 AD |  if_e	jmp	#LR__0492
07544     03 1E 16 F2 | 	cmp	local04, #3 wc
07548     00 1A 0E C2 |  if_b	cmp	local02, #0 wz
0754c     0F F5 01 B6 |  if_nc_or_z	mov	result1, local04
07550     F0 00 90 BD |  if_nc_or_z	jmp	#LR__0499
07554                 | LR__0492
07554                 | ' 	for (i = 0; i < 4; i++) {
07554     00 20 06 F6 | 	mov	local05, #0
07558                 | LR__0493
07558     04 20 16 F2 | 	cmp	local05, #4 wc
0755c     4C 00 90 3D |  if_ae	jmp	#LR__0494
07560     10 1D 02 F6 | 	mov	local03, local05
07564     02 1C 66 F0 | 	shl	local03, #2
07568     14 50 05 F1 | 	add	fp, #20
0756c     A8 1C 02 F1 | 	add	local03, fp
07570     34 18 06 F1 | 	add	local01, #52
07574     0C 23 02 F6 | 	mov	local06, local01
07578     11 0F 02 F6 | 	mov	arg01, local06
0757c     BE 0F 06 F1 | 	add	arg01, #446
07580     10 25 02 F6 | 	mov	local07, local05
07584     04 24 66 F0 | 	shl	local07, #4
07588     12 27 02 F6 | 	mov	local08, local07
0758c     12 0F 02 F1 | 	add	arg01, local07
07590     08 0E 06 F1 | 	add	arg01, #8
07594     14 50 85 F1 | 	sub	fp, #20
07598     34 18 86 F1 | 	sub	local01, #52
0759c     98 CD BF FD | 	call	#_ff_cc_ld_dword_0193
075a0     0E F5 61 FC | 	wrlong	result1, local03
075a4     01 20 06 F1 | 	add	local05, #1
075a8     AC FF 9F FD | 	jmp	#LR__0493
075ac                 | LR__0494
075ac     00 1A 0E F2 | 	cmp	local02, #0 wz
075b0     0D 1D 02 56 |  if_ne	mov	local03, local02
075b4     01 1C 86 51 |  if_ne	sub	local03, #1
075b8     00 1C 06 A6 |  if_e	mov	local03, #0
075bc     0E 21 02 F6 | 	mov	local05, local03
075c0                 | ' 		mbr_pt[i] = ld_dword(fs->win +  446  + i *  16  +  8 );
075c0                 | ' 	}
075c0                 | ' 	i = part ? part - 1 : 0;
075c0                 | ' 	do {
075c0                 | LR__0495
075c0     10 29 02 F6 | 	mov	local09, local05
075c4     02 28 66 F0 | 	shl	local09, #2
075c8     14 50 05 F1 | 	add	fp, #20
075cc     A8 2A 02 F6 | 	mov	local10, fp
075d0     A8 28 02 F1 | 	add	local09, fp
075d4     14 2D 0A FB | 	rdlong	local11, local09 wz
075d8     14 50 85 F1 | 	sub	fp, #20
075dc     34 00 90 AD |  if_e	jmp	#LR__0496
075e0     10 27 02 F6 | 	mov	local08, local05
075e4     02 26 66 F0 | 	shl	local08, #2
075e8     14 50 05 F1 | 	add	fp, #20
075ec     A8 2E 02 F6 | 	mov	local12, fp
075f0     A8 26 02 F1 | 	add	local08, fp
075f4     13 25 02 FB | 	rdlong	local07, local08
075f8     0C 0F 02 F6 | 	mov	arg01, local01
075fc     12 11 02 F6 | 	mov	arg02, local07
07600     14 50 85 F1 | 	sub	fp, #20
07604     FC FD BF FD | 	call	#_ff_cc_check_fs_0339
07608     FA 22 02 F6 | 	mov	local06, result1
0760c     11 1D 02 F6 | 	mov	local03, local06
07610     04 00 90 FD | 	jmp	#LR__0497
07614                 | LR__0496
07614     03 1C 06 F6 | 	mov	local03, #3
07618                 | LR__0497
07618     0E 1F 02 F6 | 	mov	local04, local03
0761c     00 1A 0E F2 | 	cmp	local02, #0 wz
07620     1C 00 90 5D |  if_ne	jmp	#LR__0498
07624     02 1E 16 F2 | 	cmp	local04, #2 wc
07628     14 00 90 CD |  if_b	jmp	#LR__0498
0762c     10 1D 02 F6 | 	mov	local03, local05
07630     01 1C 06 F1 | 	add	local03, #1
07634     0E 21 02 F6 | 	mov	local05, local03
07638     04 20 16 F2 | 	cmp	local05, #4 wc
0763c     80 FF 9F CD |  if_b	jmp	#LR__0495
07640                 | LR__0498
07640                 | ' 	return fmt;
07640     0F F5 01 F6 | 	mov	result1, local04
07644                 | LR__0499
07644     A8 F0 03 F6 | 	mov	ptra, fp
07648     B3 00 A0 FD | 	call	#popregs_
0764c                 | _ff_cc_find_volume_0343_ret
0764c     2D 00 64 FD | 	ret
07650                 | 
07650                 | _ff_cc_mount_volume_0355
07650     18 4C 05 F6 | 	mov	COUNT_, #24
07654     A9 00 A0 FD | 	call	#pushregs_
07658     07 19 02 F6 | 	mov	local01, arg01
0765c     08 1B 02 F6 | 	mov	local02, arg02
07660     09 1D 02 F6 | 	mov	local03, arg03
07664     0D 01 68 FC | 	wrlong	#0, local02
07668     0C 0F 02 F6 | 	mov	arg01, local01
0766c     F8 FC BF FD | 	call	#_ff_cc_get_ldnumber_0338
07670     FA 1E 02 F6 | 	mov	local04, result1
07674     00 1E 56 F2 | 	cmps	local04, #0 wc
07678     0B F4 05 C6 |  if_b	mov	result1, #11
0767c     C8 05 90 CD |  if_b	jmp	#LR__0512
07680     0F 0F 02 F6 | 	mov	arg01, local04
07684     02 0E 66 F0 | 	shl	arg01, #2
07688     F8 0E 02 F1 | 	add	arg01, ptr__ff_cc_dat__
0768c     07 21 0A FB | 	rdlong	local05, arg01 wz
07690     0C F4 05 A6 |  if_e	mov	result1, #12
07694     B0 05 90 AD |  if_e	jmp	#LR__0512
07698     0D 21 62 FC | 	wrlong	local05, local02
0769c     0E 1D E2 F8 | 	getbyte	local03, local03, #0
076a0     FE 1C 06 F5 | 	and	local03, #254
076a4     10 0F CA FA | 	rdbyte	arg01, local05 wz
076a8     4C 00 90 AD |  if_e	jmp	#LR__0501
076ac     01 20 06 F1 | 	add	local05, #1
076b0     10 0F CA FA | 	rdbyte	arg01, local05 wz
076b4     01 20 86 F1 | 	sub	local05, #1
076b8     01 F4 05 56 |  if_ne	mov	result1, #1
076bc                 | ' 
076bc                 | ' 	return Stat;
076bc     03 00 00 AF 
076c0     44 F1 05 A1 |  if_e	add	ptr__ff_cc_dat__, ##1860
076c4     F8 F4 C1 AA |  if_e	rdbyte	result1, ptr__ff_cc_dat__
076c8     03 00 00 AF 
076cc     44 F1 85 A1 |  if_e	sub	ptr__ff_cc_dat__, ##1860
076d0     FA 0E E2 F8 | 	getbyte	arg01, result1, #0
076d4     01 0E CE F7 | 	test	arg01, #1 wz
076d8     1C 00 90 5D |  if_ne	jmp	#LR__0500
076dc     00 1C 0E F2 | 	cmp	local03, #0 wz
076e0     FA F4 E1 58 |  if_ne	getbyte	result1, result1, #0
076e4     04 F4 0D 55 |  if_ne	and	result1, #4 wz
076e8                 | ' 				return FR_WRITE_PROTECTED;
076e8     0A F4 05 56 |  if_ne	mov	result1, #10
076ec     58 05 90 5D |  if_ne	jmp	#LR__0512
076f0                 | ' 			}
076f0                 | ' 			return FR_OK;
076f0     00 F4 05 F6 | 	mov	result1, #0
076f4     50 05 90 FD | 	jmp	#LR__0512
076f8                 | LR__0500
076f8                 | LR__0501
076f8     10 01 48 FC | 	wrbyte	#0, local05
076fc     01 20 06 F1 | 	add	local05, #1
07700     10 1F 42 FC | 	wrbyte	local04, local05
07704     10 0F C2 FA | 	rdbyte	arg01, local05
07708     01 20 86 F1 | 	sub	local05, #1
0770c     44 C2 BF FD | 	call	#_ff_cc_disk_initialize
07710     FA 22 02 F6 | 	mov	local06, result1
07714     11 25 E2 F8 | 	getbyte	local07, local06, #0
07718     01 24 CE F7 | 	test	local07, #1 wz
0771c                 | ' 		return FR_NOT_READY;
0771c     03 F4 05 56 |  if_ne	mov	result1, #3
07720     24 05 90 5D |  if_ne	jmp	#LR__0512
07724     00 1C 0E F2 | 	cmp	local03, #0 wz
07728     11 25 E2 58 |  if_ne	getbyte	local07, local06, #0
0772c     04 24 CE 57 |  if_ne	test	local07, #4 wz
07730                 | ' 		return FR_WRITE_PROTECTED;
07730     0A F4 05 56 |  if_ne	mov	result1, #10
07734     10 05 90 5D |  if_ne	jmp	#LR__0512
07738     10 0F 02 F6 | 	mov	arg01, local05
0773c     00 10 06 F6 | 	mov	arg02, #0
07740     D0 FD BF FD | 	call	#_ff_cc_find_volume_0343
07744     FA 0E 02 F6 | 	mov	arg01, result1
07748     04 0E 0E F2 | 	cmp	arg01, #4 wz
0774c     01 F4 05 A6 |  if_e	mov	result1, #1
07750     F4 04 90 AD |  if_e	jmp	#LR__0512
07754     02 0E 16 F2 | 	cmp	arg01, #2 wc
07758     0D F4 05 36 |  if_ae	mov	result1, #13
0775c     E8 04 90 3D |  if_ae	jmp	#LR__0512
07760     30 20 06 F1 | 	add	local05, #48
07764     10 27 02 FB | 	rdlong	local08, local05
07768     04 20 06 F1 | 	add	local05, #4
0776c     10 0F 02 F6 | 	mov	arg01, local05
07770     34 20 86 F1 | 	sub	local05, #52
07774     0B 0E 06 F1 | 	add	arg01, #11
07778     9C CB BF FD | 	call	#_ff_cc_ld_word_0191
0777c     FA F4 31 F9 | 	getword	result1, result1, #0
07780     01 00 00 FF 
07784     00 F4 0D F2 | 	cmp	result1, ##512 wz
07788     0D F4 05 56 |  if_ne	mov	result1, #13
0778c     B8 04 90 5D |  if_ne	jmp	#LR__0512
07790     34 20 06 F1 | 	add	local05, #52
07794     10 0F 02 F6 | 	mov	arg01, local05
07798     34 20 86 F1 | 	sub	local05, #52
0779c     16 0E 06 F1 | 	add	arg01, #22
077a0     74 CB BF FD | 	call	#_ff_cc_ld_word_0191
077a4     FA 28 02 F6 | 	mov	local09, result1
077a8     0F 28 4E F7 | 	zerox	local09, #15 wz
077ac     18 00 90 5D |  if_ne	jmp	#LR__0502
077b0     34 20 06 F1 | 	add	local05, #52
077b4     10 0F 02 F6 | 	mov	arg01, local05
077b8     34 20 86 F1 | 	sub	local05, #52
077bc     24 0E 06 F1 | 	add	arg01, #36
077c0     74 CB BF FD | 	call	#_ff_cc_ld_dword_0193
077c4     FA 28 02 F6 | 	mov	local09, result1
077c8                 | LR__0502
077c8     1C 20 06 F1 | 	add	local05, #28
077cc     10 29 62 FC | 	wrlong	local09, local05
077d0     28 20 06 F1 | 	add	local05, #40
077d4     10 25 C2 FA | 	rdbyte	local07, local05
077d8     42 20 86 F1 | 	sub	local05, #66
077dc     10 25 42 FC | 	wrbyte	local07, local05
077e0     10 25 C2 FA | 	rdbyte	local07, local05
077e4     02 20 86 F1 | 	sub	local05, #2
077e8     01 24 0E F2 | 	cmp	local07, #1 wz
077ec     18 00 90 AD |  if_e	jmp	#LR__0503
077f0     02 20 06 F1 | 	add	local05, #2
077f4     10 25 C2 FA | 	rdbyte	local07, local05
077f8     02 20 86 F1 | 	sub	local05, #2
077fc     02 24 0E F2 | 	cmp	local07, #2 wz
07800     0D F4 05 56 |  if_ne	mov	result1, #13
07804     40 04 90 5D |  if_ne	jmp	#LR__0512
07808                 | LR__0503
07808     02 20 06 F1 | 	add	local05, #2
0780c     10 25 C2 FA | 	rdbyte	local07, local05
07810     12 29 02 FD | 	qmul	local09, local07
07814     3F 20 06 F1 | 	add	local05, #63
07818     10 25 C2 FA | 	rdbyte	local07, local05
0781c     37 20 86 F1 | 	sub	local05, #55
07820     10 25 52 FC | 	wrword	local07, local05
07824     10 25 E2 FA | 	rdword	local07, local05
07828     0A 20 86 F1 | 	sub	local05, #10
0782c     0F 24 4E F7 | 	zerox	local07, #15 wz
07830     18 28 62 FD | 	getqx	local09
07834     20 00 90 AD |  if_e	jmp	#LR__0504
07838     0A 20 06 F1 | 	add	local05, #10
0783c     10 2B E2 FA | 	rdword	local10, local05
07840     15 25 32 F9 | 	getword	local07, local10, #0
07844     0A 20 86 F1 | 	sub	local05, #10
07848     15 F5 31 F9 | 	getword	result1, local10, #0
0784c     01 F4 85 F1 | 	sub	result1, #1
07850     FA 24 CA F7 | 	test	local07, result1 wz
07854     08 00 90 AD |  if_e	jmp	#LR__0505
07858                 | LR__0504
07858     0D F4 05 F6 | 	mov	result1, #13
0785c     E8 03 90 FD | 	jmp	#LR__0512
07860                 | LR__0505
07860     34 20 06 F1 | 	add	local05, #52
07864     10 0F 02 F6 | 	mov	arg01, local05
07868     34 20 86 F1 | 	sub	local05, #52
0786c     11 0E 06 F1 | 	add	arg01, #17
07870     A4 CA BF FD | 	call	#_ff_cc_ld_word_0191
07874     08 20 06 F1 | 	add	local05, #8
07878     10 F5 51 FC | 	wrword	result1, local05
0787c     10 25 E2 FA | 	rdword	local07, local05
07880     08 20 86 F1 | 	sub	local05, #8
07884     12 0F 52 F6 | 	abs	arg01, local07 wc
07888     07 0F 42 F8 | 	getnib	arg01, arg01, #0
0788c     07 0F 8A F6 | 	negc	arg01, arg01 wz
07890     0D F4 05 56 |  if_ne	mov	result1, #13
07894     B0 03 90 5D |  if_ne	jmp	#LR__0512
07898     34 20 06 F1 | 	add	local05, #52
0789c     10 0F 02 F6 | 	mov	arg01, local05
078a0     34 20 86 F1 | 	sub	local05, #52
078a4     13 0E 06 F1 | 	add	arg01, #19
078a8     6C CA BF FD | 	call	#_ff_cc_ld_word_0191
078ac     FA F4 31 F9 | 	getword	result1, result1, #0
078b0     FA 2C 0A F6 | 	mov	local11, result1 wz
078b4     18 00 90 5D |  if_ne	jmp	#LR__0506
078b8     34 20 06 F1 | 	add	local05, #52
078bc     10 0F 02 F6 | 	mov	arg01, local05
078c0     34 20 86 F1 | 	sub	local05, #52
078c4     20 0E 06 F1 | 	add	arg01, #32
078c8     6C CA BF FD | 	call	#_ff_cc_ld_dword_0193
078cc     FA 2C 02 F6 | 	mov	local11, result1
078d0                 | LR__0506
078d0     34 20 06 F1 | 	add	local05, #52
078d4     10 0F 02 F6 | 	mov	arg01, local05
078d8     34 20 86 F1 | 	sub	local05, #52
078dc     0E 0E 06 F1 | 	add	arg01, #14
078e0     34 CA BF FD | 	call	#_ff_cc_ld_word_0191
078e4     FA 2E 02 F6 | 	mov	local12, result1
078e8     17 25 02 F6 | 	mov	local07, local12
078ec     0F 24 4E F7 | 	zerox	local07, #15 wz
078f0     0D F4 05 A6 |  if_e	mov	result1, #13
078f4     50 03 90 AD |  if_e	jmp	#LR__0512
078f8     17 31 32 F9 | 	getword	local13, local12, #0
078fc     14 31 02 F1 | 	add	local13, local09
07900     08 20 06 F1 | 	add	local05, #8
07904     10 25 E2 FA | 	rdword	local07, local05
07908     08 20 86 F1 | 	sub	local05, #8
0790c     12 25 52 F6 | 	abs	local07, local07 wc
07910     04 24 46 F0 | 	shr	local07, #4
07914     12 25 82 F6 | 	negc	local07, local07
07918     12 31 02 F1 | 	add	local13, local07
0791c     18 2D 12 F2 | 	cmp	local11, local13 wc
07920     0D F4 05 C6 |  if_b	mov	result1, #13
07924     20 03 90 CD |  if_b	jmp	#LR__0512
07928     16 25 02 F6 | 	mov	local07, local11
0792c     18 25 82 F1 | 	sub	local07, local13
07930     0A 20 06 F1 | 	add	local05, #10
07934     10 0F E2 FA | 	rdword	arg01, local05
07938     07 25 12 FD | 	qdiv	local07, arg01
0793c     0A 20 86 F1 | 	sub	local05, #10
07940     18 32 62 FD | 	getqx	local14
07944     00 32 0E F2 | 	cmp	local14, #0 wz
07948     0D F4 05 A6 |  if_e	mov	result1, #13
0794c     F8 02 90 AD |  if_e	jmp	#LR__0512
07950     00 34 06 F6 | 	mov	local15, #0
07954     FF FF 07 FF 
07958     F6 33 16 F2 | 	cmp	local14, ##268435446 wc
0795c     03 34 06 C6 |  if_b	mov	local15, #3
07960     7F 00 00 FF 
07964     F6 33 16 F2 | 	cmp	local14, ##65526 wc
07968     02 34 06 C6 |  if_b	mov	local15, #2
0796c     07 00 00 FF 
07970     F6 33 16 F2 | 	cmp	local14, ##4086 wc
07974     01 34 06 C6 |  if_b	mov	local15, #1
07978     00 34 0E F2 | 	cmp	local15, #0 wz
0797c     0D F4 05 A6 |  if_e	mov	result1, #13
07980     C4 02 90 AD |  if_e	jmp	#LR__0512
07984     19 25 02 F6 | 	mov	local07, local14
07988     02 24 06 F1 | 	add	local07, #2
0798c     18 20 06 F1 | 	add	local05, #24
07990     10 25 62 FC | 	wrlong	local07, local05
07994     08 20 06 F1 | 	add	local05, #8
07998     10 27 62 FC | 	wrlong	local08, local05
0799c     13 25 02 F6 | 	mov	local07, local08
079a0     17 0F 32 F9 | 	getword	arg01, local12, #0
079a4     07 25 02 F1 | 	add	local07, arg01
079a8     04 20 06 F1 | 	add	local05, #4
079ac     10 25 62 FC | 	wrlong	local07, local05
079b0     13 25 02 F6 | 	mov	local07, local08
079b4     18 25 02 F1 | 	add	local07, local13
079b8     08 20 06 F1 | 	add	local05, #8
079bc     10 25 62 FC | 	wrlong	local07, local05
079c0     2C 20 86 F1 | 	sub	local05, #44
079c4     03 34 0E F2 | 	cmp	local15, #3 wz
079c8     68 00 90 5D |  if_ne	jmp	#LR__0507
079cc     34 20 06 F1 | 	add	local05, #52
079d0     10 0F 02 F6 | 	mov	arg01, local05
079d4     34 20 86 F1 | 	sub	local05, #52
079d8     2A 0E 06 F1 | 	add	arg01, #42
079dc     38 C9 BF FD | 	call	#_ff_cc_ld_word_0191
079e0     0F F4 4D F7 | 	zerox	result1, #15 wz
079e4     0D F4 05 56 |  if_ne	mov	result1, #13
079e8     5C 02 90 5D |  if_ne	jmp	#LR__0512
079ec     08 20 06 F1 | 	add	local05, #8
079f0     10 25 E2 FA | 	rdword	local07, local05
079f4     08 20 86 F1 | 	sub	local05, #8
079f8     0F 24 4E F7 | 	zerox	local07, #15 wz
079fc     0D F4 05 56 |  if_ne	mov	result1, #13
07a00     44 02 90 5D |  if_ne	jmp	#LR__0512
07a04     34 20 06 F1 | 	add	local05, #52
07a08     10 0F 02 F6 | 	mov	arg01, local05
07a0c     34 20 86 F1 | 	sub	local05, #52
07a10     2C 0E 06 F1 | 	add	arg01, #44
07a14     20 C9 BF FD | 	call	#_ff_cc_ld_dword_0193
07a18     28 20 06 F1 | 	add	local05, #40
07a1c     10 F5 61 FC | 	wrlong	result1, local05
07a20     10 20 86 F1 | 	sub	local05, #16
07a24     10 37 02 FB | 	rdlong	local16, local05
07a28     18 20 86 F1 | 	sub	local05, #24
07a2c     02 36 66 F0 | 	shl	local16, #2
07a30     80 00 90 FD | 	jmp	#LR__0509
07a34                 | LR__0507
07a34     08 20 06 F1 | 	add	local05, #8
07a38     10 25 E2 FA | 	rdword	local07, local05
07a3c     08 20 86 F1 | 	sub	local05, #8
07a40     0F 24 4E F7 | 	zerox	local07, #15 wz
07a44     0D F4 05 A6 |  if_e	mov	result1, #13
07a48     FC 01 90 AD |  if_e	jmp	#LR__0512
07a4c     24 20 06 F1 | 	add	local05, #36
07a50     10 25 02 FB | 	rdlong	local07, local05
07a54     14 25 02 F1 | 	add	local07, local09
07a58     04 20 06 F1 | 	add	local05, #4
07a5c     10 25 62 FC | 	wrlong	local07, local05
07a60     28 20 86 F1 | 	sub	local05, #40
07a64     02 34 0E F2 | 	cmp	local15, #2 wz
07a68     18 20 06 A1 |  if_e	add	local05, #24
07a6c     10 25 02 AB |  if_e	rdlong	local07, local05
07a70     18 20 86 A1 |  if_e	sub	local05, #24
07a74     01 24 66 A0 |  if_e	shl	local07, #1
07a78     34 00 90 AD |  if_e	jmp	#LR__0508
07a7c     18 20 06 F1 | 	add	local05, #24
07a80     10 39 02 FB | 	rdlong	local17, local05
07a84     1C 3B 02 F6 | 	mov	local18, local17
07a88     1D 2B 02 F6 | 	mov	local10, local18
07a8c     01 2A 66 F0 | 	shl	local10, #1
07a90     1D 2B 02 F1 | 	add	local10, local18
07a94     15 25 02 F6 | 	mov	local07, local10
07a98     01 24 46 F0 | 	shr	local07, #1
07a9c     1C 3D 02 F6 | 	mov	local19, local17
07aa0     18 20 86 F1 | 	sub	local05, #24
07aa4     1E 3F 02 F6 | 	mov	local20, local19
07aa8     01 3E 06 F5 | 	and	local20, #1
07aac     1F 25 02 F1 | 	add	local07, local20
07ab0                 | LR__0508
07ab0     12 37 02 F6 | 	mov	local16, local07
07ab4                 | LR__0509
07ab4     1B 25 02 F6 | 	mov	local07, local16
07ab8     FF 25 06 F1 | 	add	local07, #511
07abc     09 24 46 F0 | 	shr	local07, #9
07ac0     1C 20 06 F1 | 	add	local05, #28
07ac4     10 0F 02 FB | 	rdlong	arg01, local05
07ac8     1C 20 86 F1 | 	sub	local05, #28
07acc     12 0F 12 F2 | 	cmp	arg01, local07 wc
07ad0     0D F4 05 C6 |  if_b	mov	result1, #13
07ad4     70 01 90 CD |  if_b	jmp	#LR__0512
07ad8     14 20 06 F1 | 	add	local05, #20
07adc     FF FF FF FF 
07ae0     10 FF 6B FC | 	wrlong	##-1, local05
07ae4     04 20 86 F1 | 	sub	local05, #4
07ae8     FF FF FF FF 
07aec     10 FF 6B FC | 	wrlong	##-1, local05
07af0     0C 20 86 F1 | 	sub	local05, #12
07af4     10 01 49 FC | 	wrbyte	#128, local05
07af8     04 20 86 F1 | 	sub	local05, #4
07afc     03 34 0E F2 | 	cmp	local15, #3 wz
07b00     10 01 90 5D |  if_ne	jmp	#LR__0511
07b04     34 20 06 F1 | 	add	local05, #52
07b08     10 0F 02 F6 | 	mov	arg01, local05
07b0c     34 20 86 F1 | 	sub	local05, #52
07b10     30 0E 06 F1 | 	add	arg01, #48
07b14     00 C8 BF FD | 	call	#_ff_cc_ld_word_0191
07b18     FA 24 32 F9 | 	getword	local07, result1, #0
07b1c     01 24 0E F2 | 	cmp	local07, #1 wz
07b20     F0 00 90 5D |  if_ne	jmp	#LR__0511
07b24     13 41 02 F6 | 	mov	local21, local08
07b28     01 40 06 F1 | 	add	local21, #1
07b2c     10 0F 02 F6 | 	mov	arg01, local05
07b30     20 11 02 F6 | 	mov	arg02, local21
07b34     EC CA BF FD | 	call	#_ff_cc_move_window_0218
07b38     00 F4 0D F2 | 	cmp	result1, #0 wz
07b3c     D4 00 90 5D |  if_ne	jmp	#LR__0511
07b40     04 20 06 F1 | 	add	local05, #4
07b44     10 01 48 FC | 	wrbyte	#0, local05
07b48     30 20 06 F1 | 	add	local05, #48
07b4c     10 43 02 F6 | 	mov	local22, local05
07b50     21 45 02 F6 | 	mov	local23, local22
07b54     FE 45 06 F1 | 	add	local23, #510
07b58     22 0F 02 F6 | 	mov	arg01, local23
07b5c     34 20 86 F1 | 	sub	local05, #52
07b60     B4 C7 BF FD | 	call	#_ff_cc_ld_word_0191
07b64     FA 46 02 F6 | 	mov	local24, result1
07b68     23 25 32 F9 | 	getword	local07, local24, #0
07b6c     55 00 00 FF 
07b70     55 24 0E F2 | 	cmp	local07, ##43605 wz
07b74     9C 00 90 5D |  if_ne	jmp	#LR__0510
07b78     34 20 06 F1 | 	add	local05, #52
07b7c     10 41 02 F6 | 	mov	local21, local05
07b80     20 43 02 F6 | 	mov	local22, local21
07b84     21 0F 02 F6 | 	mov	arg01, local22
07b88     34 20 86 F1 | 	sub	local05, #52
07b8c     A8 C7 BF FD | 	call	#_ff_cc_ld_dword_0193
07b90     FA 44 02 F6 | 	mov	local23, result1
07b94     A9 B0 20 FF 
07b98     52 44 0E F2 | 	cmp	local23, ##1096897106 wz
07b9c     74 00 90 5D |  if_ne	jmp	#LR__0510
07ba0     34 20 06 F1 | 	add	local05, #52
07ba4     10 2B 02 F6 | 	mov	local10, local05
07ba8     15 41 02 F6 | 	mov	local21, local10
07bac     E4 41 06 F1 | 	add	local21, #484
07bb0     20 0F 02 F6 | 	mov	arg01, local21
07bb4     34 20 86 F1 | 	sub	local05, #52
07bb8     7C C7 BF FD | 	call	#_ff_cc_ld_dword_0193
07bbc     FA 42 02 F6 | 	mov	local22, result1
07bc0     B9 A0 30 FF 
07bc4     72 42 0E F2 | 	cmp	local22, ##1631679090 wz
07bc8     48 00 90 5D |  if_ne	jmp	#LR__0510
07bcc     34 20 06 F1 | 	add	local05, #52
07bd0     10 0F 02 F6 | 	mov	arg01, local05
07bd4     34 20 86 F1 | 	sub	local05, #52
07bd8     E8 0F 06 F1 | 	add	arg01, #488
07bdc     58 C7 BF FD | 	call	#_ff_cc_ld_dword_0193
07be0     14 20 06 F1 | 	add	local05, #20
07be4     10 F5 61 FC | 	wrlong	result1, local05
07be8     20 20 06 F1 | 	add	local05, #32
07bec     10 45 02 F6 | 	mov	local23, local05
07bf0     22 47 02 F6 | 	mov	local24, local23
07bf4     EC 47 06 F1 | 	add	local24, #492
07bf8     23 0F 02 F6 | 	mov	arg01, local24
07bfc     34 20 86 F1 | 	sub	local05, #52
07c00     34 C7 BF FD | 	call	#_ff_cc_ld_dword_0193
07c04     FA 24 02 F6 | 	mov	local07, result1
07c08     10 20 06 F1 | 	add	local05, #16
07c0c     10 25 62 FC | 	wrlong	local07, local05
07c10     10 20 86 F1 | 	sub	local05, #16
07c14                 | LR__0510
07c14                 | LR__0511
07c14     10 35 42 FC | 	wrbyte	local15, local05
07c18     04 F0 05 F1 | 	add	ptr__ff_cc_dat__, #4
07c1c     F8 24 E2 FA | 	rdword	local07, ptr__ff_cc_dat__
07c20     01 24 06 F1 | 	add	local07, #1
07c24     F8 24 52 FC | 	wrword	local07, ptr__ff_cc_dat__
07c28     F8 44 E2 FA | 	rdword	local23, ptr__ff_cc_dat__
07c2c     06 20 06 F1 | 	add	local05, #6
07c30     10 45 52 FC | 	wrword	local23, local05
07c34     10 F0 05 F1 | 	add	ptr__ff_cc_dat__, #16
07c38     06 20 06 F1 | 	add	local05, #6
07c3c     10 F1 61 FC | 	wrlong	ptr__ff_cc_dat__, local05
07c40                 | ' 				&& ld_dword(fs->win +  0 ) == 0x41615252
07c40                 | ' 				&& ld_dword(fs->win +  484 ) == 0x61417272)
07c40                 | ' 			{
07c40                 | ' 
07c40                 | ' 				fs->free_clst = ld_dword(fs->win +  488 );
07c40                 | ' 
07c40                 | ' 
07c40                 | ' 				fs->last_clst = ld_dword(fs->win +  492 );
07c40                 | ' 
07c40                 | ' 			}
07c40                 | ' 		}
07c40                 | ' 
07c40                 | ' 
07c40                 | ' 	}
07c40                 | ' 
07c40                 | ' 	fs->fs_type = (BYTE)fmt;
07c40                 | ' 	fs->id = ++Fsid;
07c40                 | ' 
07c40                 | ' 	fs->lfnbuf = LfnBuf;
07c40                 | ' #line 3608 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
07c40                 | ' 	return FR_OK;
07c40     00 F4 05 F6 | 	mov	result1, #0
07c44     14 F0 85 F1 | 	sub	ptr__ff_cc_dat__, #20
07c48                 | LR__0512
07c48     A8 F0 03 F6 | 	mov	ptra, fp
07c4c     B3 00 A0 FD | 	call	#popregs_
07c50                 | _ff_cc_mount_volume_0355_ret
07c50     2D 00 64 FD | 	ret
07c54                 | 
07c54                 | _ff_cc_validate_0357
07c54     0B 4C 05 F6 | 	mov	COUNT_, #11
07c58     A9 00 A0 FD | 	call	#pushregs_
07c5c     07 19 0A F6 | 	mov	local01, arg01 wz
07c60     08 1B 02 F6 | 	mov	local02, arg02
07c64     09 1C 06 F6 | 	mov	local03, #9
07c68     7C 00 90 AD |  if_e	jmp	#LR__0513
07c6c     0C 1F 0A FB | 	rdlong	local04, local01 wz
07c70     74 00 90 AD |  if_e	jmp	#LR__0513
07c74     0C F5 01 FB | 	rdlong	result1, local01
07c78     FA F4 C9 FA | 	rdbyte	result1, result1 wz
07c7c     68 00 90 AD |  if_e	jmp	#LR__0513
07c80     04 18 06 F1 | 	add	local01, #4
07c84     0C 21 E2 FA | 	rdword	local05, local01
07c88     04 18 86 F1 | 	sub	local01, #4
07c8c     10 F5 31 F9 | 	getword	result1, local05, #0
07c90     0C 23 02 FB | 	rdlong	local06, local01
07c94     06 22 06 F1 | 	add	local06, #6
07c98     11 25 E2 FA | 	rdword	local07, local06
07c9c     06 22 86 F1 | 	sub	local06, #6
07ca0     12 27 32 F9 | 	getword	local08, local07, #0
07ca4     13 F5 09 F2 | 	cmp	result1, local08 wz
07ca8     3C 00 90 5D |  if_ne	jmp	#LR__0513
07cac     0C 29 02 FB | 	rdlong	local09, local01
07cb0     01 28 06 F1 | 	add	local09, #1
07cb4     14 2B C2 FA | 	rdbyte	local10, local09
07cb8     01 28 86 F1 | 	sub	local09, #1
07cbc     15 0F 0A F6 | 	mov	arg01, local10 wz
07cc0     01 F4 05 56 |  if_ne	mov	result1, #1
07cc4                 | ' 
07cc4                 | ' 	return Stat;
07cc4     03 00 00 AF 
07cc8     44 F1 05 A1 |  if_e	add	ptr__ff_cc_dat__, ##1860
07ccc     F8 F4 C1 AA |  if_e	rdbyte	result1, ptr__ff_cc_dat__
07cd0     03 00 00 AF 
07cd4     44 F1 85 A1 |  if_e	sub	ptr__ff_cc_dat__, ##1860
07cd8     FA 2C 02 F6 | 	mov	local11, result1
07cdc     16 1F E2 F8 | 	getbyte	local04, local11, #0
07ce0     01 1E 0E F5 | 	and	local04, #1 wz
07ce4     00 1C 06 A6 |  if_e	mov	local03, #0
07ce8                 | LR__0513
07ce8     00 1C 0E F2 | 	cmp	local03, #0 wz
07cec     0C 1F 02 AB |  if_e	rdlong	local04, local01
07cf0     00 1E 06 56 |  if_ne	mov	local04, #0
07cf4     0D 1F 62 FC | 	wrlong	local04, local02
07cf8                 | ' 			res = FR_OK;
07cf8                 | ' 		}
07cf8                 | ' 
07cf8                 | ' 	}
07cf8                 | ' 	*rfs = (res == FR_OK) ? obj->fs : 0;
07cf8                 | ' 	return res;
07cf8     0E F5 01 F6 | 	mov	result1, local03
07cfc     A8 F0 03 F6 | 	mov	ptra, fp
07d00     B3 00 A0 FD | 	call	#popregs_
07d04                 | _ff_cc_validate_0357_ret
07d04     2D 00 64 FD | 	ret
07d08                 | 
07d08                 | _ff_cc_f_mount
07d08     01 4C 05 F6 | 	mov	COUNT_, #1
07d0c     A9 00 A0 FD | 	call	#pushregs_
07d10     20 F0 07 F1 | 	add	ptra, #32
07d14     04 50 05 F1 | 	add	fp, #4
07d18     A8 0E 62 FC | 	wrlong	arg01, fp
07d1c     04 50 05 F1 | 	add	fp, #4
07d20     A8 10 62 FC | 	wrlong	arg02, fp
07d24     04 50 05 F1 | 	add	fp, #4
07d28     A8 12 42 FC | 	wrbyte	arg03, fp
07d2c     04 50 85 F1 | 	sub	fp, #4
07d30     A8 0E 02 FB | 	rdlong	arg01, fp
07d34     14 50 05 F1 | 	add	fp, #20
07d38     A8 0E 62 FC | 	wrlong	arg01, fp
07d3c     A8 0E 02 F6 | 	mov	arg01, fp
07d40     1C 50 85 F1 | 	sub	fp, #28
07d44     20 F6 BF FD | 	call	#_ff_cc_get_ldnumber_0338
07d48     14 50 05 F1 | 	add	fp, #20
07d4c     A8 F4 61 FC | 	wrlong	result1, fp
07d50     14 50 85 F1 | 	sub	fp, #20
07d54     00 F4 55 F2 | 	cmps	result1, #0 wc
07d58     0B F4 05 C6 |  if_b	mov	result1, #11
07d5c     A8 00 90 CD |  if_b	jmp	#LR__0514
07d60     14 50 05 F1 | 	add	fp, #20
07d64     A8 18 02 FB | 	rdlong	local01, fp
07d68     02 18 66 F0 | 	shl	local01, #2
07d6c     F8 18 02 F1 | 	add	local01, ptr__ff_cc_dat__
07d70     0C 19 0A FB | 	rdlong	local01, local01 wz
07d74     04 50 85 F1 | 	sub	fp, #4
07d78     A8 18 62 FC | 	wrlong	local01, fp
07d7c     10 50 85 F1 | 	sub	fp, #16
07d80     10 50 05 51 |  if_ne	add	fp, #16
07d84     A8 18 02 5B |  if_ne	rdlong	local01, fp
07d88     10 50 85 51 |  if_ne	sub	fp, #16
07d8c     0C 01 48 5C |  if_ne	wrbyte	#0, local01
07d90     04 50 05 F1 | 	add	fp, #4
07d94     A8 18 0A FB | 	rdlong	local01, fp wz
07d98     04 50 85 F1 | 	sub	fp, #4
07d9c     04 50 05 51 |  if_ne	add	fp, #4
07da0     A8 18 02 5B |  if_ne	rdlong	local01, fp
07da4     04 50 85 51 |  if_ne	sub	fp, #4
07da8     0C 01 48 5C |  if_ne	wrbyte	#0, local01
07dac     14 50 05 F1 | 	add	fp, #20
07db0     A8 18 02 FB | 	rdlong	local01, fp
07db4     02 18 66 F0 | 	shl	local01, #2
07db8     F8 18 02 F1 | 	add	local01, ptr__ff_cc_dat__
07dbc     10 50 85 F1 | 	sub	fp, #16
07dc0     A8 12 02 FB | 	rdlong	arg03, fp
07dc4     0C 13 62 FC | 	wrlong	arg03, local01
07dc8     08 50 05 F1 | 	add	fp, #8
07dcc     A8 18 C2 FA | 	rdbyte	local01, fp
07dd0     0C 50 85 F1 | 	sub	fp, #12
07dd4     07 18 4E F7 | 	zerox	local01, #7 wz
07dd8     00 F4 05 A6 |  if_e	mov	result1, #0
07ddc     28 00 90 AD |  if_e	jmp	#LR__0514
07de0     08 50 05 F1 | 	add	fp, #8
07de4     A8 0E 02 F6 | 	mov	arg01, fp
07de8     04 50 85 F1 | 	sub	fp, #4
07dec     A8 10 02 F6 | 	mov	arg02, fp
07df0     04 50 85 F1 | 	sub	fp, #4
07df4     00 12 06 F6 | 	mov	arg03, #0
07df8     54 F8 BF FD | 	call	#_ff_cc_mount_volume_0355
07dfc     18 50 05 F1 | 	add	fp, #24
07e00     A8 F4 61 FC | 	wrlong	result1, fp
07e04                 | ' 
07e04                 | ' 	res = mount_volume(&path, &fs, 0);
07e04                 | ' 	return res ;
07e04     18 50 85 F1 | 	sub	fp, #24
07e08                 | LR__0514
07e08     A8 F0 03 F6 | 	mov	ptra, fp
07e0c     B3 00 A0 FD | 	call	#popregs_
07e10                 | _ff_cc_f_mount_ret
07e10     2D 00 64 FD | 	ret
07e14                 | 
07e14                 | _ff_cc_f_open
07e14     0D 4C 05 F6 | 	mov	COUNT_, #13
07e18     A9 00 A0 FD | 	call	#pushregs_
07e1c     5C F0 07 F1 | 	add	ptra, #92
07e20     04 50 05 F1 | 	add	fp, #4
07e24     A8 0E 62 FC | 	wrlong	arg01, fp
07e28     04 50 05 F1 | 	add	fp, #4
07e2c     A8 10 62 FC | 	wrlong	arg02, fp
07e30     04 50 05 F1 | 	add	fp, #4
07e34     A8 12 42 FC | 	wrbyte	arg03, fp
07e38     08 50 85 F1 | 	sub	fp, #8
07e3c     A8 12 0A FB | 	rdlong	arg03, fp wz
07e40     04 50 85 F1 | 	sub	fp, #4
07e44     09 F4 05 A6 |  if_e	mov	result1, #9
07e48     88 06 90 AD |  if_e	jmp	#LR__0533
07e4c     0C 50 05 F1 | 	add	fp, #12
07e50     A8 12 C2 FA | 	rdbyte	arg03, fp
07e54     3F 12 06 F5 | 	and	arg03, #63
07e58     A8 12 42 FC | 	wrbyte	arg03, fp
07e5c     04 50 85 F1 | 	sub	fp, #4
07e60     A8 0E 02 F6 | 	mov	arg01, fp
07e64     3C 50 05 F1 | 	add	fp, #60
07e68     A8 10 02 F6 | 	mov	arg02, fp
07e6c     38 50 85 F1 | 	sub	fp, #56
07e70     A8 18 C2 FA | 	rdbyte	local01, fp
07e74     0C 50 85 F1 | 	sub	fp, #12
07e78     0C 13 02 F6 | 	mov	arg03, local01
07e7c     D0 F7 BF FD | 	call	#_ff_cc_mount_volume_0355
07e80     10 50 05 F1 | 	add	fp, #16
07e84     A8 F4 61 FC | 	wrlong	result1, fp
07e88     10 50 85 F1 | 	sub	fp, #16
07e8c     00 F4 0D F2 | 	cmp	result1, #0 wz
07e90     18 06 90 5D |  if_ne	jmp	#LR__0532
07e94     44 50 05 F1 | 	add	fp, #68
07e98     A8 10 02 FB | 	rdlong	arg02, fp
07e9c     30 50 85 F1 | 	sub	fp, #48
07ea0     A8 10 62 FC | 	wrlong	arg02, fp
07ea4     A8 0E 02 F6 | 	mov	arg01, fp
07ea8     0C 50 85 F1 | 	sub	fp, #12
07eac     A8 1A 02 FB | 	rdlong	local02, fp
07eb0     08 50 85 F1 | 	sub	fp, #8
07eb4     0D 11 02 F6 | 	mov	arg02, local02
07eb8     9C F2 BF FD | 	call	#_ff_cc_follow_path_0332
07ebc     10 50 05 F1 | 	add	fp, #16
07ec0     A8 F4 61 FC | 	wrlong	result1, fp
07ec4     10 50 85 F1 | 	sub	fp, #16
07ec8     00 F4 0D F2 | 	cmp	result1, #0 wz
07ecc     1C 00 90 5D |  if_ne	jmp	#LR__0515
07ed0     3F 50 05 F1 | 	add	fp, #63
07ed4     A8 1C C2 FA | 	rdbyte	local03, fp
07ed8     3F 50 85 F1 | 	sub	fp, #63
07edc     80 1C CE F7 | 	test	local03, #128 wz
07ee0     10 50 05 51 |  if_ne	add	fp, #16
07ee4     A8 0C 68 5C |  if_ne	wrlong	#6, fp
07ee8     10 50 85 51 |  if_ne	sub	fp, #16
07eec                 | LR__0515
07eec     0C 50 05 F1 | 	add	fp, #12
07ef0     A8 1C C2 FA | 	rdbyte	local03, fp
07ef4     0C 50 85 F1 | 	sub	fp, #12
07ef8     1C 1C CE F7 | 	test	local03, #28 wz
07efc     E4 01 90 AD |  if_e	jmp	#LR__0520
07f00     10 50 05 F1 | 	add	fp, #16
07f04     A8 1C 0A FB | 	rdlong	local03, fp wz
07f08     10 50 85 F1 | 	sub	fp, #16
07f0c     48 00 90 AD |  if_e	jmp	#LR__0517
07f10     10 50 05 F1 | 	add	fp, #16
07f14     A8 1C 02 FB | 	rdlong	local03, fp
07f18     10 50 85 F1 | 	sub	fp, #16
07f1c     04 1C 0E F2 | 	cmp	local03, #4 wz
07f20     1C 00 90 5D |  if_ne	jmp	#LR__0516
07f24     14 50 05 F1 | 	add	fp, #20
07f28     A8 0E 02 F6 | 	mov	arg01, fp
07f2c     14 50 85 F1 | 	sub	fp, #20
07f30     B0 DF BF FD | 	call	#_ff_cc_dir_register_0306
07f34     10 50 05 F1 | 	add	fp, #16
07f38     A8 F4 61 FC | 	wrlong	result1, fp
07f3c     10 50 85 F1 | 	sub	fp, #16
07f40                 | LR__0516
07f40     0C 50 05 F1 | 	add	fp, #12
07f44     A8 1C C2 FA | 	rdbyte	local03, fp
07f48     08 1C 46 F5 | 	or	local03, #8
07f4c     A8 1C 42 FC | 	wrbyte	local03, fp
07f50     0C 50 85 F1 | 	sub	fp, #12
07f54     3C 00 90 FD | 	jmp	#LR__0519
07f58                 | LR__0517
07f58     1A 50 05 F1 | 	add	fp, #26
07f5c     A8 1C C2 FA | 	rdbyte	local03, fp
07f60     1A 50 85 F1 | 	sub	fp, #26
07f64     11 1C CE F7 | 	test	local03, #17 wz
07f68     10 50 05 51 |  if_ne	add	fp, #16
07f6c     A8 0E 68 5C |  if_ne	wrlong	#7, fp
07f70     10 50 85 51 |  if_ne	sub	fp, #16
07f74     1C 00 90 5D |  if_ne	jmp	#LR__0518
07f78     0C 50 05 F1 | 	add	fp, #12
07f7c     A8 1C C2 FA | 	rdbyte	local03, fp
07f80     0C 50 85 F1 | 	sub	fp, #12
07f84     04 1C CE F7 | 	test	local03, #4 wz
07f88     10 50 05 51 |  if_ne	add	fp, #16
07f8c     A8 10 68 5C |  if_ne	wrlong	#8, fp
07f90     10 50 85 51 |  if_ne	sub	fp, #16
07f94                 | LR__0518
07f94                 | LR__0519
07f94     10 50 05 F1 | 	add	fp, #16
07f98     A8 1C 0A FB | 	rdlong	local03, fp wz
07f9c     10 50 85 F1 | 	sub	fp, #16
07fa0     AC 01 90 5D |  if_ne	jmp	#LR__0524
07fa4     0C 50 05 F1 | 	add	fp, #12
07fa8     A8 1A C2 FA | 	rdbyte	local02, fp
07fac     0C 50 85 F1 | 	sub	fp, #12
07fb0     08 1A CE F7 | 	test	local02, #8 wz
07fb4     98 01 90 AD |  if_e	jmp	#LR__0524
07fb8     44 50 05 F1 | 	add	fp, #68
07fbc     A8 0E 02 FB | 	rdlong	arg01, fp
07fc0     14 50 85 F1 | 	sub	fp, #20
07fc4     A8 10 02 FB | 	rdlong	arg02, fp
07fc8     30 50 85 F1 | 	sub	fp, #48
07fcc     10 D5 BF FD | 	call	#_ff_cc_ld_clust_0259
07fd0     48 50 05 F1 | 	add	fp, #72
07fd4     A8 F4 61 FC | 	wrlong	result1, fp
07fd8     18 50 85 F1 | 	sub	fp, #24
07fdc     A8 0E 02 FB | 	rdlong	arg01, fp
07fe0     30 50 85 F1 | 	sub	fp, #48
07fe4     0E 0E 06 F1 | 	add	arg01, #14
07fe8     80 10 27 FF 
07fec     00 10 06 F6 | 	mov	arg02, ##1310785536
07ff0     A0 C3 BF FD | 	call	#_ff_cc_st_dword_0195
07ff4     30 50 05 F1 | 	add	fp, #48
07ff8     A8 1C 02 FB | 	rdlong	local03, fp
07ffc     0B 1C 06 F1 | 	add	local03, #11
08000     0E 41 48 FC | 	wrbyte	#32, local03
08004     14 50 05 F1 | 	add	fp, #20
08008     A8 0E 02 FB | 	rdlong	arg01, fp
0800c     14 50 85 F1 | 	sub	fp, #20
08010     A8 10 02 FB | 	rdlong	arg02, fp
08014     30 50 85 F1 | 	sub	fp, #48
08018     00 12 06 F6 | 	mov	arg03, #0
0801c     14 D5 BF FD | 	call	#_ff_cc_st_clust_0260
08020     30 50 05 F1 | 	add	fp, #48
08024     A8 0E 02 FB | 	rdlong	arg01, fp
08028     30 50 85 F1 | 	sub	fp, #48
0802c     1C 0E 06 F1 | 	add	arg01, #28
08030     00 10 06 F6 | 	mov	arg02, #0
08034     5C C3 BF FD | 	call	#_ff_cc_st_dword_0195
08038     44 50 05 F1 | 	add	fp, #68
0803c     A8 1C 02 FB | 	rdlong	local03, fp
08040     03 1C 06 F1 | 	add	local03, #3
08044     0E 03 48 FC | 	wrbyte	#1, local03
08048     04 50 05 F1 | 	add	fp, #4
0804c     A8 1C 0A FB | 	rdlong	local03, fp wz
08050     48 50 85 F1 | 	sub	fp, #72
08054     F8 00 90 AD |  if_e	jmp	#LR__0524
08058     44 50 05 F1 | 	add	fp, #68
0805c     A8 1C 02 FB | 	rdlong	local03, fp
08060     30 1C 06 F1 | 	add	local03, #48
08064     0E 1B 02 FB | 	rdlong	local02, local03
08068     10 50 05 F1 | 	add	fp, #16
0806c     A8 1A 62 FC | 	wrlong	local02, fp
08070     40 50 85 F1 | 	sub	fp, #64
08074     A8 0E 02 F6 | 	mov	arg01, fp
08078     34 50 05 F1 | 	add	fp, #52
0807c     A8 10 02 FB | 	rdlong	arg02, fp
08080     48 50 85 F1 | 	sub	fp, #72
08084     00 12 06 F6 | 	mov	arg03, #0
08088     3C CC BF FD | 	call	#_ff_cc_remove_chain_0234
0808c     10 50 05 F1 | 	add	fp, #16
08090     A8 F4 61 FC | 	wrlong	result1, fp
08094     FA 1C 0A F6 | 	mov	local03, result1 wz
08098     10 50 85 F1 | 	sub	fp, #16
0809c     B0 00 90 5D |  if_ne	jmp	#LR__0524
080a0     44 50 05 F1 | 	add	fp, #68
080a4     A8 0E 02 FB | 	rdlong	arg01, fp
080a8     10 50 05 F1 | 	add	fp, #16
080ac     A8 10 02 FB | 	rdlong	arg02, fp
080b0     54 50 85 F1 | 	sub	fp, #84
080b4     6C C5 BF FD | 	call	#_ff_cc_move_window_0218
080b8     10 50 05 F1 | 	add	fp, #16
080bc     A8 F4 61 FC | 	wrlong	result1, fp
080c0     34 50 05 F1 | 	add	fp, #52
080c4     A8 1C 02 FB | 	rdlong	local03, fp
080c8     04 50 05 F1 | 	add	fp, #4
080cc     A8 1A 02 FB | 	rdlong	local02, fp
080d0     48 50 85 F1 | 	sub	fp, #72
080d4     01 1A 86 F1 | 	sub	local02, #1
080d8     10 1C 06 F1 | 	add	local03, #16
080dc     0E 1B 62 FC | 	wrlong	local02, local03
080e0     6C 00 90 FD | 	jmp	#LR__0524
080e4                 | LR__0520
080e4     10 50 05 F1 | 	add	fp, #16
080e8     A8 1C 0A FB | 	rdlong	local03, fp wz
080ec     10 50 85 F1 | 	sub	fp, #16
080f0     5C 00 90 5D |  if_ne	jmp	#LR__0523
080f4     1A 50 05 F1 | 	add	fp, #26
080f8     A8 1C C2 FA | 	rdbyte	local03, fp
080fc     1A 50 85 F1 | 	sub	fp, #26
08100     10 1C CE F7 | 	test	local03, #16 wz
08104     10 50 05 51 |  if_ne	add	fp, #16
08108     A8 08 68 5C |  if_ne	wrlong	#4, fp
0810c     10 50 85 51 |  if_ne	sub	fp, #16
08110     3C 00 90 5D |  if_ne	jmp	#LR__0522
08114     0C 50 05 F1 | 	add	fp, #12
08118     A8 1E C2 FA | 	rdbyte	local04, fp
0811c     0C 50 85 F1 | 	sub	fp, #12
08120     0F 1D E2 F8 | 	getbyte	local03, local04, #0
08124     02 1C 0E F5 | 	and	local03, #2 wz
08128     24 00 90 AD |  if_e	jmp	#LR__0521
0812c     1A 50 05 F1 | 	add	fp, #26
08130     A8 18 C2 FA | 	rdbyte	local01, fp
08134     1A 50 85 F1 | 	sub	fp, #26
08138     0C 1B E2 F8 | 	getbyte	local02, local01, #0
0813c     01 1A 0E F5 | 	and	local02, #1 wz
08140     07 1C 06 56 |  if_ne	mov	local03, #7
08144     10 50 05 51 |  if_ne	add	fp, #16
08148     A8 0E 68 5C |  if_ne	wrlong	#7, fp
0814c     10 50 85 51 |  if_ne	sub	fp, #16
08150                 | LR__0521
08150                 | LR__0522
08150                 | LR__0523
08150                 | LR__0524
08150     10 50 05 F1 | 	add	fp, #16
08154     A8 1C 0A FB | 	rdlong	local03, fp wz
08158     10 50 85 F1 | 	sub	fp, #16
0815c     60 00 90 5D |  if_ne	jmp	#LR__0525
08160     0C 50 05 F1 | 	add	fp, #12
08164     A8 1C C2 FA | 	rdbyte	local03, fp
08168     0C 50 85 F1 | 	sub	fp, #12
0816c     08 1C CE F7 | 	test	local03, #8 wz
08170     0C 50 05 51 |  if_ne	add	fp, #12
08174     A8 1C C2 5A |  if_ne	rdbyte	local03, fp
08178     40 1C 46 55 |  if_ne	or	local03, #64
0817c     A8 1C 42 5C |  if_ne	wrbyte	local03, fp
08180     0C 50 85 51 |  if_ne	sub	fp, #12
08184     04 50 05 F1 | 	add	fp, #4
08188     A8 1C 02 FB | 	rdlong	local03, fp
0818c     40 50 05 F1 | 	add	fp, #64
08190     A8 1A 02 FB | 	rdlong	local02, fp
08194     30 1A 06 F1 | 	add	local02, #48
08198     0D 1F 02 FB | 	rdlong	local04, local02
0819c     20 1C 06 F1 | 	add	local03, #32
081a0     0E 1F 62 FC | 	wrlong	local04, local03
081a4     40 50 85 F1 | 	sub	fp, #64
081a8     A8 1C 02 FB | 	rdlong	local03, fp
081ac     2C 50 05 F1 | 	add	fp, #44
081b0     A8 1A 02 FB | 	rdlong	local02, fp
081b4     30 50 85 F1 | 	sub	fp, #48
081b8     24 1C 06 F1 | 	add	local03, #36
081bc     0E 1B 62 FC | 	wrlong	local02, local03
081c0                 | LR__0525
081c0     10 50 05 F1 | 	add	fp, #16
081c4     A8 1C 0A FB | 	rdlong	local03, fp wz
081c8     10 50 85 F1 | 	sub	fp, #16
081cc     DC 02 90 5D |  if_ne	jmp	#LR__0531
081d0     04 50 05 F1 | 	add	fp, #4
081d4     A8 1C 02 FB | 	rdlong	local03, fp
081d8     40 50 05 F1 | 	add	fp, #64
081dc     A8 0E 02 FB | 	rdlong	arg01, fp
081e0     14 50 85 F1 | 	sub	fp, #20
081e4     A8 10 02 FB | 	rdlong	arg02, fp
081e8     30 50 85 F1 | 	sub	fp, #48
081ec     F0 D2 BF FD | 	call	#_ff_cc_ld_clust_0259
081f0     08 1C 06 F1 | 	add	local03, #8
081f4     0E F5 61 FC | 	wrlong	result1, local03
081f8     04 50 05 F1 | 	add	fp, #4
081fc     A8 1C 02 FB | 	rdlong	local03, fp
08200     2C 50 05 F1 | 	add	fp, #44
08204     A8 0E 02 FB | 	rdlong	arg01, fp
08208     30 50 85 F1 | 	sub	fp, #48
0820c     1C 0E 06 F1 | 	add	arg01, #28
08210     24 C1 BF FD | 	call	#_ff_cc_ld_dword_0193
08214     0C 1C 06 F1 | 	add	local03, #12
08218     0E F5 61 FC | 	wrlong	result1, local03
0821c     04 50 05 F1 | 	add	fp, #4
08220     A8 1C 02 FB | 	rdlong	local03, fp
08224     40 50 05 F1 | 	add	fp, #64
08228     A8 1A 02 FB | 	rdlong	local02, fp
0822c     0E 1B 62 FC | 	wrlong	local02, local03
08230     40 50 85 F1 | 	sub	fp, #64
08234     A8 1C 02 FB | 	rdlong	local03, fp
08238     40 50 05 F1 | 	add	fp, #64
0823c     A8 1A 02 FB | 	rdlong	local02, fp
08240     06 1A 06 F1 | 	add	local02, #6
08244     0D 1F E2 FA | 	rdword	local04, local02
08248     04 1C 06 F1 | 	add	local03, #4
0824c     0E 1F 52 FC | 	wrword	local04, local03
08250     40 50 85 F1 | 	sub	fp, #64
08254     A8 1C 02 FB | 	rdlong	local03, fp
08258     08 50 05 F1 | 	add	fp, #8
0825c     A8 1A C2 FA | 	rdbyte	local02, fp
08260     10 1C 06 F1 | 	add	local03, #16
08264     0E 1B 42 FC | 	wrbyte	local02, local03
08268     08 50 85 F1 | 	sub	fp, #8
0826c     A8 1C 02 FB | 	rdlong	local03, fp
08270     11 1C 06 F1 | 	add	local03, #17
08274     0E 01 48 FC | 	wrbyte	#0, local03
08278     A8 1C 02 FB | 	rdlong	local03, fp
0827c     1C 1C 06 F1 | 	add	local03, #28
08280     0E 01 68 FC | 	wrlong	#0, local03
08284     A8 1C 02 FB | 	rdlong	local03, fp
08288     14 1C 06 F1 | 	add	local03, #20
0828c     0E 01 68 FC | 	wrlong	#0, local03
08290     08 50 05 F1 | 	add	fp, #8
08294     A8 1C C2 FA | 	rdbyte	local03, fp
08298     0C 50 85 F1 | 	sub	fp, #12
0829c     20 1C CE F7 | 	test	local03, #32 wz
082a0     08 02 90 AD |  if_e	jmp	#LR__0530
082a4     04 50 05 F1 | 	add	fp, #4
082a8     A8 1A 02 FB | 	rdlong	local02, fp
082ac     04 50 85 F1 | 	sub	fp, #4
082b0     0C 1A 06 F1 | 	add	local02, #12
082b4     0D 21 02 FB | 	rdlong	local05, local02
082b8     01 20 16 F2 | 	cmp	local05, #1 wc
082bc     EC 01 90 CD |  if_b	jmp	#LR__0530
082c0     04 50 05 F1 | 	add	fp, #4
082c4     A8 1A 02 FB | 	rdlong	local02, fp
082c8     0D 1D 02 F6 | 	mov	local03, local02
082cc     0C 1A 06 F1 | 	add	local02, #12
082d0     0D 1F 02 FB | 	rdlong	local04, local02
082d4     14 1C 06 F1 | 	add	local03, #20
082d8     0E 1F 62 FC | 	wrlong	local04, local03
082dc     40 50 05 F1 | 	add	fp, #64
082e0     A8 1E 02 FB | 	rdlong	local04, fp
082e4     0A 1E 06 F1 | 	add	local04, #10
082e8     0F 1D E2 FA | 	rdword	local03, local04
082ec     09 1C 66 F0 | 	shl	local03, #9
082f0     08 50 05 F1 | 	add	fp, #8
082f4     A8 1C 62 FC | 	wrlong	local03, fp
082f8     48 50 85 F1 | 	sub	fp, #72
082fc     A8 1C 02 FB | 	rdlong	local03, fp
08300     08 1C 06 F1 | 	add	local03, #8
08304     0E 1B 02 FB | 	rdlong	local02, local03
08308     4C 50 05 F1 | 	add	fp, #76
0830c     A8 1A 62 FC | 	wrlong	local02, fp
08310                 | ' 				fp->fptr = fp->obj.objsize;
08310                 | ' 				bcs = (DWORD)fs->csize *  ((UINT) 512 ) ;
08310                 | ' 				clst = fp->obj.sclust;
08310                 | ' 				for (ofs = fp->obj.objsize; res == FR_OK && ofs > bcs; ofs -= bcs) {
08310     4C 50 85 F1 | 	sub	fp, #76
08314     A8 1C 02 FB | 	rdlong	local03, fp
08318     0C 1C 06 F1 | 	add	local03, #12
0831c     0E 1B 02 FB | 	rdlong	local02, local03
08320     54 50 05 F1 | 	add	fp, #84
08324     A8 1A 62 FC | 	wrlong	local02, fp
08328     58 50 85 F1 | 	sub	fp, #88
0832c                 | LR__0526
0832c     10 50 05 F1 | 	add	fp, #16
08330     A8 22 02 FB | 	rdlong	local06, fp
08334     10 50 85 F1 | 	sub	fp, #16
08338     11 19 0A F6 | 	mov	local01, local06 wz
0833c     A4 00 90 5D |  if_ne	jmp	#LR__0527
08340     58 50 05 F1 | 	add	fp, #88
08344     A8 24 02 FB | 	rdlong	local07, fp
08348     12 21 02 F6 | 	mov	local05, local07
0834c     0C 50 85 F1 | 	sub	fp, #12
08350     A8 26 02 FB | 	rdlong	local08, fp
08354     4C 50 85 F1 | 	sub	fp, #76
08358     13 29 02 F6 | 	mov	local09, local08
0835c     14 21 1A F2 | 	cmp	local05, local09 wcz
08360     80 00 90 ED |  if_be	jmp	#LR__0527
08364     04 50 05 F1 | 	add	fp, #4
08368     A8 0E 02 FB | 	rdlong	arg01, fp
0836c     4C 50 05 F1 | 	add	fp, #76
08370     A8 10 02 FB | 	rdlong	arg02, fp
08374     50 50 85 F1 | 	sub	fp, #80
08378     C8 C4 BF FD | 	call	#_ff_cc_get_fat_0226
0837c     50 50 05 F1 | 	add	fp, #80
08380     A8 F4 61 FC | 	wrlong	result1, fp
08384     50 50 85 F1 | 	sub	fp, #80
08388     02 F4 15 F2 | 	cmp	result1, #2 wc
0838c     10 50 05 C1 |  if_b	add	fp, #16
08390     A8 04 68 CC |  if_b	wrlong	#2, fp
08394     10 50 85 C1 |  if_b	sub	fp, #16
08398     50 50 05 F1 | 	add	fp, #80
0839c     A8 22 02 FB | 	rdlong	local06, fp
083a0     50 50 85 F1 | 	sub	fp, #80
083a4     FF FF 7F FF 
083a8     FF 23 0E F2 | 	cmp	local06, ##-1 wz
083ac     10 50 05 A1 |  if_e	add	fp, #16
083b0     A8 02 68 AC |  if_e	wrlong	#1, fp
083b4     10 50 85 A1 |  if_e	sub	fp, #16
083b8     58 50 05 F1 | 	add	fp, #88
083bc     A8 2A 02 FB | 	rdlong	local10, fp
083c0     15 2D 02 F6 | 	mov	local11, local10
083c4     0C 50 85 F1 | 	sub	fp, #12
083c8     A8 2E 02 FB | 	rdlong	local12, fp
083cc     17 31 02 F6 | 	mov	local13, local12
083d0     18 2D 82 F1 | 	sub	local11, local13
083d4     0C 50 05 F1 | 	add	fp, #12
083d8     A8 2C 62 FC | 	wrlong	local11, fp
083dc     58 50 85 F1 | 	sub	fp, #88
083e0     48 FF 9F FD | 	jmp	#LR__0526
083e4                 | LR__0527
083e4     04 50 05 F1 | 	add	fp, #4
083e8     A8 1C 02 FB | 	rdlong	local03, fp
083ec     4C 50 05 F1 | 	add	fp, #76
083f0     A8 1A 02 FB | 	rdlong	local02, fp
083f4     18 1C 06 F1 | 	add	local03, #24
083f8     0E 1B 62 FC | 	wrlong	local02, local03
083fc     40 50 85 F1 | 	sub	fp, #64
08400     A8 1E 02 FB | 	rdlong	local04, fp
08404     10 50 85 F1 | 	sub	fp, #16
08408     0F 1D 0A F6 | 	mov	local03, local04 wz
0840c     9C 00 90 5D |  if_ne	jmp	#LR__0529
08410     58 50 05 F1 | 	add	fp, #88
08414     A8 22 02 FB | 	rdlong	local06, fp
08418     58 50 85 F1 | 	sub	fp, #88
0841c     11 19 02 F6 | 	mov	local01, local06
08420     0C 1B 02 F6 | 	mov	local02, local01
08424     FF 1B 0E F5 | 	and	local02, #511 wz
08428     80 00 90 AD |  if_e	jmp	#LR__0529
0842c     44 50 05 F1 | 	add	fp, #68
08430     A8 0E 02 FB | 	rdlong	arg01, fp
08434     0C 50 05 F1 | 	add	fp, #12
08438     A8 1A 02 FB | 	rdlong	local02, fp
0843c     50 50 85 F1 | 	sub	fp, #80
08440     0D 11 02 F6 | 	mov	arg02, local02
08444     BC C3 BF FD | 	call	#_ff_cc_clst2sect_0221
08448     54 50 05 F1 | 	add	fp, #84
0844c     A8 F4 61 FC | 	wrlong	result1, fp
08450     FA 1E 0A F6 | 	mov	local04, result1 wz
08454     54 50 85 F1 | 	sub	fp, #84
08458     02 1C 06 A6 |  if_e	mov	local03, #2
0845c     10 50 05 A1 |  if_e	add	fp, #16
08460     A8 04 68 AC |  if_e	wrlong	#2, fp
08464     10 50 85 A1 |  if_e	sub	fp, #16
08468     40 00 90 AD |  if_e	jmp	#LR__0528
0846c     04 50 05 F1 | 	add	fp, #4
08470     A8 1E 02 FB | 	rdlong	local04, fp
08474     0F 1D 02 F6 | 	mov	local03, local04
08478     50 50 05 F1 | 	add	fp, #80
0847c     A8 18 02 FB | 	rdlong	local01, fp
08480     0C 1B 02 F6 | 	mov	local02, local01
08484     04 50 05 F1 | 	add	fp, #4
08488     A8 24 02 FB | 	rdlong	local07, fp
0848c     58 50 85 F1 | 	sub	fp, #88
08490     12 21 02 F6 | 	mov	local05, local07
08494     10 23 02 F6 | 	mov	local06, local05
08498     09 22 46 F0 | 	shr	local06, #9
0849c     11 1B 02 F1 | 	add	local02, local06
084a0     1C 1C 06 F1 | 	add	local03, #28
084a4     0E 1B 62 FC | 	wrlong	local02, local03
084a8     1C 1C 86 F1 | 	sub	local03, #28
084ac                 | LR__0528
084ac                 | LR__0529
084ac                 | LR__0530
084ac                 | LR__0531
084ac                 | LR__0532
084ac     10 50 05 F1 | 	add	fp, #16
084b0     A8 1C 0A FB | 	rdlong	local03, fp wz
084b4     10 50 85 F1 | 	sub	fp, #16
084b8     04 50 05 51 |  if_ne	add	fp, #4
084bc     A8 1C 02 5B |  if_ne	rdlong	local03, fp
084c0     04 50 85 51 |  if_ne	sub	fp, #4
084c4     0E 01 68 5C |  if_ne	wrlong	#0, local03
084c8                 | ' 
084c8                 | ' 	return res ;
084c8     10 50 05 F1 | 	add	fp, #16
084cc     A8 F4 01 FB | 	rdlong	result1, fp
084d0     10 50 85 F1 | 	sub	fp, #16
084d4                 | LR__0533
084d4     A8 F0 03 F6 | 	mov	ptra, fp
084d8     B3 00 A0 FD | 	call	#popregs_
084dc                 | _ff_cc_f_open_ret
084dc     2D 00 64 FD | 	ret
084e0                 | 
084e0                 | _ff_cc_f_read
084e0     19 4C 05 F6 | 	mov	COUNT_, #25
084e4     A9 00 A0 FD | 	call	#pushregs_
084e8     38 F0 07 F1 | 	add	ptra, #56
084ec     04 50 05 F1 | 	add	fp, #4
084f0     A8 0E 62 FC | 	wrlong	arg01, fp
084f4     04 50 05 F1 | 	add	fp, #4
084f8     A8 10 62 FC | 	wrlong	arg02, fp
084fc     04 50 05 F1 | 	add	fp, #4
08500     A8 12 62 FC | 	wrlong	arg03, fp
08504     04 50 05 F1 | 	add	fp, #4
08508     A8 14 62 FC | 	wrlong	arg04, fp
0850c     18 50 05 F1 | 	add	fp, #24
08510     A8 00 68 FC | 	wrlong	#0, fp
08514     20 50 85 F1 | 	sub	fp, #32
08518     A8 F4 01 FB | 	rdlong	result1, fp
0851c     2C 50 05 F1 | 	add	fp, #44
08520     A8 F4 61 FC | 	wrlong	result1, fp
08524     24 50 85 F1 | 	sub	fp, #36
08528     A8 F4 01 FB | 	rdlong	result1, fp
0852c     FA 00 68 FC | 	wrlong	#0, result1
08530     0C 50 85 F1 | 	sub	fp, #12
08534     A8 0E 02 FB | 	rdlong	arg01, fp
08538     14 50 05 F1 | 	add	fp, #20
0853c     A8 10 02 F6 | 	mov	arg02, fp
08540     18 50 85 F1 | 	sub	fp, #24
08544     0C F7 BF FD | 	call	#_ff_cc_validate_0357
08548     14 50 05 F1 | 	add	fp, #20
0854c     A8 F4 61 FC | 	wrlong	result1, fp
08550     FA 10 0A F6 | 	mov	arg02, result1 wz
08554     14 50 85 F1 | 	sub	fp, #20
08558     28 00 90 5D |  if_ne	jmp	#LR__0534
0855c     04 50 05 F1 | 	add	fp, #4
08560     A8 10 02 FB | 	rdlong	arg02, fp
08564     11 10 06 F1 | 	add	arg02, #17
08568     08 19 C2 FA | 	rdbyte	local01, arg02
0856c     0C 11 E2 F8 | 	getbyte	arg02, local01, #0
08570     10 50 05 F1 | 	add	fp, #16
08574     A8 10 62 FC | 	wrlong	arg02, fp
08578     14 50 85 F1 | 	sub	fp, #20
0857c     08 11 0A F6 | 	mov	arg02, arg02 wz
08580     10 00 90 AD |  if_e	jmp	#LR__0535
08584                 | LR__0534
08584     14 50 05 F1 | 	add	fp, #20
08588     A8 F4 01 FB | 	rdlong	result1, fp
0858c     14 50 85 F1 | 	sub	fp, #20
08590     54 05 90 FD | 	jmp	#LR__0551
08594                 | LR__0535
08594     04 50 05 F1 | 	add	fp, #4
08598     A8 10 02 FB | 	rdlong	arg02, fp
0859c     04 50 85 F1 | 	sub	fp, #4
085a0     10 10 06 F1 | 	add	arg02, #16
085a4     08 11 C2 FA | 	rdbyte	arg02, arg02
085a8     01 10 CE F7 | 	test	arg02, #1 wz
085ac     07 F4 05 A6 |  if_e	mov	result1, #7
085b0     34 05 90 AD |  if_e	jmp	#LR__0551
085b4     04 50 05 F1 | 	add	fp, #4
085b8     A8 1A 02 FB | 	rdlong	local02, fp
085bc     0D 1D 02 F6 | 	mov	local03, local02
085c0     0C 1C 06 F1 | 	add	local03, #12
085c4     0E 1F 02 FB | 	rdlong	local04, local03
085c8     14 1A 06 F1 | 	add	local02, #20
085cc     0D 21 02 FB | 	rdlong	local05, local02
085d0     10 1F 82 F1 | 	sub	local04, local05
085d4     20 50 05 F1 | 	add	fp, #32
085d8     A8 1E 62 FC | 	wrlong	local04, fp
085dc     18 50 85 F1 | 	sub	fp, #24
085e0     A8 22 02 FB | 	rdlong	local06, fp
085e4     0C 50 85 F1 | 	sub	fp, #12
085e8     0F 23 1A F2 | 	cmp	local06, local04 wcz
085ec     24 50 05 11 |  if_a	add	fp, #36
085f0     A8 22 02 1B |  if_a	rdlong	local06, fp
085f4     18 50 85 11 |  if_a	sub	fp, #24
085f8     A8 22 62 1C |  if_a	wrlong	local06, fp
085fc     0C 50 85 11 |  if_a	sub	fp, #12
08600                 | ' 
08600                 | ' 	for ( ; btr;
08600                 | LR__0536
08600     0C 50 05 F1 | 	add	fp, #12
08604     A8 1C 02 FB | 	rdlong	local03, fp
08608     0C 50 85 F1 | 	sub	fp, #12
0860c     0E 23 0A F6 | 	mov	local06, local03 wz
08610     D0 04 90 AD |  if_e	jmp	#LR__0550
08614     04 50 05 F1 | 	add	fp, #4
08618     A8 1E 02 FB | 	rdlong	local04, fp
0861c     04 50 85 F1 | 	sub	fp, #4
08620     14 1E 06 F1 | 	add	local04, #20
08624     0F 1F 02 FB | 	rdlong	local04, local04
08628     FF 1F CE F7 | 	test	local04, #511 wz
0862c     44 03 90 5D |  if_ne	jmp	#LR__0547
08630     04 50 05 F1 | 	add	fp, #4
08634     A8 1A 02 FB | 	rdlong	local02, fp
08638     14 1A 06 F1 | 	add	local02, #20
0863c     0D 1F 02 FB | 	rdlong	local04, local02
08640     09 1E 46 F0 | 	shr	local04, #9
08644     14 50 05 F1 | 	add	fp, #20
08648     A8 24 02 FB | 	rdlong	local07, fp
0864c     12 27 02 F6 | 	mov	local08, local07
08650     0A 26 06 F1 | 	add	local08, #10
08654     13 29 E2 FA | 	rdword	local09, local08
08658     0A 26 86 F1 | 	sub	local08, #10
0865c     14 2B 32 F9 | 	getword	local10, local09, #0
08660     01 2A 86 F1 | 	sub	local10, #1
08664     15 1F 0A F5 | 	and	local04, local10 wz
08668     18 50 05 F1 | 	add	fp, #24
0866c     A8 1E 62 FC | 	wrlong	local04, fp
08670     30 50 85 F1 | 	sub	fp, #48
08674     E0 00 90 5D |  if_ne	jmp	#LR__0541
08678     04 50 05 F1 | 	add	fp, #4
0867c     A8 1E 02 FB | 	rdlong	local04, fp
08680     04 50 85 F1 | 	sub	fp, #4
08684     14 1E 06 F1 | 	add	local04, #20
08688     0F 1F 0A FB | 	rdlong	local04, local04 wz
0868c     20 00 90 5D |  if_ne	jmp	#LR__0537
08690     04 50 05 F1 | 	add	fp, #4
08694     A8 1E 02 FB | 	rdlong	local04, fp
08698     08 1E 06 F1 | 	add	local04, #8
0869c     0F 1F 02 FB | 	rdlong	local04, local04
086a0     18 50 05 F1 | 	add	fp, #24
086a4     A8 1E 62 FC | 	wrlong	local04, fp
086a8     1C 50 85 F1 | 	sub	fp, #28
086ac     28 00 90 FD | 	jmp	#LR__0538
086b0                 | LR__0537
086b0     04 50 05 F1 | 	add	fp, #4
086b4     A8 1E 02 FB | 	rdlong	local04, fp
086b8     0F 0F 02 F6 | 	mov	arg01, local04
086bc     04 50 85 F1 | 	sub	fp, #4
086c0     18 1E 06 F1 | 	add	local04, #24
086c4     0F 11 02 FB | 	rdlong	arg02, local04
086c8     78 C1 BF FD | 	call	#_ff_cc_get_fat_0226
086cc     1C 50 05 F1 | 	add	fp, #28
086d0     A8 F4 61 FC | 	wrlong	result1, fp
086d4     1C 50 85 F1 | 	sub	fp, #28
086d8                 | LR__0538
086d8     1C 50 05 F1 | 	add	fp, #28
086dc     A8 1E 02 FB | 	rdlong	local04, fp
086e0     1C 50 85 F1 | 	sub	fp, #28
086e4     02 1E 16 F2 | 	cmp	local04, #2 wc
086e8     1C 00 90 3D |  if_ae	jmp	#LR__0539
086ec     04 50 05 F1 | 	add	fp, #4
086f0     A8 1E 02 FB | 	rdlong	local04, fp
086f4     04 50 85 F1 | 	sub	fp, #4
086f8     11 1E 06 F1 | 	add	local04, #17
086fc     0F 05 48 FC | 	wrbyte	#2, local04
08700     02 F4 05 F6 | 	mov	result1, #2
08704     E0 03 90 FD | 	jmp	#LR__0551
08708                 | LR__0539
08708     1C 50 05 F1 | 	add	fp, #28
0870c     A8 1E 02 FB | 	rdlong	local04, fp
08710     1C 50 85 F1 | 	sub	fp, #28
08714     FF FF 7F FF 
08718     FF 1F 0E F2 | 	cmp	local04, ##-1 wz
0871c     1C 00 90 5D |  if_ne	jmp	#LR__0540
08720     04 50 05 F1 | 	add	fp, #4
08724     A8 1E 02 FB | 	rdlong	local04, fp
08728     04 50 85 F1 | 	sub	fp, #4
0872c     11 1E 06 F1 | 	add	local04, #17
08730     0F 03 48 FC | 	wrbyte	#1, local04
08734     01 F4 05 F6 | 	mov	result1, #1
08738     AC 03 90 FD | 	jmp	#LR__0551
0873c                 | LR__0540
0873c     04 50 05 F1 | 	add	fp, #4
08740     A8 1E 02 FB | 	rdlong	local04, fp
08744     18 50 05 F1 | 	add	fp, #24
08748     A8 2A 02 FB | 	rdlong	local10, fp
0874c     1C 50 85 F1 | 	sub	fp, #28
08750     18 1E 06 F1 | 	add	local04, #24
08754     0F 2B 62 FC | 	wrlong	local10, local04
08758                 | LR__0541
08758     18 50 05 F1 | 	add	fp, #24
0875c     A8 0E 02 FB | 	rdlong	arg01, fp
08760     14 50 85 F1 | 	sub	fp, #20
08764     A8 1E 02 FB | 	rdlong	local04, fp
08768     04 50 85 F1 | 	sub	fp, #4
0876c     18 1E 06 F1 | 	add	local04, #24
08770     0F 11 02 FB | 	rdlong	arg02, local04
08774     8C C0 BF FD | 	call	#_ff_cc_clst2sect_0221
08778     20 50 05 F1 | 	add	fp, #32
0877c     A8 F4 61 FC | 	wrlong	result1, fp
08780     20 50 85 F1 | 	sub	fp, #32
08784     00 F4 0D F2 | 	cmp	result1, #0 wz
08788     1C 00 90 5D |  if_ne	jmp	#LR__0542
0878c     04 50 05 F1 | 	add	fp, #4
08790     A8 1E 02 FB | 	rdlong	local04, fp
08794     04 50 85 F1 | 	sub	fp, #4
08798     11 1E 06 F1 | 	add	local04, #17
0879c     0F 05 48 FC | 	wrbyte	#2, local04
087a0     02 F4 05 F6 | 	mov	result1, #2
087a4     40 03 90 FD | 	jmp	#LR__0551
087a8                 | LR__0542
087a8     20 50 05 F1 | 	add	fp, #32
087ac     A8 1E 02 FB | 	rdlong	local04, fp
087b0     10 50 05 F1 | 	add	fp, #16
087b4     A8 2A 02 FB | 	rdlong	local10, fp
087b8     15 1F 02 F1 | 	add	local04, local10
087bc     10 50 85 F1 | 	sub	fp, #16
087c0     A8 1E 62 FC | 	wrlong	local04, fp
087c4     14 50 85 F1 | 	sub	fp, #20
087c8     A8 1E 02 FB | 	rdlong	local04, fp
087cc     09 1E 46 F0 | 	shr	local04, #9
087d0     20 50 05 F1 | 	add	fp, #32
087d4     A8 1E 62 FC | 	wrlong	local04, fp
087d8     2C 50 85 F1 | 	sub	fp, #44
087dc     01 1E 16 F2 | 	cmp	local04, #1 wc
087e0     74 01 90 CD |  if_b	jmp	#LR__0546
087e4     30 50 05 F1 | 	add	fp, #48
087e8     A8 1E 02 FB | 	rdlong	local04, fp
087ec     04 50 85 F1 | 	sub	fp, #4
087f0     A8 2A 02 FB | 	rdlong	local10, fp
087f4     15 1F 02 F1 | 	add	local04, local10
087f8     14 50 85 F1 | 	sub	fp, #20
087fc     A8 2A 02 FB | 	rdlong	local10, fp
08800     18 50 85 F1 | 	sub	fp, #24
08804     0A 2A 06 F1 | 	add	local10, #10
08808     15 21 E2 FA | 	rdword	local05, local10
0880c     10 1F 1A F2 | 	cmp	local04, local05 wcz
08810     28 00 90 ED |  if_be	jmp	#LR__0543
08814     18 50 05 F1 | 	add	fp, #24
08818     A8 1A 02 FB | 	rdlong	local02, fp
0881c     0A 1A 06 F1 | 	add	local02, #10
08820     0D 1F E2 FA | 	rdword	local04, local02
08824     18 50 05 F1 | 	add	fp, #24
08828     A8 20 02 FB | 	rdlong	local05, fp
0882c     10 1F 82 F1 | 	sub	local04, local05
08830     04 50 85 F1 | 	sub	fp, #4
08834     A8 1E 62 FC | 	wrlong	local04, fp
08838     2C 50 85 F1 | 	sub	fp, #44
0883c                 | LR__0543
0883c     18 50 05 F1 | 	add	fp, #24
08840     A8 1A 02 FB | 	rdlong	local02, fp
08844     01 1A 06 F1 | 	add	local02, #1
08848     0D 0F C2 FA | 	rdbyte	arg01, local02
0884c     1C 50 05 F1 | 	add	fp, #28
08850     A8 10 02 FB | 	rdlong	arg02, fp
08854     14 50 85 F1 | 	sub	fp, #20
08858     A8 12 02 FB | 	rdlong	arg03, fp
0885c     0C 50 05 F1 | 	add	fp, #12
08860     A8 14 02 FB | 	rdlong	arg04, fp
08864     2C 50 85 F1 | 	sub	fp, #44
08868     30 B6 BF FD | 	call	#_ff_cc_disk_read
0886c     00 F4 0D F2 | 	cmp	result1, #0 wz
08870     1C 00 90 AD |  if_e	jmp	#LR__0544
08874     04 50 05 F1 | 	add	fp, #4
08878     A8 1E 02 FB | 	rdlong	local04, fp
0887c     04 50 85 F1 | 	sub	fp, #4
08880     11 1E 06 F1 | 	add	local04, #17
08884     0F 03 48 FC | 	wrbyte	#1, local04
08888     01 F4 05 F6 | 	mov	result1, #1
0888c     58 02 90 FD | 	jmp	#LR__0551
08890                 | LR__0544
08890     18 50 05 F1 | 	add	fp, #24
08894     A8 1E 02 FB | 	rdlong	local04, fp
08898     18 50 85 F1 | 	sub	fp, #24
0889c     03 1E 06 F1 | 	add	local04, #3
088a0     0F 2D CA FA | 	rdbyte	local11, local04 wz
088a4     94 00 90 AD |  if_e	jmp	#LR__0545
088a8     18 50 05 F1 | 	add	fp, #24
088ac     A8 2A 02 FB | 	rdlong	local10, fp
088b0     30 2A 06 F1 | 	add	local10, #48
088b4     15 21 02 FB | 	rdlong	local05, local10
088b8     08 50 05 F1 | 	add	fp, #8
088bc     A8 28 02 FB | 	rdlong	local09, fp
088c0     14 21 82 F1 | 	sub	local05, local09
088c4     0C 50 05 F1 | 	add	fp, #12
088c8     A8 2E 02 FB | 	rdlong	local12, fp
088cc     2C 50 85 F1 | 	sub	fp, #44
088d0     17 21 12 F2 | 	cmp	local05, local12 wc
088d4     64 00 90 3D |  if_ae	jmp	#LR__0545
088d8     34 50 05 F1 | 	add	fp, #52
088dc     A8 1E 02 FB | 	rdlong	local04, fp
088e0     1C 50 85 F1 | 	sub	fp, #28
088e4     A8 2A 02 FB | 	rdlong	local10, fp
088e8     15 21 02 F6 | 	mov	local05, local10
088ec     30 20 06 F1 | 	add	local05, #48
088f0     10 27 02 FB | 	rdlong	local08, local05
088f4     13 31 02 F6 | 	mov	local13, local08
088f8     08 50 05 F1 | 	add	fp, #8
088fc     A8 28 02 FB | 	rdlong	local09, fp
08900     14 25 02 F6 | 	mov	local07, local09
08904     12 31 82 F1 | 	sub	local13, local07
08908     09 30 66 F0 | 	shl	local13, #9
0890c     18 33 02 F6 | 	mov	local14, local13
08910     18 1F 02 F1 | 	add	local04, local13
08914     15 19 02 F6 | 	mov	local01, local10
08918     20 50 85 F1 | 	sub	fp, #32
0891c     0C 21 02 F6 | 	mov	local05, local01
08920     34 20 06 F1 | 	add	local05, #52
08924     10 1B 02 F6 | 	mov	local02, local05
08928     09 2C C6 F9 | 	decod	local11, #9
0892c     0F 0F 02 F6 | 	mov	arg01, local04
08930     0D 11 02 F6 | 	mov	arg02, local02
08934     09 12 C6 F9 | 	decod	arg03, #9
08938     84 BA BF FD | 	call	#_ff_cc_mem_cpy_0198
0893c                 | LR__0545
0893c     2C 50 05 F1 | 	add	fp, #44
08940     A8 1E 02 FB | 	rdlong	local04, fp
08944     09 1E 66 F0 | 	shl	local04, #9
08948     04 50 85 F1 | 	sub	fp, #4
0894c     A8 1E 62 FC | 	wrlong	local04, fp
08950     28 50 85 F1 | 	sub	fp, #40
08954                 | ' 					mem_cpy(rbuff + ((fs->winsect - sect) *  ((UINT) 512 ) ), fs->win,  ((UINT) 512 ) );
08954                 | ' 				}
08954                 | ' #line 3977 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
08954                 | ' 				rcnt =  ((UINT) 512 )  * cc;
08954                 | ' 				continue;
08954     E4 00 90 FD | 	jmp	#LR__0549
08958                 | LR__0546
08958     04 50 05 F1 | 	add	fp, #4
0895c     A8 1E 02 FB | 	rdlong	local04, fp
08960     1C 50 05 F1 | 	add	fp, #28
08964     A8 2C 02 FB | 	rdlong	local11, fp
08968     20 50 85 F1 | 	sub	fp, #32
0896c     1C 1E 06 F1 | 	add	local04, #28
08970     0F 2D 62 FC | 	wrlong	local11, local04
08974                 | LR__0547
08974     04 50 05 F1 | 	add	fp, #4
08978     A8 1A 02 FB | 	rdlong	local02, fp
0897c     14 1A 06 F1 | 	add	local02, #20
08980     0D 19 02 FB | 	rdlong	local01, local02
08984     FF 19 06 F5 | 	and	local01, #511
08988     09 1E C6 F9 | 	decod	local04, #9
0898c     0C 1F 82 F1 | 	sub	local04, local01
08990     24 50 05 F1 | 	add	fp, #36
08994     A8 1E 62 FC | 	wrlong	local04, fp
08998     1C 50 85 F1 | 	sub	fp, #28
0899c     A8 2C 02 FB | 	rdlong	local11, fp
089a0     0C 50 85 F1 | 	sub	fp, #12
089a4     16 1F 1A F2 | 	cmp	local04, local11 wcz
089a8     0C 50 05 11 |  if_a	add	fp, #12
089ac     A8 1E 02 1B |  if_a	rdlong	local04, fp
089b0     1C 50 05 11 |  if_a	add	fp, #28
089b4     A8 1E 62 1C |  if_a	wrlong	local04, fp
089b8     28 50 85 11 |  if_a	sub	fp, #40
089bc     18 50 05 F1 | 	add	fp, #24
089c0     A8 0E 02 FB | 	rdlong	arg01, fp
089c4     14 50 85 F1 | 	sub	fp, #20
089c8     A8 2C 02 FB | 	rdlong	local11, fp
089cc     04 50 85 F1 | 	sub	fp, #4
089d0     1C 2C 06 F1 | 	add	local11, #28
089d4     16 11 02 FB | 	rdlong	arg02, local11
089d8     48 BC BF FD | 	call	#_ff_cc_move_window_0218
089dc     00 F4 0D F2 | 	cmp	result1, #0 wz
089e0     1C 00 90 AD |  if_e	jmp	#LR__0548
089e4     04 50 05 F1 | 	add	fp, #4
089e8     A8 1E 02 FB | 	rdlong	local04, fp
089ec     04 50 85 F1 | 	sub	fp, #4
089f0     11 1E 06 F1 | 	add	local04, #17
089f4     0F 03 48 FC | 	wrbyte	#1, local04
089f8     01 F4 05 F6 | 	mov	result1, #1
089fc     E8 00 90 FD | 	jmp	#LR__0551
08a00                 | LR__0548
08a00     34 50 05 F1 | 	add	fp, #52
08a04     A8 0E 02 FB | 	rdlong	arg01, fp
08a08     1C 50 85 F1 | 	sub	fp, #28
08a0c     A8 10 02 FB | 	rdlong	arg02, fp
08a10     34 10 06 F1 | 	add	arg02, #52
08a14     14 50 85 F1 | 	sub	fp, #20
08a18     A8 26 02 FB | 	rdlong	local08, fp
08a1c     14 26 06 F1 | 	add	local08, #20
08a20     13 2F 02 FB | 	rdlong	local12, local08
08a24     FF 2F 06 F5 | 	and	local12, #511
08a28     17 11 02 F1 | 	add	arg02, local12
08a2c     24 50 05 F1 | 	add	fp, #36
08a30     A8 12 02 FB | 	rdlong	arg03, fp
08a34     28 50 85 F1 | 	sub	fp, #40
08a38     84 B9 BF FD | 	call	#_ff_cc_mem_cpy_0198
08a3c                 | LR__0549
08a3c     0C 50 05 F1 | 	add	fp, #12
08a40     A8 1E 02 FB | 	rdlong	local04, fp
08a44     1C 50 05 F1 | 	add	fp, #28
08a48     A8 18 02 FB | 	rdlong	local01, fp
08a4c     0C 1F 82 F1 | 	sub	local04, local01
08a50     1C 50 85 F1 | 	sub	fp, #28
08a54     A8 1E 62 FC | 	wrlong	local04, fp
08a58     04 50 05 F1 | 	add	fp, #4
08a5c     A8 24 02 FB | 	rdlong	local07, fp
08a60     12 27 02 FB | 	rdlong	local08, local07
08a64     18 50 05 F1 | 	add	fp, #24
08a68     A8 32 02 FB | 	rdlong	local14, fp
08a6c     19 31 02 F6 | 	mov	local13, local14
08a70     19 27 02 F1 | 	add	local08, local14
08a74     12 27 62 FC | 	wrlong	local08, local07
08a78     0C 50 05 F1 | 	add	fp, #12
08a7c     A8 34 02 FB | 	rdlong	local15, fp
08a80     1A 2F 02 F6 | 	mov	local12, local15
08a84     0C 50 85 F1 | 	sub	fp, #12
08a88     A8 36 02 FB | 	rdlong	local16, fp
08a8c     1B 39 02 F6 | 	mov	local17, local16
08a90     1B 2F 02 F1 | 	add	local12, local16
08a94     0C 50 05 F1 | 	add	fp, #12
08a98     A8 2E 62 FC | 	wrlong	local12, fp
08a9c     30 50 85 F1 | 	sub	fp, #48
08aa0     A8 3A 02 FB | 	rdlong	local18, fp
08aa4     1D 3D 02 F6 | 	mov	local19, local18
08aa8     1D 3F 02 F6 | 	mov	local20, local18
08aac     1F 41 02 F6 | 	mov	local21, local20
08ab0     14 40 06 F1 | 	add	local21, #20
08ab4     20 43 02 FB | 	rdlong	local22, local21
08ab8     14 40 86 F1 | 	sub	local21, #20
08abc     21 45 02 F6 | 	mov	local23, local22
08ac0     24 50 05 F1 | 	add	fp, #36
08ac4     A8 46 02 FB | 	rdlong	local24, fp
08ac8     28 50 85 F1 | 	sub	fp, #40
08acc     23 49 02 F6 | 	mov	local25, local24
08ad0     23 45 02 F1 | 	add	local23, local24
08ad4     14 3C 06 F1 | 	add	local19, #20
08ad8     1E 45 62 FC | 	wrlong	local23, local19
08adc     14 3C 86 F1 | 	sub	local19, #20
08ae0     1C FB 9F FD | 	jmp	#LR__0536
08ae4                 | LR__0550
08ae4                 | ' 		mem_cpy(rbuff, fs->win + fp->fptr %  ((UINT) 512 ) , rcnt);
08ae4                 | ' #line 4001 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
08ae4                 | ' 	}
08ae4                 | ' 
08ae4                 | ' 	return FR_OK ;
08ae4     00 F4 05 F6 | 	mov	result1, #0
08ae8                 | LR__0551
08ae8     A8 F0 03 F6 | 	mov	ptra, fp
08aec     B3 00 A0 FD | 	call	#popregs_
08af0                 | _ff_cc_f_read_ret
08af0     2D 00 64 FD | 	ret
08af4                 | 
08af4                 | _ff_cc_f_write
08af4     2A 4C 05 F6 | 	mov	COUNT_, #42
08af8     A9 00 A0 FD | 	call	#pushregs_
08afc     34 F0 07 F1 | 	add	ptra, #52
08b00     04 50 05 F1 | 	add	fp, #4
08b04     A8 0E 62 FC | 	wrlong	arg01, fp
08b08     04 50 05 F1 | 	add	fp, #4
08b0c     A8 10 62 FC | 	wrlong	arg02, fp
08b10     04 50 05 F1 | 	add	fp, #4
08b14     A8 12 62 FC | 	wrlong	arg03, fp
08b18     04 50 05 F1 | 	add	fp, #4
08b1c     A8 14 62 FC | 	wrlong	arg04, fp
08b20     14 50 05 F1 | 	add	fp, #20
08b24     A8 00 68 FC | 	wrlong	#0, fp
08b28     1C 50 85 F1 | 	sub	fp, #28
08b2c     A8 F4 01 FB | 	rdlong	result1, fp
08b30     28 50 05 F1 | 	add	fp, #40
08b34     A8 F4 61 FC | 	wrlong	result1, fp
08b38     20 50 85 F1 | 	sub	fp, #32
08b3c     A8 F4 01 FB | 	rdlong	result1, fp
08b40     FA 00 68 FC | 	wrlong	#0, result1
08b44     0C 50 85 F1 | 	sub	fp, #12
08b48     A8 0E 02 FB | 	rdlong	arg01, fp
08b4c     14 50 05 F1 | 	add	fp, #20
08b50     A8 10 02 F6 | 	mov	arg02, fp
08b54     18 50 85 F1 | 	sub	fp, #24
08b58     F8 F0 BF FD | 	call	#_ff_cc_validate_0357
08b5c     14 50 05 F1 | 	add	fp, #20
08b60     A8 F4 61 FC | 	wrlong	result1, fp
08b64     FA 0E 0A F6 | 	mov	arg01, result1 wz
08b68     14 50 85 F1 | 	sub	fp, #20
08b6c     28 00 90 5D |  if_ne	jmp	#LR__0552
08b70     04 50 05 F1 | 	add	fp, #4
08b74     A8 0E 02 FB | 	rdlong	arg01, fp
08b78     11 0E 06 F1 | 	add	arg01, #17
08b7c     07 0F C2 FA | 	rdbyte	arg01, arg01
08b80     07 0F E2 F8 | 	getbyte	arg01, arg01, #0
08b84     10 50 05 F1 | 	add	fp, #16
08b88     A8 0E 62 FC | 	wrlong	arg01, fp
08b8c     14 50 85 F1 | 	sub	fp, #20
08b90     07 0F 0A F6 | 	mov	arg01, arg01 wz
08b94     10 00 90 AD |  if_e	jmp	#LR__0553
08b98                 | LR__0552
08b98     14 50 05 F1 | 	add	fp, #20
08b9c     A8 F4 01 FB | 	rdlong	result1, fp
08ba0     14 50 85 F1 | 	sub	fp, #20
08ba4     50 07 90 FD | 	jmp	#LR__0576
08ba8                 | LR__0553
08ba8     04 50 05 F1 | 	add	fp, #4
08bac     A8 0E 02 FB | 	rdlong	arg01, fp
08bb0     04 50 85 F1 | 	sub	fp, #4
08bb4     10 0E 06 F1 | 	add	arg01, #16
08bb8     07 0F C2 FA | 	rdbyte	arg01, arg01
08bbc     02 0E CE F7 | 	test	arg01, #2 wz
08bc0     07 F4 05 A6 |  if_e	mov	result1, #7
08bc4     30 07 90 AD |  if_e	jmp	#LR__0576
08bc8     04 50 05 F1 | 	add	fp, #4
08bcc     A8 18 02 FB | 	rdlong	local01, fp
08bd0     0C F5 01 F6 | 	mov	result1, local01
08bd4     14 F4 05 F1 | 	add	result1, #20
08bd8     FA 1A 02 FB | 	rdlong	local02, result1
08bdc     0D F5 01 F6 | 	mov	result1, local02
08be0     08 50 05 F1 | 	add	fp, #8
08be4     A8 0E 02 FB | 	rdlong	arg01, fp
08be8     07 F5 01 F1 | 	add	result1, arg01
08bec     0C 1D 02 F6 | 	mov	local03, local01
08bf0     0C 50 85 F1 | 	sub	fp, #12
08bf4     14 1C 06 F1 | 	add	local03, #20
08bf8     0E 1F 02 FB | 	rdlong	local04, local03
08bfc     14 1C 86 F1 | 	sub	local03, #20
08c00     0F 21 02 F6 | 	mov	local05, local04
08c04     10 F5 11 F2 | 	cmp	result1, local05 wc
08c08     24 00 90 3D |  if_ae	jmp	#LR__0554
08c0c     04 50 05 F1 | 	add	fp, #4
08c10     A8 0E 02 FB | 	rdlong	arg01, fp
08c14     01 F4 65 F6 | 	neg	result1, #1
08c18     14 0E 06 F1 | 	add	arg01, #20
08c1c     07 0F 02 FB | 	rdlong	arg01, arg01
08c20     07 F5 81 F1 | 	sub	result1, arg01
08c24     08 50 05 F1 | 	add	fp, #8
08c28     A8 F4 61 FC | 	wrlong	result1, fp
08c2c     0C 50 85 F1 | 	sub	fp, #12
08c30                 | LR__0554
08c30                 | ' 		btw = (UINT)(0xFFFFFFFF - (DWORD)fp->fptr);
08c30                 | ' 	}
08c30                 | ' 
08c30                 | ' 	for ( ; btw;
08c30                 | LR__0555
08c30     0C 50 05 F1 | 	add	fp, #12
08c34     A8 22 02 FB | 	rdlong	local06, fp
08c38     0C 50 85 F1 | 	sub	fp, #12
08c3c     11 25 0A F6 | 	mov	local07, local06 wz
08c40     8C 06 90 AD |  if_e	jmp	#LR__0575
08c44     04 50 05 F1 | 	add	fp, #4
08c48     A8 F4 01 FB | 	rdlong	result1, fp
08c4c     04 50 85 F1 | 	sub	fp, #4
08c50     14 F4 05 F1 | 	add	result1, #20
08c54     FA F4 01 FB | 	rdlong	result1, result1
08c58     FF F5 CD F7 | 	test	result1, #511 wz
08c5c     54 04 90 5D |  if_ne	jmp	#LR__0570
08c60     04 50 05 F1 | 	add	fp, #4
08c64     A8 26 02 FB | 	rdlong	local08, fp
08c68     14 26 06 F1 | 	add	local08, #20
08c6c     13 F5 01 FB | 	rdlong	result1, local08
08c70     09 F4 45 F0 | 	shr	result1, #9
08c74     14 50 05 F1 | 	add	fp, #20
08c78     A8 28 02 FB | 	rdlong	local09, fp
08c7c     0A 28 06 F1 | 	add	local09, #10
08c80     14 2B E2 FA | 	rdword	local10, local09
08c84     15 2D 32 F9 | 	getword	local11, local10, #0
08c88     01 2C 86 F1 | 	sub	local11, #1
08c8c     16 F5 09 F5 | 	and	result1, local11 wz
08c90     14 50 05 F1 | 	add	fp, #20
08c94     A8 F4 61 FC | 	wrlong	result1, fp
08c98     2C 50 85 F1 | 	sub	fp, #44
08c9c     44 01 90 5D |  if_ne	jmp	#LR__0561
08ca0     04 50 05 F1 | 	add	fp, #4
08ca4     A8 2E 02 FB | 	rdlong	local12, fp
08ca8     04 50 85 F1 | 	sub	fp, #4
08cac     14 2E 06 F1 | 	add	local12, #20
08cb0     17 0F 0A FB | 	rdlong	arg01, local12 wz
08cb4     44 00 90 5D |  if_ne	jmp	#LR__0556
08cb8     04 50 05 F1 | 	add	fp, #4
08cbc     A8 2E 02 FB | 	rdlong	local12, fp
08cc0     08 2E 06 F1 | 	add	local12, #8
08cc4     17 2F 0A FB | 	rdlong	local12, local12 wz
08cc8     18 50 05 F1 | 	add	fp, #24
08ccc     A8 2E 62 FC | 	wrlong	local12, fp
08cd0     1C 50 85 F1 | 	sub	fp, #28
08cd4     4C 00 90 5D |  if_ne	jmp	#LR__0557
08cd8     04 50 05 F1 | 	add	fp, #4
08cdc     A8 0E 02 FB | 	rdlong	arg01, fp
08ce0     04 50 85 F1 | 	sub	fp, #4
08ce4     00 10 06 F6 | 	mov	arg02, #0
08ce8     F4 C0 BF FD | 	call	#_ff_cc_create_chain_0240
08cec     1C 50 05 F1 | 	add	fp, #28
08cf0     A8 F4 61 FC | 	wrlong	result1, fp
08cf4     1C 50 85 F1 | 	sub	fp, #28
08cf8     28 00 90 FD | 	jmp	#LR__0557
08cfc                 | LR__0556
08cfc     04 50 05 F1 | 	add	fp, #4
08d00     A8 30 02 FB | 	rdlong	local13, fp
08d04     18 0F 02 F6 | 	mov	arg01, local13
08d08     04 50 85 F1 | 	sub	fp, #4
08d0c     18 30 06 F1 | 	add	local13, #24
08d10     18 11 02 FB | 	rdlong	arg02, local13
08d14     C8 C0 BF FD | 	call	#_ff_cc_create_chain_0240
08d18     1C 50 05 F1 | 	add	fp, #28
08d1c     A8 F4 61 FC | 	wrlong	result1, fp
08d20     1C 50 85 F1 | 	sub	fp, #28
08d24                 | LR__0557
08d24     1C 50 05 F1 | 	add	fp, #28
08d28     A8 2E 0A FB | 	rdlong	local12, fp wz
08d2c     1C 50 85 F1 | 	sub	fp, #28
08d30     9C 05 90 AD |  if_e	jmp	#LR__0575
08d34     1C 50 05 F1 | 	add	fp, #28
08d38     A8 2E 02 FB | 	rdlong	local12, fp
08d3c     1C 50 85 F1 | 	sub	fp, #28
08d40     01 2E 0E F2 | 	cmp	local12, #1 wz
08d44     1C 00 90 5D |  if_ne	jmp	#LR__0558
08d48     04 50 05 F1 | 	add	fp, #4
08d4c     A8 2E 02 FB | 	rdlong	local12, fp
08d50     04 50 85 F1 | 	sub	fp, #4
08d54     11 2E 06 F1 | 	add	local12, #17
08d58     17 05 48 FC | 	wrbyte	#2, local12
08d5c     02 F4 05 F6 | 	mov	result1, #2
08d60     94 05 90 FD | 	jmp	#LR__0576
08d64                 | LR__0558
08d64     1C 50 05 F1 | 	add	fp, #28
08d68     A8 2E 02 FB | 	rdlong	local12, fp
08d6c     1C 50 85 F1 | 	sub	fp, #28
08d70     FF FF 7F FF 
08d74     FF 2F 0E F2 | 	cmp	local12, ##-1 wz
08d78     1C 00 90 5D |  if_ne	jmp	#LR__0559
08d7c     04 50 05 F1 | 	add	fp, #4
08d80     A8 2E 02 FB | 	rdlong	local12, fp
08d84     04 50 85 F1 | 	sub	fp, #4
08d88     11 2E 06 F1 | 	add	local12, #17
08d8c     17 03 48 FC | 	wrbyte	#1, local12
08d90     01 F4 05 F6 | 	mov	result1, #1
08d94     60 05 90 FD | 	jmp	#LR__0576
08d98                 | LR__0559
08d98     04 50 05 F1 | 	add	fp, #4
08d9c     A8 2E 02 FB | 	rdlong	local12, fp
08da0     18 50 05 F1 | 	add	fp, #24
08da4     A8 30 02 FB | 	rdlong	local13, fp
08da8     18 2E 06 F1 | 	add	local12, #24
08dac     17 31 62 FC | 	wrlong	local13, local12
08db0     18 50 85 F1 | 	sub	fp, #24
08db4     A8 2E 02 FB | 	rdlong	local12, fp
08db8     04 50 85 F1 | 	sub	fp, #4
08dbc     08 2E 06 F1 | 	add	local12, #8
08dc0     17 31 0A FB | 	rdlong	local13, local12 wz
08dc4     1C 00 90 5D |  if_ne	jmp	#LR__0560
08dc8     04 50 05 F1 | 	add	fp, #4
08dcc     A8 2E 02 FB | 	rdlong	local12, fp
08dd0     18 50 05 F1 | 	add	fp, #24
08dd4     A8 30 02 FB | 	rdlong	local13, fp
08dd8     1C 50 85 F1 | 	sub	fp, #28
08ddc     08 2E 06 F1 | 	add	local12, #8
08de0     17 31 62 FC | 	wrlong	local13, local12
08de4                 | LR__0560
08de4                 | LR__0561
08de4     18 50 05 F1 | 	add	fp, #24
08de8     A8 2E 02 FB | 	rdlong	local12, fp
08dec     14 50 85 F1 | 	sub	fp, #20
08df0     A8 30 02 FB | 	rdlong	local13, fp
08df4     04 50 85 F1 | 	sub	fp, #4
08df8     30 2E 06 F1 | 	add	local12, #48
08dfc     17 1B 02 FB | 	rdlong	local02, local12
08e00     1C 30 06 F1 | 	add	local13, #28
08e04     18 29 02 FB | 	rdlong	local09, local13
08e08     14 1B 0A F2 | 	cmp	local02, local09 wz
08e0c     34 00 90 5D |  if_ne	jmp	#LR__0562
08e10     18 50 05 F1 | 	add	fp, #24
08e14     A8 0E 02 FB | 	rdlong	arg01, fp
08e18     18 50 85 F1 | 	sub	fp, #24
08e1c     30 B7 BF FD | 	call	#_ff_cc_sync_window_0216
08e20     00 F4 0D F2 | 	cmp	result1, #0 wz
08e24     1C 00 90 AD |  if_e	jmp	#LR__0562
08e28     04 50 05 F1 | 	add	fp, #4
08e2c     A8 2E 02 FB | 	rdlong	local12, fp
08e30     04 50 85 F1 | 	sub	fp, #4
08e34     11 2E 06 F1 | 	add	local12, #17
08e38     17 03 48 FC | 	wrbyte	#1, local12
08e3c     01 F4 05 F6 | 	mov	result1, #1
08e40     B4 04 90 FD | 	jmp	#LR__0576
08e44                 | LR__0562
08e44     18 50 05 F1 | 	add	fp, #24
08e48     A8 0E 02 FB | 	rdlong	arg01, fp
08e4c     14 50 85 F1 | 	sub	fp, #20
08e50     A8 30 02 FB | 	rdlong	local13, fp
08e54     04 50 85 F1 | 	sub	fp, #4
08e58     18 30 06 F1 | 	add	local13, #24
08e5c     18 11 02 FB | 	rdlong	arg02, local13
08e60     A0 B9 BF FD | 	call	#_ff_cc_clst2sect_0221
08e64     20 50 05 F1 | 	add	fp, #32
08e68     A8 F4 61 FC | 	wrlong	result1, fp
08e6c     20 50 85 F1 | 	sub	fp, #32
08e70     00 F4 0D F2 | 	cmp	result1, #0 wz
08e74     1C 00 90 5D |  if_ne	jmp	#LR__0563
08e78     04 50 05 F1 | 	add	fp, #4
08e7c     A8 2E 02 FB | 	rdlong	local12, fp
08e80     04 50 85 F1 | 	sub	fp, #4
08e84     11 2E 06 F1 | 	add	local12, #17
08e88     17 05 48 FC | 	wrbyte	#2, local12
08e8c     02 F4 05 F6 | 	mov	result1, #2
08e90     64 04 90 FD | 	jmp	#LR__0576
08e94                 | LR__0563
08e94     20 50 05 F1 | 	add	fp, #32
08e98     A8 2E 02 FB | 	rdlong	local12, fp
08e9c     0C 50 05 F1 | 	add	fp, #12
08ea0     A8 30 02 FB | 	rdlong	local13, fp
08ea4     18 2F 02 F1 | 	add	local12, local13
08ea8     0C 50 85 F1 | 	sub	fp, #12
08eac     A8 2E 62 FC | 	wrlong	local12, fp
08eb0     14 50 85 F1 | 	sub	fp, #20
08eb4     A8 2E 02 FB | 	rdlong	local12, fp
08eb8     09 2E 46 F0 | 	shr	local12, #9
08ebc     1C 50 05 F1 | 	add	fp, #28
08ec0     A8 2E 62 FC | 	wrlong	local12, fp
08ec4     28 50 85 F1 | 	sub	fp, #40
08ec8     01 2E 16 F2 | 	cmp	local12, #1 wc
08ecc     50 01 90 CD |  if_b	jmp	#LR__0567
08ed0     2C 50 05 F1 | 	add	fp, #44
08ed4     A8 2E 02 FB | 	rdlong	local12, fp
08ed8     04 50 85 F1 | 	sub	fp, #4
08edc     A8 30 02 FB | 	rdlong	local13, fp
08ee0     18 2F 02 F1 | 	add	local12, local13
08ee4     10 50 85 F1 | 	sub	fp, #16
08ee8     A8 2C 02 FB | 	rdlong	local11, fp
08eec     18 50 85 F1 | 	sub	fp, #24
08ef0     0A 2C 06 F1 | 	add	local11, #10
08ef4     16 1B E2 FA | 	rdword	local02, local11
08ef8     0D 2F 1A F2 | 	cmp	local12, local02 wcz
08efc     28 00 90 ED |  if_be	jmp	#LR__0564
08f00     18 50 05 F1 | 	add	fp, #24
08f04     A8 26 02 FB | 	rdlong	local08, fp
08f08     0A 26 06 F1 | 	add	local08, #10
08f0c     13 2F E2 FA | 	rdword	local12, local08
08f10     14 50 05 F1 | 	add	fp, #20
08f14     A8 1A 02 FB | 	rdlong	local02, fp
08f18     0D 2F 82 F1 | 	sub	local12, local02
08f1c     04 50 85 F1 | 	sub	fp, #4
08f20     A8 2E 62 FC | 	wrlong	local12, fp
08f24     28 50 85 F1 | 	sub	fp, #40
08f28                 | LR__0564
08f28     18 50 05 F1 | 	add	fp, #24
08f2c     A8 26 02 FB | 	rdlong	local08, fp
08f30     01 26 06 F1 | 	add	local08, #1
08f34     13 0F C2 FA | 	rdbyte	arg01, local08
08f38     18 50 05 F1 | 	add	fp, #24
08f3c     A8 10 02 FB | 	rdlong	arg02, fp
08f40     10 50 85 F1 | 	sub	fp, #16
08f44     A8 12 02 FB | 	rdlong	arg03, fp
08f48     08 50 05 F1 | 	add	fp, #8
08f4c     A8 14 02 FB | 	rdlong	arg04, fp
08f50     28 50 85 F1 | 	sub	fp, #40
08f54     10 B0 BF FD | 	call	#_ff_cc_disk_write
08f58     00 F4 0D F2 | 	cmp	result1, #0 wz
08f5c     1C 00 90 AD |  if_e	jmp	#LR__0565
08f60     04 50 05 F1 | 	add	fp, #4
08f64     A8 2E 02 FB | 	rdlong	local12, fp
08f68     04 50 85 F1 | 	sub	fp, #4
08f6c     11 2E 06 F1 | 	add	local12, #17
08f70     17 03 48 FC | 	wrbyte	#1, local12
08f74     01 F4 05 F6 | 	mov	result1, #1
08f78     7C 03 90 FD | 	jmp	#LR__0576
08f7c                 | LR__0565
08f7c     18 50 05 F1 | 	add	fp, #24
08f80     A8 26 02 FB | 	rdlong	local08, fp
08f84     30 26 06 F1 | 	add	local08, #48
08f88     13 2F 02 FB | 	rdlong	local12, local08
08f8c     08 50 05 F1 | 	add	fp, #8
08f90     A8 1A 02 FB | 	rdlong	local02, fp
08f94     0D 2F 82 F1 | 	sub	local12, local02
08f98     08 50 05 F1 | 	add	fp, #8
08f9c     A8 28 02 FB | 	rdlong	local09, fp
08fa0     28 50 85 F1 | 	sub	fp, #40
08fa4     14 2F 12 F2 | 	cmp	local12, local09 wc
08fa8     58 00 90 3D |  if_ae	jmp	#LR__0566
08fac     18 50 05 F1 | 	add	fp, #24
08fb0     A8 0E 02 FB | 	rdlong	arg01, fp
08fb4     34 0E 06 F1 | 	add	arg01, #52
08fb8     18 50 05 F1 | 	add	fp, #24
08fbc     A8 10 02 FB | 	rdlong	arg02, fp
08fc0     18 50 85 F1 | 	sub	fp, #24
08fc4     A8 2C 02 FB | 	rdlong	local11, fp
08fc8     30 2C 06 F1 | 	add	local11, #48
08fcc     16 31 02 FB | 	rdlong	local13, local11
08fd0     08 50 05 F1 | 	add	fp, #8
08fd4     A8 2A 02 FB | 	rdlong	local10, fp
08fd8     20 50 85 F1 | 	sub	fp, #32
08fdc     15 31 82 F1 | 	sub	local13, local10
08fe0     09 30 66 F0 | 	shl	local13, #9
08fe4     18 11 02 F1 | 	add	arg02, local13
08fe8     09 12 C6 F9 | 	decod	arg03, #9
08fec     D0 B3 BF FD | 	call	#_ff_cc_mem_cpy_0198
08ff0     18 50 05 F1 | 	add	fp, #24
08ff4     A8 2E 02 FB | 	rdlong	local12, fp
08ff8     18 50 85 F1 | 	sub	fp, #24
08ffc     03 2E 06 F1 | 	add	local12, #3
09000     17 01 48 FC | 	wrbyte	#0, local12
09004                 | LR__0566
09004     28 50 05 F1 | 	add	fp, #40
09008     A8 2E 02 FB | 	rdlong	local12, fp
0900c     09 2E 66 F0 | 	shl	local12, #9
09010     04 50 85 F1 | 	sub	fp, #4
09014     A8 2E 62 FC | 	wrlong	local12, fp
09018     24 50 85 F1 | 	sub	fp, #36
0901c                 | ' 					mem_cpy(fs->win, wbuff + ((fs->winsect - sect) *  ((UINT) 512 ) ),  ((UINT) 512 ) );
0901c                 | ' 					fs->wflag = 0;
0901c                 | ' 				}
0901c                 | ' #line 4095 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
0901c                 | ' 				wcnt =  ((UINT) 512 )  * cc;
0901c                 | ' 				continue;
0901c     70 01 90 FD | 	jmp	#LR__0572
09020                 | LR__0567
09020     04 50 05 F1 | 	add	fp, #4
09024     A8 30 02 FB | 	rdlong	local13, fp
09028     18 2F 02 F6 | 	mov	local12, local13
0902c     04 50 85 F1 | 	sub	fp, #4
09030     14 2E 06 F1 | 	add	local12, #20
09034     17 1B 02 FB | 	rdlong	local02, local12
09038     0C 30 06 F1 | 	add	local13, #12
0903c     18 29 02 FB | 	rdlong	local09, local13
09040     14 1B 12 F2 | 	cmp	local02, local09 wc
09044     50 00 90 CD |  if_b	jmp	#LR__0569
09048     18 50 05 F1 | 	add	fp, #24
0904c     A8 0E 02 FB | 	rdlong	arg01, fp
09050     18 50 85 F1 | 	sub	fp, #24
09054     F8 B4 BF FD | 	call	#_ff_cc_sync_window_0216
09058     00 F4 0D F2 | 	cmp	result1, #0 wz
0905c     1C 00 90 AD |  if_e	jmp	#LR__0568
09060     04 50 05 F1 | 	add	fp, #4
09064     A8 2E 02 FB | 	rdlong	local12, fp
09068     04 50 85 F1 | 	sub	fp, #4
0906c     11 2E 06 F1 | 	add	local12, #17
09070     17 03 48 FC | 	wrbyte	#1, local12
09074     01 F4 05 F6 | 	mov	result1, #1
09078     7C 02 90 FD | 	jmp	#LR__0576
0907c                 | LR__0568
0907c     18 50 05 F1 | 	add	fp, #24
09080     A8 2E 02 FB | 	rdlong	local12, fp
09084     08 50 05 F1 | 	add	fp, #8
09088     A8 30 02 FB | 	rdlong	local13, fp
0908c     20 50 85 F1 | 	sub	fp, #32
09090     30 2E 06 F1 | 	add	local12, #48
09094     17 31 62 FC | 	wrlong	local13, local12
09098                 | LR__0569
09098     04 50 05 F1 | 	add	fp, #4
0909c     A8 2E 02 FB | 	rdlong	local12, fp
090a0     1C 50 05 F1 | 	add	fp, #28
090a4     A8 30 02 FB | 	rdlong	local13, fp
090a8     20 50 85 F1 | 	sub	fp, #32
090ac     1C 2E 06 F1 | 	add	local12, #28
090b0     17 31 62 FC | 	wrlong	local13, local12
090b4                 | LR__0570
090b4     04 50 05 F1 | 	add	fp, #4
090b8     A8 26 02 FB | 	rdlong	local08, fp
090bc     14 26 06 F1 | 	add	local08, #20
090c0     13 19 02 FB | 	rdlong	local01, local08
090c4     FF 19 06 F5 | 	and	local01, #511
090c8     09 2E C6 F9 | 	decod	local12, #9
090cc     0C 2F 82 F1 | 	sub	local12, local01
090d0     20 50 05 F1 | 	add	fp, #32
090d4     A8 2E 62 FC | 	wrlong	local12, fp
090d8     18 50 85 F1 | 	sub	fp, #24
090dc     A8 30 02 FB | 	rdlong	local13, fp
090e0     0C 50 85 F1 | 	sub	fp, #12
090e4     18 2F 1A F2 | 	cmp	local12, local13 wcz
090e8     0C 50 05 11 |  if_a	add	fp, #12
090ec     A8 2E 02 1B |  if_a	rdlong	local12, fp
090f0     18 50 05 11 |  if_a	add	fp, #24
090f4     A8 2E 62 1C |  if_a	wrlong	local12, fp
090f8     24 50 85 11 |  if_a	sub	fp, #36
090fc     18 50 05 F1 | 	add	fp, #24
09100     A8 0E 02 FB | 	rdlong	arg01, fp
09104     14 50 85 F1 | 	sub	fp, #20
09108     A8 30 02 FB | 	rdlong	local13, fp
0910c     04 50 85 F1 | 	sub	fp, #4
09110     1C 30 06 F1 | 	add	local13, #28
09114     18 11 02 FB | 	rdlong	arg02, local13
09118     08 B5 BF FD | 	call	#_ff_cc_move_window_0218
0911c     00 F4 0D F2 | 	cmp	result1, #0 wz
09120     1C 00 90 AD |  if_e	jmp	#LR__0571
09124     04 50 05 F1 | 	add	fp, #4
09128     A8 2E 02 FB | 	rdlong	local12, fp
0912c     04 50 85 F1 | 	sub	fp, #4
09130     11 2E 06 F1 | 	add	local12, #17
09134     17 03 48 FC | 	wrbyte	#1, local12
09138     01 F4 05 F6 | 	mov	result1, #1
0913c     B8 01 90 FD | 	jmp	#LR__0576
09140                 | LR__0571
09140     18 50 05 F1 | 	add	fp, #24
09144     A8 0E 02 FB | 	rdlong	arg01, fp
09148     34 0E 06 F1 | 	add	arg01, #52
0914c     14 50 85 F1 | 	sub	fp, #20
09150     A8 2C 02 FB | 	rdlong	local11, fp
09154     14 2C 06 F1 | 	add	local11, #20
09158     16 1F 02 FB | 	rdlong	local04, local11
0915c     FF 1F 06 F5 | 	and	local04, #511
09160     0F 0F 02 F1 | 	add	arg01, local04
09164     2C 50 05 F1 | 	add	fp, #44
09168     A8 10 02 FB | 	rdlong	arg02, fp
0916c     0C 50 85 F1 | 	sub	fp, #12
09170     A8 12 02 FB | 	rdlong	arg03, fp
09174     24 50 85 F1 | 	sub	fp, #36
09178     44 B2 BF FD | 	call	#_ff_cc_mem_cpy_0198
0917c     18 50 05 F1 | 	add	fp, #24
09180     A8 2E 02 FB | 	rdlong	local12, fp
09184     18 50 85 F1 | 	sub	fp, #24
09188     03 2E 06 F1 | 	add	local12, #3
0918c     17 03 48 FC | 	wrbyte	#1, local12
09190                 | LR__0572
09190     0C 50 05 F1 | 	add	fp, #12
09194     A8 2E 02 FB | 	rdlong	local12, fp
09198     18 50 05 F1 | 	add	fp, #24
0919c     A8 18 02 FB | 	rdlong	local01, fp
091a0     0C 2F 82 F1 | 	sub	local12, local01
091a4     18 50 85 F1 | 	sub	fp, #24
091a8     A8 2E 62 FC | 	wrlong	local12, fp
091ac     04 50 05 F1 | 	add	fp, #4
091b0     A8 1C 02 FB | 	rdlong	local03, fp
091b4     0E 1B 02 F6 | 	mov	local02, local03
091b8     0E 29 02 FB | 	rdlong	local09, local03
091bc     14 50 05 F1 | 	add	fp, #20
091c0     A8 1E 02 FB | 	rdlong	local04, fp
091c4     0F 21 02 F6 | 	mov	local05, local04
091c8     0F 29 02 F1 | 	add	local09, local04
091cc     0D 29 62 FC | 	wrlong	local09, local02
091d0     0C 50 05 F1 | 	add	fp, #12
091d4     A8 32 02 FB | 	rdlong	local14, fp
091d8     19 35 02 F6 | 	mov	local15, local14
091dc     0C 50 85 F1 | 	sub	fp, #12
091e0     A8 36 02 FB | 	rdlong	local16, fp
091e4     1B 39 02 F6 | 	mov	local17, local16
091e8     1B 35 02 F1 | 	add	local15, local16
091ec     0C 50 05 F1 | 	add	fp, #12
091f0     A8 34 62 FC | 	wrlong	local15, fp
091f4     2C 50 85 F1 | 	sub	fp, #44
091f8     A8 3A 02 FB | 	rdlong	local18, fp
091fc     1D 3D 02 F6 | 	mov	local19, local18
09200     1D 3F 02 F6 | 	mov	local20, local18
09204     1F 41 02 F6 | 	mov	local21, local20
09208     14 40 06 F1 | 	add	local21, #20
0920c     20 43 02 FB | 	rdlong	local22, local21
09210     14 40 86 F1 | 	sub	local21, #20
09214     21 45 02 F6 | 	mov	local23, local22
09218     20 50 05 F1 | 	add	fp, #32
0921c     A8 46 02 FB | 	rdlong	local24, fp
09220     23 49 02 F6 | 	mov	local25, local24
09224     23 45 02 F1 | 	add	local23, local24
09228     14 3C 06 F1 | 	add	local19, #20
0922c     1E 45 62 FC | 	wrlong	local23, local19
09230     14 3C 86 F1 | 	sub	local19, #20
09234     20 50 85 F1 | 	sub	fp, #32
09238     A8 4A 02 FB | 	rdlong	local26, fp
0923c     25 4D 02 F6 | 	mov	local27, local26
09240     25 4F 02 F6 | 	mov	local28, local26
09244     27 51 02 F6 | 	mov	local29, local28
09248     25 53 02 F6 | 	mov	local30, local26
0924c     04 50 85 F1 | 	sub	fp, #4
09250     29 55 02 F6 | 	mov	local31, local30
09254     14 50 06 F1 | 	add	local29, #20
09258     28 57 02 FB | 	rdlong	local32, local29
0925c     14 50 86 F1 | 	sub	local29, #20
09260     2B 59 02 F6 | 	mov	local33, local32
09264     0C 54 06 F1 | 	add	local31, #12
09268     2A 5B 02 FB | 	rdlong	local34, local31
0926c     0C 54 86 F1 | 	sub	local31, #12
09270     2D 5D 02 F6 | 	mov	local35, local34
09274     2E 59 1A F2 | 	cmp	local33, local35 wcz
09278     24 00 90 ED |  if_be	jmp	#LR__0573
0927c     04 50 05 F1 | 	add	fp, #4
09280     A8 5E 02 FB | 	rdlong	local36, fp
09284     04 50 85 F1 | 	sub	fp, #4
09288     2F 61 02 F6 | 	mov	local37, local36
0928c     14 60 06 F1 | 	add	local37, #20
09290     30 63 02 FB | 	rdlong	local38, local37
09294     14 60 86 F1 | 	sub	local37, #20
09298     31 65 02 F6 | 	mov	local39, local38
0929c     20 00 90 FD | 	jmp	#LR__0574
092a0                 | LR__0573
092a0     04 50 05 F1 | 	add	fp, #4
092a4     A8 66 02 FB | 	rdlong	local40, fp
092a8     04 50 85 F1 | 	sub	fp, #4
092ac     33 69 02 F6 | 	mov	local41, local40
092b0     0C 68 06 F1 | 	add	local41, #12
092b4     34 6B 02 FB | 	rdlong	local42, local41
092b8     0C 68 86 F1 | 	sub	local41, #12
092bc     35 65 02 F6 | 	mov	local39, local42
092c0                 | LR__0574
092c0     0C 4C 06 F1 | 	add	local27, #12
092c4     26 65 62 FC | 	wrlong	local39, local27
092c8     0C 4C 86 F1 | 	sub	local27, #12
092cc     60 F9 9F FD | 	jmp	#LR__0555
092d0                 | LR__0575
092d0     04 50 05 F1 | 	add	fp, #4
092d4     A8 26 02 FB | 	rdlong	local08, fp
092d8     13 25 02 F6 | 	mov	local07, local08
092dc     04 50 85 F1 | 	sub	fp, #4
092e0     10 26 06 F1 | 	add	local08, #16
092e4     13 2F C2 FA | 	rdbyte	local12, local08
092e8     40 2E 46 F5 | 	or	local12, #64
092ec     10 24 06 F1 | 	add	local07, #16
092f0     12 2F 42 FC | 	wrbyte	local12, local07
092f4                 | ' 		mem_cpy(fs->win + fp->fptr %  ((UINT) 512 ) , wbuff, wcnt);
092f4                 | ' 		fs->wflag = 1;
092f4                 | ' #line 4122 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
092f4                 | ' 	}
092f4                 | ' 
092f4                 | ' 	fp->flag |=  0x40 ;
092f4                 | ' 
092f4                 | ' 	return FR_OK ;
092f4     00 F4 05 F6 | 	mov	result1, #0
092f8                 | LR__0576
092f8     A8 F0 03 F6 | 	mov	ptra, fp
092fc     B3 00 A0 FD | 	call	#popregs_
09300                 | _ff_cc_f_write_ret
09300     2D 00 64 FD | 	ret
09304                 | 
09304                 | _ff_cc_f_sync
09304     00 4C 05 F6 | 	mov	COUNT_, #0
09308     A9 00 A0 FD | 	call	#pushregs_
0930c     18 F0 07 F1 | 	add	ptra, #24
09310     04 50 05 F1 | 	add	fp, #4
09314     A8 0E 62 FC | 	wrlong	arg01, fp
09318     08 50 05 F1 | 	add	fp, #8
0931c     A8 10 02 F6 | 	mov	arg02, fp
09320     0C 50 85 F1 | 	sub	fp, #12
09324     2C E9 BF FD | 	call	#_ff_cc_validate_0357
09328     08 50 05 F1 | 	add	fp, #8
0932c     A8 F4 61 FC | 	wrlong	result1, fp
09330     08 50 85 F1 | 	sub	fp, #8
09334     00 F4 0D F2 | 	cmp	result1, #0 wz
09338     50 01 90 5D |  if_ne	jmp	#LR__0579
0933c     04 50 05 F1 | 	add	fp, #4
09340     A8 10 02 FB | 	rdlong	arg02, fp
09344     04 50 85 F1 | 	sub	fp, #4
09348     10 10 06 F1 | 	add	arg02, #16
0934c     08 11 C2 FA | 	rdbyte	arg02, arg02
09350     40 10 CE F7 | 	test	arg02, #64 wz
09354     34 01 90 AD |  if_e	jmp	#LR__0578
09358     10 50 05 F1 | 	add	fp, #16
0935c     80 10 A7 FF 
09360     A8 00 68 FC | 	wrlong	##1310785536, fp
09364     04 50 85 F1 | 	sub	fp, #4
09368     A8 0E 02 FB | 	rdlong	arg01, fp
0936c     08 50 85 F1 | 	sub	fp, #8
09370     A8 10 02 FB | 	rdlong	arg02, fp
09374     04 50 85 F1 | 	sub	fp, #4
09378     20 10 06 F1 | 	add	arg02, #32
0937c     08 11 02 FB | 	rdlong	arg02, arg02
09380     A0 B2 BF FD | 	call	#_ff_cc_move_window_0218
09384     08 50 05 F1 | 	add	fp, #8
09388     A8 F4 61 FC | 	wrlong	result1, fp
0938c     08 50 85 F1 | 	sub	fp, #8
09390     00 F4 0D F2 | 	cmp	result1, #0 wz
09394     F4 00 90 5D |  if_ne	jmp	#LR__0577
09398     04 50 05 F1 | 	add	fp, #4
0939c     A8 12 02 FB | 	rdlong	arg03, fp
093a0     24 12 06 F1 | 	add	arg03, #36
093a4     09 13 02 FB | 	rdlong	arg03, arg03
093a8     10 50 05 F1 | 	add	fp, #16
093ac     A8 12 62 FC | 	wrlong	arg03, fp
093b0     09 F5 01 F6 | 	mov	result1, arg03
093b4     0B F4 05 F1 | 	add	result1, #11
093b8     FA 10 C2 FA | 	rdbyte	arg02, result1
093bc     20 10 46 F5 | 	or	arg02, #32
093c0     0B 12 06 F1 | 	add	arg03, #11
093c4     09 11 42 FC | 	wrbyte	arg02, arg03
093c8     10 50 85 F1 | 	sub	fp, #16
093cc     A8 12 02 FB | 	rdlong	arg03, fp
093d0     09 0F 02 FB | 	rdlong	arg01, arg03
093d4     10 50 05 F1 | 	add	fp, #16
093d8     A8 10 02 FB | 	rdlong	arg02, fp
093dc     14 50 85 F1 | 	sub	fp, #20
093e0     08 12 06 F1 | 	add	arg03, #8
093e4     09 13 02 FB | 	rdlong	arg03, arg03
093e8     48 C1 BF FD | 	call	#_ff_cc_st_clust_0260
093ec     14 50 05 F1 | 	add	fp, #20
093f0     A8 0E 02 FB | 	rdlong	arg01, fp
093f4     1C 0E 06 F1 | 	add	arg01, #28
093f8     10 50 85 F1 | 	sub	fp, #16
093fc     A8 10 02 FB | 	rdlong	arg02, fp
09400     04 50 85 F1 | 	sub	fp, #4
09404     0C 10 06 F1 | 	add	arg02, #12
09408     08 11 02 FB | 	rdlong	arg02, arg02
0940c     84 AF BF FD | 	call	#_ff_cc_st_dword_0195
09410     14 50 05 F1 | 	add	fp, #20
09414     A8 0E 02 FB | 	rdlong	arg01, fp
09418     16 0E 06 F1 | 	add	arg01, #22
0941c     04 50 85 F1 | 	sub	fp, #4
09420     A8 10 02 FB | 	rdlong	arg02, fp
09424     10 50 85 F1 | 	sub	fp, #16
09428     68 AF BF FD | 	call	#_ff_cc_st_dword_0195
0942c     14 50 05 F1 | 	add	fp, #20
09430     A8 0E 02 FB | 	rdlong	arg01, fp
09434     14 50 85 F1 | 	sub	fp, #20
09438     12 0E 06 F1 | 	add	arg01, #18
0943c     00 10 06 F6 | 	mov	arg02, #0
09440     30 AF BF FD | 	call	#_ff_cc_st_word_0194
09444     0C 50 05 F1 | 	add	fp, #12
09448     A8 0E 02 FB | 	rdlong	arg01, fp
0944c     03 0E 06 F1 | 	add	arg01, #3
09450     07 03 48 FC | 	wrbyte	#1, arg01
09454     A8 0E 02 FB | 	rdlong	arg01, fp
09458     0C 50 85 F1 | 	sub	fp, #12
0945c     40 B2 BF FD | 	call	#_ff_cc_sync_fs_0220
09460     08 50 05 F1 | 	add	fp, #8
09464     A8 F4 61 FC | 	wrlong	result1, fp
09468     04 50 85 F1 | 	sub	fp, #4
0946c     A8 12 02 FB | 	rdlong	arg03, fp
09470     09 F5 01 F6 | 	mov	result1, arg03
09474     04 50 85 F1 | 	sub	fp, #4
09478     10 12 06 F1 | 	add	arg03, #16
0947c     09 13 C2 FA | 	rdbyte	arg03, arg03
09480     BF 12 06 F5 | 	and	arg03, #191
09484     10 F4 05 F1 | 	add	result1, #16
09488     FA 12 42 FC | 	wrbyte	arg03, result1
0948c                 | LR__0577
0948c                 | LR__0578
0948c                 | LR__0579
0948c                 | ' 					dir = fp->dir_ptr;
0948c                 | ' 					dir[ 11 ] |=  0x20 ;
0948c                 | ' 					st_clust(fp->obj.fs, dir, fp->obj.sclust);
0948c                 | ' 					st_dword(dir +  28 , (DWORD)fp->obj.objsize);
0948c                 | ' 					st_dword(dir +  22 , tm);
0948c                 | ' 					st_word(dir +  18 , 0);
0948c                 | ' 					fs->wflag = 1;
0948c                 | ' 					res = sync_fs(fs);
0948c                 | ' 					fp->flag &= (BYTE)~ 0x40 ;
0948c                 | ' 				}
0948c                 | ' 			}
0948c                 | ' 		}
0948c                 | ' 	}
0948c                 | ' 
0948c                 | ' 	return res ;
0948c     08 50 05 F1 | 	add	fp, #8
09490     A8 F4 01 FB | 	rdlong	result1, fp
09494     08 50 85 F1 | 	sub	fp, #8
09498     A8 F0 03 F6 | 	mov	ptra, fp
0949c     B3 00 A0 FD | 	call	#popregs_
094a0                 | _ff_cc_f_sync_ret
094a0     2D 00 64 FD | 	ret
094a4                 | 
094a4                 | _ff_cc_f_close
094a4     01 4C 05 F6 | 	mov	COUNT_, #1
094a8     A9 00 A0 FD | 	call	#pushregs_
094ac     10 F0 07 F1 | 	add	ptra, #16
094b0     04 50 05 F1 | 	add	fp, #4
094b4     A8 0E 62 FC | 	wrlong	arg01, fp
094b8     04 50 85 F1 | 	sub	fp, #4
094bc     44 FE BF FD | 	call	#_ff_cc_f_sync
094c0     08 50 05 F1 | 	add	fp, #8
094c4     A8 F4 61 FC | 	wrlong	result1, fp
094c8     08 50 85 F1 | 	sub	fp, #8
094cc     00 F4 0D F2 | 	cmp	result1, #0 wz
094d0     38 00 90 5D |  if_ne	jmp	#LR__0580
094d4     04 50 05 F1 | 	add	fp, #4
094d8     A8 0E 02 FB | 	rdlong	arg01, fp
094dc     08 50 05 F1 | 	add	fp, #8
094e0     A8 10 02 F6 | 	mov	arg02, fp
094e4     0C 50 85 F1 | 	sub	fp, #12
094e8     68 E7 BF FD | 	call	#_ff_cc_validate_0357
094ec     08 50 05 F1 | 	add	fp, #8
094f0     A8 F4 61 FC | 	wrlong	result1, fp
094f4     08 50 85 F1 | 	sub	fp, #8
094f8     00 F4 0D F2 | 	cmp	result1, #0 wz
094fc     04 50 05 A1 |  if_e	add	fp, #4
09500     A8 18 02 AB |  if_e	rdlong	local01, fp
09504     04 50 85 A1 |  if_e	sub	fp, #4
09508     0C 01 68 AC |  if_e	wrlong	#0, local01
0950c                 | LR__0580
0950c                 | ' 
0950c                 | ' 
0950c                 | ' 
0950c                 | ' 
0950c                 | ' 			fp->obj.fs = 0;
0950c                 | ' #line 4240 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
0950c                 | ' 		}
0950c                 | ' 	}
0950c                 | ' 	return res;
0950c     08 50 05 F1 | 	add	fp, #8
09510     A8 F4 01 FB | 	rdlong	result1, fp
09514     08 50 85 F1 | 	sub	fp, #8
09518     A8 F0 03 F6 | 	mov	ptra, fp
0951c     B3 00 A0 FD | 	call	#popregs_
09520                 | _ff_cc_f_close_ret
09520     2D 00 64 FD | 	ret
09524                 | 
09524                 | _ff_cc_f_lseek
09524     0C 4C 05 F6 | 	mov	COUNT_, #12
09528     A9 00 A0 FD | 	call	#pushregs_
0952c     24 F0 07 F1 | 	add	ptra, #36
09530     04 50 05 F1 | 	add	fp, #4
09534     A8 0E 62 FC | 	wrlong	arg01, fp
09538     04 50 05 F1 | 	add	fp, #4
0953c     A8 10 62 FC | 	wrlong	arg02, fp
09540     04 50 85 F1 | 	sub	fp, #4
09544     A8 0E 02 FB | 	rdlong	arg01, fp
09548     0C 50 05 F1 | 	add	fp, #12
0954c     A8 10 02 F6 | 	mov	arg02, fp
09550     10 50 85 F1 | 	sub	fp, #16
09554     FC E6 BF FD | 	call	#_ff_cc_validate_0357
09558     0C 50 05 F1 | 	add	fp, #12
0955c     A8 F4 61 FC | 	wrlong	result1, fp
09560     0C 50 85 F1 | 	sub	fp, #12
09564     00 F4 0D F2 | 	cmp	result1, #0 wz
09568     1C 00 90 5D |  if_ne	jmp	#LR__0581
0956c     04 50 05 F1 | 	add	fp, #4
09570     A8 18 02 FB | 	rdlong	local01, fp
09574     11 18 06 F1 | 	add	local01, #17
09578     0C 19 C2 FA | 	rdbyte	local01, local01
0957c     08 50 05 F1 | 	add	fp, #8
09580     A8 18 62 FC | 	wrlong	local01, fp
09584     0C 50 85 F1 | 	sub	fp, #12
09588                 | LR__0581
09588     0C 50 05 F1 | 	add	fp, #12
0958c     A8 18 0A FB | 	rdlong	local01, fp wz
09590     0C 50 85 F1 | 	sub	fp, #12
09594     0C 50 05 51 |  if_ne	add	fp, #12
09598     A8 F4 01 5B |  if_ne	rdlong	result1, fp
0959c     0C 50 85 51 |  if_ne	sub	fp, #12
095a0     8C 05 90 5D |  if_ne	jmp	#LR__0601
095a4     04 50 05 F1 | 	add	fp, #4
095a8     A8 18 02 FB | 	rdlong	local01, fp
095ac     04 50 05 F1 | 	add	fp, #4
095b0     A8 1A 02 FB | 	rdlong	local02, fp
095b4     08 50 85 F1 | 	sub	fp, #8
095b8     0C 18 06 F1 | 	add	local01, #12
095bc     0C 1D 02 FB | 	rdlong	local03, local01
095c0     0E 1F 02 F6 | 	mov	local04, local03
095c4     0F 1B 1A F2 | 	cmp	local02, local04 wcz
095c8     4C 00 90 ED |  if_be	jmp	#LR__0582
095cc     04 50 05 F1 | 	add	fp, #4
095d0     A8 20 02 FB | 	rdlong	local05, fp
095d4     04 50 85 F1 | 	sub	fp, #4
095d8     10 23 02 F6 | 	mov	local06, local05
095dc     10 22 06 F1 | 	add	local06, #16
095e0     11 25 C2 FA | 	rdbyte	local07, local06
095e4     10 22 86 F1 | 	sub	local06, #16
095e8     12 27 E2 F8 | 	getbyte	local08, local07, #0
095ec     02 26 0E F5 | 	and	local08, #2 wz
095f0     24 00 90 5D |  if_ne	jmp	#LR__0582
095f4     04 50 05 F1 | 	add	fp, #4
095f8     A8 18 02 FB | 	rdlong	local01, fp
095fc     0C 29 02 F6 | 	mov	local09, local01
09600     0C 28 06 F1 | 	add	local09, #12
09604     14 2B 02 FB | 	rdlong	local10, local09
09608     0C 28 86 F1 | 	sub	local09, #12
0960c     04 50 05 F1 | 	add	fp, #4
09610     A8 2A 62 FC | 	wrlong	local10, fp
09614     08 50 85 F1 | 	sub	fp, #8
09618                 | LR__0582
09618     04 50 05 F1 | 	add	fp, #4
0961c     A8 28 02 FB | 	rdlong	local09, fp
09620     14 28 06 F1 | 	add	local09, #20
09624     14 2B 02 FB | 	rdlong	local10, local09
09628     1C 50 05 F1 | 	add	fp, #28
0962c     A8 2A 62 FC | 	wrlong	local10, fp
09630     1C 50 85 F1 | 	sub	fp, #28
09634     A8 28 02 FB | 	rdlong	local09, fp
09638     18 50 05 F1 | 	add	fp, #24
0963c     A8 00 68 FC | 	wrlong	#0, fp
09640     14 28 06 F1 | 	add	local09, #20
09644     14 01 68 FC | 	wrlong	#0, local09
09648     14 50 85 F1 | 	sub	fp, #20
0964c     A8 28 02 FB | 	rdlong	local09, fp
09650     08 50 85 F1 | 	sub	fp, #8
09654     01 28 16 F2 | 	cmp	local09, #1 wc
09658     EC 03 90 CD |  if_b	jmp	#LR__0598
0965c     10 50 05 F1 | 	add	fp, #16
09660     A8 18 02 FB | 	rdlong	local01, fp
09664     0A 18 06 F1 | 	add	local01, #10
09668     0C 1F E2 FA | 	rdword	local04, local01
0966c     09 1E 66 F0 | 	shl	local04, #9
09670     08 50 05 F1 | 	add	fp, #8
09674     A8 1E 62 FC | 	wrlong	local04, fp
09678     08 50 05 F1 | 	add	fp, #8
0967c     A8 28 02 FB | 	rdlong	local09, fp
09680     20 50 85 F1 | 	sub	fp, #32
09684     01 28 16 F2 | 	cmp	local09, #1 wc
09688     B4 00 90 CD |  if_b	jmp	#LR__0583
0968c     08 50 05 F1 | 	add	fp, #8
09690     A8 1E 02 FB | 	rdlong	local04, fp
09694     01 1E 86 F1 | 	sub	local04, #1
09698     10 50 05 F1 | 	add	fp, #16
0969c     A8 2C 02 FB | 	rdlong	local11, fp
096a0     16 1F 12 FD | 	qdiv	local04, local11
096a4     08 50 05 F1 | 	add	fp, #8
096a8     A8 20 02 FB | 	rdlong	local05, fp
096ac     10 25 02 F6 | 	mov	local07, local05
096b0     01 24 86 F1 | 	sub	local07, #1
096b4     16 2F 02 F6 | 	mov	local12, local11
096b8     18 1E 62 FD | 	getqx	local04
096bc     17 25 12 FD | 	qdiv	local07, local12
096c0     20 50 85 F1 | 	sub	fp, #32
096c4     18 24 62 FD | 	getqx	local07
096c8     12 1F 12 F2 | 	cmp	local04, local07 wc
096cc     70 00 90 CD |  if_b	jmp	#LR__0583
096d0     04 50 05 F1 | 	add	fp, #4
096d4     A8 28 02 FB | 	rdlong	local09, fp
096d8     1C 50 05 F1 | 	add	fp, #28
096dc     A8 2A 02 FB | 	rdlong	local10, fp
096e0     01 2A 86 F1 | 	sub	local10, #1
096e4     08 50 85 F1 | 	sub	fp, #8
096e8     A8 1E 02 FB | 	rdlong	local04, fp
096ec     01 1E 86 F1 | 	sub	local04, #1
096f0     0F 2B 22 F5 | 	andn	local10, local04
096f4     14 28 06 F1 | 	add	local09, #20
096f8     14 2B 62 FC | 	wrlong	local10, local09
096fc     10 50 85 F1 | 	sub	fp, #16
09700     A8 28 02 FB | 	rdlong	local09, fp
09704     04 50 85 F1 | 	sub	fp, #4
09708     A8 2A 02 FB | 	rdlong	local10, fp
0970c     14 2A 06 F1 | 	add	local10, #20
09710     15 1F 02 FB | 	rdlong	local04, local10
09714     0F 29 82 F1 | 	sub	local09, local04
09718     04 50 05 F1 | 	add	fp, #4
0971c     A8 28 62 FC | 	wrlong	local09, fp
09720     04 50 85 F1 | 	sub	fp, #4
09724     A8 28 02 FB | 	rdlong	local09, fp
09728     18 28 06 F1 | 	add	local09, #24
0972c     14 2B 02 FB | 	rdlong	local10, local09
09730     10 50 05 F1 | 	add	fp, #16
09734     A8 2A 62 FC | 	wrlong	local10, fp
09738     14 50 85 F1 | 	sub	fp, #20
0973c     D0 00 90 FD | 	jmp	#LR__0587
09740                 | LR__0583
09740     04 50 05 F1 | 	add	fp, #4
09744     A8 28 02 FB | 	rdlong	local09, fp
09748     08 28 06 F1 | 	add	local09, #8
0974c     14 29 0A FB | 	rdlong	local09, local09 wz
09750     10 50 05 F1 | 	add	fp, #16
09754     A8 28 62 FC | 	wrlong	local09, fp
09758     14 50 85 F1 | 	sub	fp, #20
0975c     94 00 90 5D |  if_ne	jmp	#LR__0586
09760     04 50 05 F1 | 	add	fp, #4
09764     A8 0E 02 FB | 	rdlong	arg01, fp
09768     04 50 85 F1 | 	sub	fp, #4
0976c     00 10 06 F6 | 	mov	arg02, #0
09770     6C B6 BF FD | 	call	#_ff_cc_create_chain_0240
09774     14 50 05 F1 | 	add	fp, #20
09778     A8 F4 61 FC | 	wrlong	result1, fp
0977c     14 50 85 F1 | 	sub	fp, #20
09780     01 F4 0D F2 | 	cmp	result1, #1 wz
09784     1C 00 90 5D |  if_ne	jmp	#LR__0584
09788     04 50 05 F1 | 	add	fp, #4
0978c     A8 28 02 FB | 	rdlong	local09, fp
09790     04 50 85 F1 | 	sub	fp, #4
09794     11 28 06 F1 | 	add	local09, #17
09798     14 05 48 FC | 	wrbyte	#2, local09
0979c     02 F4 05 F6 | 	mov	result1, #2
097a0     8C 03 90 FD | 	jmp	#LR__0601
097a4                 | LR__0584
097a4     14 50 05 F1 | 	add	fp, #20
097a8     A8 28 02 FB | 	rdlong	local09, fp
097ac     14 50 85 F1 | 	sub	fp, #20
097b0     FF FF 7F FF 
097b4     FF 29 0E F2 | 	cmp	local09, ##-1 wz
097b8     1C 00 90 5D |  if_ne	jmp	#LR__0585
097bc     04 50 05 F1 | 	add	fp, #4
097c0     A8 28 02 FB | 	rdlong	local09, fp
097c4     04 50 85 F1 | 	sub	fp, #4
097c8     11 28 06 F1 | 	add	local09, #17
097cc     14 03 48 FC | 	wrbyte	#1, local09
097d0     01 F4 05 F6 | 	mov	result1, #1
097d4     58 03 90 FD | 	jmp	#LR__0601
097d8                 | LR__0585
097d8     04 50 05 F1 | 	add	fp, #4
097dc     A8 28 02 FB | 	rdlong	local09, fp
097e0     10 50 05 F1 | 	add	fp, #16
097e4     A8 2A 02 FB | 	rdlong	local10, fp
097e8     14 50 85 F1 | 	sub	fp, #20
097ec     08 28 06 F1 | 	add	local09, #8
097f0     14 2B 62 FC | 	wrlong	local10, local09
097f4                 | LR__0586
097f4     04 50 05 F1 | 	add	fp, #4
097f8     A8 28 02 FB | 	rdlong	local09, fp
097fc     10 50 05 F1 | 	add	fp, #16
09800     A8 2A 02 FB | 	rdlong	local10, fp
09804     14 50 85 F1 | 	sub	fp, #20
09808     18 28 06 F1 | 	add	local09, #24
0980c     14 2B 62 FC | 	wrlong	local10, local09
09810                 | LR__0587
09810     14 50 05 F1 | 	add	fp, #20
09814     A8 28 0A FB | 	rdlong	local09, fp wz
09818     14 50 85 F1 | 	sub	fp, #20
0981c     28 02 90 AD |  if_e	jmp	#LR__0597
09820                 | ' 				while (ofs > bcs) {
09820                 | LR__0588
09820     08 50 05 F1 | 	add	fp, #8
09824     A8 28 02 FB | 	rdlong	local09, fp
09828     10 50 05 F1 | 	add	fp, #16
0982c     A8 2A 02 FB | 	rdlong	local10, fp
09830     18 50 85 F1 | 	sub	fp, #24
09834     15 29 1A F2 | 	cmp	local09, local10 wcz
09838     68 01 90 ED |  if_be	jmp	#LR__0594
0983c     08 50 05 F1 | 	add	fp, #8
09840     A8 28 02 FB | 	rdlong	local09, fp
09844     10 50 05 F1 | 	add	fp, #16
09848     A8 2A 02 FB | 	rdlong	local10, fp
0984c     15 29 82 F1 | 	sub	local09, local10
09850     10 50 85 F1 | 	sub	fp, #16
09854     A8 28 62 FC | 	wrlong	local09, fp
09858     04 50 85 F1 | 	sub	fp, #4
0985c     A8 1E 02 FB | 	rdlong	local04, fp
09860     0F 1B 02 F6 | 	mov	local02, local04
09864     14 1A 06 F1 | 	add	local02, #20
09868     0D 2B 02 FB | 	rdlong	local10, local02
0986c     14 50 05 F1 | 	add	fp, #20
09870     A8 22 02 FB | 	rdlong	local06, fp
09874     11 2B 02 F1 | 	add	local10, local06
09878     14 1E 06 F1 | 	add	local04, #20
0987c     0F 2B 62 FC | 	wrlong	local10, local04
09880     14 50 85 F1 | 	sub	fp, #20
09884     A8 18 02 FB | 	rdlong	local01, fp
09888     04 50 85 F1 | 	sub	fp, #4
0988c     10 18 06 F1 | 	add	local01, #16
09890     0C 29 C2 FA | 	rdbyte	local09, local01
09894     02 28 CE F7 | 	test	local09, #2 wz
09898     3C 00 90 AD |  if_e	jmp	#LR__0589
0989c     04 50 05 F1 | 	add	fp, #4
098a0     A8 0E 02 FB | 	rdlong	arg01, fp
098a4     10 50 05 F1 | 	add	fp, #16
098a8     A8 10 02 FB | 	rdlong	arg02, fp
098ac     14 50 85 F1 | 	sub	fp, #20
098b0     2C B5 BF FD | 	call	#_ff_cc_create_chain_0240
098b4     14 50 05 F1 | 	add	fp, #20
098b8     A8 F4 61 FC | 	wrlong	result1, fp
098bc     FA 28 0A F6 | 	mov	local09, result1 wz
098c0     14 50 85 F1 | 	sub	fp, #20
098c4     08 50 05 A1 |  if_e	add	fp, #8
098c8     A8 00 68 AC |  if_e	wrlong	#0, fp
098cc     08 50 85 A1 |  if_e	sub	fp, #8
098d0                 | ' 							ofs = 0; break;
098d0     D0 00 90 AD |  if_e	jmp	#LR__0594
098d4     24 00 90 FD | 	jmp	#LR__0590
098d8                 | LR__0589
098d8     04 50 05 F1 | 	add	fp, #4
098dc     A8 0E 02 FB | 	rdlong	arg01, fp
098e0     10 50 05 F1 | 	add	fp, #16
098e4     A8 10 02 FB | 	rdlong	arg02, fp
098e8     14 50 85 F1 | 	sub	fp, #20
098ec     54 AF BF FD | 	call	#_ff_cc_get_fat_0226
098f0     14 50 05 F1 | 	add	fp, #20
098f4     A8 F4 61 FC | 	wrlong	result1, fp
098f8     14 50 85 F1 | 	sub	fp, #20
098fc                 | LR__0590
098fc     14 50 05 F1 | 	add	fp, #20
09900     A8 28 02 FB | 	rdlong	local09, fp
09904     14 50 85 F1 | 	sub	fp, #20
09908     FF FF 7F FF 
0990c     FF 29 0E F2 | 	cmp	local09, ##-1 wz
09910     1C 00 90 5D |  if_ne	jmp	#LR__0591
09914     04 50 05 F1 | 	add	fp, #4
09918     A8 28 02 FB | 	rdlong	local09, fp
0991c     04 50 85 F1 | 	sub	fp, #4
09920     11 28 06 F1 | 	add	local09, #17
09924     14 03 48 FC | 	wrbyte	#1, local09
09928     01 F4 05 F6 | 	mov	result1, #1
0992c     00 02 90 FD | 	jmp	#LR__0601
09930                 | LR__0591
09930     14 50 05 F1 | 	add	fp, #20
09934     A8 28 02 FB | 	rdlong	local09, fp
09938     14 50 85 F1 | 	sub	fp, #20
0993c     02 28 16 F2 | 	cmp	local09, #2 wc
09940     24 00 90 CD |  if_b	jmp	#LR__0592
09944     10 50 05 F1 | 	add	fp, #16
09948     A8 2A 02 FB | 	rdlong	local10, fp
0994c     04 50 05 F1 | 	add	fp, #4
09950     A8 1E 02 FB | 	rdlong	local04, fp
09954     14 50 85 F1 | 	sub	fp, #20
09958     18 2A 06 F1 | 	add	local10, #24
0995c     15 27 02 FB | 	rdlong	local08, local10
09960     13 1F 12 F2 | 	cmp	local04, local08 wc
09964     1C 00 90 CD |  if_b	jmp	#LR__0593
09968                 | LR__0592
09968     04 50 05 F1 | 	add	fp, #4
0996c     A8 28 02 FB | 	rdlong	local09, fp
09970     04 50 85 F1 | 	sub	fp, #4
09974     11 28 06 F1 | 	add	local09, #17
09978     14 05 48 FC | 	wrbyte	#2, local09
0997c     02 F4 05 F6 | 	mov	result1, #2
09980     AC 01 90 FD | 	jmp	#LR__0601
09984                 | LR__0593
09984     04 50 05 F1 | 	add	fp, #4
09988     A8 28 02 FB | 	rdlong	local09, fp
0998c     10 50 05 F1 | 	add	fp, #16
09990     A8 2A 02 FB | 	rdlong	local10, fp
09994     14 50 85 F1 | 	sub	fp, #20
09998     18 28 06 F1 | 	add	local09, #24
0999c     14 2B 62 FC | 	wrlong	local10, local09
099a0     7C FE 9F FD | 	jmp	#LR__0588
099a4                 | LR__0594
099a4     04 50 05 F1 | 	add	fp, #4
099a8     A8 1A 02 FB | 	rdlong	local02, fp
099ac     0D 29 02 F6 | 	mov	local09, local02
099b0     14 1A 06 F1 | 	add	local02, #20
099b4     0D 2B 02 FB | 	rdlong	local10, local02
099b8     04 50 05 F1 | 	add	fp, #4
099bc     A8 26 02 FB | 	rdlong	local08, fp
099c0     13 2B 02 F1 | 	add	local10, local08
099c4     14 28 06 F1 | 	add	local09, #20
099c8     14 2B 62 FC | 	wrlong	local10, local09
099cc     A8 28 02 FB | 	rdlong	local09, fp
099d0     08 50 85 F1 | 	sub	fp, #8
099d4     FF 29 CE F7 | 	test	local09, #511 wz
099d8     6C 00 90 AD |  if_e	jmp	#LR__0596
099dc     10 50 05 F1 | 	add	fp, #16
099e0     A8 0E 02 FB | 	rdlong	arg01, fp
099e4     04 50 05 F1 | 	add	fp, #4
099e8     A8 10 02 FB | 	rdlong	arg02, fp
099ec     14 50 85 F1 | 	sub	fp, #20
099f0     10 AE BF FD | 	call	#_ff_cc_clst2sect_0221
099f4     1C 50 05 F1 | 	add	fp, #28
099f8     A8 F4 61 FC | 	wrlong	result1, fp
099fc     1C 50 85 F1 | 	sub	fp, #28
09a00     00 F4 0D F2 | 	cmp	result1, #0 wz
09a04     1C 00 90 5D |  if_ne	jmp	#LR__0595
09a08     04 50 05 F1 | 	add	fp, #4
09a0c     A8 28 02 FB | 	rdlong	local09, fp
09a10     04 50 85 F1 | 	sub	fp, #4
09a14     11 28 06 F1 | 	add	local09, #17
09a18     14 05 48 FC | 	wrbyte	#2, local09
09a1c     02 F4 05 F6 | 	mov	result1, #2
09a20     0C 01 90 FD | 	jmp	#LR__0601
09a24                 | LR__0595
09a24     1C 50 05 F1 | 	add	fp, #28
09a28     A8 28 02 FB | 	rdlong	local09, fp
09a2c     14 50 85 F1 | 	sub	fp, #20
09a30     A8 2A 02 FB | 	rdlong	local10, fp
09a34     09 2A 46 F0 | 	shr	local10, #9
09a38     15 29 02 F1 | 	add	local09, local10
09a3c     14 50 05 F1 | 	add	fp, #20
09a40     A8 28 62 FC | 	wrlong	local09, fp
09a44     1C 50 85 F1 | 	sub	fp, #28
09a48                 | LR__0596
09a48                 | LR__0597
09a48                 | LR__0598
09a48     04 50 05 F1 | 	add	fp, #4
09a4c     A8 2A 02 FB | 	rdlong	local10, fp
09a50     15 29 02 F6 | 	mov	local09, local10
09a54     04 50 85 F1 | 	sub	fp, #4
09a58     14 28 06 F1 | 	add	local09, #20
09a5c     14 1F 02 FB | 	rdlong	local04, local09
09a60     0C 2A 06 F1 | 	add	local10, #12
09a64     15 27 02 FB | 	rdlong	local08, local10
09a68     13 1F 1A F2 | 	cmp	local04, local08 wcz
09a6c     3C 00 90 ED |  if_be	jmp	#LR__0599
09a70     04 50 05 F1 | 	add	fp, #4
09a74     A8 2A 02 FB | 	rdlong	local10, fp
09a78     15 29 02 F6 | 	mov	local09, local10
09a7c     14 2A 06 F1 | 	add	local10, #20
09a80     15 1F 02 FB | 	rdlong	local04, local10
09a84     0C 28 06 F1 | 	add	local09, #12
09a88     14 1F 62 FC | 	wrlong	local04, local09
09a8c     A8 1A 02 FB | 	rdlong	local02, fp
09a90     0D 29 02 F6 | 	mov	local09, local02
09a94     04 50 85 F1 | 	sub	fp, #4
09a98     10 1A 06 F1 | 	add	local02, #16
09a9c     0D 2B C2 FA | 	rdbyte	local10, local02
09aa0     40 2A 46 F5 | 	or	local10, #64
09aa4     10 28 06 F1 | 	add	local09, #16
09aa8     14 2B 42 FC | 	wrbyte	local10, local09
09aac                 | LR__0599
09aac     04 50 05 F1 | 	add	fp, #4
09ab0     A8 28 02 FB | 	rdlong	local09, fp
09ab4     04 50 85 F1 | 	sub	fp, #4
09ab8     14 28 06 F1 | 	add	local09, #20
09abc     14 1F 02 FB | 	rdlong	local04, local09
09ac0     0F 1B 02 F6 | 	mov	local02, local04
09ac4     FF 1B CE F7 | 	test	local02, #511 wz
09ac8     58 00 90 AD |  if_e	jmp	#LR__0600
09acc     04 50 05 F1 | 	add	fp, #4
09ad0     A8 26 02 FB | 	rdlong	local08, fp
09ad4     13 1D 02 F6 | 	mov	local03, local08
09ad8     18 50 05 F1 | 	add	fp, #24
09adc     A8 20 02 FB | 	rdlong	local05, fp
09ae0     1C 50 85 F1 | 	sub	fp, #28
09ae4     10 23 02 F6 | 	mov	local06, local05
09ae8     1C 1C 06 F1 | 	add	local03, #28
09aec     0E 2F 02 FB | 	rdlong	local12, local03
09af0     1C 1C 86 F1 | 	sub	local03, #28
09af4     17 25 02 F6 | 	mov	local07, local12
09af8     12 23 0A F2 | 	cmp	local06, local07 wz
09afc     24 00 90 AD |  if_e	jmp	#LR__0600
09b00     04 50 05 F1 | 	add	fp, #4
09b04     A8 18 02 FB | 	rdlong	local01, fp
09b08     0C 29 02 F6 | 	mov	local09, local01
09b0c     18 50 05 F1 | 	add	fp, #24
09b10     A8 2A 02 FB | 	rdlong	local10, fp
09b14     1C 50 85 F1 | 	sub	fp, #28
09b18     1C 28 06 F1 | 	add	local09, #28
09b1c     14 2B 62 FC | 	wrlong	local10, local09
09b20     1C 28 86 F1 | 	sub	local09, #28
09b24                 | LR__0600
09b24                 | ' #line 4581 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
09b24                 | ' 			fp->sect = nsect;
09b24                 | ' 		}
09b24                 | ' 	}
09b24                 | ' 
09b24                 | ' 	return res ;
09b24     0C 50 05 F1 | 	add	fp, #12
09b28     A8 F4 01 FB | 	rdlong	result1, fp
09b2c     0C 50 85 F1 | 	sub	fp, #12
09b30                 | LR__0601
09b30     A8 F0 03 F6 | 	mov	ptra, fp
09b34     B3 00 A0 FD | 	call	#popregs_
09b38                 | _ff_cc_f_lseek_ret
09b38     2D 00 64 FD | 	ret
09b3c                 | 
09b3c                 | _ff_cc_f_opendir
09b3c     01 4C 05 F6 | 	mov	COUNT_, #1
09b40     A9 00 A0 FD | 	call	#pushregs_
09b44     14 F0 07 F1 | 	add	ptra, #20
09b48     04 50 05 F1 | 	add	fp, #4
09b4c     A8 0E 62 FC | 	wrlong	arg01, fp
09b50     04 50 05 F1 | 	add	fp, #4
09b54     A8 10 62 FC | 	wrlong	arg02, fp
09b58     04 50 85 F1 | 	sub	fp, #4
09b5c     A8 12 0A FB | 	rdlong	arg03, fp wz
09b60     04 50 85 F1 | 	sub	fp, #4
09b64     09 F4 05 A6 |  if_e	mov	result1, #9
09b68     78 01 90 AD |  if_e	jmp	#LR__0608
09b6c     08 50 05 F1 | 	add	fp, #8
09b70     A8 0E 02 F6 | 	mov	arg01, fp
09b74     08 50 05 F1 | 	add	fp, #8
09b78     A8 10 02 F6 | 	mov	arg02, fp
09b7c     10 50 85 F1 | 	sub	fp, #16
09b80     00 12 06 F6 | 	mov	arg03, #0
09b84     C8 DA BF FD | 	call	#_ff_cc_mount_volume_0355
09b88     0C 50 05 F1 | 	add	fp, #12
09b8c     A8 F4 61 FC | 	wrlong	result1, fp
09b90     0C 50 85 F1 | 	sub	fp, #12
09b94     00 F4 0D F2 | 	cmp	result1, #0 wz
09b98     20 01 90 5D |  if_ne	jmp	#LR__0607
09b9c     04 50 05 F1 | 	add	fp, #4
09ba0     A8 10 02 FB | 	rdlong	arg02, fp
09ba4     0C 50 05 F1 | 	add	fp, #12
09ba8     A8 F4 01 FB | 	rdlong	result1, fp
09bac     08 F5 61 FC | 	wrlong	result1, arg02
09bb0     0C 50 85 F1 | 	sub	fp, #12
09bb4     A8 0E 02 FB | 	rdlong	arg01, fp
09bb8     04 50 05 F1 | 	add	fp, #4
09bbc     A8 10 02 FB | 	rdlong	arg02, fp
09bc0     08 50 85 F1 | 	sub	fp, #8
09bc4     90 D5 BF FD | 	call	#_ff_cc_follow_path_0332
09bc8     0C 50 05 F1 | 	add	fp, #12
09bcc     A8 F4 61 FC | 	wrlong	result1, fp
09bd0     0C 50 85 F1 | 	sub	fp, #12
09bd4     00 F4 0D F2 | 	cmp	result1, #0 wz
09bd8     C4 00 90 5D |  if_ne	jmp	#LR__0606
09bdc     04 50 05 F1 | 	add	fp, #4
09be0     A8 F4 01 FB | 	rdlong	result1, fp
09be4     04 50 85 F1 | 	sub	fp, #4
09be8     2B F4 05 F1 | 	add	result1, #43
09bec     FA F4 C1 FA | 	rdbyte	result1, result1
09bf0     80 F4 CD F7 | 	test	result1, #128 wz
09bf4     58 00 90 5D |  if_ne	jmp	#LR__0604
09bf8     04 50 05 F1 | 	add	fp, #4
09bfc     A8 10 02 FB | 	rdlong	arg02, fp
09c00     04 50 85 F1 | 	sub	fp, #4
09c04     06 10 06 F1 | 	add	arg02, #6
09c08     08 F5 C1 FA | 	rdbyte	result1, arg02
09c0c     10 F4 CD F7 | 	test	result1, #16 wz
09c10     30 00 90 AD |  if_e	jmp	#LR__0602
09c14     04 50 05 F1 | 	add	fp, #4
09c18     A8 10 02 FB | 	rdlong	arg02, fp
09c1c     08 19 02 F6 | 	mov	local01, arg02
09c20     0C 50 05 F1 | 	add	fp, #12
09c24     A8 0E 02 FB | 	rdlong	arg01, fp
09c28     10 50 85 F1 | 	sub	fp, #16
09c2c     1C 10 06 F1 | 	add	arg02, #28
09c30     08 11 02 FB | 	rdlong	arg02, arg02
09c34     A8 B8 BF FD | 	call	#_ff_cc_ld_clust_0259
09c38     08 18 06 F1 | 	add	local01, #8
09c3c     0C F5 61 FC | 	wrlong	result1, local01
09c40     0C 00 90 FD | 	jmp	#LR__0603
09c44                 | LR__0602
09c44     0C 50 05 F1 | 	add	fp, #12
09c48     A8 0A 68 FC | 	wrlong	#5, fp
09c4c     0C 50 85 F1 | 	sub	fp, #12
09c50                 | LR__0603
09c50                 | LR__0604
09c50     0C 50 05 F1 | 	add	fp, #12
09c54     A8 18 0A FB | 	rdlong	local01, fp wz
09c58     0C 50 85 F1 | 	sub	fp, #12
09c5c     40 00 90 5D |  if_ne	jmp	#LR__0605
09c60     04 50 05 F1 | 	add	fp, #4
09c64     A8 18 02 FB | 	rdlong	local01, fp
09c68     0C 50 05 F1 | 	add	fp, #12
09c6c     A8 10 02 FB | 	rdlong	arg02, fp
09c70     06 10 06 F1 | 	add	arg02, #6
09c74     08 11 E2 FA | 	rdword	arg02, arg02
09c78     04 18 06 F1 | 	add	local01, #4
09c7c     0C 11 52 FC | 	wrword	arg02, local01
09c80     0C 50 85 F1 | 	sub	fp, #12
09c84     A8 0E 02 FB | 	rdlong	arg01, fp
09c88     04 50 85 F1 | 	sub	fp, #4
09c8c     00 10 06 F6 | 	mov	arg02, #0
09c90     54 B4 BF FD | 	call	#_ff_cc_dir_sdi_0249
09c94     0C 50 05 F1 | 	add	fp, #12
09c98     A8 F4 61 FC | 	wrlong	result1, fp
09c9c     0C 50 85 F1 | 	sub	fp, #12
09ca0                 | LR__0605
09ca0                 | LR__0606
09ca0     0C 50 05 F1 | 	add	fp, #12
09ca4     A8 18 02 FB | 	rdlong	local01, fp
09ca8     0C 50 85 F1 | 	sub	fp, #12
09cac     04 18 0E F2 | 	cmp	local01, #4 wz
09cb0     0C 50 05 A1 |  if_e	add	fp, #12
09cb4     A8 0A 68 AC |  if_e	wrlong	#5, fp
09cb8     0C 50 85 A1 |  if_e	sub	fp, #12
09cbc                 | LR__0607
09cbc     0C 50 05 F1 | 	add	fp, #12
09cc0     A8 18 0A FB | 	rdlong	local01, fp wz
09cc4     0C 50 85 F1 | 	sub	fp, #12
09cc8     04 50 05 51 |  if_ne	add	fp, #4
09ccc     A8 18 02 5B |  if_ne	rdlong	local01, fp
09cd0     04 50 85 51 |  if_ne	sub	fp, #4
09cd4     0C 01 68 5C |  if_ne	wrlong	#0, local01
09cd8                 | ' 
09cd8                 | ' 	return res ;
09cd8     0C 50 05 F1 | 	add	fp, #12
09cdc     A8 F4 01 FB | 	rdlong	result1, fp
09ce0     0C 50 85 F1 | 	sub	fp, #12
09ce4                 | LR__0608
09ce4     A8 F0 03 F6 | 	mov	ptra, fp
09ce8     B3 00 A0 FD | 	call	#popregs_
09cec                 | _ff_cc_f_opendir_ret
09cec     2D 00 64 FD | 	ret
09cf0                 | 
09cf0                 | _ff_cc_f_closedir
09cf0     00 4C 05 F6 | 	mov	COUNT_, #0
09cf4     A9 00 A0 FD | 	call	#pushregs_
09cf8     10 F0 07 F1 | 	add	ptra, #16
09cfc     04 50 05 F1 | 	add	fp, #4
09d00     A8 0E 62 FC | 	wrlong	arg01, fp
09d04     08 50 05 F1 | 	add	fp, #8
09d08     A8 10 02 F6 | 	mov	arg02, fp
09d0c     0C 50 85 F1 | 	sub	fp, #12
09d10     40 DF BF FD | 	call	#_ff_cc_validate_0357
09d14     08 50 05 F1 | 	add	fp, #8
09d18     A8 F4 61 FC | 	wrlong	result1, fp
09d1c     08 50 85 F1 | 	sub	fp, #8
09d20     00 F4 0D F2 | 	cmp	result1, #0 wz
09d24     04 50 05 A1 |  if_e	add	fp, #4
09d28     A8 F4 01 AB |  if_e	rdlong	result1, fp
09d2c     04 50 85 A1 |  if_e	sub	fp, #4
09d30     FA 00 68 AC |  if_e	wrlong	#0, result1
09d34                 | ' 
09d34                 | ' 
09d34                 | ' 
09d34                 | ' 
09d34                 | ' 		dp->obj.fs = 0;
09d34                 | ' #line 4680 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
09d34                 | ' 	}
09d34                 | ' 	return res;
09d34     08 50 05 F1 | 	add	fp, #8
09d38     A8 F4 01 FB | 	rdlong	result1, fp
09d3c     08 50 85 F1 | 	sub	fp, #8
09d40     A8 F0 03 F6 | 	mov	ptra, fp
09d44     B3 00 A0 FD | 	call	#popregs_
09d48                 | _ff_cc_f_closedir_ret
09d48     2D 00 64 FD | 	ret
09d4c                 | 
09d4c                 | _ff_cc_f_readdir
09d4c     00 4C 05 F6 | 	mov	COUNT_, #0
09d50     A9 00 A0 FD | 	call	#pushregs_
09d54     14 F0 07 F1 | 	add	ptra, #20
09d58     04 50 05 F1 | 	add	fp, #4
09d5c     A8 0E 62 FC | 	wrlong	arg01, fp
09d60     04 50 05 F1 | 	add	fp, #4
09d64     A8 10 62 FC | 	wrlong	arg02, fp
09d68     04 50 85 F1 | 	sub	fp, #4
09d6c     A8 0E 02 FB | 	rdlong	arg01, fp
09d70     0C 50 05 F1 | 	add	fp, #12
09d74     A8 10 02 F6 | 	mov	arg02, fp
09d78     10 50 85 F1 | 	sub	fp, #16
09d7c     D4 DE BF FD | 	call	#_ff_cc_validate_0357
09d80     0C 50 05 F1 | 	add	fp, #12
09d84     A8 F4 61 FC | 	wrlong	result1, fp
09d88     0C 50 85 F1 | 	sub	fp, #12
09d8c     00 F4 0D F2 | 	cmp	result1, #0 wz
09d90     BC 00 90 5D |  if_ne	jmp	#LR__0612
09d94     08 50 05 F1 | 	add	fp, #8
09d98     A8 F4 09 FB | 	rdlong	result1, fp wz
09d9c     08 50 85 F1 | 	sub	fp, #8
09da0     24 00 90 5D |  if_ne	jmp	#LR__0609
09da4     04 50 05 F1 | 	add	fp, #4
09da8     A8 0E 02 FB | 	rdlong	arg01, fp
09dac     04 50 85 F1 | 	sub	fp, #4
09db0     00 10 06 F6 | 	mov	arg02, #0
09db4     30 B3 BF FD | 	call	#_ff_cc_dir_sdi_0249
09db8     0C 50 05 F1 | 	add	fp, #12
09dbc     A8 F4 61 FC | 	wrlong	result1, fp
09dc0     0C 50 85 F1 | 	sub	fp, #12
09dc4     88 00 90 FD | 	jmp	#LR__0611
09dc8                 | LR__0609
09dc8     04 50 05 F1 | 	add	fp, #4
09dcc     A8 0E 02 FB | 	rdlong	arg01, fp
09dd0     04 50 85 F1 | 	sub	fp, #4
09dd4     00 10 06 F6 | 	mov	arg02, #0
09dd8     94 BC BF FD | 	call	#_ff_cc_dir_read_0291
09ddc     0C 50 05 F1 | 	add	fp, #12
09de0     A8 F4 61 FC | 	wrlong	result1, fp
09de4     0C 50 85 F1 | 	sub	fp, #12
09de8     04 F4 0D F2 | 	cmp	result1, #4 wz
09dec     0C 50 05 A1 |  if_e	add	fp, #12
09df0     A8 00 68 AC |  if_e	wrlong	#0, fp
09df4     0C 50 85 A1 |  if_e	sub	fp, #12
09df8     0C 50 05 F1 | 	add	fp, #12
09dfc     A8 F4 09 FB | 	rdlong	result1, fp wz
09e00     0C 50 85 F1 | 	sub	fp, #12
09e04     48 00 90 5D |  if_ne	jmp	#LR__0610
09e08     04 50 05 F1 | 	add	fp, #4
09e0c     A8 0E 02 FB | 	rdlong	arg01, fp
09e10     04 50 05 F1 | 	add	fp, #4
09e14     A8 10 02 FB | 	rdlong	arg02, fp
09e18     08 50 85 F1 | 	sub	fp, #8
09e1c     40 C6 BF FD | 	call	#_ff_cc_get_fileinfo_0317
09e20     04 50 05 F1 | 	add	fp, #4
09e24     A8 0E 02 FB | 	rdlong	arg01, fp
09e28     04 50 85 F1 | 	sub	fp, #4
09e2c     00 10 06 F6 | 	mov	arg02, #0
09e30     2C B4 BF FD | 	call	#_ff_cc_dir_next_0253
09e34     0C 50 05 F1 | 	add	fp, #12
09e38     A8 F4 61 FC | 	wrlong	result1, fp
09e3c     0C 50 85 F1 | 	sub	fp, #12
09e40     04 F4 0D F2 | 	cmp	result1, #4 wz
09e44     0C 50 05 A1 |  if_e	add	fp, #12
09e48     A8 00 68 AC |  if_e	wrlong	#0, fp
09e4c     0C 50 85 A1 |  if_e	sub	fp, #12
09e50                 | LR__0610
09e50                 | LR__0611
09e50                 | LR__0612
09e50                 | ' 			}
09e50                 | ' 			;
09e50                 | ' 		}
09e50                 | ' 	}
09e50                 | ' 	return res ;
09e50     0C 50 05 F1 | 	add	fp, #12
09e54     A8 F4 01 FB | 	rdlong	result1, fp
09e58     0C 50 85 F1 | 	sub	fp, #12
09e5c     A8 F0 03 F6 | 	mov	ptra, fp
09e60     B3 00 A0 FD | 	call	#popregs_
09e64                 | _ff_cc_f_readdir_ret
09e64     2D 00 64 FD | 	ret
09e68                 | 
09e68                 | _ff_cc_f_stat
09e68     00 4C 05 F6 | 	mov	COUNT_, #0
09e6c     A9 00 A0 FD | 	call	#pushregs_
09e70     40 F0 07 F1 | 	add	ptra, #64
09e74     04 50 05 F1 | 	add	fp, #4
09e78     A8 0E 62 FC | 	wrlong	arg01, fp
09e7c     04 50 05 F1 | 	add	fp, #4
09e80     A8 10 62 FC | 	wrlong	arg02, fp
09e84     04 50 85 F1 | 	sub	fp, #4
09e88     A8 0E 02 F6 | 	mov	arg01, fp
09e8c     0C 50 05 F1 | 	add	fp, #12
09e90     A8 10 02 F6 | 	mov	arg02, fp
09e94     10 50 85 F1 | 	sub	fp, #16
09e98     00 12 06 F6 | 	mov	arg03, #0
09e9c     B0 D7 BF FD | 	call	#_ff_cc_mount_volume_0355
09ea0     0C 50 05 F1 | 	add	fp, #12
09ea4     A8 F4 61 FC | 	wrlong	result1, fp
09ea8     0C 50 85 F1 | 	sub	fp, #12
09eac     00 F4 0D F2 | 	cmp	result1, #0 wz
09eb0     74 00 90 5D |  if_ne	jmp	#LR__0616
09eb4     10 50 05 F1 | 	add	fp, #16
09eb8     A8 0E 02 F6 | 	mov	arg01, fp
09ebc     0C 50 85 F1 | 	sub	fp, #12
09ec0     A8 10 02 FB | 	rdlong	arg02, fp
09ec4     04 50 85 F1 | 	sub	fp, #4
09ec8     8C D2 BF FD | 	call	#_ff_cc_follow_path_0332
09ecc     0C 50 05 F1 | 	add	fp, #12
09ed0     A8 F4 61 FC | 	wrlong	result1, fp
09ed4     0C 50 85 F1 | 	sub	fp, #12
09ed8     00 F4 0D F2 | 	cmp	result1, #0 wz
09edc     48 00 90 5D |  if_ne	jmp	#LR__0615
09ee0     3B 50 05 F1 | 	add	fp, #59
09ee4     A8 F4 C1 FA | 	rdbyte	result1, fp
09ee8     3B 50 85 F1 | 	sub	fp, #59
09eec     80 F4 CD F7 | 	test	result1, #128 wz
09ef0     0C 50 05 51 |  if_ne	add	fp, #12
09ef4     A8 0C 68 5C |  if_ne	wrlong	#6, fp
09ef8     0C 50 85 51 |  if_ne	sub	fp, #12
09efc     28 00 90 5D |  if_ne	jmp	#LR__0614
09f00     08 50 05 F1 | 	add	fp, #8
09f04     A8 F4 09 FB | 	rdlong	result1, fp wz
09f08     08 50 85 F1 | 	sub	fp, #8
09f0c     18 00 90 AD |  if_e	jmp	#LR__0613
09f10     10 50 05 F1 | 	add	fp, #16
09f14     A8 0E 02 F6 | 	mov	arg01, fp
09f18     08 50 85 F1 | 	sub	fp, #8
09f1c     A8 10 02 FB | 	rdlong	arg02, fp
09f20     08 50 85 F1 | 	sub	fp, #8
09f24     38 C5 BF FD | 	call	#_ff_cc_get_fileinfo_0317
09f28                 | LR__0613
09f28                 | LR__0614
09f28                 | LR__0615
09f28                 | LR__0616
09f28                 | ' 			}
09f28                 | ' 		}
09f28                 | ' 		;
09f28                 | ' 	}
09f28                 | ' 
09f28                 | ' 	return res ;
09f28     0C 50 05 F1 | 	add	fp, #12
09f2c     A8 F4 01 FB | 	rdlong	result1, fp
09f30     0C 50 85 F1 | 	sub	fp, #12
09f34     A8 F0 03 F6 | 	mov	ptra, fp
09f38     B3 00 A0 FD | 	call	#popregs_
09f3c                 | _ff_cc_f_stat_ret
09f3c     2D 00 64 FD | 	ret
09f40                 | 
09f40                 | _ff_cc_f_unlink
09f40     04 4C 05 F6 | 	mov	COUNT_, #4
09f44     A9 00 A0 FD | 	call	#pushregs_
09f48     74 F0 07 F1 | 	add	ptra, #116
09f4c     04 50 05 F1 | 	add	fp, #4
09f50     A8 0E 62 FC | 	wrlong	arg01, fp
09f54     68 50 05 F1 | 	add	fp, #104
09f58     A8 00 68 FC | 	wrlong	#0, fp
09f5c     68 50 85 F1 | 	sub	fp, #104
09f60     A8 0E 02 F6 | 	mov	arg01, fp
09f64     6C 50 05 F1 | 	add	fp, #108
09f68     A8 10 02 F6 | 	mov	arg02, fp
09f6c     70 50 85 F1 | 	sub	fp, #112
09f70     02 12 06 F6 | 	mov	arg03, #2
09f74     D8 D6 BF FD | 	call	#_ff_cc_mount_volume_0355
09f78     08 50 05 F1 | 	add	fp, #8
09f7c     A8 F4 61 FC | 	wrlong	result1, fp
09f80     08 50 85 F1 | 	sub	fp, #8
09f84     00 F4 0D F2 | 	cmp	result1, #0 wz
09f88     F0 01 90 5D |  if_ne	jmp	#LR__0625
09f8c     70 50 05 F1 | 	add	fp, #112
09f90     A8 10 02 FB | 	rdlong	arg02, fp
09f94     64 50 85 F1 | 	sub	fp, #100
09f98     A8 10 62 FC | 	wrlong	arg02, fp
09f9c     A8 0E 02 F6 | 	mov	arg01, fp
09fa0     08 50 85 F1 | 	sub	fp, #8
09fa4     A8 10 02 FB | 	rdlong	arg02, fp
09fa8     04 50 85 F1 | 	sub	fp, #4
09fac     A8 D1 BF FD | 	call	#_ff_cc_follow_path_0332
09fb0     08 50 05 F1 | 	add	fp, #8
09fb4     A8 F4 61 FC | 	wrlong	result1, fp
09fb8     FA F4 09 F6 | 	mov	result1, result1 wz
09fbc     08 50 85 F1 | 	sub	fp, #8
09fc0     B8 01 90 5D |  if_ne	jmp	#LR__0624
09fc4     37 50 05 F1 | 	add	fp, #55
09fc8     A8 F4 C1 FA | 	rdbyte	result1, fp
09fcc     37 50 85 F1 | 	sub	fp, #55
09fd0     80 F4 CD F7 | 	test	result1, #128 wz
09fd4     08 50 05 51 |  if_ne	add	fp, #8
09fd8     A8 0C 68 5C |  if_ne	wrlong	#6, fp
09fdc     08 50 85 51 |  if_ne	sub	fp, #8
09fe0     1C 00 90 5D |  if_ne	jmp	#LR__0617
09fe4     12 50 05 F1 | 	add	fp, #18
09fe8     A8 F4 C1 FA | 	rdbyte	result1, fp
09fec     12 50 85 F1 | 	sub	fp, #18
09ff0     01 F4 CD F7 | 	test	result1, #1 wz
09ff4     08 50 05 51 |  if_ne	add	fp, #8
09ff8     A8 0E 68 5C |  if_ne	wrlong	#7, fp
09ffc     08 50 85 51 |  if_ne	sub	fp, #8
0a000                 | LR__0617
0a000     08 50 05 F1 | 	add	fp, #8
0a004     A8 F4 09 FB | 	rdlong	result1, fp wz
0a008     08 50 85 F1 | 	sub	fp, #8
0a00c     C8 00 90 5D |  if_ne	jmp	#LR__0620
0a010     70 50 05 F1 | 	add	fp, #112
0a014     A8 0E 02 FB | 	rdlong	arg01, fp
0a018     48 50 85 F1 | 	sub	fp, #72
0a01c     A8 10 02 FB | 	rdlong	arg02, fp
0a020     28 50 85 F1 | 	sub	fp, #40
0a024     B8 B4 BF FD | 	call	#_ff_cc_ld_clust_0259
0a028     6C 50 05 F1 | 	add	fp, #108
0a02c     A8 F4 61 FC | 	wrlong	result1, fp
0a030     5A 50 85 F1 | 	sub	fp, #90
0a034     A8 F4 C1 FA | 	rdbyte	result1, fp
0a038     12 50 85 F1 | 	sub	fp, #18
0a03c     10 F4 CD F7 | 	test	result1, #16 wz
0a040     94 00 90 AD |  if_e	jmp	#LR__0619
0a044     70 50 05 F1 | 	add	fp, #112
0a048     A8 F4 01 FB | 	rdlong	result1, fp
0a04c     34 50 85 F1 | 	sub	fp, #52
0a050     A8 F4 61 FC | 	wrlong	result1, fp
0a054     30 50 05 F1 | 	add	fp, #48
0a058     A8 10 02 FB | 	rdlong	arg02, fp
0a05c     28 50 85 F1 | 	sub	fp, #40
0a060     A8 10 62 FC | 	wrlong	arg02, fp
0a064     08 50 85 F1 | 	sub	fp, #8
0a068     A8 0E 02 F6 | 	mov	arg01, fp
0a06c     3C 50 85 F1 | 	sub	fp, #60
0a070     00 10 06 F6 | 	mov	arg02, #0
0a074     70 B0 BF FD | 	call	#_ff_cc_dir_sdi_0249
0a078     08 50 05 F1 | 	add	fp, #8
0a07c     A8 F4 61 FC | 	wrlong	result1, fp
0a080     08 50 85 F1 | 	sub	fp, #8
0a084     00 F4 0D F2 | 	cmp	result1, #0 wz
0a088     4C 00 90 5D |  if_ne	jmp	#LR__0618
0a08c     3C 50 05 F1 | 	add	fp, #60
0a090     A8 0E 02 F6 | 	mov	arg01, fp
0a094     3C 50 85 F1 | 	sub	fp, #60
0a098     00 10 06 F6 | 	mov	arg02, #0
0a09c     D0 B9 BF FD | 	call	#_ff_cc_dir_read_0291
0a0a0     08 50 05 F1 | 	add	fp, #8
0a0a4     A8 F4 61 FC | 	wrlong	result1, fp
0a0a8     FA F4 09 F6 | 	mov	result1, result1 wz
0a0ac     08 50 85 F1 | 	sub	fp, #8
0a0b0     08 50 05 A1 |  if_e	add	fp, #8
0a0b4     A8 0E 68 AC |  if_e	wrlong	#7, fp
0a0b8     08 50 85 A1 |  if_e	sub	fp, #8
0a0bc     08 50 05 F1 | 	add	fp, #8
0a0c0     A8 F4 01 FB | 	rdlong	result1, fp
0a0c4     08 50 85 F1 | 	sub	fp, #8
0a0c8     04 F4 0D F2 | 	cmp	result1, #4 wz
0a0cc     08 50 05 A1 |  if_e	add	fp, #8
0a0d0     A8 00 68 AC |  if_e	wrlong	#0, fp
0a0d4     08 50 85 A1 |  if_e	sub	fp, #8
0a0d8                 | LR__0618
0a0d8                 | LR__0619
0a0d8                 | LR__0620
0a0d8     08 50 05 F1 | 	add	fp, #8
0a0dc     A8 F4 09 FB | 	rdlong	result1, fp wz
0a0e0     08 50 85 F1 | 	sub	fp, #8
0a0e4     94 00 90 5D |  if_ne	jmp	#LR__0623
0a0e8     0C 50 05 F1 | 	add	fp, #12
0a0ec     A8 0E 02 F6 | 	mov	arg01, fp
0a0f0     0C 50 85 F1 | 	sub	fp, #12
0a0f4     88 C2 BF FD | 	call	#_ff_cc_dir_remove_0310
0a0f8     08 50 05 F1 | 	add	fp, #8
0a0fc     A8 F4 61 FC | 	wrlong	result1, fp
0a100     08 50 85 F1 | 	sub	fp, #8
0a104     00 F4 0D F2 | 	cmp	result1, #0 wz
0a108     44 00 90 5D |  if_ne	jmp	#LR__0621
0a10c     6C 50 05 F1 | 	add	fp, #108
0a110     A8 18 0A FB | 	rdlong	local01, fp wz
0a114     6C 50 85 F1 | 	sub	fp, #108
0a118     34 00 90 AD |  if_e	jmp	#LR__0621
0a11c     0C 50 05 F1 | 	add	fp, #12
0a120     A8 0E 02 F6 | 	mov	arg01, fp
0a124     60 50 05 F1 | 	add	fp, #96
0a128     A8 1A 02 FB | 	rdlong	local02, fp
0a12c     6C 50 85 F1 | 	sub	fp, #108
0a130     00 1C 06 F6 | 	mov	local03, #0
0a134     0D 11 02 F6 | 	mov	arg02, local02
0a138     00 12 06 F6 | 	mov	arg03, #0
0a13c     88 AB BF FD | 	call	#_ff_cc_remove_chain_0234
0a140     FA 1E 02 F6 | 	mov	local04, result1
0a144     08 50 05 F1 | 	add	fp, #8
0a148     A8 1E 62 FC | 	wrlong	local04, fp
0a14c     08 50 85 F1 | 	sub	fp, #8
0a150                 | LR__0621
0a150     08 50 05 F1 | 	add	fp, #8
0a154     A8 1E 0A FB | 	rdlong	local04, fp wz
0a158     08 50 85 F1 | 	sub	fp, #8
0a15c     1C 00 90 5D |  if_ne	jmp	#LR__0622
0a160     70 50 05 F1 | 	add	fp, #112
0a164     A8 0E 02 FB | 	rdlong	arg01, fp
0a168     70 50 85 F1 | 	sub	fp, #112
0a16c     30 A5 BF FD | 	call	#_ff_cc_sync_fs_0220
0a170     08 50 05 F1 | 	add	fp, #8
0a174     A8 F4 61 FC | 	wrlong	result1, fp
0a178     08 50 85 F1 | 	sub	fp, #8
0a17c                 | LR__0622
0a17c                 | LR__0623
0a17c                 | LR__0624
0a17c                 | LR__0625
0a17c                 | ' 			}
0a17c                 | ' 		}
0a17c                 | ' 		;
0a17c                 | ' 	}
0a17c                 | ' 
0a17c                 | ' 	return res ;
0a17c     08 50 05 F1 | 	add	fp, #8
0a180     A8 F4 01 FB | 	rdlong	result1, fp
0a184     08 50 85 F1 | 	sub	fp, #8
0a188     A8 F0 03 F6 | 	mov	ptra, fp
0a18c     B3 00 A0 FD | 	call	#popregs_
0a190                 | _ff_cc_f_unlink_ret
0a190     2D 00 64 FD | 	ret
0a194                 | 
0a194                 | _ff_cc_f_mkdir
0a194     03 4C 05 F6 | 	mov	COUNT_, #3
0a198     A9 00 A0 FD | 	call	#pushregs_
0a19c     5C F0 07 F1 | 	add	ptra, #92
0a1a0     04 50 05 F1 | 	add	fp, #4
0a1a4     A8 0E 62 FC | 	wrlong	arg01, fp
0a1a8     A8 0E 02 F6 | 	mov	arg01, fp
0a1ac     48 50 05 F1 | 	add	fp, #72
0a1b0     A8 10 02 F6 | 	mov	arg02, fp
0a1b4     4C 50 85 F1 | 	sub	fp, #76
0a1b8     02 12 06 F6 | 	mov	arg03, #2
0a1bc     90 D4 BF FD | 	call	#_ff_cc_mount_volume_0355
0a1c0     08 50 05 F1 | 	add	fp, #8
0a1c4     A8 F4 61 FC | 	wrlong	result1, fp
0a1c8     08 50 85 F1 | 	sub	fp, #8
0a1cc     00 F4 0D F2 | 	cmp	result1, #0 wz
0a1d0     EC 02 90 5D |  if_ne	jmp	#LR__0635
0a1d4     4C 50 05 F1 | 	add	fp, #76
0a1d8     A8 10 02 FB | 	rdlong	arg02, fp
0a1dc     40 50 85 F1 | 	sub	fp, #64
0a1e0     A8 10 62 FC | 	wrlong	arg02, fp
0a1e4     A8 0E 02 F6 | 	mov	arg01, fp
0a1e8     08 50 85 F1 | 	sub	fp, #8
0a1ec     A8 18 02 FB | 	rdlong	local01, fp
0a1f0     04 50 85 F1 | 	sub	fp, #4
0a1f4     0C 11 02 F6 | 	mov	arg02, local01
0a1f8     5C CF BF FD | 	call	#_ff_cc_follow_path_0332
0a1fc     08 50 05 F1 | 	add	fp, #8
0a200     A8 F4 61 FC | 	wrlong	result1, fp
0a204     FA 1A 02 F6 | 	mov	local02, result1
0a208     08 50 85 F1 | 	sub	fp, #8
0a20c     0D F5 09 F6 | 	mov	result1, local02 wz
0a210     08 50 05 A1 |  if_e	add	fp, #8
0a214     A8 10 68 AC |  if_e	wrlong	#8, fp
0a218     08 50 85 A1 |  if_e	sub	fp, #8
0a21c     08 50 05 F1 | 	add	fp, #8
0a220     A8 F4 01 FB | 	rdlong	result1, fp
0a224     08 50 85 F1 | 	sub	fp, #8
0a228     04 F4 0D F2 | 	cmp	result1, #4 wz
0a22c     90 02 90 5D |  if_ne	jmp	#LR__0634
0a230     4C 50 05 F1 | 	add	fp, #76
0a234     A8 10 02 FB | 	rdlong	arg02, fp
0a238     10 50 85 F1 | 	sub	fp, #16
0a23c     A8 10 62 FC | 	wrlong	arg02, fp
0a240     A8 0E 02 F6 | 	mov	arg01, fp
0a244     3C 50 85 F1 | 	sub	fp, #60
0a248     00 10 06 F6 | 	mov	arg02, #0
0a24c     90 AB BF FD | 	call	#_ff_cc_create_chain_0240
0a250     50 50 05 F1 | 	add	fp, #80
0a254     A8 F4 61 FC | 	wrlong	result1, fp
0a258     48 50 85 F1 | 	sub	fp, #72
0a25c     A8 00 68 FC | 	wrlong	#0, fp
0a260     48 50 05 F1 | 	add	fp, #72
0a264     A8 F4 09 FB | 	rdlong	result1, fp wz
0a268     50 50 85 F1 | 	sub	fp, #80
0a26c     08 50 05 A1 |  if_e	add	fp, #8
0a270     A8 0E 68 AC |  if_e	wrlong	#7, fp
0a274     08 50 85 A1 |  if_e	sub	fp, #8
0a278     50 50 05 F1 | 	add	fp, #80
0a27c     A8 F4 01 FB | 	rdlong	result1, fp
0a280     50 50 85 F1 | 	sub	fp, #80
0a284     01 F4 0D F2 | 	cmp	result1, #1 wz
0a288     08 50 05 A1 |  if_e	add	fp, #8
0a28c     A8 04 68 AC |  if_e	wrlong	#2, fp
0a290     08 50 85 A1 |  if_e	sub	fp, #8
0a294     50 50 05 F1 | 	add	fp, #80
0a298     A8 F4 01 FB | 	rdlong	result1, fp
0a29c     50 50 85 F1 | 	sub	fp, #80
0a2a0     FF FF 7F FF 
0a2a4     FF F5 0D F2 | 	cmp	result1, ##-1 wz
0a2a8     08 50 05 A1 |  if_e	add	fp, #8
0a2ac     A8 02 68 AC |  if_e	wrlong	#1, fp
0a2b0     08 50 85 A1 |  if_e	sub	fp, #8
0a2b4     58 50 05 F1 | 	add	fp, #88
0a2b8     80 10 A7 FF 
0a2bc     A8 00 68 FC | 	wrlong	##1310785536, fp
0a2c0     50 50 85 F1 | 	sub	fp, #80
0a2c4     A8 F4 09 FB | 	rdlong	result1, fp wz
0a2c8     08 50 85 F1 | 	sub	fp, #8
0a2cc     38 01 90 5D |  if_ne	jmp	#LR__0631
0a2d0     4C 50 05 F1 | 	add	fp, #76
0a2d4     A8 0E 02 FB | 	rdlong	arg01, fp
0a2d8     04 50 05 F1 | 	add	fp, #4
0a2dc     A8 18 02 FB | 	rdlong	local01, fp
0a2e0     50 50 85 F1 | 	sub	fp, #80
0a2e4     0C 11 02 F6 | 	mov	arg02, local01
0a2e8     24 AD BF FD | 	call	#_ff_cc_dir_clear_0245
0a2ec     08 50 05 F1 | 	add	fp, #8
0a2f0     A8 F4 61 FC | 	wrlong	result1, fp
0a2f4     FA 1A 02 F6 | 	mov	local02, result1
0a2f8     08 50 85 F1 | 	sub	fp, #8
0a2fc     0D 11 0A F6 | 	mov	arg02, local02 wz
0a300     04 01 90 5D |  if_ne	jmp	#LR__0630
0a304     4C 50 05 F1 | 	add	fp, #76
0a308     A8 0E 02 FB | 	rdlong	arg01, fp
0a30c     4C 50 85 F1 | 	sub	fp, #76
0a310     34 0E 06 F1 | 	add	arg01, #52
0a314     20 10 06 F6 | 	mov	arg02, #32
0a318     0B 12 06 F6 | 	mov	arg03, #11
0a31c                 | ' {
0a31c                 | ' 	BYTE *d = (BYTE*)dst;
0a31c                 | ' 
0a31c                 | ' 	do {
0a31c     EC 5C 9F FE | 	loc	pa,	#(@LR__0628-@LR__0626)
0a320     8C 00 A0 FD | 	call	#FCACHE_LOAD_
0a324                 | LR__0626
0a324     0B 04 DC FC | 	rep	@LR__0629, #11
0a328                 | LR__0627
0a328     07 11 42 FC | 	wrbyte	arg02, arg01
0a32c     01 0E 06 F1 | 	add	arg01, #1
0a330                 | LR__0628
0a330                 | LR__0629
0a330     4C 50 05 F1 | 	add	fp, #76
0a334     A8 F4 01 FB | 	rdlong	result1, fp
0a338     34 F4 05 F1 | 	add	result1, #52
0a33c     FA 5C 48 FC | 	wrbyte	#46, result1
0a340     A8 10 02 FB | 	rdlong	arg02, fp
0a344     3F 10 06 F1 | 	add	arg02, #63
0a348     08 21 48 FC | 	wrbyte	#16, arg02
0a34c     A8 0E 02 FB | 	rdlong	arg01, fp
0a350     4A 0E 06 F1 | 	add	arg01, #74
0a354     0C 50 05 F1 | 	add	fp, #12
0a358     A8 10 02 FB | 	rdlong	arg02, fp
0a35c     58 50 85 F1 | 	sub	fp, #88
0a360     30 A0 BF FD | 	call	#_ff_cc_st_dword_0195
0a364     4C 50 05 F1 | 	add	fp, #76
0a368     A8 10 02 FB | 	rdlong	arg02, fp
0a36c     08 0F 02 F6 | 	mov	arg01, arg02
0a370     34 10 06 F1 | 	add	arg02, #52
0a374     04 50 05 F1 | 	add	fp, #4
0a378     A8 12 02 FB | 	rdlong	arg03, fp
0a37c     50 50 85 F1 | 	sub	fp, #80
0a380     B0 B1 BF FD | 	call	#_ff_cc_st_clust_0260
0a384     4C 50 05 F1 | 	add	fp, #76
0a388     A8 10 02 FB | 	rdlong	arg02, fp
0a38c     08 0F 02 F6 | 	mov	arg01, arg02
0a390     54 0E 06 F1 | 	add	arg01, #84
0a394     4C 50 85 F1 | 	sub	fp, #76
0a398     34 10 06 F1 | 	add	arg02, #52
0a39c     20 12 06 F6 | 	mov	arg03, #32
0a3a0     1C A0 BF FD | 	call	#_ff_cc_mem_cpy_0198
0a3a4     4C 50 05 F1 | 	add	fp, #76
0a3a8     A8 12 02 FB | 	rdlong	arg03, fp
0a3ac     55 12 06 F1 | 	add	arg03, #85
0a3b0     09 5D 48 FC | 	wrbyte	#46, arg03
0a3b4     38 50 85 F1 | 	sub	fp, #56
0a3b8     A8 12 02 FB | 	rdlong	arg03, fp
0a3bc     40 50 05 F1 | 	add	fp, #64
0a3c0     A8 12 62 FC | 	wrlong	arg03, fp
0a3c4     08 50 85 F1 | 	sub	fp, #8
0a3c8     A8 10 02 FB | 	rdlong	arg02, fp
0a3cc     08 0F 02 F6 | 	mov	arg01, arg02
0a3d0     54 10 06 F1 | 	add	arg02, #84
0a3d4     4C 50 85 F1 | 	sub	fp, #76
0a3d8     58 B1 BF FD | 	call	#_ff_cc_st_clust_0260
0a3dc     4C 50 05 F1 | 	add	fp, #76
0a3e0     A8 0E 02 FB | 	rdlong	arg01, fp
0a3e4     03 0E 06 F1 | 	add	arg01, #3
0a3e8     07 03 48 FC | 	wrbyte	#1, arg01
0a3ec     40 50 85 F1 | 	sub	fp, #64
0a3f0     A8 0E 02 F6 | 	mov	arg01, fp
0a3f4     0C 50 85 F1 | 	sub	fp, #12
0a3f8     E8 BA BF FD | 	call	#_ff_cc_dir_register_0306
0a3fc     08 50 05 F1 | 	add	fp, #8
0a400     A8 F4 61 FC | 	wrlong	result1, fp
0a404     08 50 85 F1 | 	sub	fp, #8
0a408                 | LR__0630
0a408                 | LR__0631
0a408     08 50 05 F1 | 	add	fp, #8
0a40c     A8 1C 0A FB | 	rdlong	local03, fp wz
0a410     08 50 85 F1 | 	sub	fp, #8
0a414     8C 00 90 5D |  if_ne	jmp	#LR__0632
0a418     28 50 05 F1 | 	add	fp, #40
0a41c     A8 0E 02 FB | 	rdlong	arg01, fp
0a420     16 0E 06 F1 | 	add	arg01, #22
0a424     30 50 05 F1 | 	add	fp, #48
0a428     A8 10 02 FB | 	rdlong	arg02, fp
0a42c     58 50 85 F1 | 	sub	fp, #88
0a430     60 9F BF FD | 	call	#_ff_cc_st_dword_0195
0a434     4C 50 05 F1 | 	add	fp, #76
0a438     A8 0E 02 FB | 	rdlong	arg01, fp
0a43c     24 50 85 F1 | 	sub	fp, #36
0a440     A8 10 02 FB | 	rdlong	arg02, fp
0a444     28 50 05 F1 | 	add	fp, #40
0a448     A8 12 02 FB | 	rdlong	arg03, fp
0a44c     50 50 85 F1 | 	sub	fp, #80
0a450     E0 B0 BF FD | 	call	#_ff_cc_st_clust_0260
0a454     28 50 05 F1 | 	add	fp, #40
0a458     A8 1C 02 FB | 	rdlong	local03, fp
0a45c     0B 1C 06 F1 | 	add	local03, #11
0a460     0E 21 48 FC | 	wrbyte	#16, local03
0a464     24 50 05 F1 | 	add	fp, #36
0a468     A8 1C 02 FB | 	rdlong	local03, fp
0a46c     03 1C 06 F1 | 	add	local03, #3
0a470     0E 03 48 FC | 	wrbyte	#1, local03
0a474     44 50 85 F1 | 	sub	fp, #68
0a478     A8 1C 0A FB | 	rdlong	local03, fp wz
0a47c     08 50 85 F1 | 	sub	fp, #8
0a480     3C 00 90 5D |  if_ne	jmp	#LR__0633
0a484     4C 50 05 F1 | 	add	fp, #76
0a488     A8 0E 02 FB | 	rdlong	arg01, fp
0a48c     4C 50 85 F1 | 	sub	fp, #76
0a490     0C A2 BF FD | 	call	#_ff_cc_sync_fs_0220
0a494     08 50 05 F1 | 	add	fp, #8
0a498     A8 F4 61 FC | 	wrlong	result1, fp
0a49c     08 50 85 F1 | 	sub	fp, #8
0a4a0     1C 00 90 FD | 	jmp	#LR__0633
0a4a4                 | LR__0632
0a4a4     3C 50 05 F1 | 	add	fp, #60
0a4a8     A8 0E 02 F6 | 	mov	arg01, fp
0a4ac     14 50 05 F1 | 	add	fp, #20
0a4b0     A8 10 02 FB | 	rdlong	arg02, fp
0a4b4     50 50 85 F1 | 	sub	fp, #80
0a4b8     00 12 06 F6 | 	mov	arg03, #0
0a4bc     08 A8 BF FD | 	call	#_ff_cc_remove_chain_0234
0a4c0                 | LR__0633
0a4c0                 | LR__0634
0a4c0                 | LR__0635
0a4c0                 | ' 				remove_chain(&sobj, dcl, 0);
0a4c0                 | ' 			}
0a4c0                 | ' 		}
0a4c0                 | ' 		;
0a4c0                 | ' 	}
0a4c0                 | ' 
0a4c0                 | ' 	return res ;
0a4c0     08 50 05 F1 | 	add	fp, #8
0a4c4     A8 F4 01 FB | 	rdlong	result1, fp
0a4c8     08 50 85 F1 | 	sub	fp, #8
0a4cc     A8 F0 03 F6 | 	mov	ptra, fp
0a4d0     B3 00 A0 FD | 	call	#popregs_
0a4d4                 | _ff_cc_f_mkdir_ret
0a4d4     2D 00 64 FD | 	ret
0a4d8                 | 
0a4d8                 | _ff_cc_f_rename
0a4d8     09 4C 05 F6 | 	mov	COUNT_, #9
0a4dc     A9 00 A0 FD | 	call	#pushregs_
0a4e0     9C F0 07 F1 | 	add	ptra, #156
0a4e4     04 50 05 F1 | 	add	fp, #4
0a4e8     A8 0E 62 FC | 	wrlong	arg01, fp
0a4ec     04 50 05 F1 | 	add	fp, #4
0a4f0     A8 10 62 FC | 	wrlong	arg02, fp
0a4f4     A8 0E 02 F6 | 	mov	arg01, fp
0a4f8     08 50 85 F1 | 	sub	fp, #8
0a4fc     68 CE BF FD | 	call	#_ff_cc_get_ldnumber_0338
0a500     04 50 05 F1 | 	add	fp, #4
0a504     A8 0E 02 F6 | 	mov	arg01, fp
0a508     6C 50 05 F1 | 	add	fp, #108
0a50c     A8 10 02 F6 | 	mov	arg02, fp
0a510     70 50 85 F1 | 	sub	fp, #112
0a514     02 12 06 F6 | 	mov	arg03, #2
0a518     34 D1 BF FD | 	call	#_ff_cc_mount_volume_0355
0a51c     0C 50 05 F1 | 	add	fp, #12
0a520     A8 F4 61 FC | 	wrlong	result1, fp
0a524     0C 50 85 F1 | 	sub	fp, #12
0a528     00 F4 0D F2 | 	cmp	result1, #0 wz
0a52c     84 03 90 5D |  if_ne	jmp	#LR__0649
0a530     70 50 05 F1 | 	add	fp, #112
0a534     A8 10 02 FB | 	rdlong	arg02, fp
0a538     60 50 85 F1 | 	sub	fp, #96
0a53c     A8 10 62 FC | 	wrlong	arg02, fp
0a540     A8 0E 02 F6 | 	mov	arg01, fp
0a544     0C 50 85 F1 | 	sub	fp, #12
0a548     A8 10 02 FB | 	rdlong	arg02, fp
0a54c     04 50 85 F1 | 	sub	fp, #4
0a550     04 CC BF FD | 	call	#_ff_cc_follow_path_0332
0a554     0C 50 05 F1 | 	add	fp, #12
0a558     A8 F4 61 FC | 	wrlong	result1, fp
0a55c     FA F4 09 F6 | 	mov	result1, result1 wz
0a560     0C 50 85 F1 | 	sub	fp, #12
0a564     1C 00 90 5D |  if_ne	jmp	#LR__0636
0a568     3B 50 05 F1 | 	add	fp, #59
0a56c     A8 F4 C1 FA | 	rdbyte	result1, fp
0a570     3B 50 85 F1 | 	sub	fp, #59
0a574     A0 F4 CD F7 | 	test	result1, #160 wz
0a578     0C 50 05 51 |  if_ne	add	fp, #12
0a57c     A8 0C 68 5C |  if_ne	wrlong	#6, fp
0a580     0C 50 85 51 |  if_ne	sub	fp, #12
0a584                 | LR__0636
0a584     0C 50 05 F1 | 	add	fp, #12
0a588     A8 18 0A FB | 	rdlong	local01, fp wz
0a58c     0C 50 85 F1 | 	sub	fp, #12
0a590     20 03 90 5D |  if_ne	jmp	#LR__0648
0a594     74 50 05 F1 | 	add	fp, #116
0a598     A8 0E 02 F6 | 	mov	arg01, fp
0a59c     48 50 85 F1 | 	sub	fp, #72
0a5a0     A8 10 02 FB | 	rdlong	arg02, fp
0a5a4     2C 50 85 F1 | 	sub	fp, #44
0a5a8     20 12 06 F6 | 	mov	arg03, #32
0a5ac     10 9E BF FD | 	call	#_ff_cc_mem_cpy_0198
0a5b0     40 50 05 F1 | 	add	fp, #64
0a5b4     A8 0E 02 F6 | 	mov	arg01, fp
0a5b8     30 50 85 F1 | 	sub	fp, #48
0a5bc     A8 10 02 F6 | 	mov	arg02, fp
0a5c0     10 50 85 F1 | 	sub	fp, #16
0a5c4     30 12 06 F6 | 	mov	arg03, #48
0a5c8     F4 9D BF FD | 	call	#_ff_cc_mem_cpy_0198
0a5cc     40 50 05 F1 | 	add	fp, #64
0a5d0     A8 0E 02 F6 | 	mov	arg01, fp
0a5d4     38 50 85 F1 | 	sub	fp, #56
0a5d8     A8 10 02 FB | 	rdlong	arg02, fp
0a5dc     08 50 85 F1 | 	sub	fp, #8
0a5e0     74 CB BF FD | 	call	#_ff_cc_follow_path_0332
0a5e4     0C 50 05 F1 | 	add	fp, #12
0a5e8     A8 F4 61 FC | 	wrlong	result1, fp
0a5ec     0C 50 85 F1 | 	sub	fp, #12
0a5f0     00 F4 0D F2 | 	cmp	result1, #0 wz
0a5f4     4C 00 90 5D |  if_ne	jmp	#LR__0639
0a5f8     48 50 05 F1 | 	add	fp, #72
0a5fc     A8 0E 02 FB | 	rdlong	arg01, fp
0a600     30 50 85 F1 | 	sub	fp, #48
0a604     A8 F4 01 FB | 	rdlong	result1, fp
0a608     18 50 85 F1 | 	sub	fp, #24
0a60c     FA 0E 0A F2 | 	cmp	arg01, result1 wz
0a610     20 00 90 5D |  if_ne	jmp	#LR__0637
0a614     50 50 05 F1 | 	add	fp, #80
0a618     A8 F4 01 FB | 	rdlong	result1, fp
0a61c     30 50 85 F1 | 	sub	fp, #48
0a620     A8 1A 02 FB | 	rdlong	local02, fp
0a624     20 50 85 F1 | 	sub	fp, #32
0a628     0D F5 09 F2 | 	cmp	result1, local02 wz
0a62c     04 18 06 A6 |  if_e	mov	local01, #4
0a630     04 00 90 AD |  if_e	jmp	#LR__0638
0a634                 | LR__0637
0a634     08 18 06 F6 | 	mov	local01, #8
0a638                 | LR__0638
0a638     0C 50 05 F1 | 	add	fp, #12
0a63c     A8 18 62 FC | 	wrlong	local01, fp
0a640     0C 50 85 F1 | 	sub	fp, #12
0a644                 | LR__0639
0a644     0C 50 05 F1 | 	add	fp, #12
0a648     A8 18 02 FB | 	rdlong	local01, fp
0a64c     0C 50 85 F1 | 	sub	fp, #12
0a650     04 18 0E F2 | 	cmp	local01, #4 wz
0a654     0C 02 90 5D |  if_ne	jmp	#LR__0645
0a658     40 50 05 F1 | 	add	fp, #64
0a65c     A8 0E 02 F6 | 	mov	arg01, fp
0a660     40 50 85 F1 | 	sub	fp, #64
0a664     7C B8 BF FD | 	call	#_ff_cc_dir_register_0306
0a668     0C 50 05 F1 | 	add	fp, #12
0a66c     A8 F4 61 FC | 	wrlong	result1, fp
0a670     0C 50 85 F1 | 	sub	fp, #12
0a674     00 F4 0D F2 | 	cmp	result1, #0 wz
0a678     E8 01 90 5D |  if_ne	jmp	#LR__0644
0a67c     5C 50 05 F1 | 	add	fp, #92
0a680     A8 0E 02 FB | 	rdlong	arg01, fp
0a684     38 50 05 F1 | 	add	fp, #56
0a688     A8 0E 62 FC | 	wrlong	arg01, fp
0a68c     0D 0E 06 F1 | 	add	arg01, #13
0a690     20 50 85 F1 | 	sub	fp, #32
0a694     A8 10 02 F6 | 	mov	arg02, fp
0a698     74 50 85 F1 | 	sub	fp, #116
0a69c     0D 10 06 F1 | 	add	arg02, #13
0a6a0     13 12 06 F6 | 	mov	arg03, #19
0a6a4     18 9D BF FD | 	call	#_ff_cc_mem_cpy_0198
0a6a8     94 50 05 F1 | 	add	fp, #148
0a6ac     A8 18 02 FB | 	rdlong	local01, fp
0a6b0     15 50 85 F1 | 	sub	fp, #21
0a6b4     A8 F4 C1 FA | 	rdbyte	result1, fp
0a6b8     0B 18 06 F1 | 	add	local01, #11
0a6bc     0C F5 41 FC | 	wrbyte	result1, local01
0a6c0     15 50 05 F1 | 	add	fp, #21
0a6c4     A8 18 02 FB | 	rdlong	local01, fp
0a6c8     94 50 85 F1 | 	sub	fp, #148
0a6cc     0B 18 06 F1 | 	add	local01, #11
0a6d0     0C 19 C2 FA | 	rdbyte	local01, local01
0a6d4     10 18 CE F7 | 	test	local01, #16 wz
0a6d8     24 00 90 5D |  if_ne	jmp	#LR__0640
0a6dc     94 50 05 F1 | 	add	fp, #148
0a6e0     A8 F4 01 FB | 	rdlong	result1, fp
0a6e4     FA 18 02 F6 | 	mov	local01, result1
0a6e8     94 50 85 F1 | 	sub	fp, #148
0a6ec     0B F4 05 F1 | 	add	result1, #11
0a6f0     FA F4 C1 FA | 	rdbyte	result1, result1
0a6f4     20 F4 45 F5 | 	or	result1, #32
0a6f8     0B 18 06 F1 | 	add	local01, #11
0a6fc     0C F5 41 FC | 	wrbyte	result1, local01
0a700                 | LR__0640
0a700     70 50 05 F1 | 	add	fp, #112
0a704     A8 18 02 FB | 	rdlong	local01, fp
0a708     03 18 06 F1 | 	add	local01, #3
0a70c     0C 03 48 FC | 	wrbyte	#1, local01
0a710     24 50 05 F1 | 	add	fp, #36
0a714     A8 18 02 FB | 	rdlong	local01, fp
0a718     94 50 85 F1 | 	sub	fp, #148
0a71c     0B 18 06 F1 | 	add	local01, #11
0a720     0C 19 C2 FA | 	rdbyte	local01, local01
0a724     10 18 CE F7 | 	test	local01, #16 wz
0a728     38 01 90 AD |  if_e	jmp	#LR__0643
0a72c     18 50 05 F1 | 	add	fp, #24
0a730     A8 1C 02 FB | 	rdlong	local03, fp
0a734     0E 1F 02 F6 | 	mov	local04, local03
0a738     30 50 05 F1 | 	add	fp, #48
0a73c     A8 20 02 FB | 	rdlong	local05, fp
0a740     48 50 85 F1 | 	sub	fp, #72
0a744     10 23 02 F6 | 	mov	local06, local05
0a748     11 1F 0A F2 | 	cmp	local04, local06 wz
0a74c     14 01 90 AD |  if_e	jmp	#LR__0643
0a750     70 50 05 F1 | 	add	fp, #112
0a754     A8 0E 02 FB | 	rdlong	arg01, fp
0a758     07 19 02 F6 | 	mov	local01, arg01
0a75c     24 50 05 F1 | 	add	fp, #36
0a760     A8 24 02 FB | 	rdlong	local07, fp
0a764     94 50 85 F1 | 	sub	fp, #148
0a768     12 27 02 F6 | 	mov	local08, local07
0a76c     13 11 02 F6 | 	mov	arg02, local08
0a770     6C AD BF FD | 	call	#_ff_cc_ld_clust_0259
0a774     FA 10 02 F6 | 	mov	arg02, result1
0a778     0C 0F 02 F6 | 	mov	arg01, local01
0a77c     84 A0 BF FD | 	call	#_ff_cc_clst2sect_0221
0a780     98 50 05 F1 | 	add	fp, #152
0a784     A8 F4 61 FC | 	wrlong	result1, fp
0a788     FA 28 0A F6 | 	mov	local09, result1 wz
0a78c     98 50 85 F1 | 	sub	fp, #152
0a790     02 18 06 A6 |  if_e	mov	local01, #2
0a794     0C 50 05 A1 |  if_e	add	fp, #12
0a798     A8 04 68 AC |  if_e	wrlong	#2, fp
0a79c     0C 50 85 A1 |  if_e	sub	fp, #12
0a7a0     C0 00 90 AD |  if_e	jmp	#LR__0642
0a7a4     70 50 05 F1 | 	add	fp, #112
0a7a8     A8 0E 02 FB | 	rdlong	arg01, fp
0a7ac     28 50 05 F1 | 	add	fp, #40
0a7b0     A8 10 02 FB | 	rdlong	arg02, fp
0a7b4     98 50 85 F1 | 	sub	fp, #152
0a7b8     68 9E BF FD | 	call	#_ff_cc_move_window_0218
0a7bc     0C 50 05 F1 | 	add	fp, #12
0a7c0     A8 F4 61 FC | 	wrlong	result1, fp
0a7c4     64 50 05 F1 | 	add	fp, #100
0a7c8     A8 26 02 FB | 	rdlong	local08, fp
0a7cc     13 25 02 F6 | 	mov	local07, local08
0a7d0     34 24 06 F1 | 	add	local07, #52
0a7d4     12 19 02 F6 | 	mov	local01, local07
0a7d8     20 18 06 F1 | 	add	local01, #32
0a7dc     24 50 05 F1 | 	add	fp, #36
0a7e0     A8 18 62 FC | 	wrlong	local01, fp
0a7e4     88 50 85 F1 | 	sub	fp, #136
0a7e8     A8 28 02 FB | 	rdlong	local09, fp
0a7ec     0C 50 85 F1 | 	sub	fp, #12
0a7f0     14 19 0A F6 | 	mov	local01, local09 wz
0a7f4     6C 00 90 5D |  if_ne	jmp	#LR__0641
0a7f8     94 50 05 F1 | 	add	fp, #148
0a7fc     A8 1E 02 FB | 	rdlong	local04, fp
0a800     94 50 85 F1 | 	sub	fp, #148
0a804     0F 25 02 F6 | 	mov	local07, local04
0a808     01 24 06 F1 | 	add	local07, #1
0a80c     12 1D C2 FA | 	rdbyte	local03, local07
0a810     01 24 86 F1 | 	sub	local07, #1
0a814     0E 27 E2 F8 | 	getbyte	local08, local03, #0
0a818     2E 26 0E F2 | 	cmp	local08, #46 wz
0a81c     44 00 90 5D |  if_ne	jmp	#LR__0641
0a820     70 50 05 F1 | 	add	fp, #112
0a824     A8 0E 02 FB | 	rdlong	arg01, fp
0a828     24 50 05 F1 | 	add	fp, #36
0a82c     A8 10 02 FB | 	rdlong	arg02, fp
0a830     4C 50 85 F1 | 	sub	fp, #76
0a834     A8 24 02 FB | 	rdlong	local07, fp
0a838     48 50 85 F1 | 	sub	fp, #72
0a83c     12 13 02 F6 | 	mov	arg03, local07
0a840     F0 AC BF FD | 	call	#_ff_cc_st_clust_0260
0a844     70 50 05 F1 | 	add	fp, #112
0a848     A8 28 02 FB | 	rdlong	local09, fp
0a84c     70 50 85 F1 | 	sub	fp, #112
0a850     14 19 02 F6 | 	mov	local01, local09
0a854     01 26 06 F6 | 	mov	local08, #1
0a858     03 18 06 F1 | 	add	local01, #3
0a85c     0C 03 48 FC | 	wrbyte	#1, local01
0a860     03 18 86 F1 | 	sub	local01, #3
0a864                 | LR__0641
0a864                 | LR__0642
0a864                 | LR__0643
0a864                 | LR__0644
0a864                 | LR__0645
0a864     0C 50 05 F1 | 	add	fp, #12
0a868     A8 18 0A FB | 	rdlong	local01, fp wz
0a86c     0C 50 85 F1 | 	sub	fp, #12
0a870     40 00 90 5D |  if_ne	jmp	#LR__0647
0a874     10 50 05 F1 | 	add	fp, #16
0a878     A8 0E 02 F6 | 	mov	arg01, fp
0a87c     10 50 85 F1 | 	sub	fp, #16
0a880     FC BA BF FD | 	call	#_ff_cc_dir_remove_0310
0a884     0C 50 05 F1 | 	add	fp, #12
0a888     A8 F4 61 FC | 	wrlong	result1, fp
0a88c     0C 50 85 F1 | 	sub	fp, #12
0a890     00 F4 0D F2 | 	cmp	result1, #0 wz
0a894     1C 00 90 5D |  if_ne	jmp	#LR__0646
0a898     70 50 05 F1 | 	add	fp, #112
0a89c     A8 0E 02 FB | 	rdlong	arg01, fp
0a8a0     70 50 85 F1 | 	sub	fp, #112
0a8a4     F8 9D BF FD | 	call	#_ff_cc_sync_fs_0220
0a8a8     0C 50 05 F1 | 	add	fp, #12
0a8ac     A8 F4 61 FC | 	wrlong	result1, fp
0a8b0     0C 50 85 F1 | 	sub	fp, #12
0a8b4                 | LR__0646
0a8b4                 | LR__0647
0a8b4                 | LR__0648
0a8b4                 | LR__0649
0a8b4                 | ' 					res = sync_fs(fs);
0a8b4                 | ' 				}
0a8b4                 | ' 			}
0a8b4                 | ' 
0a8b4                 | ' 		}
0a8b4                 | ' 		;
0a8b4                 | ' 	}
0a8b4                 | ' 
0a8b4                 | ' 	return res ;
0a8b4     0C 50 05 F1 | 	add	fp, #12
0a8b8     A8 F4 01 FB | 	rdlong	result1, fp
0a8bc     0C 50 85 F1 | 	sub	fp, #12
0a8c0     A8 F0 03 F6 | 	mov	ptra, fp
0a8c4     B3 00 A0 FD | 	call	#popregs_
0a8c8                 | _ff_cc_f_rename_ret
0a8c8     2D 00 64 FD | 	ret
0a8cc                 | 
0a8cc                 | _ff_cc_stat
0a8cc     04 4C 05 F6 | 	mov	COUNT_, #4
0a8d0     A9 00 A0 FD | 	call	#pushregs_
0a8d4     07 13 02 F6 | 	mov	arg03, arg01
0a8d8     08 19 02 F6 | 	mov	local01, arg02
0a8dc     40 EF 05 F1 | 	add	ptr___system__dat__, #320
0a8e0     F7 1A 02 F6 | 	mov	local02, ptr___system__dat__
0a8e4     0D 0F 02 F6 | 	mov	arg01, local02
0a8e8     09 11 02 F6 | 	mov	arg02, arg03
0a8ec     00 12 06 F6 | 	mov	arg03, #0
0a8f0     40 EF 85 F1 | 	sub	ptr___system__dat__, #320
0a8f4     F4 64 BF FD | 	call	#__system____getvfsforfile
0a8f8     FA 1C 0A F6 | 	mov	local03, result1 wz
0a8fc     2C 1C 06 51 |  if_ne	add	local03, #44
0a900     0E 0F 02 5B |  if_ne	rdlong	arg01, local03
0a904     2C 1C 86 51 |  if_ne	sub	local03, #44
0a908     07 0F 0A 56 |  if_ne	mov	arg01, arg01 wz
0a90c                 | ' #line 19 "/home/pik33/Programy/flexprop/include/libc/unix/stat.c"
0a90c                 | '         return _seterror( 16 );
0a90c     1C EE 05 A1 |  if_e	add	ptr___system__dat__, #28
0a910     F7 20 68 AC |  if_e	wrlong	#16, ptr___system__dat__
0a914     1C EE 85 A1 |  if_e	sub	ptr___system__dat__, #28
0a918     01 F4 65 A6 |  if_e	neg	result1, #1
0a91c     3C 00 90 AD |  if_e	jmp	#LR__0650
0a920     0C 0F 02 F6 | 	mov	arg01, local01
0a924     00 10 06 F6 | 	mov	arg02, #0
0a928     30 12 06 F6 | 	mov	arg03, #48
0a92c     99 00 A0 FD | 	call	#\builtin_bytefill_
0a930     2C 1C 06 F1 | 	add	local03, #44
0a934     0E 1D 02 FB | 	rdlong	local03, local03
0a938     0E 1F 02 FB | 	rdlong	local04, local03
0a93c     04 1C 06 F1 | 	add	local03, #4
0a940     0E 1D 02 FB | 	rdlong	local03, local03
0a944     0D 0F 02 F6 | 	mov	arg01, local02
0a948     0C 11 02 F6 | 	mov	arg02, local01
0a94c     F1 1A 02 F6 | 	mov	local02, objptr
0a950     0F E3 01 F6 | 	mov	objptr, local04
0a954     2D 1C 62 FD | 	call	local03
0a958     0D E3 01 F6 | 	mov	objptr, local02
0a95c                 | ' #line 29 "/home/pik33/Programy/flexprop/include/libc/unix/stat.c"
0a95c                 | '     r = v->stat(name, buf);
0a95c                 | ' #line 33 "/home/pik33/Programy/flexprop/include/libc/unix/stat.c"
0a95c                 | '     return r;
0a95c                 | LR__0650
0a95c     A8 F0 03 F6 | 	mov	ptra, fp
0a960     B3 00 A0 FD | 	call	#popregs_
0a964                 | _ff_cc_stat_ret
0a964     2D 00 64 FD | 	ret
0a968                 | 
0a968                 | _ff_cc__set_dos_error_0481
0a968     03 4C 05 F6 | 	mov	COUNT_, #3
0a96c     A9 00 A0 FD | 	call	#pushregs_
0a970     07 19 02 F6 | 	mov	local01, arg01
0a974                 | ' #line 6899 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
0a974                 | '     switch (derr) {
0a974     0C 1B 02 F6 | 	mov	local02, local01
0a978     14 1A 26 F3 | 	fle	local02, #20
0a97c     30 1A 62 FD | 	jmprel	local02
0a980                 | LR__0651
0a980     50 00 90 FD | 	jmp	#LR__0652
0a984     84 00 90 FD | 	jmp	#LR__0666
0a988     80 00 90 FD | 	jmp	#LR__0667
0a98c     7C 00 90 FD | 	jmp	#LR__0668
0a990     48 00 90 FD | 	jmp	#LR__0653
0a994     44 00 90 FD | 	jmp	#LR__0654
0a998     40 00 90 FD | 	jmp	#LR__0655
0a99c     44 00 90 FD | 	jmp	#LR__0656
0a9a0     48 00 90 FD | 	jmp	#LR__0658
0a9a4     54 00 90 FD | 	jmp	#LR__0661
0a9a8     38 00 90 FD | 	jmp	#LR__0657
0a9ac     4C 00 90 FD | 	jmp	#LR__0662
0a9b0     48 00 90 FD | 	jmp	#LR__0663
0a9b4     44 00 90 FD | 	jmp	#LR__0664
0a9b8     50 00 90 FD | 	jmp	#LR__0669
0a9bc     4C 00 90 FD | 	jmp	#LR__0669
0a9c0     48 00 90 FD | 	jmp	#LR__0669
0a9c4     2C 00 90 FD | 	jmp	#LR__0659
0a9c8     38 00 90 FD | 	jmp	#LR__0665
0a9cc     2C 00 90 FD | 	jmp	#LR__0660
0a9d0     38 00 90 FD | 	jmp	#LR__0669
0a9d4                 | LR__0652
0a9d4     00 1C 06 F6 | 	mov	local03, #0
0a9d8                 | '         r = 0;
0a9d8                 | '         break;
0a9d8     34 00 90 FD | 	jmp	#LR__0670
0a9dc                 | LR__0653
0a9dc                 | LR__0654
0a9dc                 | LR__0655
0a9dc     04 1C 06 F6 | 	mov	local03, #4
0a9e0                 | '         r =  4 ;
0a9e0                 | '         break;
0a9e0     2C 00 90 FD | 	jmp	#LR__0670
0a9e4                 | LR__0656
0a9e4                 | LR__0657
0a9e4     06 1C 06 F6 | 	mov	local03, #6
0a9e8                 | '         r =  6 ;
0a9e8                 | '         break;
0a9e8     24 00 90 FD | 	jmp	#LR__0670
0a9ec                 | LR__0658
0a9ec     09 1C 06 F6 | 	mov	local03, #9
0a9f0                 | '         r =  9 ;
0a9f0                 | '         break;
0a9f0     1C 00 90 FD | 	jmp	#LR__0670
0a9f4                 | LR__0659
0a9f4     07 1C 06 F6 | 	mov	local03, #7
0a9f8                 | '         r =  7 ;
0a9f8                 | '         break;
0a9f8     14 00 90 FD | 	jmp	#LR__0670
0a9fc                 | LR__0660
0a9fc                 | LR__0661
0a9fc                 | LR__0662
0a9fc                 | LR__0663
0a9fc                 | LR__0664
0a9fc     0A 1C 06 F6 | 	mov	local03, #10
0aa00                 | '         r =  10 ;
0aa00                 | '         break;
0aa00     0C 00 90 FD | 	jmp	#LR__0670
0aa04                 | LR__0665
0aa04     0B 1C 06 F6 | 	mov	local03, #11
0aa08                 | '         r =  11 ;
0aa08                 | '         break;
0aa08     04 00 90 FD | 	jmp	#LR__0670
0aa0c                 | LR__0666
0aa0c                 | LR__0667
0aa0c                 | LR__0668
0aa0c                 | LR__0669
0aa0c     0C 1C 06 F6 | 	mov	local03, #12
0aa10                 | '         r =  12 ;
0aa10                 | '         break;
0aa10                 | LR__0670
0aa10                 | '     }
0aa10                 | '     return _seterror(r);
0aa10     1C EE 05 F1 | 	add	ptr___system__dat__, #28
0aa14     F7 1C 62 FC | 	wrlong	local03, ptr___system__dat__
0aa18     1C EE 85 F1 | 	sub	ptr___system__dat__, #28
0aa1c     00 1C 0E F2 | 	cmp	local03, #0 wz
0aa20     01 F4 65 56 |  if_ne	neg	result1, #1
0aa24     00 F4 05 A6 |  if_e	mov	result1, #0
0aa28     A8 F0 03 F6 | 	mov	ptra, fp
0aa2c     B3 00 A0 FD | 	call	#popregs_
0aa30                 | _ff_cc__set_dos_error_0481_ret
0aa30     2D 00 64 FD | 	ret
0aa34                 | 
0aa34                 | _ff_cc_v_creat_0485
0aa34     04 4C 05 F6 | 	mov	COUNT_, #4
0aa38     A9 00 A0 FD | 	call	#pushregs_
0aa3c     07 19 02 F6 | 	mov	local01, arg01
0aa40     08 1B 02 F6 | 	mov	local02, arg02
0aa44     02 00 00 FF 
0aa48     34 0E 06 F6 | 	mov	arg01, ##1076
0aa4c                 | '     return _gc_alloc(size);
0aa4c     10 10 06 F6 | 	mov	arg02, #16
0aa50     B0 6E BF FD | 	call	#__system___gc_doalloc
0aa54     FA 1C 0A F6 | 	mov	local03, result1 wz
0aa58                 | '       return _seterror( 7 );
0aa58     1C EE 05 A1 |  if_e	add	ptr___system__dat__, #28
0aa5c     F7 0E 68 AC |  if_e	wrlong	#7, ptr___system__dat__
0aa60     1C EE 85 A1 |  if_e	sub	ptr___system__dat__, #28
0aa64     01 F4 65 A6 |  if_e	neg	result1, #1
0aa68     58 00 90 AD |  if_e	jmp	#LR__0672
0aa6c     0E 0F 02 F6 | 	mov	arg01, local03
0aa70     00 10 06 F6 | 	mov	arg02, #0
0aa74     02 00 00 FF 
0aa78     34 12 06 F6 | 	mov	arg03, ##1076
0aa7c     70 0E B0 FD | 	call	#_ff_cc_memset
0aa80     02 00 00 FF 
0aa84     0C 1C 06 F1 | 	add	local03, ##1036
0aa88     0E 0F 02 F6 | 	mov	arg01, local03
0aa8c     02 00 00 FF 
0aa90     0C 1C 86 F1 | 	sub	local03, ##1036
0aa94     0D 11 02 F6 | 	mov	arg02, local02
0aa98     07 12 06 F6 | 	mov	arg03, #7
0aa9c     74 D3 BF FD | 	call	#_ff_cc_f_open
0aaa0     FA 1E 0A F6 | 	mov	local04, result1 wz
0aaa4     14 00 90 AD |  if_e	jmp	#LR__0671
0aaa8     0E 0F 02 F6 | 	mov	arg01, local03
0aaac                 | '     return _gc_free(ptr);
0aaac     84 6F BF FD | 	call	#__system___gc_free
0aab0                 | '     free(f);
0aab0                 | '     return _set_dos_error(r);
0aab0     0F 0F 02 F6 | 	mov	arg01, local04
0aab4     B0 FE BF FD | 	call	#_ff_cc__set_dos_error_0481
0aab8     08 00 90 FD | 	jmp	#LR__0672
0aabc                 | LR__0671
0aabc     0C 1D 62 FC | 	wrlong	local03, local01
0aac0                 | '   }
0aac0                 | '   fil->vfsdata = f;
0aac0                 | '   return 0;
0aac0     00 F4 05 F6 | 	mov	result1, #0
0aac4                 | LR__0672
0aac4     A8 F0 03 F6 | 	mov	ptra, fp
0aac8     B3 00 A0 FD | 	call	#popregs_
0aacc                 | _ff_cc_v_creat_0485_ret
0aacc     2D 00 64 FD | 	ret
0aad0                 | 
0aad0                 | _ff_cc_v_close_0488
0aad0     02 4C 05 F6 | 	mov	COUNT_, #2
0aad4     A9 00 A0 FD | 	call	#pushregs_
0aad8     07 19 02 FB | 	rdlong	local01, arg01
0aadc     02 00 00 FF 
0aae0     0C 18 06 F1 | 	add	local01, ##1036
0aae4     0C 0F 02 F6 | 	mov	arg01, local01
0aae8     02 00 00 FF 
0aaec     0C 18 86 F1 | 	sub	local01, ##1036
0aaf0     B0 E9 BF FD | 	call	#_ff_cc_f_close
0aaf4     FA 1A 02 F6 | 	mov	local02, result1
0aaf8     0C 0F 02 F6 | 	mov	arg01, local01
0aafc                 | '     return _gc_free(ptr);
0aafc     34 6F BF FD | 	call	#__system___gc_free
0ab00                 | '     FAT_FIL *f = fil->vfsdata;
0ab00                 | '     r=f_close(&f->fil);
0ab00                 | '     free(f);
0ab00                 | '     return _set_dos_error(r);
0ab00     0D 0F 02 F6 | 	mov	arg01, local02
0ab04     60 FE BF FD | 	call	#_ff_cc__set_dos_error_0481
0ab08     A8 F0 03 F6 | 	mov	ptra, fp
0ab0c     B3 00 A0 FD | 	call	#popregs_
0ab10                 | _ff_cc_v_close_0488_ret
0ab10     2D 00 64 FD | 	ret
0ab14                 | 
0ab14                 | _ff_cc_v_opendir_0491
0ab14     04 4C 05 F6 | 	mov	COUNT_, #4
0ab18     A9 00 A0 FD | 	call	#pushregs_
0ab1c     07 19 02 F6 | 	mov	local01, arg01
0ab20     08 1B 02 F6 | 	mov	local02, arg02
0ab24     30 0E 06 F6 | 	mov	arg01, #48
0ab28                 | '     return _gc_alloc(size);
0ab28     10 10 06 F6 | 	mov	arg02, #16
0ab2c     D4 6D BF FD | 	call	#__system___gc_doalloc
0ab30     FA 1C 0A F6 | 	mov	local03, result1 wz
0ab34                 | ' #line 6983 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
0ab34                 | '       return _seterror( 7 );
0ab34     1C EE 05 A1 |  if_e	add	ptr___system__dat__, #28
0ab38     F7 0E 68 AC |  if_e	wrlong	#7, ptr___system__dat__
0ab3c     1C EE 85 A1 |  if_e	sub	ptr___system__dat__, #28
0ab40     01 F4 65 A6 |  if_e	neg	result1, #1
0ab44     34 00 90 AD |  if_e	jmp	#LR__0674
0ab48     0D 11 02 F6 | 	mov	arg02, local02
0ab4c     0E 0F 02 F6 | 	mov	arg01, local03
0ab50     E8 EF BF FD | 	call	#_ff_cc_f_opendir
0ab54     FA 1E 0A F6 | 	mov	local04, result1 wz
0ab58     14 00 90 AD |  if_e	jmp	#LR__0673
0ab5c     0E 0F 02 F6 | 	mov	arg01, local03
0ab60                 | '     return _gc_free(ptr);
0ab60     D0 6E BF FD | 	call	#__system___gc_free
0ab64                 | '         free(f);
0ab64                 | '         return _set_dos_error(r);
0ab64     0F 0F 02 F6 | 	mov	arg01, local04
0ab68     FC FD BF FD | 	call	#_ff_cc__set_dos_error_0481
0ab6c     0C 00 90 FD | 	jmp	#LR__0674
0ab70                 | LR__0673
0ab70     04 18 06 F1 | 	add	local01, #4
0ab74     0C 1D 62 FC | 	wrlong	local03, local01
0ab78                 | '     }
0ab78                 | '     dir->vfsdata = f;
0ab78                 | '     return 0;
0ab78     00 F4 05 F6 | 	mov	result1, #0
0ab7c                 | LR__0674
0ab7c     A8 F0 03 F6 | 	mov	ptra, fp
0ab80     B3 00 A0 FD | 	call	#popregs_
0ab84                 | _ff_cc_v_opendir_0491_ret
0ab84     2D 00 64 FD | 	ret
0ab88                 | 
0ab88                 | _ff_cc_v_closedir_0494
0ab88     02 4C 05 F6 | 	mov	COUNT_, #2
0ab8c     A9 00 A0 FD | 	call	#pushregs_
0ab90     04 0E 06 F1 | 	add	arg01, #4
0ab94     07 19 02 FB | 	rdlong	local01, arg01
0ab98     0C 0F 02 F6 | 	mov	arg01, local01
0ab9c     50 F1 BF FD | 	call	#_ff_cc_f_closedir
0aba0     FA 1A 02 F6 | 	mov	local02, result1
0aba4     0C 0F 02 F6 | 	mov	arg01, local01
0aba8                 | '     return _gc_free(ptr);
0aba8     88 6E BF FD | 	call	#__system___gc_free
0abac     00 1A 0E F2 | 	cmp	local02, #0 wz
0abb0     0D 0F 02 56 |  if_ne	mov	arg01, local02
0abb4     B0 FD BF 5D |  if_ne	call	#_ff_cc__set_dos_error_0481
0abb8                 | '     return r;
0abb8     0D F5 01 F6 | 	mov	result1, local02
0abbc     A8 F0 03 F6 | 	mov	ptra, fp
0abc0     B3 00 A0 FD | 	call	#popregs_
0abc4                 | _ff_cc_v_closedir_0494_ret
0abc4     2D 00 64 FD | 	ret
0abc8                 | 
0abc8                 | _ff_cc_v_readdir_0497
0abc8     00 4C 05 F6 | 	mov	COUNT_, #0
0abcc     A9 00 A0 FD | 	call	#pushregs_
0abd0     2C F1 07 F1 | 	add	ptra, #300
0abd4     04 50 05 F1 | 	add	fp, #4
0abd8     A8 0E 62 FC | 	wrlong	arg01, fp
0abdc     04 50 05 F1 | 	add	fp, #4
0abe0     A8 10 62 FC | 	wrlong	arg02, fp
0abe4     04 50 85 F1 | 	sub	fp, #4
0abe8     A8 10 02 FB | 	rdlong	arg02, fp
0abec     04 10 06 F1 | 	add	arg02, #4
0abf0     08 0F 02 FB | 	rdlong	arg01, arg02
0abf4     08 50 05 F1 | 	add	fp, #8
0abf8     A8 10 02 F6 | 	mov	arg02, fp
0abfc     0C 50 85 F1 | 	sub	fp, #12
0ac00     48 F1 BF FD | 	call	#_ff_cc_f_readdir
0ac04     28 51 05 F1 | 	add	fp, #296
0ac08     A8 F4 61 FC | 	wrlong	result1, fp
0ac0c     28 51 85 F1 | 	sub	fp, #296
0ac10     00 F4 0D F2 | 	cmp	result1, #0 wz
0ac14     14 00 90 AD |  if_e	jmp	#LR__0675
0ac18                 | '         return _set_dos_error(r);
0ac18     28 51 05 F1 | 	add	fp, #296
0ac1c     A8 0E 02 FB | 	rdlong	arg01, fp
0ac20     28 51 85 F1 | 	sub	fp, #296
0ac24     40 FD BF FD | 	call	#_ff_cc__set_dos_error_0481
0ac28     4C 00 90 FD | 	jmp	#LR__0676
0ac2c                 | LR__0675
0ac2c     28 50 05 F1 | 	add	fp, #40
0ac30     A8 12 C2 FA | 	rdbyte	arg03, fp
0ac34     28 50 85 F1 | 	sub	fp, #40
0ac38     07 12 4E F7 | 	zerox	arg03, #7 wz
0ac3c                 | '         return -1;
0ac3c     01 F4 65 A6 |  if_e	neg	result1, #1
0ac40     34 00 90 AD |  if_e	jmp	#LR__0676
0ac44     08 50 05 F1 | 	add	fp, #8
0ac48     A8 0E 02 FB | 	rdlong	arg01, fp
0ac4c     20 50 05 F1 | 	add	fp, #32
0ac50     A8 10 02 F6 | 	mov	arg02, fp
0ac54     28 50 85 F1 | 	sub	fp, #40
0ac58     3F 12 06 F6 | 	mov	arg03, #63
0ac5c     38 0C B0 FD | 	call	#_ff_cc_strncpy
0ac60     08 50 05 F1 | 	add	fp, #8
0ac64     A8 F4 01 FB | 	rdlong	result1, fp
0ac68     08 50 85 F1 | 	sub	fp, #8
0ac6c     3F F4 05 F1 | 	add	result1, #63
0ac70     FA 00 48 FC | 	wrbyte	#0, result1
0ac74                 | '     }
0ac74                 | ' 
0ac74                 | '     strncpy(ent->d_name, finfo.fname,  (64) -1);
0ac74                 | '     ent->d_name[ (64) -1] = 0;
0ac74                 | ' #line 7029 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
0ac74                 | '     return 0;
0ac74     00 F4 05 F6 | 	mov	result1, #0
0ac78                 | LR__0676
0ac78     A8 F0 03 F6 | 	mov	ptra, fp
0ac7c     B3 00 A0 FD | 	call	#popregs_
0ac80                 | _ff_cc_v_readdir_0497_ret
0ac80     2D 00 64 FD | 	ret
0ac84                 | 
0ac84                 | _ff_cc_unixtime_0505
0ac84     08 F5 01 F6 | 	mov	result1, arg02
0ac88     0B F4 45 F0 | 	shr	result1, #11
0ac8c     1F F4 05 F5 | 	and	result1, #31
0ac90     07 00 00 FF 
0ac94     10 F4 05 FD | 	qmul	result1, ##3600
0ac98     08 F5 01 F6 | 	mov	result1, arg02
0ac9c     05 F4 45 F0 | 	shr	result1, #5
0aca0     3F F4 05 F5 | 	and	result1, #63
0aca4     1F 10 06 F5 | 	and	arg02, #31
0aca8     01 10 66 F0 | 	shl	arg02, #1
0acac     FA F8 01 F6 | 	mov	_var01, result1
0acb0     04 F8 65 F0 | 	shl	_var01, #4
0acb4     FA F8 81 F1 | 	sub	_var01, result1
0acb8     02 F8 65 F0 | 	shl	_var01, #2
0acbc     FC 10 02 F1 | 	add	arg02, _var01
0acc0                 | ' 
0acc0                 | '     t = second + minute*60 + hour * 3600;
0acc0                 | '     return t;
0acc0     18 F8 61 FD | 	getqx	_var01
0acc4     FC 10 02 F1 | 	add	arg02, _var01
0acc8     08 F5 01 F6 | 	mov	result1, arg02
0accc                 | _ff_cc_unixtime_0505_ret
0accc     2D 00 64 FD | 	ret
0acd0                 | 
0acd0                 | _ff_cc_v_stat_0509
0acd0     03 4C 05 F6 | 	mov	COUNT_, #3
0acd4     A9 00 A0 FD | 	call	#pushregs_
0acd8     30 F1 07 F1 | 	add	ptra, #304
0acdc     04 50 05 F1 | 	add	fp, #4
0ace0     A8 0E 62 FC | 	wrlong	arg01, fp
0ace4     04 50 05 F1 | 	add	fp, #4
0ace8     A8 10 62 FC | 	wrlong	arg02, fp
0acec     08 50 85 F1 | 	sub	fp, #8
0acf0     08 0F 02 F6 | 	mov	arg01, arg02
0acf4     00 10 06 F6 | 	mov	arg02, #0
0acf8     30 12 06 F6 | 	mov	arg03, #48
0acfc     F0 0B B0 FD | 	call	#_ff_cc_memset
0ad00     04 50 05 F1 | 	add	fp, #4
0ad04     A8 F4 01 FB | 	rdlong	result1, fp
0ad08     04 50 85 F1 | 	sub	fp, #4
0ad0c     FA F4 C9 FA | 	rdbyte	result1, result1 wz
0ad10     30 00 90 AD |  if_e	jmp	#LR__0677
0ad14     04 50 05 F1 | 	add	fp, #4
0ad18     A8 F4 01 FB | 	rdlong	result1, fp
0ad1c     04 50 85 F1 | 	sub	fp, #4
0ad20     FA F4 C1 FA | 	rdbyte	result1, result1
0ad24     2E F4 0D F2 | 	cmp	result1, #46 wz
0ad28     30 00 90 5D |  if_ne	jmp	#LR__0678
0ad2c     04 50 05 F1 | 	add	fp, #4
0ad30     A8 F4 01 FB | 	rdlong	result1, fp
0ad34     04 50 85 F1 | 	sub	fp, #4
0ad38     01 F4 05 F1 | 	add	result1, #1
0ad3c     FA F4 C9 FA | 	rdbyte	result1, result1 wz
0ad40     18 00 90 5D |  if_ne	jmp	#LR__0678
0ad44                 | LR__0677
0ad44     18 50 05 F1 | 	add	fp, #24
0ad48     A8 20 48 FC | 	wrbyte	#16, fp
0ad4c     0C 50 85 F1 | 	sub	fp, #12
0ad50     A8 00 68 FC | 	wrlong	#0, fp
0ad54     0C 50 85 F1 | 	sub	fp, #12
0ad58     24 00 90 FD | 	jmp	#LR__0679
0ad5c                 | LR__0678
0ad5c     04 50 05 F1 | 	add	fp, #4
0ad60     A8 0E 02 FB | 	rdlong	arg01, fp
0ad64     0C 50 05 F1 | 	add	fp, #12
0ad68     A8 10 02 F6 | 	mov	arg02, fp
0ad6c     10 50 85 F1 | 	sub	fp, #16
0ad70     F4 F0 BF FD | 	call	#_ff_cc_f_stat
0ad74     0C 50 05 F1 | 	add	fp, #12
0ad78     A8 F4 61 FC | 	wrlong	result1, fp
0ad7c     0C 50 85 F1 | 	sub	fp, #12
0ad80                 | LR__0679
0ad80     0C 50 05 F1 | 	add	fp, #12
0ad84     A8 F4 09 FB | 	rdlong	result1, fp wz
0ad88     0C 50 85 F1 | 	sub	fp, #12
0ad8c     14 00 90 AD |  if_e	jmp	#LR__0680
0ad90                 | '         return _set_dos_error(r);
0ad90     0C 50 05 F1 | 	add	fp, #12
0ad94     A8 0E 02 FB | 	rdlong	arg01, fp
0ad98     0C 50 85 F1 | 	sub	fp, #12
0ad9c     C8 FB BF FD | 	call	#_ff_cc__set_dos_error_0481
0ada0     10 01 90 FD | 	jmp	#LR__0681
0ada4                 | LR__0680
0ada4     2C 51 05 F1 | 	add	fp, #300
0ada8     A8 48 6A FC | 	wrlong	#292, fp
0adac     14 51 85 F1 | 	sub	fp, #276
0adb0     A8 18 C2 FA | 	rdbyte	local01, fp
0adb4     18 50 85 F1 | 	sub	fp, #24
0adb8     01 18 CE F7 | 	test	local01, #1 wz
0adbc     2C 51 05 51 |  if_ne	add	fp, #300
0adc0     A8 18 02 5B |  if_ne	rdlong	local01, fp
0adc4     92 18 46 55 |  if_ne	or	local01, #146
0adc8     A8 18 62 5C |  if_ne	wrlong	local01, fp
0adcc     2C 51 85 51 |  if_ne	sub	fp, #300
0add0     18 50 05 F1 | 	add	fp, #24
0add4     A8 18 C2 FA | 	rdbyte	local01, fp
0add8     18 50 85 F1 | 	sub	fp, #24
0addc     10 18 CE F7 | 	test	local01, #16 wz
0ade0     2C 51 05 51 |  if_ne	add	fp, #300
0ade4     A8 18 02 5B |  if_ne	rdlong	local01, fp
0ade8     08 00 00 5F 
0adec     49 18 46 55 |  if_ne	or	local01, ##4169
0adf0     A8 18 62 5C |  if_ne	wrlong	local01, fp
0adf4     2C 51 85 51 |  if_ne	sub	fp, #300
0adf8     08 50 05 F1 | 	add	fp, #8
0adfc     A8 18 02 FB | 	rdlong	local01, fp
0ae00     24 51 05 F1 | 	add	fp, #292
0ae04     A8 F4 01 FB | 	rdlong	result1, fp
0ae08     08 18 06 F1 | 	add	local01, #8
0ae0c     0C F5 61 FC | 	wrlong	result1, local01
0ae10     24 51 85 F1 | 	sub	fp, #292
0ae14     A8 18 02 FB | 	rdlong	local01, fp
0ae18     0C 18 06 F1 | 	add	local01, #12
0ae1c     0C 03 68 FC | 	wrlong	#1, local01
0ae20     A8 18 02 FB | 	rdlong	local01, fp
0ae24     08 50 05 F1 | 	add	fp, #8
0ae28     A8 F4 01 FB | 	rdlong	result1, fp
0ae2c     18 18 06 F1 | 	add	local01, #24
0ae30     0C F5 61 FC | 	wrlong	result1, local01
0ae34     08 50 85 F1 | 	sub	fp, #8
0ae38     A8 18 02 FB | 	rdlong	local01, fp
0ae3c     1C 18 06 F1 | 	add	local01, #28
0ae40     01 00 80 FF 
0ae44     0C 01 68 FC | 	wrlong	##512, local01
0ae48     A8 F4 01 FB | 	rdlong	result1, fp
0ae4c     FA 18 02 F6 | 	mov	local01, result1
0ae50     18 F4 05 F1 | 	add	result1, #24
0ae54     FA F4 01 FB | 	rdlong	result1, result1
0ae58     FA F4 51 F6 | 	abs	result1, result1 wc
0ae5c     09 F4 45 F0 | 	shr	result1, #9
0ae60     FA F4 81 F6 | 	negc	result1, result1
0ae64     20 18 06 F1 | 	add	local01, #32
0ae68     0C F5 61 FC | 	wrlong	result1, local01
0ae6c     A8 1A 02 FB | 	rdlong	local02, fp
0ae70     0D 19 02 F6 | 	mov	local01, local02
0ae74     0D 1D 02 F6 | 	mov	local03, local02
0ae78     0C 50 05 F1 | 	add	fp, #12
0ae7c     A8 0E E2 FA | 	rdword	arg01, fp
0ae80     02 50 05 F1 | 	add	fp, #2
0ae84     A8 10 E2 FA | 	rdword	arg02, fp
0ae88     16 50 85 F1 | 	sub	fp, #22
0ae8c     F4 FD BF FD | 	call	#_ff_cc_unixtime_0505
0ae90     2C 1C 06 F1 | 	add	local03, #44
0ae94     0E F5 61 FC | 	wrlong	result1, local03
0ae98     28 1A 06 F1 | 	add	local02, #40
0ae9c     0D F5 61 FC | 	wrlong	result1, local02
0aea0     24 18 06 F1 | 	add	local01, #36
0aea4     0C F5 61 FC | 	wrlong	result1, local01
0aea8                 | '         mode |=  0010000  |  0100  |  0010  |  0001 ;
0aea8                 | '     }
0aea8                 | '     buf->st_mode = mode;
0aea8                 | '     buf->st_nlink = 1;
0aea8                 | '     buf->st_size = finfo.fsize;
0aea8                 | '     buf->st_blksize = 512;
0aea8                 | '     buf->st_blocks = buf->st_size / 512;
0aea8                 | '     buf->st_atime = buf->st_mtime = buf->st_ctime = unixtime(finfo.fdate, finfo.ftime);
0aea8                 | ' #line 7081 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
0aea8                 | '     return r;
0aea8     0C 50 05 F1 | 	add	fp, #12
0aeac     A8 F4 01 FB | 	rdlong	result1, fp
0aeb0     0C 50 85 F1 | 	sub	fp, #12
0aeb4                 | LR__0681
0aeb4     A8 F0 03 F6 | 	mov	ptra, fp
0aeb8     B3 00 A0 FD | 	call	#popregs_
0aebc                 | _ff_cc_v_stat_0509_ret
0aebc     2D 00 64 FD | 	ret
0aec0                 | 
0aec0                 | _ff_cc_v_read_0513
0aec0     01 4C 05 F6 | 	mov	COUNT_, #1
0aec4     A9 00 A0 FD | 	call	#pushregs_
0aec8     1C F0 07 F1 | 	add	ptra, #28
0aecc     04 50 05 F1 | 	add	fp, #4
0aed0     A8 0E 62 FC | 	wrlong	arg01, fp
0aed4     04 50 05 F1 | 	add	fp, #4
0aed8     A8 10 62 FC | 	wrlong	arg02, fp
0aedc     04 50 05 F1 | 	add	fp, #4
0aee0     A8 12 62 FC | 	wrlong	arg03, fp
0aee4     08 50 85 F1 | 	sub	fp, #8
0aee8     A8 0E 02 FB | 	rdlong	arg01, fp
0aeec     07 0F 0A FB | 	rdlong	arg01, arg01 wz
0aef0     0C 50 05 F1 | 	add	fp, #12
0aef4     A8 0E 62 FC | 	wrlong	arg01, fp
0aef8     10 50 85 F1 | 	sub	fp, #16
0aefc                 | '         return _seterror( 5 );
0aefc     1C EE 05 A1 |  if_e	add	ptr___system__dat__, #28
0af00     F7 0A 68 AC |  if_e	wrlong	#5, ptr___system__dat__
0af04     1C EE 85 A1 |  if_e	sub	ptr___system__dat__, #28
0af08     01 F4 65 A6 |  if_e	neg	result1, #1
0af0c     B8 00 90 AD |  if_e	jmp	#LR__0684
0af10     10 50 05 F1 | 	add	fp, #16
0af14     A8 0E 02 FB | 	rdlong	arg01, fp
0af18     02 00 00 FF 
0af1c     0C 0E 06 F1 | 	add	arg01, ##1036
0af20     08 50 85 F1 | 	sub	fp, #8
0af24     A8 10 02 FB | 	rdlong	arg02, fp
0af28     04 50 05 F1 | 	add	fp, #4
0af2c     A8 12 02 FB | 	rdlong	arg03, fp
0af30     0C 50 05 F1 | 	add	fp, #12
0af34     A8 14 02 F6 | 	mov	arg04, fp
0af38     18 50 85 F1 | 	sub	fp, #24
0af3c     A0 D5 BF FD | 	call	#_ff_cc_f_read
0af40     14 50 05 F1 | 	add	fp, #20
0af44     A8 F4 61 FC | 	wrlong	result1, fp
0af48     14 50 85 F1 | 	sub	fp, #20
0af4c     00 F4 0D F2 | 	cmp	result1, #0 wz
0af50     34 00 90 AD |  if_e	jmp	#LR__0682
0af54     04 50 05 F1 | 	add	fp, #4
0af58     A8 0E 02 FB | 	rdlong	arg01, fp
0af5c     07 19 02 F6 | 	mov	local01, arg01
0af60     08 0E 06 F1 | 	add	arg01, #8
0af64     07 0F 02 FB | 	rdlong	arg01, arg01
0af68     20 0E 46 F5 | 	or	arg01, #32
0af6c     08 18 06 F1 | 	add	local01, #8
0af70     0C 0F 62 FC | 	wrlong	arg01, local01
0af74                 | '         fil->state |=  (0x20) ;
0af74                 | '         return _set_dos_error(r);
0af74     10 50 05 F1 | 	add	fp, #16
0af78     A8 0E 02 FB | 	rdlong	arg01, fp
0af7c     14 50 85 F1 | 	sub	fp, #20
0af80     E4 F9 BF FD | 	call	#_ff_cc__set_dos_error_0481
0af84     40 00 90 FD | 	jmp	#LR__0684
0af88                 | LR__0682
0af88     18 50 05 F1 | 	add	fp, #24
0af8c     A8 18 0A FB | 	rdlong	local01, fp wz
0af90     18 50 85 F1 | 	sub	fp, #24
0af94     24 00 90 5D |  if_ne	jmp	#LR__0683
0af98     04 50 05 F1 | 	add	fp, #4
0af9c     A8 F4 01 FB | 	rdlong	result1, fp
0afa0     FA 18 02 F6 | 	mov	local01, result1
0afa4     04 50 85 F1 | 	sub	fp, #4
0afa8     08 F4 05 F1 | 	add	result1, #8
0afac     FA F4 01 FB | 	rdlong	result1, result1
0afb0     10 F4 45 F5 | 	or	result1, #16
0afb4     08 18 06 F1 | 	add	local01, #8
0afb8     0C F5 61 FC | 	wrlong	result1, local01
0afbc                 | LR__0683
0afbc                 | '         fil->state |=  (0x10) ;
0afbc                 | '     }
0afbc                 | '     return x;
0afbc     18 50 05 F1 | 	add	fp, #24
0afc0     A8 F4 01 FB | 	rdlong	result1, fp
0afc4     18 50 85 F1 | 	sub	fp, #24
0afc8                 | LR__0684
0afc8     A8 F0 03 F6 | 	mov	ptra, fp
0afcc     B3 00 A0 FD | 	call	#popregs_
0afd0                 | _ff_cc_v_read_0513_ret
0afd0     2D 00 64 FD | 	ret
0afd4                 | 
0afd4                 | _ff_cc_v_write_0517
0afd4     01 4C 05 F6 | 	mov	COUNT_, #1
0afd8     A9 00 A0 FD | 	call	#pushregs_
0afdc     1C F0 07 F1 | 	add	ptra, #28
0afe0     04 50 05 F1 | 	add	fp, #4
0afe4     A8 0E 62 FC | 	wrlong	arg01, fp
0afe8     04 50 05 F1 | 	add	fp, #4
0afec     A8 10 62 FC | 	wrlong	arg02, fp
0aff0     04 50 05 F1 | 	add	fp, #4
0aff4     A8 12 62 FC | 	wrlong	arg03, fp
0aff8     08 50 85 F1 | 	sub	fp, #8
0affc     A8 0E 02 FB | 	rdlong	arg01, fp
0b000     07 0F 0A FB | 	rdlong	arg01, arg01 wz
0b004     0C 50 05 F1 | 	add	fp, #12
0b008     A8 0E 62 FC | 	wrlong	arg01, fp
0b00c     10 50 85 F1 | 	sub	fp, #16
0b010                 | '         return _seterror( 5 );
0b010     1C EE 05 A1 |  if_e	add	ptr___system__dat__, #28
0b014     F7 0A 68 AC |  if_e	wrlong	#5, ptr___system__dat__
0b018     1C EE 85 A1 |  if_e	sub	ptr___system__dat__, #28
0b01c     01 F4 65 A6 |  if_e	neg	result1, #1
0b020     84 00 90 AD |  if_e	jmp	#LR__0686
0b024     10 50 05 F1 | 	add	fp, #16
0b028     A8 0E 02 FB | 	rdlong	arg01, fp
0b02c     02 00 00 FF 
0b030     0C 0E 06 F1 | 	add	arg01, ##1036
0b034     08 50 85 F1 | 	sub	fp, #8
0b038     A8 10 02 FB | 	rdlong	arg02, fp
0b03c     04 50 05 F1 | 	add	fp, #4
0b040     A8 12 02 FB | 	rdlong	arg03, fp
0b044     0C 50 05 F1 | 	add	fp, #12
0b048     A8 14 02 F6 | 	mov	arg04, fp
0b04c     18 50 85 F1 | 	sub	fp, #24
0b050     A0 DA BF FD | 	call	#_ff_cc_f_write
0b054     14 50 05 F1 | 	add	fp, #20
0b058     A8 F4 61 FC | 	wrlong	result1, fp
0b05c     14 50 85 F1 | 	sub	fp, #20
0b060     00 F4 0D F2 | 	cmp	result1, #0 wz
0b064     34 00 90 AD |  if_e	jmp	#LR__0685
0b068     04 50 05 F1 | 	add	fp, #4
0b06c     A8 0E 02 FB | 	rdlong	arg01, fp
0b070     07 19 02 F6 | 	mov	local01, arg01
0b074     08 0E 06 F1 | 	add	arg01, #8
0b078     07 0F 02 FB | 	rdlong	arg01, arg01
0b07c     20 0E 46 F5 | 	or	arg01, #32
0b080     08 18 06 F1 | 	add	local01, #8
0b084     0C 0F 62 FC | 	wrlong	arg01, local01
0b088                 | '         fil->state |=  (0x20) ;
0b088                 | '         return _set_dos_error(r);
0b088     10 50 05 F1 | 	add	fp, #16
0b08c     A8 0E 02 FB | 	rdlong	arg01, fp
0b090     14 50 85 F1 | 	sub	fp, #20
0b094     D0 F8 BF FD | 	call	#_ff_cc__set_dos_error_0481
0b098     0C 00 90 FD | 	jmp	#LR__0686
0b09c                 | LR__0685
0b09c                 | '     }
0b09c                 | '     return x;
0b09c     18 50 05 F1 | 	add	fp, #24
0b0a0     A8 F4 01 FB | 	rdlong	result1, fp
0b0a4     18 50 85 F1 | 	sub	fp, #24
0b0a8                 | LR__0686
0b0a8     A8 F0 03 F6 | 	mov	ptra, fp
0b0ac     B3 00 A0 FD | 	call	#popregs_
0b0b0                 | _ff_cc_v_write_0517_ret
0b0b0     2D 00 64 FD | 	ret
0b0b4                 | 
0b0b4                 | _ff_cc_v_lseek_0521
0b0b4     04 4C 05 F6 | 	mov	COUNT_, #4
0b0b8     A9 00 A0 FD | 	call	#pushregs_
0b0bc     08 19 02 F6 | 	mov	local01, arg02
0b0c0     09 1B 02 F6 | 	mov	local02, arg03
0b0c4     07 1D 02 FB | 	rdlong	local03, arg01
0b0c8     02 00 00 FF 
0b0cc     0C 1C 0E F1 | 	add	local03, ##1036 wz
0b0d0                 | '         return _seterror( 5 );
0b0d0     1C EE 05 A1 |  if_e	add	ptr___system__dat__, #28
0b0d4     F7 0A 68 AC |  if_e	wrlong	#5, ptr___system__dat__
0b0d8     1C EE 85 A1 |  if_e	sub	ptr___system__dat__, #28
0b0dc     01 F4 65 A6 |  if_e	neg	result1, #1
0b0e0     4C 00 90 AD |  if_e	jmp	#LR__0689
0b0e4     00 1A 0E F2 | 	cmp	local02, #0 wz
0b0e8     24 00 90 AD |  if_e	jmp	#LR__0687
0b0ec     01 1A 0E F2 | 	cmp	local02, #1 wz
0b0f0     14 1C 06 A1 |  if_e	add	local03, #20
0b0f4     0E 1F 02 AB |  if_e	rdlong	local04, local03
0b0f8     14 1C 86 A1 |  if_e	sub	local03, #20
0b0fc     0F 19 02 A1 |  if_e	add	local01, local04
0b100     0C 1C 06 51 |  if_ne	add	local03, #12
0b104     0E 1F 02 5B |  if_ne	rdlong	local04, local03
0b108     0C 1C 86 51 |  if_ne	sub	local03, #12
0b10c     0F 19 02 51 |  if_ne	add	local01, local04
0b110                 | LR__0687
0b110     0C 11 02 F6 | 	mov	arg02, local01
0b114     0E 0F 02 F6 | 	mov	arg01, local03
0b118     08 E4 BF FD | 	call	#_ff_cc_f_lseek
0b11c     FA 0E 0A F6 | 	mov	arg01, result1 wz
0b120     08 00 90 AD |  if_e	jmp	#LR__0688
0b124                 | '         return _set_dos_error(result);
0b124     40 F8 BF FD | 	call	#_ff_cc__set_dos_error_0481
0b128     04 00 90 FD | 	jmp	#LR__0689
0b12c                 | LR__0688
0b12c                 | '     }
0b12c                 | '     return offset;
0b12c     0C F5 01 F6 | 	mov	result1, local01
0b130                 | LR__0689
0b130     A8 F0 03 F6 | 	mov	ptra, fp
0b134     B3 00 A0 FD | 	call	#popregs_
0b138                 | _ff_cc_v_lseek_0521_ret
0b138     2D 00 64 FD | 	ret
0b13c                 | 
0b13c                 | _ff_cc_v_ioctl
0b13c                 | ' {
0b13c                 | '     return _seterror( 10 );
0b13c     1C EE 05 F1 | 	add	ptr___system__dat__, #28
0b140     F7 14 68 FC | 	wrlong	#10, ptr___system__dat__
0b144     1C EE 85 F1 | 	sub	ptr___system__dat__, #28
0b148     01 F4 65 F6 | 	neg	result1, #1
0b14c                 | _ff_cc_v_ioctl_ret
0b14c     2D 00 64 FD | 	ret
0b150                 | 
0b150                 | _ff_cc_v_mkdir
0b150     40 F0 BF FD | 	call	#_ff_cc_f_mkdir
0b154     FA 0E 02 F6 | 	mov	arg01, result1
0b158                 | ' 
0b158                 | '     r = f_mkdir(name);
0b158                 | '     return _set_dos_error(r);
0b158     0C F8 BF FD | 	call	#_ff_cc__set_dos_error_0481
0b15c                 | _ff_cc_v_mkdir_ret
0b15c     2D 00 64 FD | 	ret
0b160                 | 
0b160                 | _ff_cc_v_remove
0b160     DC ED BF FD | 	call	#_ff_cc_f_unlink
0b164     FA 0E 02 F6 | 	mov	arg01, result1
0b168                 | ' 
0b168                 | '     r = f_unlink(name);
0b168                 | '     return _set_dos_error(r);
0b168     FC F7 BF FD | 	call	#_ff_cc__set_dos_error_0481
0b16c                 | _ff_cc_v_remove_ret
0b16c     2D 00 64 FD | 	ret
0b170                 | 
0b170                 | _ff_cc_v_rmdir_0525
0b170     CC ED BF FD | 	call	#_ff_cc_f_unlink
0b174     FA 0E 02 F6 | 	mov	arg01, result1
0b178                 | ' 
0b178                 | '     r = f_unlink(name);
0b178                 | '     return _set_dos_error(r);
0b178     EC F7 BF FD | 	call	#_ff_cc__set_dos_error_0481
0b17c                 | _ff_cc_v_rmdir_0525_ret
0b17c     2D 00 64 FD | 	ret
0b180                 | 
0b180                 | _ff_cc_v_rename_0527
0b180     54 F3 BF FD | 	call	#_ff_cc_f_rename
0b184     FA 0E 02 F6 | 	mov	arg01, result1
0b188                 | '     return _set_dos_error(r);
0b188     DC F7 BF FD | 	call	#_ff_cc__set_dos_error_0481
0b18c                 | _ff_cc_v_rename_0527_ret
0b18c     2D 00 64 FD | 	ret
0b190                 | 
0b190                 | _ff_cc_v_open_0531
0b190     0A 4C 05 F6 | 	mov	COUNT_, #10
0b194     A9 00 A0 FD | 	call	#pushregs_
0b198     07 19 02 F6 | 	mov	local01, arg01
0b19c     08 1B 02 F6 | 	mov	local02, arg02
0b1a0     09 1D 02 F6 | 	mov	local03, arg03
0b1a4     02 00 00 FF 
0b1a8     34 0E 06 F6 | 	mov	arg01, ##1076
0b1ac                 | '     return _gc_alloc(size);
0b1ac     10 10 06 F6 | 	mov	arg02, #16
0b1b0     50 67 BF FD | 	call	#__system___gc_doalloc
0b1b4     FA 1E 0A F6 | 	mov	local04, result1 wz
0b1b8                 | '       return _seterror( 7 );
0b1b8     1C EE 05 A1 |  if_e	add	ptr___system__dat__, #28
0b1bc     F7 0E 68 AC |  if_e	wrlong	#7, ptr___system__dat__
0b1c0     1C EE 85 A1 |  if_e	sub	ptr___system__dat__, #28
0b1c4     01 F4 65 A6 |  if_e	neg	result1, #1
0b1c8     A8 00 90 AD |  if_e	jmp	#LR__0696
0b1cc     0F 21 02 F6 | 	mov	local05, local04
0b1d0     00 22 06 F6 | 	mov	local06, #0
0b1d4     02 00 00 FF 
0b1d8     34 24 06 F6 | 	mov	local07, ##1076
0b1dc     10 0F 02 F6 | 	mov	arg01, local05
0b1e0     00 10 06 F6 | 	mov	arg02, #0
0b1e4     02 00 00 FF 
0b1e8     34 12 06 F6 | 	mov	arg03, ##1076
0b1ec     00 07 B0 FD | 	call	#_ff_cc_memset
0b1f0                 | '   switch (flags & 3) {
0b1f0     0E 27 02 F6 | 	mov	local08, local03
0b1f4     03 26 0E F5 | 	and	local08, #3 wz
0b1f8     0C 00 90 AD |  if_e	jmp	#LR__0690
0b1fc     01 26 0E F2 | 	cmp	local08, #1 wz
0b200     0C 00 90 AD |  if_e	jmp	#LR__0691
0b204     10 00 90 FD | 	jmp	#LR__0692
0b208                 | LR__0690
0b208     01 28 06 F6 | 	mov	local09, #1
0b20c                 | '       fs_flags =  0x01 ;
0b20c                 | '       break;
0b20c     0C 00 90 FD | 	jmp	#LR__0693
0b210                 | LR__0691
0b210     02 28 06 F6 | 	mov	local09, #2
0b214                 | '       fs_flags =  0x02 ;
0b214                 | '       break;
0b214     04 00 90 FD | 	jmp	#LR__0693
0b218                 | LR__0692
0b218     03 28 06 F6 | 	mov	local09, #3
0b21c                 | '       fs_flags =  0x01  |  0x02 ;
0b21c                 | '       break;
0b21c                 | LR__0693
0b21c     08 1C CE F7 | 	test	local03, #8 wz
0b220     18 28 46 55 |  if_ne	or	local09, #24
0b224     08 00 90 5D |  if_ne	jmp	#LR__0694
0b228     20 1C CE F7 | 	test	local03, #32 wz
0b22c     30 28 46 55 |  if_ne	or	local09, #48
0b230                 | LR__0694
0b230     02 00 00 FF 
0b234     0C 1E 06 F1 | 	add	local04, ##1036
0b238     0F 0F 02 F6 | 	mov	arg01, local04
0b23c     02 00 00 FF 
0b240     0C 1E 86 F1 | 	sub	local04, ##1036
0b244     0D 11 02 F6 | 	mov	arg02, local02
0b248     14 13 02 F6 | 	mov	arg03, local09
0b24c     C4 CB BF FD | 	call	#_ff_cc_f_open
0b250     FA 2A 0A F6 | 	mov	local10, result1 wz
0b254     14 00 90 AD |  if_e	jmp	#LR__0695
0b258     0F 0F 02 F6 | 	mov	arg01, local04
0b25c                 | '     return _gc_free(ptr);
0b25c     D4 67 BF FD | 	call	#__system___gc_free
0b260                 | '     free(f);
0b260                 | ' #line 7229 "/home/pik33/Programy/flexprop/include/filesys/fatfs/ff.cc"
0b260                 | '     return _set_dos_error(r);
0b260     15 0F 02 F6 | 	mov	arg01, local10
0b264     00 F7 BF FD | 	call	#_ff_cc__set_dos_error_0481
0b268     08 00 90 FD | 	jmp	#LR__0696
0b26c                 | LR__0695
0b26c     0C 1F 62 FC | 	wrlong	local04, local01
0b270                 | '   }
0b270                 | '   fil->vfsdata = f;
0b270                 | '   return 0;
0b270     00 F4 05 F6 | 	mov	result1, #0
0b274                 | LR__0696
0b274     A8 F0 03 F6 | 	mov	ptra, fp
0b278     B3 00 A0 FD | 	call	#popregs_
0b27c                 | _ff_cc_v_open_0531_ret
0b27c     2D 00 64 FD | 	ret
0b280                 | 
0b280                 | _ff_cc_xmit_mmc_0655
0b280     03 00 00 FF 
0b284     34 F1 05 F1 | 	add	ptr__ff_cc_dat__, ##1844
0b288     F8 F8 01 FB | 	rdlong	_var01, ptr__ff_cc_dat__
0b28c     08 F0 05 F1 | 	add	ptr__ff_cc_dat__, #8
0b290     F8 FA 01 FB | 	rdlong	_var02, ptr__ff_cc_dat__
0b294     03 00 00 FF 
0b298     3C F1 85 F1 | 	sub	ptr__ff_cc_dat__, ##1852
0b29c     40 FA 61 FD | 	dirl	_var02
0b2a0     28 02 64 FD | 	setq	#1
0b2a4     07 FD 01 FB | 	rdlong	_var03, arg01
0b2a8     69 FC 61 FD | 	rev	_var03
0b2ac     1B FC FD F9 | 	movbyts	_var03, #27
0b2b0     FD FC 21 FC | 	wypin	_var03, _var02
0b2b4     08 FD 01 F6 | 	mov	_var03, arg02
0b2b8     02 10 4E F0 | 	shr	arg02, #2 wz
0b2bc     03 FC 65 F0 | 	shl	_var03, #3
0b2c0     FC FC 21 FC | 	wypin	_var03, _var01
0b2c4     41 FA 61 FD | 	dirh	_var02
0b2c8     08 0E 06 F1 | 	add	arg01, #8
0b2cc     69 FE 61 FD | 	rev	_var04
0b2d0     1B FE FD F9 | 	movbyts	_var04, #27
0b2d4                 | LR__0697
0b2d4     FD FE 21 5C |  if_ne	wypin	_var04, _var02
0b2d8     07 FF 01 5B |  if_ne	rdlong	_var04, arg01
0b2dc     04 0E 06 51 |  if_ne	add	arg01, #4
0b2e0     69 FE 61 5D |  if_ne	rev	_var04
0b2e4     1B FE FD 59 |  if_ne	movbyts	_var04, #27
0b2e8                 | LR__0698
0b2e8     40 FA 71 5D |  if_ne	testp	_var02 wc
0b2ec     F8 FF 9F 1D |  if_a	jmp	#LR__0698
0b2f0     F8 11 6E 5B |  if_ne	djnz	arg02, #LR__0697
0b2f4                 | LR__0699
0b2f4     40 F8 71 FD | 	testp	_var01 wc
0b2f8     F8 FF 9F 3D |  if_ae	jmp	#LR__0699
0b2fc     40 FA 61 FD | 	dirl	_var02
0b300     FF FF FF FF 
0b304     FD FE 2B FC | 	wypin	##-1, _var02
0b308     41 FA 61 FD | 	dirh	_var02
0b30c                 | _ff_cc_xmit_mmc_0655_ret
0b30c     2D 00 64 FD | 	ret
0b310                 | 
0b310                 | _ff_cc_rcvr_mmc_0660
0b310     03 00 00 FF 
0b314     34 F1 05 F1 | 	add	ptr__ff_cc_dat__, ##1844
0b318     F8 F8 01 FB | 	rdlong	_var01, ptr__ff_cc_dat__
0b31c     0C F0 05 F1 | 	add	ptr__ff_cc_dat__, #12
0b320     F8 FA 01 FB | 	rdlong	_var02, ptr__ff_cc_dat__
0b324     03 00 00 FF 
0b328     40 F1 85 F1 | 	sub	ptr__ff_cc_dat__, ##1856
0b32c     FD 02 08 FC | 	akpin	_var02
0b330     08 FD 09 F6 | 	mov	_var03, arg02 wz
0b334     02 FC 4D F0 | 	shr	_var03, #2 wz
0b338     30 00 90 AD |  if_e	jmp	#LR__0702
0b33c     FE FE 01 F6 | 	mov	_var04, _var03
0b340     05 FE 65 F0 | 	shl	_var04, #5
0b344     FC FE 21 FC | 	wypin	_var04, _var01
0b348     FD 7E 18 FC | 	wxpin	#63, _var02
0b34c                 | LR__0700
0b34c                 | LR__0701
0b34c     40 FA 71 FD | 	testp	_var02 wc
0b350     F8 FF 9F 3D |  if_ae	jmp	#LR__0701
0b354     FD FE 89 FA | 	rdpin	_var04, _var02
0b358     69 FE 61 FD | 	rev	_var04
0b35c     1B FE FD F9 | 	movbyts	_var04, #27
0b360     07 FF 61 FC | 	wrlong	_var04, arg01
0b364     04 0E 06 F1 | 	add	arg01, #4
0b368     F8 FD 6D FB | 	djnz	_var03, #LR__0700
0b36c                 | LR__0702
0b36c     03 10 0E F5 | 	and	arg02, #3 wz
0b370     24 00 90 AD |  if_e	jmp	#LR__0705
0b374     FD 4E 18 FC | 	wxpin	#39, _var02
0b378                 | LR__0703
0b378     FC 10 28 FC | 	wypin	#8, _var01
0b37c                 | LR__0704
0b37c     40 FA 71 FD | 	testp	_var02 wc
0b380     F8 FF 9F 3D |  if_ae	jmp	#LR__0704
0b384     FD FE 89 FA | 	rdpin	_var04, _var02
0b388     69 FE 61 FD | 	rev	_var04
0b38c     07 FF 41 FC | 	wrbyte	_var04, arg01
0b390     01 0E 06 F1 | 	add	arg01, #1
0b394     F8 11 6E FB | 	djnz	arg02, #LR__0703
0b398                 | LR__0705
0b398                 | _ff_cc_rcvr_mmc_0660_ret
0b398     2D 00 64 FD | 	ret
0b39c                 | 
0b39c                 | _ff_cc_wait_ready_0664
0b39c     01 4C 05 F6 | 	mov	COUNT_, #1
0b3a0     A9 00 A0 FD | 	call	#pushregs_
0b3a4     10 F0 07 F1 | 	add	ptra, #16
0b3a8     1A F4 61 FD | 	getct	result1
0b3ac     08 50 05 F1 | 	add	fp, #8
0b3b0     A8 F4 61 FC | 	wrlong	result1, fp
0b3b4     14 18 06 FB | 	rdlong	local01, #20
0b3b8     01 18 46 F0 | 	shr	local01, #1
0b3bc     04 50 05 F1 | 	add	fp, #4
0b3c0     A8 18 62 FC | 	wrlong	local01, fp
0b3c4     0C 50 85 F1 | 	sub	fp, #12
0b3c8                 | ' {
0b3c8                 | ' 	BYTE d;
0b3c8                 | ' 	UINT tmr, tmout;
0b3c8                 | ' 
0b3c8                 | ' 	tmr = _cnt();
0b3c8                 | ' 	tmout =  (*(uint32_t *)0x14)  >> 1;
0b3c8                 | ' 	for(;;) {
0b3c8                 | LR__0706
0b3c8     04 50 05 F1 | 	add	fp, #4
0b3cc     A8 0E 02 F6 | 	mov	arg01, fp
0b3d0     04 50 85 F1 | 	sub	fp, #4
0b3d4     01 10 06 F6 | 	mov	arg02, #1
0b3d8     34 FF BF FD | 	call	#_ff_cc_rcvr_mmc_0660
0b3dc     04 50 05 F1 | 	add	fp, #4
0b3e0     A8 18 C2 FA | 	rdbyte	local01, fp
0b3e4     04 50 85 F1 | 	sub	fp, #4
0b3e8     FF 18 0E F2 | 	cmp	local01, #255 wz
0b3ec     01 F4 05 A6 |  if_e	mov	result1, #1
0b3f0     28 00 90 AD |  if_e	jmp	#LR__0707
0b3f4     1A F4 61 FD | 	getct	result1
0b3f8     08 50 05 F1 | 	add	fp, #8
0b3fc     A8 18 02 FB | 	rdlong	local01, fp
0b400     0C F5 81 F1 | 	sub	result1, local01
0b404     04 50 05 F1 | 	add	fp, #4
0b408     A8 18 02 FB | 	rdlong	local01, fp
0b40c     0C 50 85 F1 | 	sub	fp, #12
0b410     0C F5 11 F2 | 	cmp	result1, local01 wc
0b414     00 F4 05 36 |  if_ae	mov	result1, #0
0b418     AC FF 9F CD |  if_b	jmp	#LR__0706
0b41c                 | LR__0707
0b41c     A8 F0 03 F6 | 	mov	ptra, fp
0b420     B3 00 A0 FD | 	call	#popregs_
0b424                 | _ff_cc_wait_ready_0664_ret
0b424     2D 00 64 FD | 	ret
0b428                 | 
0b428                 | _ff_cc_deselect_0667
0b428     00 4C 05 F6 | 	mov	COUNT_, #0
0b42c     A9 00 A0 FD | 	call	#pushregs_
0b430     08 F0 07 F1 | 	add	ptra, #8
0b434     03 00 00 FF 
0b438     38 F1 05 F1 | 	add	ptr__ff_cc_dat__, ##1848
0b43c     F8 0E 02 FB | 	rdlong	arg01, ptr__ff_cc_dat__
0b440     03 00 00 FF 
0b444     38 F1 85 F1 | 	sub	ptr__ff_cc_dat__, ##1848
0b448     04 50 05 F1 | 	add	fp, #4
0b44c     A8 0E 62 FC | 	wrlong	arg01, fp
0b450     04 50 85 F1 | 	sub	fp, #4
0b454     59 0E 62 FD | 	drvh	arg01
0b458     A8 0E 02 F6 | 	mov	arg01, fp
0b45c     01 10 06 F6 | 	mov	arg02, #1
0b460     AC FE BF FD | 	call	#_ff_cc_rcvr_mmc_0660
0b464     A8 F0 03 F6 | 	mov	ptra, fp
0b468     B3 00 A0 FD | 	call	#popregs_
0b46c                 | _ff_cc_deselect_0667_ret
0b46c     2D 00 64 FD | 	ret
0b470                 | 
0b470                 | _ff_cc_select_0671
0b470     00 4C 05 F6 | 	mov	COUNT_, #0
0b474     A9 00 A0 FD | 	call	#pushregs_
0b478     10 F0 07 F1 | 	add	ptra, #16
0b47c     03 00 00 FF 
0b480     38 F1 05 F1 | 	add	ptr__ff_cc_dat__, ##1848
0b484     F8 0E 02 FB | 	rdlong	arg01, ptr__ff_cc_dat__
0b488     08 50 05 F1 | 	add	fp, #8
0b48c     A8 0E 62 FC | 	wrlong	arg01, fp
0b490     08 F0 05 F1 | 	add	ptr__ff_cc_dat__, #8
0b494     F8 0E 02 FB | 	rdlong	arg01, ptr__ff_cc_dat__
0b498     03 00 00 FF 
0b49c     40 F1 85 F1 | 	sub	ptr__ff_cc_dat__, ##1856
0b4a0     04 50 05 F1 | 	add	fp, #4
0b4a4     A8 0E 62 FC | 	wrlong	arg01, fp
0b4a8     50 0E 62 FD | 	fltl	arg01
0b4ac     04 50 85 F1 | 	sub	fp, #4
0b4b0     A8 0E 02 FB | 	rdlong	arg01, fp
0b4b4     58 0E 62 FD | 	drvl	arg01
0b4b8     04 50 05 F1 | 	add	fp, #4
0b4bc     A8 0E 02 FB | 	rdlong	arg01, fp
0b4c0     41 0E 62 FD | 	dirh	arg01
0b4c4     08 50 85 F1 | 	sub	fp, #8
0b4c8     A8 0E 02 F6 | 	mov	arg01, fp
0b4cc     04 50 85 F1 | 	sub	fp, #4
0b4d0     01 10 06 F6 | 	mov	arg02, #1
0b4d4     38 FE BF FD | 	call	#_ff_cc_rcvr_mmc_0660
0b4d8     C0 FE BF FD | 	call	#_ff_cc_wait_ready_0664
0b4dc     00 F4 0D F2 | 	cmp	result1, #0 wz
0b4e0                 | ' 		return 1;
0b4e0     01 F4 05 56 |  if_ne	mov	result1, #1
0b4e4     08 00 90 5D |  if_ne	jmp	#LR__0708
0b4e8     3C FF BF FD | 	call	#_ff_cc_deselect_0667
0b4ec                 | ' 
0b4ec                 | ' 	deselect();
0b4ec                 | ' 	return 0;
0b4ec     00 F4 05 F6 | 	mov	result1, #0
0b4f0                 | LR__0708
0b4f0     A8 F0 03 F6 | 	mov	ptra, fp
0b4f4     B3 00 A0 FD | 	call	#popregs_
0b4f8                 | _ff_cc_select_0671_ret
0b4f8     2D 00 64 FD | 	ret
0b4fc                 | 
0b4fc                 | _ff_cc_rcvr_datablock_0675
0b4fc     01 4C 05 F6 | 	mov	COUNT_, #1
0b500     A9 00 A0 FD | 	call	#pushregs_
0b504     18 F0 07 F1 | 	add	ptra, #24
0b508     04 50 05 F1 | 	add	fp, #4
0b50c     A8 0E 62 FC | 	wrlong	arg01, fp
0b510     04 50 05 F1 | 	add	fp, #4
0b514     A8 10 62 FC | 	wrlong	arg02, fp
0b518     1A F4 61 FD | 	getct	result1
0b51c     08 50 05 F1 | 	add	fp, #8
0b520     A8 F4 61 FC | 	wrlong	result1, fp
0b524     14 18 06 FB | 	rdlong	local01, #20
0b528     03 18 46 F0 | 	shr	local01, #3
0b52c     04 50 05 F1 | 	add	fp, #4
0b530     A8 18 62 FC | 	wrlong	local01, fp
0b534     14 50 85 F1 | 	sub	fp, #20
0b538                 | ' 	BYTE *buff,
0b538                 | ' 	UINT btr
0b538                 | ' )
0b538                 | ' {
0b538                 | ' 	BYTE d[2];
0b538                 | ' 	UINT tmr, tmout;
0b538                 | ' 
0b538                 | ' 	tmr = _cnt();
0b538                 | ' 	tmout =  (*(uint32_t *)0x14)  >> 3;
0b538                 | ' 	for(;;) {
0b538                 | LR__0709
0b538     0C 50 05 F1 | 	add	fp, #12
0b53c     A8 0E 02 F6 | 	mov	arg01, fp
0b540     0C 50 85 F1 | 	sub	fp, #12
0b544     01 10 06 F6 | 	mov	arg02, #1
0b548     C4 FD BF FD | 	call	#_ff_cc_rcvr_mmc_0660
0b54c     0C 50 05 F1 | 	add	fp, #12
0b550     A8 18 C2 FA | 	rdbyte	local01, fp
0b554     0C 50 85 F1 | 	sub	fp, #12
0b558     FF 18 0E F2 | 	cmp	local01, #255 wz
0b55c     28 00 90 5D |  if_ne	jmp	#LR__0710
0b560     1A F4 61 FD | 	getct	result1
0b564     FA 18 02 F6 | 	mov	local01, result1
0b568     10 50 05 F1 | 	add	fp, #16
0b56c     A8 10 02 FB | 	rdlong	arg02, fp
0b570     08 19 82 F1 | 	sub	local01, arg02
0b574     04 50 05 F1 | 	add	fp, #4
0b578     A8 10 02 FB | 	rdlong	arg02, fp
0b57c     14 50 85 F1 | 	sub	fp, #20
0b580     08 19 12 F2 | 	cmp	local01, arg02 wc
0b584     B0 FF 9F CD |  if_b	jmp	#LR__0709
0b588                 | LR__0710
0b588     0C 50 05 F1 | 	add	fp, #12
0b58c     A8 18 C2 FA | 	rdbyte	local01, fp
0b590     0C 50 85 F1 | 	sub	fp, #12
0b594     FE 18 0E F2 | 	cmp	local01, #254 wz
0b598     00 F4 05 56 |  if_ne	mov	result1, #0
0b59c     30 00 90 5D |  if_ne	jmp	#LR__0711
0b5a0     04 50 05 F1 | 	add	fp, #4
0b5a4     A8 0E 02 FB | 	rdlong	arg01, fp
0b5a8     04 50 05 F1 | 	add	fp, #4
0b5ac     A8 10 02 FB | 	rdlong	arg02, fp
0b5b0     08 50 85 F1 | 	sub	fp, #8
0b5b4     58 FD BF FD | 	call	#_ff_cc_rcvr_mmc_0660
0b5b8     0C 50 05 F1 | 	add	fp, #12
0b5bc     A8 0E 02 F6 | 	mov	arg01, fp
0b5c0     0C 50 85 F1 | 	sub	fp, #12
0b5c4     02 10 06 F6 | 	mov	arg02, #2
0b5c8     44 FD BF FD | 	call	#_ff_cc_rcvr_mmc_0660
0b5cc                 | ' 
0b5cc                 | ' 	rcvr_mmc(buff, btr);
0b5cc                 | ' 	rcvr_mmc(d, 2);
0b5cc                 | ' 
0b5cc                 | ' 	return 1;
0b5cc     01 F4 05 F6 | 	mov	result1, #1
0b5d0                 | LR__0711
0b5d0     A8 F0 03 F6 | 	mov	ptra, fp
0b5d4     B3 00 A0 FD | 	call	#popregs_
0b5d8                 | _ff_cc_rcvr_datablock_0675_ret
0b5d8     2D 00 64 FD | 	ret
0b5dc                 | 
0b5dc                 | _ff_cc_xmit_datablock_0677
0b5dc     00 4C 05 F6 | 	mov	COUNT_, #0
0b5e0     A9 00 A0 FD | 	call	#pushregs_
0b5e4     10 F0 07 F1 | 	add	ptra, #16
0b5e8     04 50 05 F1 | 	add	fp, #4
0b5ec     A8 0E 62 FC | 	wrlong	arg01, fp
0b5f0     04 50 05 F1 | 	add	fp, #4
0b5f4     A8 10 42 FC | 	wrbyte	arg02, fp
0b5f8     08 50 85 F1 | 	sub	fp, #8
0b5fc     9C FD BF FD | 	call	#_ff_cc_wait_ready_0664
0b600     00 F4 0D F2 | 	cmp	result1, #0 wz
0b604     00 F4 05 A6 |  if_e	mov	result1, #0
0b608     90 00 90 AD |  if_e	jmp	#LR__0713
0b60c     08 50 05 F1 | 	add	fp, #8
0b610     A8 10 C2 FA | 	rdbyte	arg02, fp
0b614     04 50 05 F1 | 	add	fp, #4
0b618     A8 10 42 FC | 	wrbyte	arg02, fp
0b61c     A8 0E 02 F6 | 	mov	arg01, fp
0b620     0C 50 85 F1 | 	sub	fp, #12
0b624     01 10 06 F6 | 	mov	arg02, #1
0b628     54 FC BF FD | 	call	#_ff_cc_xmit_mmc_0655
0b62c     08 50 05 F1 | 	add	fp, #8
0b630     A8 10 C2 FA | 	rdbyte	arg02, fp
0b634     08 50 85 F1 | 	sub	fp, #8
0b638     FD 10 0E F2 | 	cmp	arg02, #253 wz
0b63c     58 00 90 AD |  if_e	jmp	#LR__0712
0b640     04 50 05 F1 | 	add	fp, #4
0b644     A8 0E 02 FB | 	rdlong	arg01, fp
0b648     04 50 85 F1 | 	sub	fp, #4
0b64c     09 10 C6 F9 | 	decod	arg02, #9
0b650     2C FC BF FD | 	call	#_ff_cc_xmit_mmc_0655
0b654     0C 50 05 F1 | 	add	fp, #12
0b658     A8 0E 02 F6 | 	mov	arg01, fp
0b65c     0C 50 85 F1 | 	sub	fp, #12
0b660     02 10 06 F6 | 	mov	arg02, #2
0b664     A8 FC BF FD | 	call	#_ff_cc_rcvr_mmc_0660
0b668     0C 50 05 F1 | 	add	fp, #12
0b66c     A8 0E 02 F6 | 	mov	arg01, fp
0b670     0C 50 85 F1 | 	sub	fp, #12
0b674     01 10 06 F6 | 	mov	arg02, #1
0b678     94 FC BF FD | 	call	#_ff_cc_rcvr_mmc_0660
0b67c     0C 50 05 F1 | 	add	fp, #12
0b680     A8 10 C2 FA | 	rdbyte	arg02, fp
0b684     0C 50 85 F1 | 	sub	fp, #12
0b688     1F 10 06 F5 | 	and	arg02, #31
0b68c     05 10 0E F2 | 	cmp	arg02, #5 wz
0b690                 | ' 			return 0;
0b690     00 F4 05 56 |  if_ne	mov	result1, #0
0b694     04 00 90 5D |  if_ne	jmp	#LR__0713
0b698                 | LR__0712
0b698                 | ' 	}
0b698                 | ' 
0b698                 | ' 	return 1;
0b698     01 F4 05 F6 | 	mov	result1, #1
0b69c                 | LR__0713
0b69c     A8 F0 03 F6 | 	mov	ptra, fp
0b6a0     B3 00 A0 FD | 	call	#popregs_
0b6a4                 | _ff_cc_xmit_datablock_0677_ret
0b6a4     2D 00 64 FD | 	ret
0b6a8                 | 
0b6a8                 | _ff_cc_send_cmd_0681
0b6a8     01 4C 05 F6 | 	mov	COUNT_, #1
0b6ac     A9 00 A0 FD | 	call	#pushregs_
0b6b0     1C F0 07 F1 | 	add	ptra, #28
0b6b4                 | _ff_cc_send_cmd_0681_enter
0b6b4     04 50 05 F1 | 	add	fp, #4
0b6b8     A8 0E 42 FC | 	wrbyte	arg01, fp
0b6bc     04 50 05 F1 | 	add	fp, #4
0b6c0     A8 10 62 FC | 	wrlong	arg02, fp
0b6c4     04 50 85 F1 | 	sub	fp, #4
0b6c8     A8 F4 C1 FA | 	rdbyte	result1, fp
0b6cc     04 50 85 F1 | 	sub	fp, #4
0b6d0     80 F4 CD F7 | 	test	result1, #128 wz
0b6d4     44 00 90 AD |  if_e	jmp	#LR__0714
0b6d8     04 50 05 F1 | 	add	fp, #4
0b6dc     A8 10 C2 FA | 	rdbyte	arg02, fp
0b6e0     7F 10 06 F5 | 	and	arg02, #127
0b6e4     A8 10 42 FC | 	wrbyte	arg02, fp
0b6e8     04 50 85 F1 | 	sub	fp, #4
0b6ec     37 0E 06 F6 | 	mov	arg01, #55
0b6f0     00 10 06 F6 | 	mov	arg02, #0
0b6f4     B0 FF BF FD | 	call	#_ff_cc_send_cmd_0681
0b6f8     0C 50 05 F1 | 	add	fp, #12
0b6fc     A8 F4 41 FC | 	wrbyte	result1, fp
0b700     A8 18 C2 FA | 	rdbyte	local01, fp
0b704     0C 50 85 F1 | 	sub	fp, #12
0b708     02 18 16 F2 | 	cmp	local01, #2 wc
0b70c     0C 50 05 31 |  if_ae	add	fp, #12
0b710     A8 F4 C1 3A |  if_ae	rdbyte	result1, fp
0b714     0C 50 85 31 |  if_ae	sub	fp, #12
0b718     70 01 90 3D |  if_ae	jmp	#LR__0718
0b71c                 | LR__0714
0b71c     04 50 05 F1 | 	add	fp, #4
0b720     A8 18 C2 FA | 	rdbyte	local01, fp
0b724     04 50 85 F1 | 	sub	fp, #4
0b728     0C 18 0E F2 | 	cmp	local01, #12 wz
0b72c     14 00 90 AD |  if_e	jmp	#LR__0715
0b730     F4 FC BF FD | 	call	#_ff_cc_deselect_0667
0b734     38 FD BF FD | 	call	#_ff_cc_select_0671
0b738     00 F4 0D F2 | 	cmp	result1, #0 wz
0b73c     FF F4 05 A6 |  if_e	mov	result1, #255
0b740     48 01 90 AD |  if_e	jmp	#LR__0718
0b744                 | LR__0715
0b744     04 50 05 F1 | 	add	fp, #4
0b748     A8 10 C2 FA | 	rdbyte	arg02, fp
0b74c     40 18 06 F6 | 	mov	local01, #64
0b750     08 19 42 F5 | 	or	local01, arg02
0b754     10 50 05 F1 | 	add	fp, #16
0b758     A8 18 42 FC | 	wrbyte	local01, fp
0b75c     0C 50 85 F1 | 	sub	fp, #12
0b760     A8 18 02 FB | 	rdlong	local01, fp
0b764     18 18 46 F0 | 	shr	local01, #24
0b768     0D 50 05 F1 | 	add	fp, #13
0b76c     A8 18 42 FC | 	wrbyte	local01, fp
0b770     0D 50 85 F1 | 	sub	fp, #13
0b774     A8 18 02 FB | 	rdlong	local01, fp
0b778     10 18 46 F0 | 	shr	local01, #16
0b77c     0E 50 05 F1 | 	add	fp, #14
0b780     A8 18 42 FC | 	wrbyte	local01, fp
0b784     0E 50 85 F1 | 	sub	fp, #14
0b788     A8 18 02 FB | 	rdlong	local01, fp
0b78c     08 18 46 F0 | 	shr	local01, #8
0b790     0F 50 05 F1 | 	add	fp, #15
0b794     A8 18 42 FC | 	wrbyte	local01, fp
0b798     0F 50 85 F1 | 	sub	fp, #15
0b79c     A8 18 02 FB | 	rdlong	local01, fp
0b7a0     10 50 05 F1 | 	add	fp, #16
0b7a4     A8 18 42 FC | 	wrbyte	local01, fp
0b7a8     0C 50 85 F1 | 	sub	fp, #12
0b7ac     A8 02 48 FC | 	wrbyte	#1, fp
0b7b0     08 50 85 F1 | 	sub	fp, #8
0b7b4     A8 18 C2 FA | 	rdbyte	local01, fp
0b7b8     04 50 85 F1 | 	sub	fp, #4
0b7bc     07 18 4E F7 | 	zerox	local01, #7 wz
0b7c0     0C 50 05 A1 |  if_e	add	fp, #12
0b7c4     A8 2A 49 AC |  if_e	wrbyte	#149, fp
0b7c8     0C 50 85 A1 |  if_e	sub	fp, #12
0b7cc     04 50 05 F1 | 	add	fp, #4
0b7d0     A8 18 C2 FA | 	rdbyte	local01, fp
0b7d4     04 50 85 F1 | 	sub	fp, #4
0b7d8     08 18 0E F2 | 	cmp	local01, #8 wz
0b7dc     0C 50 05 A1 |  if_e	add	fp, #12
0b7e0     A8 0E 49 AC |  if_e	wrbyte	#135, fp
0b7e4     0C 50 85 A1 |  if_e	sub	fp, #12
0b7e8     0C 50 05 F1 | 	add	fp, #12
0b7ec     A8 18 C2 FA | 	rdbyte	local01, fp
0b7f0     0D 50 05 F1 | 	add	fp, #13
0b7f4     A8 18 42 FC | 	wrbyte	local01, fp
0b7f8     05 50 85 F1 | 	sub	fp, #5
0b7fc     A8 0E 02 F6 | 	mov	arg01, fp
0b800     14 50 85 F1 | 	sub	fp, #20
0b804     06 10 06 F6 | 	mov	arg02, #6
0b808     74 FA BF FD | 	call	#_ff_cc_xmit_mmc_0655
0b80c     04 50 05 F1 | 	add	fp, #4
0b810     A8 18 C2 FA | 	rdbyte	local01, fp
0b814     04 50 85 F1 | 	sub	fp, #4
0b818     0C 18 0E F2 | 	cmp	local01, #12 wz
0b81c     10 50 05 A1 |  if_e	add	fp, #16
0b820     A8 0E 02 A6 |  if_e	mov	arg01, fp
0b824     10 50 85 A1 |  if_e	sub	fp, #16
0b828     01 10 06 A6 |  if_e	mov	arg02, #1
0b82c     E0 FA BF AD |  if_e	call	#_ff_cc_rcvr_mmc_0660
0b830     0C 50 05 F1 | 	add	fp, #12
0b834     A8 14 48 FC | 	wrbyte	#10, fp
0b838     0C 50 85 F1 | 	sub	fp, #12
0b83c                 | ' 	n = 10;
0b83c                 | ' 	do
0b83c                 | LR__0716
0b83c     10 50 05 F1 | 	add	fp, #16
0b840     A8 0E 02 F6 | 	mov	arg01, fp
0b844     10 50 85 F1 | 	sub	fp, #16
0b848     01 10 06 F6 | 	mov	arg02, #1
0b84c     C0 FA BF FD | 	call	#_ff_cc_rcvr_mmc_0660
0b850     10 50 05 F1 | 	add	fp, #16
0b854     A8 18 C2 FA | 	rdbyte	local01, fp
0b858     10 50 85 F1 | 	sub	fp, #16
0b85c     80 18 CE F7 | 	test	local01, #128 wz
0b860     1C 00 90 AD |  if_e	jmp	#LR__0717
0b864     0C 50 05 F1 | 	add	fp, #12
0b868     A8 18 C2 FA | 	rdbyte	local01, fp
0b86c     01 18 86 F1 | 	sub	local01, #1
0b870     A8 18 42 FC | 	wrbyte	local01, fp
0b874     A8 18 CA FA | 	rdbyte	local01, fp wz
0b878     0C 50 85 F1 | 	sub	fp, #12
0b87c     BC FF 9F 5D |  if_ne	jmp	#LR__0716
0b880                 | LR__0717
0b880                 | ' 
0b880                 | ' 	return d;
0b880     10 50 05 F1 | 	add	fp, #16
0b884     A8 F4 C1 FA | 	rdbyte	result1, fp
0b888     10 50 85 F1 | 	sub	fp, #16
0b88c                 | LR__0718
0b88c     A8 F0 03 F6 | 	mov	ptra, fp
0b890     B3 00 A0 FD | 	call	#popregs_
0b894                 | _ff_cc_send_cmd_0681_ret
0b894     2D 00 64 FD | 	ret
0b898                 | 
0b898                 | _ff_cc_strncpy
0b898     07 F9 01 F6 | 	mov	_var01, arg01
0b89c     84 47 9F FE | 	loc	pa,	#(@LR__0720-@LR__0719)
0b8a0     8C 00 A0 FD | 	call	#FCACHE_LOAD_
0b8a4                 | ' 
0b8a4                 | ' 	dscan = dst;
0b8a4                 | ' 	sscan = src;
0b8a4                 | ' 	count = n;
0b8a4                 | ' 	while (--count >= 0 && (*dscan++ = *sscan++) != '\0')
0b8a4                 | LR__0719
0b8a4     01 12 86 F1 | 	sub	arg03, #1
0b8a8     00 12 56 F2 | 	cmps	arg03, #0 wc
0b8ac     18 00 90 CD |  if_b	jmp	#LR__0721
0b8b0     08 F5 C1 FA | 	rdbyte	result1, arg02
0b8b4     FC F4 41 FC | 	wrbyte	result1, _var01
0b8b8     01 10 06 F1 | 	add	arg02, #1
0b8bc     FC F4 C9 FA | 	rdbyte	result1, _var01 wz
0b8c0                 | ' 		continue;
0b8c0     01 F8 05 F1 | 	add	_var01, #1
0b8c4     DC FF 9F 5D |  if_ne	jmp	#LR__0719
0b8c8                 | LR__0720
0b8c8                 | LR__0721
0b8c8     4C 47 9F FE | 	loc	pa,	#(@LR__0723-@LR__0722)
0b8cc     8C 00 A0 FD | 	call	#FCACHE_LOAD_
0b8d0                 | ' 	while (--count >= 0)
0b8d0                 | LR__0722
0b8d0     01 12 86 F1 | 	sub	arg03, #1
0b8d4     00 12 56 F2 | 	cmps	arg03, #0 wc
0b8d8     FC FA 01 36 |  if_ae	mov	_var02, _var01
0b8dc     01 F8 05 31 |  if_ae	add	_var01, #1
0b8e0     FD 00 48 3C |  if_ae	wrbyte	#0, _var02
0b8e4     E8 FF 9F 3D |  if_ae	jmp	#LR__0722
0b8e8                 | LR__0723
0b8e8                 | ' 		*dscan++ = '\0';
0b8e8                 | ' 	return(dst);
0b8e8     07 F5 01 F6 | 	mov	result1, arg01
0b8ec                 | _ff_cc_strncpy_ret
0b8ec     2D 00 64 FD | 	ret
0b8f0                 | 
0b8f0                 | _ff_cc_memset
0b8f0     07 F9 01 F6 | 	mov	_var01, arg01
0b8f4     08 FB 01 F6 | 	mov	_var02, arg02
0b8f8     09 FD 01 F6 | 	mov	_var03, arg03
0b8fc     FC FE 01 F6 | 	mov	_var04, _var01
0b900     03 00 06 F6 | 	mov	_var05, #3
0b904     FC 00 0A F5 | 	and	_var05, _var01 wz
0b908     70 00 90 5D |  if_ne	jmp	#LR__0727
0b90c     05 FC 15 F2 | 	cmp	_var03, #5 wc
0b910     68 00 90 CD |  if_b	jmp	#LR__0727
0b914     FC 02 02 F6 | 	mov	_var06, _var01
0b918     FD FA E1 F8 | 	getbyte	_var02, _var02, #0
0b91c     FD 00 02 F6 | 	mov	_var05, _var02
0b920     18 00 66 F0 | 	shl	_var05, #24
0b924     FD 04 02 F6 | 	mov	_var07, _var02
0b928     10 04 66 F0 | 	shl	_var07, #16
0b92c     02 01 42 F5 | 	or	_var05, _var07
0b930     FD 06 02 F6 | 	mov	_var08, _var02
0b934     08 06 66 F0 | 	shl	_var08, #8
0b938     03 01 42 F5 | 	or	_var05, _var08
0b93c     FD 00 42 F5 | 	or	_var05, _var02
0b940     00 09 02 F6 | 	mov	_var09, _var05
0b944     E4 46 9F FE | 	loc	pa,	#(@LR__0725-@LR__0724)
0b948     8C 00 A0 FD | 	call	#FCACHE_LOAD_
0b94c                 | '     {
0b94c                 | '       uint32_t lc;
0b94c                 | '       uint32_t *dstl = dest_p;
0b94c                 | '       c &= 0xff;
0b94c                 | '       lc = (c<<24)|(c<<16)|(c<<8)|c;
0b94c                 | '       while (n >= sizeof(uint32_t))
0b94c                 | LR__0724
0b94c     04 FC 15 F2 | 	cmp	_var03, #4 wc
0b950     24 00 90 CD |  if_b	jmp	#LR__0726
0b954     01 01 02 F6 | 	mov	_var05, _var06
0b958     01 05 02 F6 | 	mov	_var07, _var06
0b95c     04 04 06 F1 | 	add	_var07, #4
0b960     02 03 02 F6 | 	mov	_var06, _var07
0b964     00 09 62 FC | 	wrlong	_var09, _var05
0b968     FE 00 02 F6 | 	mov	_var05, _var03
0b96c     04 00 86 F1 | 	sub	_var05, #4
0b970     00 FD 01 F6 | 	mov	_var03, _var05
0b974     D4 FF 9F FD | 	jmp	#LR__0724
0b978                 | LR__0725
0b978                 | LR__0726
0b978     01 F9 01 F6 | 	mov	_var01, _var06
0b97c                 | LR__0727
0b97c     98 46 9F FE | 	loc	pa,	#(@LR__0729-@LR__0728)
0b980     8C 00 A0 FD | 	call	#FCACHE_LOAD_
0b984                 | ' 	}
0b984                 | '       dest_p = dstl;
0b984                 | '     }
0b984                 | ' 
0b984                 | '   dst = dest_p;
0b984                 | '   while (n > 0) {
0b984                 | LR__0728
0b984     01 FC 15 F2 | 	cmp	_var03, #1 wc
0b988     FC 00 02 36 |  if_ae	mov	_var05, _var01
0b98c     01 F8 05 31 |  if_ae	add	_var01, #1
0b990     00 FB 41 3C |  if_ae	wrbyte	_var02, _var05
0b994     01 FC 85 31 |  if_ae	sub	_var03, #1
0b998     E8 FF 9F 3D |  if_ae	jmp	#LR__0728
0b99c                 | LR__0729
0b99c                 | '     *dst++ = c;
0b99c                 | '     --n;
0b99c                 | '   }
0b99c                 | ' 
0b99c                 | '   return orig_dest;
0b99c     FF F4 01 F6 | 	mov	result1, _var04
0b9a0                 | _ff_cc_memset_ret
0b9a0     2D 00 64 FD | 	ret
0b9a4                 | 
0b9a4                 | __struct__s_vfs_file_t_putchar
0b9a4     04 4C 05 F6 | 	mov	COUNT_, #4
0b9a8     A9 00 A0 FD | 	call	#pushregs_
0b9ac     18 E2 05 F1 | 	add	objptr, #24
0b9b0     F1 10 0A FB | 	rdlong	arg02, objptr wz
0b9b4     18 E2 85 F1 | 	sub	objptr, #24
0b9b8     00 F4 05 A6 |  if_e	mov	result1, #0
0b9bc     3C 00 90 AD |  if_e	jmp	#LR__0730
0b9c0     18 E2 05 F1 | 	add	objptr, #24
0b9c4     F1 18 02 FB | 	rdlong	local01, objptr
0b9c8     18 E2 85 F1 | 	sub	objptr, #24
0b9cc     0C 1B 02 FB | 	rdlong	local02, local01
0b9d0     04 18 06 F1 | 	add	local01, #4
0b9d4     0C 1D 02 FB | 	rdlong	local03, local01
0b9d8     F1 10 02 F6 | 	mov	arg02, objptr
0b9dc     F1 1E 02 F6 | 	mov	local04, objptr
0b9e0     0D E3 01 F6 | 	mov	objptr, local02
0b9e4     2D 1C 62 FD | 	call	local03
0b9e8     0F E3 01 F6 | 	mov	objptr, local04
0b9ec     00 F4 55 F2 | 	cmps	result1, #0 wc
0b9f0     00 18 06 C6 |  if_b	mov	local01, #0
0b9f4     01 18 06 36 |  if_ae	mov	local01, #1
0b9f8     0C F5 01 F6 | 	mov	result1, local01
0b9fc                 | LR__0730
0b9fc     A8 F0 03 F6 | 	mov	ptra, fp
0ba00     B3 00 A0 FD | 	call	#popregs_
0ba04                 | __struct__s_vfs_file_t_putchar_ret
0ba04     2D 00 64 FD | 	ret
0ba08                 | 
0ba08                 | __struct__s_vfs_file_t_getchar
0ba08     03 4C 05 F6 | 	mov	COUNT_, #3
0ba0c     A9 00 A0 FD | 	call	#pushregs_
0ba10     1C E2 05 F1 | 	add	objptr, #28
0ba14     F1 0E 0A FB | 	rdlong	arg01, objptr wz
0ba18     1C E2 85 F1 | 	sub	objptr, #28
0ba1c     01 F4 65 A6 |  if_e	neg	result1, #1
0ba20     2C 00 90 AD |  if_e	jmp	#LR__0731
0ba24                 | '         return getcf(__this);
0ba24     1C E2 05 F1 | 	add	objptr, #28
0ba28     F1 0E 02 FB | 	rdlong	arg01, objptr
0ba2c     1C E2 85 F1 | 	sub	objptr, #28
0ba30     07 19 02 FB | 	rdlong	local01, arg01
0ba34     04 0E 06 F1 | 	add	arg01, #4
0ba38     07 1B 02 FB | 	rdlong	local02, arg01
0ba3c     F1 0E 02 F6 | 	mov	arg01, objptr
0ba40     F1 1C 02 F6 | 	mov	local03, objptr
0ba44     0C E3 01 F6 | 	mov	objptr, local01
0ba48     2D 1A 62 FD | 	call	local02
0ba4c     0E E3 01 F6 | 	mov	objptr, local03
0ba50                 | LR__0731
0ba50     A8 F0 03 F6 | 	mov	ptra, fp
0ba54     B3 00 A0 FD | 	call	#popregs_
0ba58                 | __struct__s_vfs_file_t_getchar_ret
0ba58     2D 00 64 FD | 	ret
0ba5c                 | 
0ba5c                 | __struct___bas_wrap_sender_tx
0ba5c     03 4C 05 F6 | 	mov	COUNT_, #3
0ba60     A9 00 A0 FD | 	call	#pushregs_
0ba64     F1 18 02 FB | 	rdlong	local01, objptr
0ba68     0C 1B 02 FB | 	rdlong	local02, local01
0ba6c     04 18 06 F1 | 	add	local01, #4
0ba70     0C 19 02 FB | 	rdlong	local01, local01
0ba74     F1 1C 02 F6 | 	mov	local03, objptr
0ba78     0D E3 01 F6 | 	mov	objptr, local02
0ba7c     2D 18 62 FD | 	call	local01
0ba80     0E E3 01 F6 | 	mov	objptr, local03
0ba84     01 F4 05 F6 | 	mov	result1, #1
0ba88     A8 F0 03 F6 | 	mov	ptra, fp
0ba8c     B3 00 A0 FD | 	call	#popregs_
0ba90                 | __struct___bas_wrap_sender_tx_ret
0ba90     2D 00 64 FD | 	ret
0ba94                 | 
0ba94                 | LR__0732
0ba94     2F          | 	byte	"/"
0ba95     00          | 	byte	0
0ba96                 | LR__0733
0ba96     20 21 21 21 
0ba9a     20 63 6F 72 
0ba9e     72 75 70 74 
0baa2     65 64 20 68 
0baa6     65 61 70 3F 
0baaa     3F 3F 20 21 
0baae     21 21 20    | 	byte	" !!! corrupted heap??? !!! "
0bab1     00          | 	byte	0
0bab2                 | LR__0734
0bab2     20 21 21 21 
0bab6     20 6F 75 74 
0baba     20 6F 66 20 
0babe     68 65 61 70 
0bac2     20 6D 65 6D 
0bac6     6F 72 79 20 
0baca     21 21 21 20 | 	byte	" !!! out of heap memory !!! "
0bace     00          | 	byte	0
0bacf                 | LR__0735
0bacf     20 21 21 21 
0bad3     20 63 6F 72 
0bad7     72 75 70 74 
0badb     65 64 20 68 
0badf     65 61 70 20 
0bae3     21 21 21 20 | 	byte	" !!! corrupted heap !!! "
0bae7     00          | 	byte	0
0bae8                 | LR__0736
0bae8     00          | 	byte	0
0bae9     00          | 	byte	0
0baea                 | LR__0737
0baea     22 2A 3A 3C 
0baee     3E 3F 7C 7F | 	byte	34,"*:<>?|",127
0baf2     00          | 	byte	0
0baf3                 | LR__0738
0baf3     2B 2C 3B 3D 
0baf7     5B 5D       | 	byte	"+,;=[]"
0baf9     00          | 	byte	0
0bafa                 | LR__0739
0bafa     EB 76 90 45 
0bafe     58 46 41 54 
0bb02     20 20 20    | 	byte	-21,"v",-112,"EXFAT   "
0bb05     00          | 	byte	0
0bb06                 | LR__0740
0bb06     46 41 54    | 	byte	"FAT"
0bb09     00          | 	byte	0
0bb0a                 | LR__0741
0bb0a     46 41 54 33 
0bb0e     32          | 	byte	"FAT32"
0bb0f     00          | 	byte	0
0bb10                 | LR__0742
0bb10     2F 73 64    | 	byte	"/sd"
0bb13     00          | 	byte	0
0bb14                 | LR__0743
0bb14     2F 73 64 2F 
0bb18     73 69 64 2F 
0bb1c     73 65 6C 65 
0bb20     63 74 65 64 | 	byte	"/sd/sid/selected"
0bb24     00          | 	byte	0
0bb25                 | LR__0744
0bb25     2F 73 64 2F 
0bb29     73 69 64 2F 
0bb2d     73 65 6C 65 
0bb31     63 74 65 64 
0bb35     2F 62 69 6C 
0bb39     69 6E 73 6B 
0bb3d     69 2E 73 69 
0bb41     64          | 	byte	"/sd/sid/selected/bilinski.sid"
0bb42     00          | 	byte	0
0bb43     00          | 	alignl
0bb44                 | __system__dat_
0bb44     00 00 00 00 
0bb48     00 00 00 00 | 	byte	$00[8]
0bb4c     03 00 00 00 
0bb50     00 00 00 00 
0bb54     00 00 00 00 
0bb58     00 00 00 00 | 	byte	$03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
0bb5c     00 00 00 00 
      ...             
0bd8c     00 00 00 00 
0bd90     00 00 00 00 | 	byte	$00[568]
0bd94     05 00 00 00 
0bd98     00 00 00 00 
0bd9c     00 00 00 00 
0bda0     00 00 00 00 | 	byte	$05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
0bda4     6C BF 00 00 | 	long	@@@__system__dat_ + 1064
0bda8     74 BF 00 00 | 	long	@@@__system__dat_ + 1072
0bdac     00 00 00 00 | 	byte	$00, $00, $00, $00
0bdb0     7C BF 00 00 | 	long	@@@__system__dat_ + 1080
0bdb4     84 BF 00 00 | 	long	@@@__system__dat_ + 1088
0bdb8     00 00 00 00 
0bdbc     00 00 00 00 | 	byte	$00[8]
0bdc0     01 00 00 00 
0bdc4     06 00 00 00 
0bdc8     00 00 00 00 
0bdcc     00 00 00 00 | 	byte	$01, $00, $00, $00, $06, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
0bdd0     00 00 00 00 | 	byte	$00, $00, $00, $00
0bdd4     8C BF 00 00 | 	long	@@@__system__dat_ + 1096
0bdd8     94 BF 00 00 | 	long	@@@__system__dat_ + 1104
0bddc     00 00 00 00 | 	byte	$00, $00, $00, $00
0bde0     9C BF 00 00 | 	long	@@@__system__dat_ + 1112
0bde4     A4 BF 00 00 | 	long	@@@__system__dat_ + 1120
0bde8     00 00 00 00 
0bdec     00 00 00 00 | 	byte	$00[8]
0bdf0     01 00 00 00 
0bdf4     06 00 00 00 
0bdf8     00 00 00 00 
0bdfc     00 00 00 00 | 	byte	$01, $00, $00, $00, $06, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
0be00     00 00 00 00 | 	byte	$00, $00, $00, $00
0be04     AC BF 00 00 | 	long	@@@__system__dat_ + 1128
0be08     B4 BF 00 00 | 	long	@@@__system__dat_ + 1136
0be0c     00 00 00 00 | 	byte	$00, $00, $00, $00
0be10     BC BF 00 00 | 	long	@@@__system__dat_ + 1144
0be14     C4 BF 00 00 | 	long	@@@__system__dat_ + 1152
0be18     00 00 00 00 
      ...             
0bf68     00 00 00 00 
0bf6c     00 00 00 00 | 	byte	$00[344]
0bf70     7C 0B 00 00 | 	long	@@@__system___tx
0bf74     00 00 00 00 | 	byte	$00, $00, $00, $00
0bf78     BC 0B 00 00 | 	long	@@@__system___rx
0bf7c     00 00 00 00 | 	byte	$00, $00, $00, $00
0bf80     3C 31 00 00 | 	long	@@@__system___rxtxioctl_0135
0bf84     00 00 00 00 | 	byte	$00, $00, $00, $00
0bf88     AC 31 00 00 | 	long	@@@__system____dummy_flush_0136
0bf8c     00 00 00 00 | 	byte	$00, $00, $00, $00
0bf90     7C 0B 00 00 | 	long	@@@__system___tx
0bf94     00 00 00 00 | 	byte	$00, $00, $00, $00
0bf98     BC 0B 00 00 | 	long	@@@__system___rx
0bf9c     00 00 00 00 | 	byte	$00, $00, $00, $00
0bfa0     3C 31 00 00 | 	long	@@@__system___rxtxioctl_0135
0bfa4     00 00 00 00 | 	byte	$00, $00, $00, $00
0bfa8     AC 31 00 00 | 	long	@@@__system____dummy_flush_0136
0bfac     00 00 00 00 | 	byte	$00, $00, $00, $00
0bfb0     7C 0B 00 00 | 	long	@@@__system___tx
0bfb4     00 00 00 00 | 	byte	$00, $00, $00, $00
0bfb8     BC 0B 00 00 | 	long	@@@__system___rx
0bfbc     00 00 00 00 | 	byte	$00, $00, $00, $00
0bfc0     3C 31 00 00 | 	long	@@@__system___rxtxioctl_0135
0bfc4     00 00 00 00 | 	byte	$00, $00, $00, $00
0bfc8     AC 31 00 00 | 	long	@@@__system____dummy_flush_0136
0bfcc     00 00 00 00 
      ...             
0c1f8     00 00 00 00 
0c1fc     00 00 00 00 | 	byte	$00[564]
0c200                 | 	alignl
0c200                 | _ff_cc_dat_
0c200     00 00 00 00 
0c204     00 00       | 	byte	$00[6]
0c206     01 03 05 07 
0c20a     09 0E 10 12 
0c20e     14 16 18 1C 
0c212     1E 00 00 00 | 	byte	$01, $03, $05, $07, $09, $0e, $10, $12, $14, $16, $18, $1c, $1e, $00, $00, $00
0c216     00 00 00 00 
      ...             
0c40e     00 00 00 00 
0c412     00 00       | 	byte	$00[510]
0c414     43 55 45 41 
0c418     41 41 41 43 
0c41c     45 45 45 49 
0c420     49 49 41 41 | 	byte	$43, $55, $45, $41, $41, $41, $41, $43, $45, $45, $45, $49, $49, $49, $41, $41
0c424     45 92 92 4F 
0c428     4F 4F 55 55 
0c42c     59 4F 55 4F 
0c430     9C 4F 9E 9F | 	byte	$45, $92, $92, $4f, $4f, $4f, $55, $55, $59, $4f, $55, $4f, $9c, $4f, $9e, $9f
0c434     41 49 4F 55 
0c438     A5 A5 A6 A7 
0c43c     A8 A9 AA AB 
0c440     AC AD AE AF | 	byte	$41, $49, $4f, $55, $a5, $a5, $a6, $a7, $a8, $a9, $aa, $ab, $ac, $ad, $ae, $af
0c444     B0 B1 B2 B3 
0c448     B4 41 41 41 
0c44c     B8 B9 BA BB 
0c450     BC BD BE BF | 	byte	$b0, $b1, $b2, $b3, $b4, $41, $41, $41, $b8, $b9, $ba, $bb, $bc, $bd, $be, $bf
0c454     C0 C1 C2 C3 
0c458     C4 C5 41 41 
0c45c     C8 C9 CA CB 
0c460     CC CD CE CF | 	byte	$c0, $c1, $c2, $c3, $c4, $c5, $41, $41, $c8, $c9, $ca, $cb, $cc, $cd, $ce, $cf
0c464     D1 D1 45 45 
0c468     45 49 49 49 
0c46c     49 D9 DA DB 
0c470     DC DD 49 DF | 	byte	$d1, $d1, $45, $45, $45, $49, $49, $49, $49, $d9, $da, $db, $dc, $dd, $49, $df
0c474     4F E1 4F 4F 
0c478     4F 4F E6 E8 
0c47c     E8 55 55 55 
0c480     59 59 EE EF | 	byte	$4f, $e1, $4f, $4f, $4f, $4f, $e6, $e8, $e8, $55, $55, $55, $59, $59, $ee, $ef
0c484     F0 F1 F2 F3 
0c488     F4 F5 F6 F7 
0c48c     F8 F9 FA FB 
0c490     FC FD FE FF | 	byte	$f0, $f1, $f2, $f3, $f4, $f5, $f6, $f7, $f8, $f9, $fa, $fb, $fc, $fd, $fe, $ff
0c494     01 00 04 00 
0c498     10 00 40 00 
0c49c     00 01 00 02 
0c4a0     00 00 01 00 | 	byte	$01, $00, $04, $00, $10, $00, $40, $00, $00, $01, $00, $02, $00, $00, $01, $00
0c4a4     02 00 04 00 
0c4a8     08 00 10 00 
0c4ac     20 00 00 00 
0c4b0     07 00 00 00 | 	byte	$02, $00, $04, $00, $08, $00, $10, $00, $20, $00, $00, $00, $07, $00, $00, $00
0c4b4     00 00 00 00 
0c4b8     00 00 00 00 
0c4bc     00 00 00 00 
0c4c0     00 00 00 00 
0c4c4     00 00 00 00 
0c4c8     00 00 00 00 | 	byte	$00[24]
0c4cc     0C C5 00 00 | 	long	@@@_ff_cc_dat_ + 780
0c4d0     14 C5 00 00 | 	long	@@@_ff_cc_dat_ + 788
0c4d4     1C C5 00 00 | 	long	@@@_ff_cc_dat_ + 796
0c4d8     24 C5 00 00 | 	long	@@@_ff_cc_dat_ + 804
0c4dc     2C C5 00 00 | 	long	@@@_ff_cc_dat_ + 812
0c4e0     34 C5 00 00 | 	long	@@@_ff_cc_dat_ + 820
0c4e4     3C C5 00 00 | 	long	@@@_ff_cc_dat_ + 828
0c4e8     00 00 00 00 | 	byte	$00, $00, $00, $00
0c4ec     44 C5 00 00 | 	long	@@@_ff_cc_dat_ + 836
0c4f0     4C C5 00 00 | 	long	@@@_ff_cc_dat_ + 844
0c4f4     54 C5 00 00 | 	long	@@@_ff_cc_dat_ + 852
0c4f8     5C C5 00 00 | 	long	@@@_ff_cc_dat_ + 860
0c4fc     64 C5 00 00 | 	long	@@@_ff_cc_dat_ + 868
0c500     6C C5 00 00 | 	long	@@@_ff_cc_dat_ + 876
0c504     74 C5 00 00 | 	long	@@@_ff_cc_dat_ + 884
0c508     7C C5 00 00 | 	long	@@@_ff_cc_dat_ + 892
0c50c     00 00 00 00 | 	byte	$00, $00, $00, $00
0c510     90 B1 00 00 | 	long	@@@_ff_cc_v_open_0531
0c514     00 00 00 00 | 	byte	$00, $00, $00, $00
0c518     34 AA 00 00 | 	long	@@@_ff_cc_v_creat_0485
0c51c     00 00 00 00 | 	byte	$00, $00, $00, $00
0c520     D0 AA 00 00 | 	long	@@@_ff_cc_v_close_0488
0c524     00 00 00 00 | 	byte	$00, $00, $00, $00
0c528     C0 AE 00 00 | 	long	@@@_ff_cc_v_read_0513
0c52c     00 00 00 00 | 	byte	$00, $00, $00, $00
0c530     D4 AF 00 00 | 	long	@@@_ff_cc_v_write_0517
0c534     00 00 00 00 | 	byte	$00, $00, $00, $00
0c538     B4 B0 00 00 | 	long	@@@_ff_cc_v_lseek_0521
0c53c     00 00 00 00 | 	byte	$00, $00, $00, $00
0c540     3C B1 00 00 | 	long	@@@_ff_cc_v_ioctl
0c544     00 00 00 00 | 	byte	$00, $00, $00, $00
0c548     14 AB 00 00 | 	long	@@@_ff_cc_v_opendir_0491
0c54c     00 00 00 00 | 	byte	$00, $00, $00, $00
0c550     88 AB 00 00 | 	long	@@@_ff_cc_v_closedir_0494
0c554     00 00 00 00 | 	byte	$00, $00, $00, $00
0c558     C8 AB 00 00 | 	long	@@@_ff_cc_v_readdir_0497
0c55c     00 00 00 00 | 	byte	$00, $00, $00, $00
0c560     D0 AC 00 00 | 	long	@@@_ff_cc_v_stat_0509
0c564     00 00 00 00 | 	byte	$00, $00, $00, $00
0c568     50 B1 00 00 | 	long	@@@_ff_cc_v_mkdir
0c56c     00 00 00 00 | 	byte	$00, $00, $00, $00
0c570     70 B1 00 00 | 	long	@@@_ff_cc_v_rmdir_0525
0c574     00 00 00 00 | 	byte	$00, $00, $00, $00
0c578     60 B1 00 00 | 	long	@@@_ff_cc_v_remove
0c57c     00 00 00 00 | 	byte	$00, $00, $00, $00
0c580     80 B1 00 00 | 	long	@@@_ff_cc_v_rename_0527
0c584     C7 00 FC 00 
0c588     E9 00 E2 00 
0c58c     E4 00 E0 00 
0c590     E5 00 E7 00 | 	byte	$c7, $00, $fc, $00, $e9, $00, $e2, $00, $e4, $00, $e0, $00, $e5, $00, $e7, $00
0c594     EA 00 EB 00 
0c598     E8 00 EF 00 
0c59c     EE 00 EC 00 
0c5a0     C4 00 C5 00 | 	byte	$ea, $00, $eb, $00, $e8, $00, $ef, $00, $ee, $00, $ec, $00, $c4, $00, $c5, $00
0c5a4     C9 00 E6 00 
0c5a8     C6 00 F4 00 
0c5ac     F6 00 F2 00 
0c5b0     FB 00 F9 00 | 	byte	$c9, $00, $e6, $00, $c6, $00, $f4, $00, $f6, $00, $f2, $00, $fb, $00, $f9, $00
0c5b4     FF 00 D6 00 
0c5b8     DC 00 F8 00 
0c5bc     A3 00 D8 00 
0c5c0     D7 00 92 01 | 	byte	$ff, $00, $d6, $00, $dc, $00, $f8, $00, $a3, $00, $d8, $00, $d7, $00, $92, $01
0c5c4     E1 00 ED 00 
0c5c8     F3 00 FA 00 
0c5cc     F1 00 D1 00 
0c5d0     AA 00 BA 00 | 	byte	$e1, $00, $ed, $00, $f3, $00, $fa, $00, $f1, $00, $d1, $00, $aa, $00, $ba, $00
0c5d4     BF 00 AE 00 
0c5d8     AC 00 BD 00 
0c5dc     BC 00 A1 00 
0c5e0     AB 00 BB 00 | 	byte	$bf, $00, $ae, $00, $ac, $00, $bd, $00, $bc, $00, $a1, $00, $ab, $00, $bb, $00
0c5e4     91 25 92 25 
0c5e8     93 25 02 25 
0c5ec     24 25 C1 00 
0c5f0     C2 00 C0 00 | 	byte	$91, $25, $92, $25, $93, $25, $02, $25, $24, $25, $c1, $00, $c2, $00, $c0, $00
0c5f4     A9 00 63 25 
0c5f8     51 25 57 25 
0c5fc     5D 25 A2 00 
0c600     A5 00 10 25 | 	byte	$a9, $00, $63, $25, $51, $25, $57, $25, $5d, $25, $a2, $00, $a5, $00, $10, $25
0c604     14 25 34 25 
0c608     2C 25 1C 25 
0c60c     00 25 3C 25 
0c610     E3 00 C3 00 | 	byte	$14, $25, $34, $25, $2c, $25, $1c, $25, $00, $25, $3c, $25, $e3, $00, $c3, $00
0c614     5A 25 54 25 
0c618     69 25 66 25 
0c61c     60 25 50 25 
0c620     6C 25 A4 00 | 	byte	$5a, $25, $54, $25, $69, $25, $66, $25, $60, $25, $50, $25, $6c, $25, $a4, $00
0c624     F0 00 D0 00 
0c628     CA 00 CB 00 
0c62c     C8 00 31 01 
0c630     CD 00 CE 00 | 	byte	$f0, $00, $d0, $00, $ca, $00, $cb, $00, $c8, $00, $31, $01, $cd, $00, $ce, $00
0c634     CF 00 18 25 
0c638     0C 25 88 25 
0c63c     84 25 A6 00 
0c640     CC 00 80 25 | 	byte	$cf, $00, $18, $25, $0c, $25, $88, $25, $84, $25, $a6, $00, $cc, $00, $80, $25
0c644     D3 00 DF 00 
0c648     D4 00 D2 00 
0c64c     F5 00 D5 00 
0c650     B5 00 FE 00 | 	byte	$d3, $00, $df, $00, $d4, $00, $d2, $00, $f5, $00, $d5, $00, $b5, $00, $fe, $00
0c654     DE 00 DA 00 
0c658     DB 00 D9 00 
0c65c     FD 00 DD 00 
0c660     AF 00 B4 00 | 	byte	$de, $00, $da, $00, $db, $00, $d9, $00, $fd, $00, $dd, $00, $af, $00, $b4, $00
0c664     AD 00 B1 00 
0c668     17 20 BE 00 
0c66c     B6 00 A7 00 
0c670     F7 00 B8 00 | 	byte	$ad, $00, $b1, $00, $17, $20, $be, $00, $b6, $00, $a7, $00, $f7, $00, $b8, $00
0c674     B0 00 A8 00 
0c678     B7 00 B9 00 
0c67c     B3 00 B2 00 
0c680     A0 25 A0 00 | 	byte	$b0, $00, $a8, $00, $b7, $00, $b9, $00, $b3, $00, $b2, $00, $a0, $25, $a0, $00
0c684     61 00 1A 03 
0c688     E0 00 17 03 
0c68c     F8 00 07 03 
0c690     FF 00 01 00 | 	byte	$61, $00, $1a, $03, $e0, $00, $17, $03, $f8, $00, $07, $03, $ff, $00, $01, $00
0c694     78 01 00 01 
0c698     30 01 32 01 
0c69c     06 01 39 01 
0c6a0     10 01 4A 01 | 	byte	$78, $01, $00, $01, $30, $01, $32, $01, $06, $01, $39, $01, $10, $01, $4a, $01
0c6a4     2E 01 79 01 
0c6a8     06 01 80 01 
0c6ac     4D 00 43 02 
0c6b0     81 01 82 01 | 	byte	$2e, $01, $79, $01, $06, $01, $80, $01, $4d, $00, $43, $02, $81, $01, $82, $01
0c6b4     82 01 84 01 
0c6b8     84 01 86 01 
0c6bc     87 01 87 01 
0c6c0     89 01 8A 01 | 	byte	$82, $01, $84, $01, $84, $01, $86, $01, $87, $01, $87, $01, $89, $01, $8a, $01
0c6c4     8B 01 8B 01 
0c6c8     8D 01 8E 01 
0c6cc     8F 01 90 01 
0c6d0     91 01 91 01 | 	byte	$8b, $01, $8b, $01, $8d, $01, $8e, $01, $8f, $01, $90, $01, $91, $01, $91, $01
0c6d4     93 01 94 01 
0c6d8     F6 01 96 01 
0c6dc     97 01 98 01 
0c6e0     98 01 3D 02 | 	byte	$93, $01, $94, $01, $f6, $01, $96, $01, $97, $01, $98, $01, $98, $01, $3d, $02
0c6e4     9B 01 9C 01 
0c6e8     9D 01 20 02 
0c6ec     9F 01 A0 01 
0c6f0     A0 01 A2 01 | 	byte	$9b, $01, $9c, $01, $9d, $01, $20, $02, $9f, $01, $a0, $01, $a0, $01, $a2, $01
0c6f4     A2 01 A4 01 
0c6f8     A4 01 A6 01 
0c6fc     A7 01 A7 01 
0c700     A9 01 AA 01 | 	byte	$a2, $01, $a4, $01, $a4, $01, $a6, $01, $a7, $01, $a7, $01, $a9, $01, $aa, $01
0c704     AB 01 AC 01 
0c708     AC 01 AE 01 
0c70c     AF 01 AF 01 
0c710     B1 01 B2 01 | 	byte	$ab, $01, $ac, $01, $ac, $01, $ae, $01, $af, $01, $af, $01, $b1, $01, $b2, $01
0c714     B3 01 B3 01 
0c718     B5 01 B5 01 
0c71c     B7 01 B8 01 
0c720     B8 01 BA 01 | 	byte	$b3, $01, $b3, $01, $b5, $01, $b5, $01, $b7, $01, $b8, $01, $b8, $01, $ba, $01
0c724     BB 01 BC 01 
0c728     BC 01 BE 01 
0c72c     F7 01 C0 01 
0c730     C1 01 C2 01 | 	byte	$bb, $01, $bc, $01, $bc, $01, $be, $01, $f7, $01, $c0, $01, $c1, $01, $c2, $01
0c734     C3 01 C4 01 
0c738     C5 01 C4 01 
0c73c     C7 01 C8 01 
0c740     C7 01 CA 01 | 	byte	$c3, $01, $c4, $01, $c5, $01, $c4, $01, $c7, $01, $c8, $01, $c7, $01, $ca, $01
0c744     CB 01 CA 01 
0c748     CD 01 10 01 
0c74c     DD 01 01 00 
0c750     8E 01 DE 01 | 	byte	$cb, $01, $ca, $01, $cd, $01, $10, $01, $dd, $01, $01, $00, $8e, $01, $de, $01
0c754     12 01 F3 01 
0c758     03 00 F1 01 
0c75c     F4 01 F4 01 
0c760     F8 01 28 01 | 	byte	$12, $01, $f3, $01, $03, $00, $f1, $01, $f4, $01, $f4, $01, $f8, $01, $28, $01
0c764     22 02 12 01 
0c768     3A 02 09 00 
0c76c     65 2C 3B 02 
0c770     3B 02 3D 02 | 	byte	$22, $02, $12, $01, $3a, $02, $09, $00, $65, $2c, $3b, $02, $3b, $02, $3d, $02
0c774     66 2C 3F 02 
0c778     40 02 41 02 
0c77c     41 02 46 02 
0c780     0A 01 53 02 | 	byte	$66, $2c, $3f, $02, $40, $02, $41, $02, $41, $02, $46, $02, $0a, $01, $53, $02
0c784     40 00 81 01 
0c788     86 01 55 02 
0c78c     89 01 8A 01 
0c790     58 02 8F 01 | 	byte	$40, $00, $81, $01, $86, $01, $55, $02, $89, $01, $8a, $01, $58, $02, $8f, $01
0c794     5A 02 90 01 
0c798     5C 02 5D 02 
0c79c     5E 02 5F 02 
0c7a0     93 01 61 02 | 	byte	$5a, $02, $90, $01, $5c, $02, $5d, $02, $5e, $02, $5f, $02, $93, $01, $61, $02
0c7a4     62 02 94 01 
0c7a8     64 02 65 02 
0c7ac     66 02 67 02 
0c7b0     97 01 96 01 | 	byte	$62, $02, $94, $01, $64, $02, $65, $02, $66, $02, $67, $02, $97, $01, $96, $01
0c7b4     6A 02 62 2C 
0c7b8     6C 02 6D 02 
0c7bc     6E 02 9C 01 
0c7c0     70 02 71 02 | 	byte	$6a, $02, $62, $2c, $6c, $02, $6d, $02, $6e, $02, $9c, $01, $70, $02, $71, $02
0c7c4     9D 01 73 02 
0c7c8     74 02 9F 01 
0c7cc     76 02 77 02 
0c7d0     78 02 79 02 | 	byte	$9d, $01, $73, $02, $74, $02, $9f, $01, $76, $02, $77, $02, $78, $02, $79, $02
0c7d4     7A 02 7B 02 
0c7d8     7C 02 64 2C 
0c7dc     7E 02 7F 02 
0c7e0     A6 01 81 02 | 	byte	$7a, $02, $7b, $02, $7c, $02, $64, $2c, $7e, $02, $7f, $02, $a6, $01, $81, $02
0c7e4     82 02 A9 01 
0c7e8     84 02 85 02 
0c7ec     86 02 87 02 
0c7f0     AE 01 44 02 | 	byte	$82, $02, $a9, $01, $84, $02, $85, $02, $86, $02, $87, $02, $ae, $01, $44, $02
0c7f4     B1 01 B2 01 
0c7f8     45 02 8D 02 
0c7fc     8E 02 8F 02 
0c800     90 02 91 02 | 	byte	$b1, $01, $b2, $01, $45, $02, $8d, $02, $8e, $02, $8f, $02, $90, $02, $91, $02
0c804     B7 01 7B 03 
0c808     03 00 FD 03 
0c80c     FE 03 FF 03 
0c810     AC 03 04 00 | 	byte	$b7, $01, $7b, $03, $03, $00, $fd, $03, $fe, $03, $ff, $03, $ac, $03, $04, $00
0c814     86 03 88 03 
0c818     89 03 8A 03 
0c81c     B1 03 11 03 
0c820     C2 03 02 00 | 	byte	$86, $03, $88, $03, $89, $03, $8a, $03, $b1, $03, $11, $03, $c2, $03, $02, $00
0c824     A3 03 A3 03 
0c828     C4 03 08 03 
0c82c     CC 03 03 00 
0c830     8C 03 8E 03 | 	byte	$a3, $03, $a3, $03, $c4, $03, $08, $03, $cc, $03, $03, $00, $8c, $03, $8e, $03
0c834     8F 03 D8 03 
0c838     18 01 F2 03 
0c83c     0A 00 F9 03 
0c840     F3 03 F4 03 | 	byte	$8f, $03, $d8, $03, $18, $01, $f2, $03, $0a, $00, $f9, $03, $f3, $03, $f4, $03
0c844     F5 03 F6 03 
0c848     F7 03 F7 03 
0c84c     F9 03 FA 03 
0c850     FA 03 30 04 | 	byte	$f5, $03, $f6, $03, $f7, $03, $f7, $03, $f9, $03, $fa, $03, $fa, $03, $30, $04
0c854     20 03 50 04 
0c858     10 07 60 04 
0c85c     22 01 8A 04 
0c860     36 01 C1 04 | 	byte	$20, $03, $50, $04, $10, $07, $60, $04, $22, $01, $8a, $04, $36, $01, $c1, $04
0c864     0E 01 CF 04 
0c868     01 00 C0 04 
0c86c     D0 04 44 01 
0c870     61 05 26 04 | 	byte	$0e, $01, $cf, $04, $01, $00, $c0, $04, $d0, $04, $44, $01, $61, $05, $26, $04
0c874     00 00 7D 1D 
0c878     01 00 63 2C 
0c87c     00 1E 96 01 
0c880     A0 1E 5A 01 | 	byte	$00, $00, $7d, $1d, $01, $00, $63, $2c, $00, $1e, $96, $01, $a0, $1e, $5a, $01
0c884     00 1F 08 06 
0c888     10 1F 06 06 
0c88c     20 1F 08 06 
0c890     30 1F 08 06 | 	byte	$00, $1f, $08, $06, $10, $1f, $06, $06, $20, $1f, $08, $06, $30, $1f, $08, $06
0c894     40 1F 06 06 
0c898     51 1F 07 00 
0c89c     59 1F 52 1F 
0c8a0     5B 1F 54 1F | 	byte	$40, $1f, $06, $06, $51, $1f, $07, $00, $59, $1f, $52, $1f, $5b, $1f, $54, $1f
0c8a4     5D 1F 56 1F 
0c8a8     5F 1F 60 1F 
0c8ac     08 06 70 1F 
0c8b0     0E 00 BA 1F | 	byte	$5d, $1f, $56, $1f, $5f, $1f, $60, $1f, $08, $06, $70, $1f, $0e, $00, $ba, $1f
0c8b4     BB 1F C8 1F 
0c8b8     C9 1F CA 1F 
0c8bc     CB 1F DA 1F 
0c8c0     DB 1F F8 1F | 	byte	$bb, $1f, $c8, $1f, $c9, $1f, $ca, $1f, $cb, $1f, $da, $1f, $db, $1f, $f8, $1f
0c8c4     F9 1F EA 1F 
0c8c8     EB 1F FA 1F 
0c8cc     FB 1F 80 1F 
0c8d0     08 06 90 1F | 	byte	$f9, $1f, $ea, $1f, $eb, $1f, $fa, $1f, $fb, $1f, $80, $1f, $08, $06, $90, $1f
0c8d4     08 06 A0 1F 
0c8d8     08 06 B0 1F 
0c8dc     04 00 B8 1F 
0c8e0     B9 1F B2 1F | 	byte	$08, $06, $a0, $1f, $08, $06, $b0, $1f, $04, $00, $b8, $1f, $b9, $1f, $b2, $1f
0c8e4     BC 1F CC 1F 
0c8e8     01 00 C3 1F 
0c8ec     D0 1F 02 06 
0c8f0     E0 1F 02 06 | 	byte	$bc, $1f, $cc, $1f, $01, $00, $c3, $1f, $d0, $1f, $02, $06, $e0, $1f, $02, $06
0c8f4     E5 1F 01 00 
0c8f8     EC 1F F3 1F 
0c8fc     01 00 FC 1F 
0c900     4E 21 01 00 | 	byte	$e5, $1f, $01, $00, $ec, $1f, $f3, $1f, $01, $00, $fc, $1f, $4e, $21, $01, $00
0c904     32 21 70 21 
0c908     10 02 84 21 
0c90c     01 00 83 21 
0c910     D0 24 1A 05 | 	byte	$32, $21, $70, $21, $10, $02, $84, $21, $01, $00, $83, $21, $d0, $24, $1a, $05
0c914     30 2C 2F 04 
0c918     60 2C 02 01 
0c91c     67 2C 06 01 
0c920     75 2C 02 01 | 	byte	$30, $2c, $2f, $04, $60, $2c, $02, $01, $67, $2c, $06, $01, $75, $2c, $02, $01
0c924     80 2C 64 01 
0c928     00 2D 26 08 
0c92c     41 FF 1A 03 
0c930     00 00 00 00 | 	byte	$80, $2c, $64, $01, $00, $2d, $26, $08, $41, $ff, $1a, $03, $00, $00, $00, $00
0c934     00 00 00 00 
0c938     00 00 00 00 
0c93c     00 00 00 00 
0c940     00 00 00 00 | 	byte	$00[16]
0c944     01 00 00 00 | 	byte	$01, $00, $00, $00
0c948                 | __heap_base
0c948     00 00 00 00 
      ...             
0d948     00 00 00 00 
0d94c     00 00 00 00 | 	long	0[1026]
0d950                 | objmem
0d950     00 00 00 00 
0d954     00 00 00 00 
0d958     00 00 00 00 | 	long	0[3]
0d95c                 | stackspace
0d95c     00 00 00 00 | 	long	0[1]
0d960 0fc             | 	org	COG_BSS_START
0d960 0fc             | _var01
0d960 0fc             | 	res	1
0d960 0fd             | _var02
0d960 0fd             | 	res	1
0d960 0fe             | _var03
0d960 0fe             | 	res	1
0d960 0ff             | _var04
0d960 0ff             | 	res	1
0d960 100             | _var05
0d960 100             | 	res	1
0d960 101             | _var06
0d960 101             | 	res	1
0d960 102             | _var07
0d960 102             | 	res	1
0d960 103             | _var08
0d960 103             | 	res	1
0d960 104             | _var09
0d960 104             | 	res	1
0d960 105             | _var10
0d960 105             | 	res	1
0d960 106             | _var11
0d960 106             | 	res	1
0d960 107             | arg01
0d960 107             | 	res	1
0d960 108             | arg02
0d960 108             | 	res	1
0d960 109             | arg03
0d960 109             | 	res	1
0d960 10a             | arg04
0d960 10a             | 	res	1
0d960 10b             | arg05
0d960 10b             | 	res	1
0d960 10c             | local01
0d960 10c             | 	res	1
0d960 10d             | local02
0d960 10d             | 	res	1
0d960 10e             | local03
0d960 10e             | 	res	1
0d960 10f             | local04
0d960 10f             | 	res	1
0d960 110             | local05
0d960 110             | 	res	1
0d960 111             | local06
0d960 111             | 	res	1
0d960 112             | local07
0d960 112             | 	res	1
0d960 113             | local08
0d960 113             | 	res	1
0d960 114             | local09
0d960 114             | 	res	1
0d960 115             | local10
0d960 115             | 	res	1
0d960 116             | local11
0d960 116             | 	res	1
0d960 117             | local12
0d960 117             | 	res	1
0d960 118             | local13
0d960 118             | 	res	1
0d960 119             | local14
0d960 119             | 	res	1
0d960 11a             | local15
0d960 11a             | 	res	1
0d960 11b             | local16
0d960 11b             | 	res	1
0d960 11c             | local17
0d960 11c             | 	res	1
0d960 11d             | local18
0d960 11d             | 	res	1
0d960 11e             | local19
0d960 11e             | 	res	1
0d960 11f             | local20
0d960 11f             | 	res	1
0d960 120             | local21
0d960 120             | 	res	1
0d960 121             | local22
0d960 121             | 	res	1
0d960 122             | local23
0d960 122             | 	res	1
0d960 123             | local24
0d960 123             | 	res	1
0d960 124             | local25
0d960 124             | 	res	1
0d960 125             | local26
0d960 125             | 	res	1
0d960 126             | local27
0d960 126             | 	res	1
0d960 127             | local28
0d960 127             | 	res	1
0d960 128             | local29
0d960 128             | 	res	1
0d960 129             | local30
0d960 129             | 	res	1
0d960 12a             | local31
0d960 12a             | 	res	1
0d960 12b             | local32
0d960 12b             | 	res	1
0d960 12c             | local33
0d960 12c             | 	res	1
0d960 12d             | local34
0d960 12d             | 	res	1
0d960 12e             | local35
0d960 12e             | 	res	1
0d960 12f             | local36
0d960 12f             | 	res	1
0d960 130             | local37
0d960 130             | 	res	1
0d960 131             | local38
0d960 131             | 	res	1
0d960 132             | local39
0d960 132             | 	res	1
0d960 133             | local40
0d960 133             | 	res	1
0d960 134             | local41
0d960 134             | 	res	1
0d960 135             | local42
0d960 135             | 	res	1
0d960 136             | muldiva_
0d960 136             | 	res	1
0d960 137             | muldivb_
0d960 137             | 	res	1
0d960 138             | 	fit	480
0d960 138             | 
