	.file	"checkP.c"
	.intel_syntax noprefix
	.text
	.globl	GetInput
	.type	GetInput, @function
GetInput:
	endbr64
	push	rbp                          # сохраняем указатель на стэк
	mov	rbp, rsp                     # изменение области видимости функции в памяти
	sub	rsp, 32                      # rsp -= 32, выделил 32 байта памяти (int size - 4 байта, int capacity - 4 байта, char *str - 8 байт)
	mov	DWORD PTR -4[rbp], 0         # dword[rbp - 4] = 0 /  size = 0;
	mov	DWORD PTR -8[rbp], 1         # dword[rbp - 8] = 1 / capacity = 1;
	mov	eax, DWORD PTR -8[rbp]       # младшие 4 байта rax = capacity (так как int) 
	cdqe                                 # кастуем eax к 8-ми байтному значению, как бы расширяем до rax, то есть в rax лежит capacity, так как capacity сделали signed int
	mov	esi, 1                       # sizeof возвращает unsigned int => используем только 4 байта от второго аргумента и так как sizeof(*str) == sizeof(char) == 1
	mov	rdi, rax                     # первый аргумент = rax, то есть первый аргумент = (long long)capacity
	call	calloc@PLT                   # вызываем calloc(rdi == rax, esi == 1)
	mov	QWORD PTR -16[rbp], rax      # берем выделенные на стеке char *str = значение которое вернул calloc (то есть адрес начала массива char'ов)
	jmp	.L2                          # начинаем while
.L4:
	mov	eax, DWORD PTR -4[rbp]       # eax = size (так как type(size) == int, и eax - 4 байта)
	cmp	eax, DWORD PTR -8[rbp]       # сравниваем eax с capacity, то есть сравниваем size с capacity
	jl	.L3                          # если size < (low == l) capacity то jump to .L3
	                                     # идём далее, если не xватает capacity (if начался)
	sal	DWORD PTR -8[rbp]            # capacity << (ariphmethic left, то есть с сохранение знакового бита) 1, на 1 так как без аргументов ~ capacity *= 2;
	mov	eax, DWORD PTR -8[rbp]       # eax = capacity (так как type(capacity) = int, то используем eax)
	movsx	rdx, eax                     # rdx = (long long)eax, то есть по сути кастуем с учётом знака и перемещаем eax (signed int) в rdx (8 байтов)
	mov	rax, QWORD PTR -16[rbp]      # rax = char* str
	mov	rsi, rdx                     # rsi = rdx (то есть второй аргумент = rdx = (long long)eax = (long long)capacity), с оптимизировали то что sizeof(*str) == sizeof(char) == 1
	mov	rdi, rax                     # rdi = rax (то есть первый аргумент = rax = str (имеет тип char*))
	call	realloc@PLT                  # вызываем realloc, новый указатель для str будет лежать в rax (8 байт)
	mov	QWORD PTR -16[rbp], rax      # str = realloc(...) (то есть str = значение которое вернул realloc)
	                                     # if закончился
	                                    
.L3:                                         # если не было проблем с size и capacity или если мы уже выделили достаточно памяти в if
	mov	eax, DWORD PTR -4[rbp]       # eax = size (type(size) = int => используем eax (4 байта))
	movsx	rdx, eax                     # rdx = (long long)eax = (long long)size
	mov	rax, QWORD PTR -16[rbp]      # rax = str (type(str) = char*)
	add	rdx, rax                     # rdx += rax, то есть rdx = rdx + rax = size * sizeof(*str) + str = size + str, то есть вычисляем адрес нужного элемента массива, то есть вычеслили адрес
	movzx	eax, BYTE PTR -17[rbp]       # movzx - каст для unsigned (то есть не волнуемся о знаке), eax (4 байта) = now (1 байт)
	mov	BYTE PTR [rdx], al           # *rdx = al = now ~ *(str + size * 1) = now (BYTE PTR говорит о том, что кладём 1-байтовое значение, так как у нас массив char) 
	add	DWORD PTR -4[rbp], 1         # size += 1
.L2:
	call	getchar@PLT                  # вызываем getchar(), так как у getchar нет аргументов, то ничего не передаём, возвращает char == 1 байт => результат лежит в a
	mov	BYTE PTR -17[rbp], al        # используем не занятую память по адресу rbp-17, и кладём туда значение символа / now = getchar(), если точнее то now = то что вернул getchar()
	cmp	BYTE PTR -17[rbp], -1        # сравниваем now c -1 (то есть с EOF), помним что char == signed char
	jne	.L4                          # если now != (not equal == ne) -1 (!= EOF), то jump to .L4
	mov	eax, DWORD PTR -4[rbp]       # eax (4 байта) = size (4 байта) 
	cmp	eax, DWORD PTR -8[rbp]       # сравниваем eax с capacity, то есть size с capacity
	jl	.L5                          # если size < (low == l) capacity, то прыгаем на .L5
	                                     # если надо расшириться
	sal	DWORD PTR -8[rbp]            # capacuty << 1 (с учётом знака)
	mov	eax, DWORD PTR -8[rbp]       # eax = capacity
	movsx	rdx, eax                     # rdx = (long long)eax = (long long)capacity
	mov	rax, QWORD PTR -16[rbp]      # rax = str (char* - 8 байт)
	mov	rsi, rdx                     # rsi = rdx (второй аргумент = (long long)capacity)
	mov	rdi, rax                     # rdi = rax (первый аргумент = str)
	call	realloc@PLT                  # вызываем realloc, значение вернёт в rax (8 байт, так как указатели 64 битные)
	mov	QWORD PTR -16[rbp], rax      # str = rax = значение которое вернул realloc (новый указатель)
	                                     # вышли из if 
.L5:
	mov	eax, DWORD PTR -4[rbp]       # eax = size
	movsx	rdx, eax                     # rdx = (long long)eax = (long long)size
	mov	rax, QWORD PTR -16[rbp]      # rax = str
	add	rax, rdx                     # rax += rdx ~ rax = rax + rdx = str + (long long)size * sizeof(*str) = str + (long long)size
	mov	BYTE PTR [rax], 0            # *rax = 0 ~~ *(str + size) = 0 ~~~ str[size] = 0;
	mov	rax, QWORD PTR -16[rbp]      # rax = str - кладём в rax возвращаемое значение
	leave                                # выйти из функции, очистить стек, восстановить предыдущее значение rbp
	ret                                  # вернуться к вызову функции
	.size	GetInput, .-GetInput
	.globl	CheckPalindrome
	.type	CheckPalindrome, @function
CheckPalindrome:
	endbr64
	push	rbp                         # сохраняем указатель на стэк
	mov	rbp, rsp                    # изменение области видимости функции в памяти
	sub	rsp, 32                     # выделяем память для l, r и str
	mov	QWORD PTR -24[rbp], rdi     # на rbp-24 выделяем 8 байт и кладём в них rdi (то есть первый аргумент функции check_palindrome), то есть локально выделяем место для char *str и кладём туда значение
	mov	DWORD PTR -4[rbp], 0        # int l = 0
	mov	rax, QWORD PTR -24[rbp]     # rax = str
	mov	rdi, rax                    # rdi = str (первый аргумент = str)
	call	strlen@PLT                  # вызываем strlen, вернёт знвчение в eax (так как вернёт size_t)
	sub	eax, 2                      # eax -= 2 (size - 2)
	mov	DWORD PTR -8[rbp], eax      # r (по адресу rbp-8) = eax = size - 2
	jmp	.L8                         # начинаем while
.L10:
	add	DWORD PTR -4[rbp], 1        # l += 1
	sub	DWORD PTR -8[rbp], 1        # r -= 1
.L8:
	mov	eax, DWORD PTR -4[rbp]      # eax (4 байта) = l (4 байта)
	cmp	eax, DWORD PTR -8[rbp]      # сравниваем eax с r, то есть сравниваем l с r
	jge	.L9                         # если l >= (great or equal == ge) r, то jump to .L9 (заканчиваем while)
	mov	eax, DWORD PTR -4[rbp]      # eax = l
	movsx	rdx, eax                    # rdx = (long long)eax (movsx - каст для signed)
	mov	rax, QWORD PTR -24[rbp]     # rax = str
	add	rax, rdx                    # rax += rdx ~ rax = rax + rdx = str + l
	movzx	edx, BYTE PTR [rax]         # edx = *rax (1 байт) ~ edx = *(rax) = *(str + l) = str[l]
	mov	eax, DWORD PTR -8[rbp]      # eax = r
	movsx	rcx, eax                    # rcx = (long long)eax = (long long)r
	mov	rax, QWORD PTR -24[rbp]     # rax = str
	add	rax, rcx                    # rax += rcx ~~ rax = rax + rcx = str + r
	movzx	eax, BYTE PTR [rax]         # eax = *rax (1 байт) ~ eax = *(rax) = *(str + r) = str[r]
	cmp	dl, al                      # стравниваем str[l] и str[r] 
	je	.L10                        # если str[l] == (equal = e) str[r] то jump to .L10
.L9:
	mov	eax, DWORD PTR -4[rbp]      # eax = l
	cmp	eax, DWORD PTR -8[rbp]      # сравниваем eax  с r, то есть l c r
	setge	al                          # если l >= (great or equal = ge) r, то set al to 1 value
	movzx	eax, al                     # кастуем 1 байт al к 4 байтам (int) eax, так как функция возвращает int
	leave                               # выйти из функции, очистить стек, восстановить предыдущее значение rbp
	ret                                 # вернуться к вызову функции
	.size	CheckPalindrome, .-CheckPalindrome
	.section	.rodata             # секция rodata, rodata - секция где прописываются константы
.LC0:
	.string	"It's palindrome"
.LC1:
	.string	"It isn't palindrome"
	.text                               # секция text  с кодом
	.globl	main
	.type	main, @function
main:
	endbr64
	push	rbp                        # сохраняем указатель на стэк
	mov	rbp, rsp                   # изменение области видимости функции в памяти
	sub	rsp, 32                    # выделяем память под локальные данные -  char *str
	mov	DWORD PTR -20[rbp], edi    # первый аргумент функции, argc
	mov	QWORD PTR -32[rbp], rsi    # второй аргумент функции, argv
	mov	eax, 0
	call	GetInput                   # вызываем GetInput, возвращаемое значение лежит в rax
	mov	QWORD PTR -8[rbp], rax     # str = rax (то что вернул read)
	mov	rax, QWORD PTR -8[rbp]     # rax = str
	mov	rdi, rax                   # rdi = rax = str (первый аргумент = str)
	call	CheckPalindrome            # вызываем check_palindrome, вернёт значение в eax
	test	eax, eax                   # сравниваем eax с eax
	je	.L13                       # если eax = (equal = e) 0, то jump to .L13 (else) 
	# зашли в if
	lea	rax, .LC0[rip]             # "it's palindrome" (.LC0)
	mov	rdi, rax                   # rdi = адрес строки "it's palindrome" (.LC0), rdi - первый аргумент puts
	call	puts@PLT                   # вызываем puts
	jmp	.L14                       # пропускаем else (прыгаем на .L14)
.L13:
	lea	rax, .LC1[rip]             # "it isn't palindrome" (.LC1)
	mov	rdi, rax                   # rdi = адрес строки "it isn't palindrome" (.LC1), rdi - первый аргумент puts
	call	puts@PLT                   # вызываем puts
.L14:
	mov	rax, QWORD PTR -8[rbp]     # rax = str
	mov	rdi, rax                   # первый аргумент = rax = str
	call	free@PLT                   # вызываем free
	mov	eax, 0                     # возвращаемое значение = 0
	leave                              # выйти из функции, очистить стек, восстановить предыдущее значение rbp
	ret                                # вернуться к вызову функции
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
