############################
##### Deepsikha Behera #####
#####     20CS10023    #####
## Compilers Assignment 1 ##
############################

	.file	"asgn1.c"										/*name of the source file*/
	.text													# beginning of code segment
	.section	.rodata										# indicates "read-only" data, if any application attempts to write into it, it'll trigger an exception
	.align 8												# aligned with 8-byte boundary
.LC0:														# constant string labels used in the code
	.string	"Enter the string (all lowrer case): "			# first prompt label to enter input
.LC1:
	.string	"%s"											# label to tak+
	
	e in the input string
.LC2:
	.string	"Length of the string: %d\n"					# label to print out the length of the input string
	.align 8												# aligned with 8-byte boundary
.LC3:
	.string	"The string in descending order: %s\n"			# label to print out the input string in descending order
	.text													# beginning of code segment
	.globl	main											# main is a global name
	.type	main, @function									# main is a function
main:														# main
.LFB0:
.cfi_startproc												# call frame information
	endbr64													# end branch 64bit
	pushq	%rbp											# push old base pointer onto stack
	.cfi_def_cfa_offset 16									
	.cfi_offset 6, -16										
	movq	%rsp, %rbp										# set new stack pointer (rbp<--rsp)
	.cfi_def_cfa_register 6
	subq	$80, %rsp										# allocate stack space of 80 bytes to store variables
	movq	%fs:40, %rax									# access value of %fs:40 and store it in %rax
	movq	%rax, -8(%rbp)									# (rbp - 8) <-- rax; move address of rax to (rbp - 8)
	xorl	%eax, %eax										#  eax = 0
	leaq	.LC0(%rip), %rdi								# load address of .LC0 into %rdi
	movl	$0, %eax										#  eax = 0
	call	printf@PLT										# print the first prompt LC0 (system function printf called)
	leaq	-64(%rbp), %rax									# load address (%rbp-64) into %rax
	movq	%rax, %rsi										# rsi <-- rax
	leaq	.LC1(%rip), %rdi								# copy address of LC1("%s") to store input variable in %rdi
	movl	$0, %eax										# load 0 to %eax
	call	__isoc99_scanf@PLT								# system function scanf called
	leaq	-64(%rbp), %rax									# load address (%rbp-64) into %rax
	movq	%rax, %rdi										# moving the input value from %rax to %rdi to be used as 1st argument in function length below
	call	length											# length function called
	movl	%eax, -68(%rbp)									# (rbp - 68) <-- eax
	movl	-68(%rbp), %eax									# eax <-- (rbp - 68)
	movl	%eax, %esi										# esi <-- eax, move return value from length function call (line 40) to eax
	leaq	.LC2(%rip), %rdi								# load address of string .LC2 into rdi, first argument to printf function
	movl	$0, %eax										# eax = 0
	call	printf@PLT										# system function printf called
	leaq	-32(%rbp), %rdx									# load address (%rbp-32) into %rdx (3rd argument)
	movl	-68(%rbp), %ecx									# move (%rbp-68) (length of string) to %ecx (4th argument)
	leaq	-64(%rbp), %rax									# load address (%rbp-64) into %rax (return val from a function)
	movl	%ecx, %esi										# ecx <-- esi (moving 4th argument(length of string) to 2nd for the sort function below)
	movq	%rax, %rdi										# rsi <-- rax (moving return value from length function as 1st argument for the sort function below)
	call	sort											# sort function called
	leaq	-32(%rbp), %rax									# load address (%rbp - 32) into rax
	movq	%rax, %rsi										# rsi <-- rax
	leaq	.LC3(%rip), %rdi								# load address of string .LC3 into rdi, first argument to printf function
	movl	$0, %eax										# eax = 0
	call	printf@PLT										# system fucntion printf called
	movl	$0, %eax										# eax = 0
	movq	-8(%rbp), %rcx									# rcx <-- (rbp - 8)
	xorq	%fs:40, %rcx									# compare rcx with canary 
	je	.L3													# if equal, jump to .L3 
	call	__stack_chk_fail@PLT
.L3:
	leave
	.cfi_def_cfa 7, 8
	ret														# return
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.globl	length											# length is a global name
	.type	length, @function								# length is a function
length:														# length function starts
.LFB1:
	.cfi_startproc											# call frame information
	endbr64													# end branch 64bit
	pushq	%rbp											# push old base pointer onto stack
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp										# set new stack pointer (rbp<--rsp)
	.cfi_def_cfa_register 6									
	movq	%rdi, -24(%rbp)									# (rbp-24) <-- rdi; store the argument passed to the function, i.e., input string via .LC1
	movl	$0, -4(%rbp)									#  (rbp-4) = 0 (length counter (i) set to 0)
	jmp	.L5													# run for loop described in L5
.L6:
	addl	$1, -4(%rbp)									# (rbp - 4)+=1; (increment i)
.L5:
	movl	-4(%rbp), %eax									# eax <--(rbp - 4) (store i in eax)
	movslq	%eax, %rdx										# moves and saves value stored in eax in 32 bits to rdx in 64 bits
	movq	-24(%rbp), %rax									# eax <-- (rbp - 24); moving the argument (input string) to eax
	addq	%rdx, %rax										# rax = rax + rdx
	movzbl	(%rax), %eax									# the low 8 bits of eax are replaced by rax, top 24 bits set to 0 
	testb	%al, %al										# sets zero flag if al&al=0 (al is the least significant bits of eax)					
	jne	.L6													# if the above zero flag!=0, jump to .L6
	movl	-4(%rbp), %eax									# eax <-- (rbp - 4); value of length counter (i)
	popq	%rbp											# pop base pointer
	.cfi_def_cfa 7, 8
	ret														# return
	.cfi_endproc
.LFE1:
	.size	length, .-length
	.globl	sort											# sort is a global name
	.type	sort, @function									# sort is a function
sort:														# sort function starts
.LFB2:
	.cfi_startproc											# call frame information
	endbr64													# end branch 64bit
	pushq	%rbp											# push old base pointer onto stack
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp										# set new stack pointer (rbp<--rsp)
	.cfi_def_cfa_register 6
	subq	$48, %rsp										# create space for local variables in the function
	movq	%rdi, -24(%rbp)									# (rbp-24) <-- rdi (to save the first argumeent passed into this function - input string)
	movl	%esi, -28(%rbp)									# (rbp-28) <-- esi (to save the second argumeent passed into this function - length of input string)
	movq	%rdx, -40(%rbp)									# (rbp-40) <-- rdx (to save the third argumeent passed into this function - destination string array)
	movl	$0, -8(%rbp)									# (rbp - 8) = 0; iterator (i) for loop  .L9
	jmp	.L9													# jump to loop in .L9
.L13:
	movl	$0, -4(%rbp)									# (rbp - 4) = 0; iterator (j) for nested for loop .L10
	jmp	.L10												# jump to loop in .L10
.L12:
	movl	-8(%rbp), %eax									# eax <-- (rbp - 8); copy value of iterator i to eax
	movslq	%eax, %rdx										# moves and saves value stored in eax in 32 bits to rdx in 64 bits
	movq	-24(%rbp), %rax									# rax <-- (rbp - 24); move the input string parameter to rax
	addq	%rdx, %rax										# rax = rax + rdx
	movzbl	(%rax), %edx									# the low 8 bits of edx are replaced by rax, top 24 bits set to 0
	movl	-4(%rbp), %eax									# eax <-- (rbp - 4); moving iterator j to eax
	movslq	%eax, %rcx										# moves and saves value stored in eax in 32 bits to rcx in 64 bits
	movq	-24(%rbp), %rax									# rax <-- (rbp - 24); move the input string parameter to rax
	addq	%rcx, %rax										# rax = rax + rcx
	movzbl	(%rax), %eax									# the low 8 bits of eax are replaced by rax, top 24 bits set to 0
	cmpb	%al, %dl										# compare al and dl (the low 8 bits of eax and rdx respectively)
	jge	.L11												# if dl >= al, jump to .L11
	movl	-8(%rbp), %eax									# eax <-- (rbp - 8); copy value of iterator i to eax
	movslq	%eax, %rdx										# moves and saves value stored in eax in 32 bits to rdx in 64 bits
	movq	-24(%rbp), %rax									# rax <-- (rbp - 24); move the input string parameter to rax
	addq	%rdx, %rax										# rax = rax + rdx
	movzbl	(%rax), %eax									# the low 8 bits of eax are replaced by rax, top 24 bits set to 0
	movb	%al, -9(%rbp)									# (rbp-9) <-- al; the low 8 bits of eax are moved to (rbp-9)
	movl	-4(%rbp), %eax									# eax <-- (rbp - 4); moving iterator j to eax
	movslq	%eax, %rdx										# moves and saves value stored in eax in 32 bits to rdx in 64 bits
	movq	-24(%rbp), %rax									# rax <-- (rbp - 24); move the input string parameter to rax
	addq	%rdx, %rax										# rax = rax + rdx 
	movl	-8(%rbp), %edx									# edx <-- (rbp - 8); move iterator i to edx
	movslq	%edx, %rcx										# moves and saves value stored in edx in 32 bits to rcx in 64 bits
	movq	-24(%rbp), %rdx									# rdx <-- (rbp - 24); move the input string parameter to rdx
	addq	%rcx, %rdx										# rdx = rdx + rcx
	movzbl	(%rax), %eax									# the low 8 bits of eax are replaced by rax, top 24 bits set to 0
	movb	%al, (%rdx)										# rdx <-- al; the low 8 bits of eax are moved to rdx
	movl	-4(%rbp), %eax									# eax <-- (rbp - 4); move the iterator j to eax
	movslq	%eax, %rdx										# moves and saves value stored in eax in 32 bits to rdx in 64 bits
	movq	-24(%rbp), %rax									# rax <-- (rbp - 24); move the input string parameter to rax
	addq	%rax, %rdx										# rdx = rdx + rax
	movzbl	-9(%rbp), %eax									# the low 8 bits of eax are replaced by (rbp - 9), top 24 bits set to 0
	movb	%al, (%rdx)										# rdx <-- al; move the 8 low bits of eax to rdx
.L11:
	addl	$1, -4(%rbp)									# increment iterator j at the end of each nested loop
.L10:
	movl	-4(%rbp), %eax									# eax <-- (rbp - 4), copy value of iterator j to eax
	cmpl	-28(%rbp), %eax									# compare length of string (rbp - 28) and iterator j (eax)
	jl	.L12												# if j < length of string, jump to .L12
	addl	$1, -8(%rbp)									# increment iterator i at the end of each loop
.L9:
	movl	-8(%rbp), %eax									# eax <-- (rbp - 8); copying iterator i to eax
	cmpl	-28(%rbp), %eax									# compares (%rbp-28) and %eax, i.e., length of the string and iterator i
	jl	.L13												# if i < length of string then jump to .L13
	movq	-40(%rbp), %rdx									# rdx <-- (rbp - 40); move the 3rd parameter (destination string array) to rdx (3rd parameter of reverse function)
	movl	-28(%rbp), %ecx									# ecx <-- (rbp - 28); move the 2nd input parameter (length of the input string array) to ecx (2nd parameter of reverse function)
	movq	-24(%rbp), %rax									# rax <-- (rbp - 24); move the 1st input parameter (input string array) to rax (1st parameter of reverse function)
	movl	%ecx, %esi										# esi <-- ecx (move length of string to esi)
	movq	%rax, %rdi										# rdi <-- rax (move input string to edi)
	call	reverse											# reverse function called
	nop														
	leave													 
	.cfi_def_cfa 7, 8
	ret														# return
	.cfi_endproc
.LFE2:
	.size	sort, .-sort
	.globl	reverse											# reverse is a global name
	.type	reverse, @function								# reverse is a function
reverse:													# reverse function starts
.LFB3:
	.cfi_startproc											# call frame information
	endbr64													# end branch 64bit
	pushq	%rbp											# push old base pointer onto stack
	.cfi_def_cfa_offset 16									
	.cfi_offset 6, -16										
	movq	%rsp, %rbp										# set new stack pointer (rbp<--rsp)
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)									# (rbp-24) <-- rdi (to save the first argumeent passed into this function - input string)
	movl	%esi, -28(%rbp)									# (rbp-28) <-- esi (to save the second argumeent passed into this function - length of input string)
	movq	%rdx, -40(%rbp)									# (rbp-40) <-- rdx (to save the third argumeent passed into this function - destination string array)
	movl	$0, -8(%rbp)									# (rbp - 8) = 0, iterator i
	jmp	.L15												# jump to loop in .L15
.L20:
	movl	-28(%rbp), %eax									# eax <-- (rbp - 28); copy length of input string to eax          
	subl	-8(%rbp), %eax									# eax = eax - (rbp - 8)
	subl	$1, %eax										# eax = eax - 1
	movl	%eax, -4(%rbp)									# (rbp - 4) <-- eax; iterator j = len - i - 1; j is the iterator for the nested loop
	nop
	movl	-28(%rbp), %eax									# eax <-- (rbp - 28); copy length of input string to eax
	movl	%eax, %edx										# edx <-- eax
	shrl	$31, %edx										# logical right shift by 31 bits
	addl	%edx, %eax										# eax <-- edx
	sarl	%eax											# arithmetic right shift by 1 bit
	cmpl	%eax, -4(%rbp)									# compare eax (len/2) with (rbp - 4) (iterator j)
	jl	.L18												# if (rbp - 4) < eax, jump to .L18
	movl	-8(%rbp), %eax									# eax <-- (rbp - 8); copy iterator i to eax 
	cmpl	-4(%rbp), %eax									# compare eax and (rbp - 4); the two iterators - i and j
	je	.L23												# if eax == (rbp - 4), jump to .L23
	movl	-8(%rbp), %eax									# eax <-- (rbp - 8); copy iterator i to eax
	movslq	%eax, %rdx										# moves and saves value stored in eax in 32 bits to rdx in 64 bits
	movq	-24(%rbp), %rax									# rax <-- (rbp - 24); move the input string parameter to rax
	addq	%rdx, %rax										# rax = rax + rdx
	movzbl	(%rax), %eax									# the low 8 bits of eax are replaced by rax, top 24 bits set to 0
	movb	%al, -9(%rbp)									# (rbp-9) <-- al; the low 8 bits of eax are moved to (rbp-9)
	movl	-4(%rbp), %eax									# eax <-- (rbp - 4); copy iterator j to eax
	movslq	%eax, %rdx										# moves and saves value stored in eax in 32 bits to rdx in 64 bits
	movq	-24(%rbp), %rax									# rax <-- (rbp - 24); move the input string parameter to rax
	addq	%rdx, %rax										# rax = rax + rdx
	movl	-8(%rbp), %edx									# edx <-- (rbp - 8); copy iterator i to edx 
	movslq	%edx, %rcx										# moves and saves value stored in edx in 32 bits to rcx in 64 bits
	movq	-24(%rbp), %rdx									# rdx <-- (rbp - 24); move input string to rdx
	addq	%rcx, %rdx										# rdx = rdx + rcx
	movzbl	(%rax), %eax									# the low 8 bits of eax are replaced by rax, top 24 bits set to 0
	movb	%al, (%rdx)										# rdx <-- al; the low 8 bits of eax are moved to rdx
	movl	-4(%rbp), %eax									# eax <-- (rbp - 4); move iterator j to eax
	movslq	%eax, %rdx										# moves and saves value stored in eax in 32 bits to rdx in 64 bits
	movq	-24(%rbp), %rax									# rax <-- (rbp - 24); move the input string parameter to rax
	addq	%rax, %rdx										# rdx = rdx + rax
	movzbl	-9(%rbp), %eax									# the low 8 bits of eax are replaced by (rbp - 9), top 24 bits set to 0
	movb	%al, (%rdx)										# rdx <-- al; the low 8 bits of eax are moved to rdx
	jmp	.L18
.L23:
	nop
.L18:
	addl	$1, -8(%rbp)									# increment iterator i
.L15:
	movl	-28(%rbp), %eax									# eax <-- (rbp - 28); copy length of input string to eax          
	movl	%eax, %edx										# edx <-- eax
	shrl	$31, %edx										# logical right shift by 31 bits
	addl	%edx, %eax										# eax = eax + edx
	sarl	%eax											# arithmetic right shift by 1 bit
	cmpl	%eax, -8(%rbp)									# compare eax and (rbp - 8) (iterator i)
	jl	.L20												# if (rbp - 8) < eax, jump to .L20
	movl	$0, -8(%rbp)									# (rbp - 8) = 0; set iterator i to 0 (for loop to fill destination array)
	jmp	.L21												# jump to loop .L21
.L22:
	movl	-8(%rbp), %eax									# eax <-- (rbp - 8); copy iterator i to eax
	movslq	%eax, %rdx										# moves and saves value stored in eax in 32 bits to rdx in 64 bits
	movq	-24(%rbp), %rax									# rax <-- (rbp - 24); move the input string parameter to rax
	addq	%rdx, %rax										# rax = rax + rdx
	movl	-8(%rbp), %edx									# edx <-- (rbp - 8); move iterator i to edx
	movslq	%edx, %rcx										# moves and saves value stored in edx in 32 bits to rcx in 64 bits
	movq	-40(%rbp), %rdx									# rdx <-- (rbp - 40); move destination string array to rdx
	addq	%rcx, %rdx										# rdx = rdx + rcx
	movzbl	(%rax), %eax									# the low 8 bits of eax are replaced by rax, top 24 bits set to 0
	movb	%al, (%rdx)										# rdx <-- al; the low 8 bits of eax are moved to rdx
	addl	$1, -8(%rbp)									# increment iterator i
.L21:
	movl	-8(%rbp), %eax									# eax <-- (rbp - 8); copy iterator i to eax
	cmpl	-28(%rbp), %eax									# compare (rbp - 28): length of input string - with eax: iterator i
	jl	.L22												# if eax < (rbp - 28), jump to .L22
	movl	-28(%rbp), %eax									# eax <-- (rbp - 28); copy length of input string to eax			
	movslq	%eax, %rdx										# moves and saves value stored in eax in 32 bits to rdx in 64 bits
	movq	-40(%rbp), %rax									# rax <-- (rbp - 40); move destination string array to rax							
	addq	%rdx, %rax										# rax = rax + rdx 
	movb	$0, (%rax)										# rax = 0
	nop
	popq	%rbp											# pop base pointer
	.cfi_def_cfa 7, 8
	ret														# return
	.cfi_endproc
.LFE3:
	.size	reverse, .-reverse
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
