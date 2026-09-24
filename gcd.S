.global gcd
# a in %edi, b in %esi; result in %eax
gcd:
    testl %esi, %esi # test b & b
    je .done # if b == 0 jump to base case
    movl %edi, %eax # %eax = a
    cltd # sign extend eax into edx:eax
    idivl %esi # divide R[%edx]:R[%eax] by %esi and store a / b in %eax, and a % b in %edx
    movl %esi, %edi # %edi = b = first argument
    movl %edx, %esi # %esi = a % b = second argument
    call gcd # call gcd(b, a % b)
    ret

.done:
    movl %edi, %eax # %eax = a
    ret # return a


# greatest common divisor via Euclid's algorithm (recursive)
# int gcd(int a, int b){
#     if(b == 0)
#         return a;
#     /* recursive call */
#     return gcd(b, a % b);
# }
