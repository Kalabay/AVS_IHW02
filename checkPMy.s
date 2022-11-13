	.file	"checkP.c"
	.intel_syntax noprefix
	.text
	.globl	GetInput
	.type	GetInput, @function
GetInput:
	endbr64
	push	rbp
	mov	rbp, rsp
	mov	r12d, 0
	mov	r13d, 1
	mov	eax, r13d
	cdqe
	mov	esi, 1
	mov	rdi, rax
	call	calloc@PLT
	mov	r15, rax
	jmp	.L2
.L4:
	mov	eax, r12d
	cmp	eax, r13d
	jl	.L3
	sal	r13d
	mov	eax, r13d
	movsx	rdx, eax
	mov	rax, r15
	mov	rsi, rdx
	mov	rdi, rax
	call	realloc@PLT
	mov	r15, rax
.L3:
	mov	eax, r12d
	movsx	rdx, eax
	mov	rax, r15
	add	rdx, rax
	movzx	eax, r14b
	mov	BYTE PTR [rdx], al
	add	r12d, 1
.L2:
	call	getchar@PLT
	mov	r14b, al
	cmp	r14b, -1
	jne	.L4
	mov	eax, r12d
	cmp	eax, r13d
	jl	.L5
	sal	r13d
	mov	eax, r13d
	movsx	rdx, eax
	mov	rax, r15
	mov	rsi, rdx
	mov	rdi, rax
	call	realloc@PLT
	mov	r15, rax
.L5:
	mov	eax, r12d
	movsx	rdx, eax
	mov	rax, r15
	add	rax, rdx
	mov	BYTE PTR [rax], 0
	mov	rax, r15
	leave
	ret
	.size	GetInput, .-GetInput
	.globl	CheckPalindrome
	.type	CheckPalindrome, @function
CheckPalindrome:
	endbr64
	push	rbp
	mov	rbp, rsp
	mov	r15, rdi
	mov	r12d, 0
	mov	rax, r15
	mov	rdi, rax
	call	strlen@PLT
	sub	eax, 2
	mov	r13d, eax
	jmp	.L8
.L10:
	add	r12d, 1
	sub	r13d, 1
.L8:
	mov	eax, r12d
	cmp	eax, r13d
	jge	.L9
	mov	eax, r12d
	movsx	rdx, eax
	mov	rax, r15
	add	rax, rdx
	movzx	edx, BYTE PTR [rax]
	mov	eax, r13d
	movsx	rcx, eax
	mov	rax, r15
	add	rax, rcx
	movzx	eax, BYTE PTR [rax]
	cmp	dl, al
	je	.L10
.L9:
	mov	eax, r12d
	cmp	eax, r13d
	setge	al
	movzx	eax, al
	leave
	ret
	.size	CheckPalindrome, .-CheckPalindrome
	.section	.rodata
.LC0:
	.string	"It's palindrome"
.LC1:
	.string	"It isn't palindrome"
	.text
	.globl	main
	.type	main, @function
main:
	endbr64
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32
	mov	DWORD PTR -20[rbp], edi
	mov	QWORD PTR -32[rbp], rsi
	mov	eax, 0
	call	GetInput
	mov	r15, rax
	mov	rdi, rax
	call	CheckPalindrome
	test	eax, eax
	je	.L13
	lea	rax, .LC0[rip]
	mov	rdi, rax
	call	puts@PLT
	jmp	.L14
.L13:
	lea	rax, .LC1[rip]
	mov	rdi, rax
	call	puts@PLT
.L14:
	mov	rax, r15
	mov	rdi, rax
	call	free@PLT
	mov	eax, 0
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.2.0-19ubuntu1) 11.2.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
