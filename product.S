.global product
# a in %rdi, b in %rsi, c in %rdx, size in %ecx
product:
    xorl %r8d, %r8d # %r8d = i = 0
    jmp .test # go to the test block for the loop

.body:
    movss (%rdi,%r8,4), %xmm0 # %xmm0 = a[i]
    mulss (%rsi,%r8,4), %xmm0 # %xmm0 = a[i] * b[i]
    movss %xmm0, (%rdx,%r8,4) # c[i] = a[i] * b[i]
    incl %r8d # i++

.test:
    cmpl %ecx, %r8d # compare i - size
    jb .body # if unsigned i < size, jump back to the body of the for loop

.done:
    ret # void for this function

# Product of two vectors in C
# void product(float *a, float *b, float *c, unsigned size){
#    for(int i=0; i<size; i++){
#        c[i] = a[i] * b[i];
#    }
# }
