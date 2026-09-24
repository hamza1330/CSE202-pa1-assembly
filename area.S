.global area
# a in %edi, b in %esi, c in %edx; result in %eax
area:
    # p = (a + b + c) / 2
    movl %edi, %r8d # p = a
    addl %esi, %r8d # p = a + b
    addl %edx, %r8d # p = a + b + c
    sarl $1, %r8d # p = p >> 1 = (a+b+c) / 2 (we know that p must be postitive here) 

    # product = p
    movl %r8d, %eax # copy p into produce holder

    # product *= (p-a)
    movl %r8d, %r9d # temp = p
    subl %edi, %r9d # temp = p - a
    imull %r9d, %eax # product = p*(p-a)

    # product *= (p-b)
    movl %r8d, %r9d # temp = p
    subl %esi, %r9d # temp = p - b
    imull %r9d, %eax # product = p*(p-a)*(p-b)

    # product *= (p-c)
    movl %r8d, %r9d # temp = p
    subl %edx, %r9d # temp = p - c
    imull %r9d, %eax # product = p*(p-a)*(p-b)*(p-c)

    # return r_sqrt(product)
    movl %eax, %edi # %edi = product
    call r_sqrt # call r_sqrt with product as arguemnt (%edi is 1st arg)
    ret

r_sqrt:
    pushq %rbx 
    movl %edi, %ebx # save original x

    testl %edi, %edi # test x 
    jl .sqrt_negative # jump to .sqrt_negative if x < 0

    cmpl $2, %edi # compare x - 2
    jl .sqrt_return_x # jump to .sqrt_return_x if x < 2

    sarl $2, %edi # edi = x >> 2
    call r_sqrt # call r_sqrt with x >> 2 as argument
    shll $1, %eax # eax = small_cand = r_sqrt(x >> 2) << 1

    leal 1(%eax), %ecx # ecx = large_cand = small_cand + 1

    movl %ecx, %edx # edx = large_cand
    imull %ecx, %edx # edx = large_canv ^ 2

    cmpl %ebx, %edx # compare large_cand^2 - x
    jg .sqrt_done # eax already = small_cand (jump if larg_can^2 > x) 

    # else return large_cand
    movl %ecx, %eax # else %eax = large_cand
    jmp .sqrt_done

.sqrt_negative:
    movl $-1, %eax # return -1
    jmp .sqrt_done

.sqrt_return_x:
    movl %edi, %eax # return x

.sqrt_done:
    popq %rbx 
    ret

# int area(int a, int b, int c){
#     int p = (a + b + c)/2;
#     p = p * (p-a) * (p-b) * (p-c);
#     return sqrt(p);
# }
# calculate recursively the square root of an int (in C)
# int r_sqrt(int x){
#    if(x < 0)
#        return -1;
#    if (x < 2)
#        return x;
#   /* recursive call */
#    int small_cand = r_sqrt(x >> 2) << 1;
#    int large_cand = small_cand + 1;
#    if (large_cand * large_cand > x)
#        return small_cand;
#    else
#        return large_cand;
# }
