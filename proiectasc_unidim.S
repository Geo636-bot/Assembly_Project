.data
    i: .space 4
    j: .space 4
    k: .space 4
    n: .space 4
    nr: .space 4
    l: .space 4
    c: .space 4
    poz: .space 4
    start: .space 4
    nroperatii: .space 4
    operatie: .space 4
    v: .space 4096
    formatScanf: .asciz "%d"
    formatPrintf1: .asciz "%d: (%d, %d)\n"
    formatPrintf2: .asciz "(%d, %d)\n"
    formatPrintf0: .asciz "%d: (0, 0)\n"
.text
.global main
main:
    lea v, %edi
    mov $0, %ecx
    mov $0, %eax
    loop_initializare_cu_zero:
        cmp $1024, %ecx
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
        cmp $4, %eax
        je DEFRAGMENTATION
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
                mov $0, %ecx
                loop_efectuarea_addului:
                    mov %ecx, k                 //for(k=0;k<1024;k++)
                    cmp $1024, %ecx
                    je loop_nr_de_adduri
                    mov $0, %ebp
                    cmp %ebp, (%edi, %ecx, 4)         //if(v[k]==0)
                    jne verificare_ultim_element
                    mov k, %eax                     //eax=k 
                    while:
                        cmp  %ebp, (%edi, %eax, 4)             //while(v[eax]==0 && eax<1024)
                        jne verificare
                        cmp $1024, %eax
                        jge verificare
                        inc %eax                            //eax=eax+1
                        jmp while
                    verificare:
                        sub k, %eax                         //in eax era stocat k+c unde c era un pointer care ne spunea cate zero uri avem intr o secventa
                        cmp %eax, poz
                        jg verificam_daca_are_loc           //daca poz>c nu putem sa adaugam
                        afisare_si_adaugare:                //altfel afisam si adaugam
                            mov k, %edx                     //edx =k
                            add poz, %edx                   //edx=k+poz
                            sub $1, %edx                    //edx=k+poz-1
                            push %eax
                            push %edx
                            push %ecx
                            push nr
                            push $formatPrintf1
                            call printf
                            pop %ebx
                            pop %ebx
                            pop %ecx
                            pop %edx
                            pop %eax
                            mov k, %ecx                     //ecx=k
                            inc %edx                        //edx=k+poz
                            adaugare:
                                mov %ecx, l                 //for(l=k;l<k+poz;l++)
                                cmp %edx, %ecx              //daca s a efectuat add ul trecem la urmatorul add
                                je incj
                                mov nr, %eax
                                movl %eax, (%edi, %ecx, 4)                      //v[l]=nr
                                mov l, %ecx
                                inc %ecx 
                                jmp adaugare
                        verificam_daca_are_loc:
                            add k, %eax                     //eax=k+c
                            cmp $1023, %eax
                            jg afisare_zero_zero
                            mov %eax, %ecx
                            jmp inck
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
                    verificare_ultim_element:
                        cmp $1023, %ecx
                        jne inck
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
                    inck:
                        mov k, %ecx
                    inc %ecx 
                    jmp loop_efectuarea_addului
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
                cmp $1024, %ecx                 //for(j=0;j<1024;j++)
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
                push %eax
                push %ecx
                push %edx
                push start
                push $formatPrintf2
                call printf
                pop %ebx
                pop %ebx
                pop %edx
                pop %ecx
                pop %eax
                jmp inci
            afisare_zero_zero_get:
                push $0
                push $0
                push $formatPrintf2
                call printf
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
                cmp $1024, %ecx
                je et_afisare_memorie
                cmp (%edi, %ecx, 4), %eax
                jne incjdel
                mov %edx, (%edi, %ecx, 4)
                incjdel:
                    mov j, %ecx
                    inc %ecx
                    jmp loop_delete     
        DEFRAGMENTATION:
            mov $0, %ecx
            loop_defragmentation:
                mov %ecx, j
                cmp $1024, %ecx
                je et_afisare_memorie
                mov $0, %eax
                cmp (%edi, %ecx, 4), %eax
                jne incjdefrag
                mov %ecx, k                 
                mov k, %edx
                while_defragmentation:              //while(v[edx]==0 && edx<1023)
                    cmp (%edi, %edx, 4), %eax
                    jne interschimbare
                    cmp $1023, %edx
                    jge interschimbare
                    inc %edx
                    jmp while_defragmentation
                interschimbare:                 //interschimbare intre v[edx] si v[ecx]
                    mov (%edi, %ecx, 4), %ebx                   //ebx=v[ecx]
                    mov (%edi, %edx, 4), %ebp              //ebp=v[edx]
                    mov %ebp, (%edi, %ecx, 4)              //v[ecx]=ebp
                    mov %ebx, (%edi, %edx, 4)              //v[edx]=ebx
                incjdefrag:
                    mov j, %ecx
                    inc %ecx
                    jmp loop_defragmentation
        et_afisare_memorie:
            mov $0, %ecx
            loop_afisare_memorie:
                mov $0, %eax
                mov %ecx, k
                cmp $1024, %ecx
                je inci
                mov %ecx, c                 //c=k
                mov c, %edx                 //edx=c
                mov (%edi, %ecx, 4), %ebx           //ebx=v[k]
                cmp (%edi, %ecx, 4), %eax           //if v[k]==0 sarim mai departe
                je inck_afisare_memorie
                while_afisare_memorie:
                    cmp %ebx, (%edi, %edx, 4)
                    jne afisare_memorie
                    inc %edx
                    jmp while_afisare_memorie
                afisare_memorie:
                    sub $1, %edx            //edx=c-1
                    mov %edx, k             //k=c-1
                    push %edx
                    push %ecx
                    push %ebx
                    push $formatPrintf1
                    call printf
                    pop %ebx
                    pop %ebx
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
