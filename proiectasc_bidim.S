.data
	i: .space 4
	j: .space 4
	v: .space 1048576
	nroperatii: .space 4
    operatie: .space 4
	n: .space 4
	nr: .space 4
	k: .space 4
	l: .space 4
	start: .space 4
	start1: .space 4
	start2: .space 4
	end: .space 4
	h: .space 4
	c: .space 4
	fin: .space 4
	fin1: .space 4
	fin2: .space 4
	cat: .space 4
	rest: .space 4
	poz: .space 4
	formatScanf: .asciz "%d"
    formatPrintf1: .asciz "%d: ((%d, %d), (%d, %d))\n"
    formatPrintf2: .asciz "((%d, %d), (%d, %d))\n"
    formatPrintf0: .asciz "%d: ((0, 0), (0, 0))\n"
.text
.global main
main:
	lea v, %edi
	mov $0, %ecx
	mov $0, %eax
	loop_initializare_cu_zero:
		cmp $262144, %ecx
        je exit_loop_initializare_cu_zero
        movl %eax, (%edi, %ecx, 4)
        inc %ecx
        jmp loop_initializare_cu_zero
    exit_loop_initializare_cu_zero:
	push $nroperatii
    push $formatScanf
    call scanf
    pop %ebx
    pop %ebx
    mov $0, %ecx
    loop_nroperatii:
		mov %ecx, i
        cmp nroperatii, %ecx
        je exit
        push $operatie
        push $formatScanf
        call scanf
        pop %ebx
        pop %ebx
        mov operatie, %eax
        cmp $1, %eax
        je ADD
        cmp $2, %eax
        je GET
        cmp $3, %eax
        je DELETE
		ADD:
            push $n                 //citim cate adduri trebuie sa facem
            push $formatScanf
            call scanf
            pop %ebx
            pop %ebx
            mov $0, %ecx
            loop_nr_de_adduri:
				mov %ecx, j                //j=ecx
                cmp n, %ecx                 //for(j=0;j<n;j++)
                je inci
                push $nr                     //citim numarul
                push $formatScanf
                call scanf
                pop %ebx
                pop %ebx
                push $poz
                push $formatScanf
                call scanf
                pop %ebx
                pop %ebx
                mov poz, %eax
                mov $8, %ebx
                mov $0, %edx
                div %ebx
                cmp $0 ,%edx            //comparam restul impartirii lui poz la 8 cu 0
                je pozitie              //daca e 0 poz=poz/8
                inc %eax                //altfel poz=poz/8+1
                pozitie:
                    mov %eax, poz
				cmp $1024, %eax
				jg afisare_zero_zero
				mov $0, %ecx
				outer_loop_efectuarea_addului:
					mov %ecx, k                 //for(k=0;k<256;k++)
                    cmp $256, %ecx
                    je loop_nr_de_adduri
					mov k, %eax
					mov $1024, %ebx
					mul %ebx
					mov %eax, start				//start=1024*k
					add $1024, %eax
					mov %eax, end				//end=1024*(k+1)
					mov start, %ecx
					inner_loop_efectuarea_addului:
						mov %ecx, l			//for(l=1024*k;l<1024*(k+1);l++)
						cmp end, %ecx
						je inck
						mov $0, %ebp
						cmp %ebp, (%edi, %ecx, 4)
						jne incl
						mov l, %eax				//eax=l
						while:
							cmp %ebp, (%edi, %eax, 4)             //while(v[eax]==0 && eax<end)
							jne verificare
							cmp end, %eax
							jge verificare
							inc %eax
							jmp while
						verificare:
							sub l, %eax				//in eax era stocat l+c unde este un pointer care ne spune cate zerouri avem
							cmp %eax, poz
							jg incl
							afisare_si_adaugare:
								mov l, %eax                   //eax =l
                           	 	mov $1024, %ebx
								mov $0, %edx
								div %ebx
								mov %eax, start1
								mov %edx, fin1
								mov %eax, start2
								add poz, %edx
								dec %edx
								mov %edx, fin2
								push %edx
								push %ecx
								push %eax
								push fin2
								push start2
								push fin1
								push start1
								push nr
								push $formatPrintf1
								call printf
								pop %ebx
								pop %ebx
								pop %ebx
								pop %ebx
								pop %ebx
								pop %ebx
								pop %eax
								pop %ecx
								pop %edx
								mov l, %ecx
								mov l, %edx
								add poz, %edx
								adaugare:
									mov %ecx, h                //for(h=l;h<l+poz;h++)
									cmp %edx, %ecx              //daca s a efectuat add ul trecem la urmatorul add
									je incj
									mov nr, %eax
									movl %eax, (%edi, %ecx, 4)                      //v[l]=nr
									mov h, %ecx
									inc %ecx
									jmp adaugare
								afisare_zero_zero:
									push %eax
									push %edx
									push %ecx
									push nr
									push $formatPrintf0
									call printf
									pop %ebx
									pop %ebx
									pop %ecx
									pop %edx
									pop %eax
									jmp incj
						incl:
							mov l, %ecx
							inc %ecx 
							jmp inner_loop_efectuarea_addului
					inck:
						mov k, %ecx
						inc %ecx
						jmp outer_loop_efectuarea_addului
				incj:
                    mov j, %ecx
                inc %ecx 
                jmp loop_nr_de_adduri
		GET:
			push $nr
            push $formatScanf
            call scanf
            pop %ebx
            pop %ebx
            mov $0, %ecx
            mov $0, %ebx            //ebx=false
            loop_GET:
                mov %ecx, j                //j=ecx
                cmp $262144, %ecx                 //for(j=0;j<262144;j++)
                je verificare_GET
                mov %ecx, c                 //c=j
                mov nr, %eax                //eax=nr
                mov (%edi, %ecx, 4), %ebp           //ebp=v[j]
                cmp (%edi, %ecx, 4), %eax           //if(v[j]==nr)
                jne incjget
                mov $1, %ebx                //ebx==true
                mov $0, %edx                //edx=0
                mov %ecx, start             //start=j
                mov c, %edx                 //edx=c
                while_get:                          //while(v[c]==v[j])
                    cmp (%edi, %edx, 4), %ebp
                    jne while_exit
                    inc %edx
                    jmp while_get
                while_exit:
                    jmp verificare_GET
                incjget:
                    mov j, %ecx
                inc %ecx 
                jmp loop_GET
				verificare_GET:
					cmp $1, %ebx
					jne afisare_zero_zero_get
					sub $1, %edx
					mov %edx, fin
					mov start, %eax                   //eax =start
                    mov $1024, %ebx
					mov $0, %edx
					div %ebx
					mov %eax, start1
					mov %edx, fin1
					mov %eax, start2
					mov fin, %eax
					mov $1024, %ebx
					mov $0, %edx
					div %ebx
					mov %edx, fin2
					mov %edx, fin2
					push %edx
					push %ecx
					push %eax
					push fin2
					push start2
					push fin1
					push start1
					push $formatPrintf2
					call printf
					pop %ebx
					pop %ebx
					pop %ebx
					pop %ebx
					pop %ebx
					pop %eax
					pop %ecx
					pop %edx
					jmp inci
				afisare_zero_zero_get:
					push $0
					push $0
					push $0
					push $0
					push $formatPrintf2
					call printf
					pop %ebx
					pop %ebx
					pop %ebx
					pop %ebx
					jmp inci
		DELETE:
			mov $0, %ecx
            push $nr
            push $formatScanf
            call scanf
            pop %ebx
            pop %ebx
            mov nr, %eax
            mov $0, %edx
            loop_delete:
                mov %ecx, j
                cmp $262144, %ecx
                je et_afisare_memorie
                cmp (%edi, %ecx, 4), %eax
                jne incjdel
                mov %edx, (%edi, %ecx, 4)
                incjdel:
                    mov j, %ecx
                    inc %ecx
                    jmp loop_delete
			et_afisare_memorie:
			mov $0, %ecx
            loop_afisare_memorie:
                mov $0, %eax
                mov %ecx, k
                cmp $262144, %ecx
                je inci
                mov %ecx, c                 //c=k
                mov c, %edx                 //edx=c
                mov (%edi, %ecx, 4), %ebp           //ebp=v[k]
                cmp (%edi, %ecx, 4), %eax           //if v[k]==0 sarim mai departe
                je inck_afisare_memorie
                while_afisare_memorie:
                    cmp %ebp, (%edi, %edx, 4)
                    jne afisare_memorie
                    inc %edx
                    jmp while_afisare_memorie
                afisare_memorie:
                    sub $1, %edx            //edx=c-1
                    mov %edx, k             //k=c-1
					mov %ecx, start
					mov %edx, fin
					mov start, %eax                   //eax =start
                    mov $1024, %ebx
					mov $0, %edx
					div %ebx
					mov %eax, start1
					mov %edx, fin1
					mov %eax, start2
					mov fin, %eax
					mov $1024, %ebx
					mov $0, %edx
					div %ebx
					mov %edx, fin2
					push %edx
					push %ecx
					push %eax
					push fin2
					push start2
					push fin1
					push start1
					push %ebp
					push $formatPrintf1
					call printf
					pop %ebx
					pop %ebx
					pop %ebx
					pop %ebx
					pop %ebx
					pop %ebx
					pop %eax
					pop %ecx
					pop %edx
                inck_afisare_memorie:
                    mov k, %ecx
                inc %ecx
                jmp loop_afisare_memorie
        inci:
            mov i, %ecx
            inc %ecx 
            jmp loop_nroperatii

	exit:
		pushl $0
		call fflush
		popl %eax
		mov $1, %eax
		mov $0, %ebx
		int $0x80
