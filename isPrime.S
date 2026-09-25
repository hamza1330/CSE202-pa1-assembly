.global isPrime
# n in %edi; result in %eax (1 = prime, 0 = not prime)
isPrime:
  cmpl $2, %edi # compare n - 2
  jl .not_prime # jump to .not_prime if n < 2
  testl $1, %edi # test n & 1
  jne .init_loop # jump to .init_loop if odd
  cmpl $2, %edi # compare n - 2
  je .prime # if n == 2 jump to .prime
  jmp .not_prime # if even and not 2 then not prime

.init_loop:
  movl $3, %r8d # i = 3

.loop_test:
  movl %r8d, %r9d # %r9d = i
  imull %r8d, %r9d # %r9d = i*i
  cmpl %edi, %r9d # %compare i*i - n
  jg .prime # if i*i > n, no divisor found
  movl %edi, %eax # %eax = n
  cltd # sign-extend %eax into %edx:%eax
  idivl %r8d # %edx = n % i
  testl %edx, %edx # test (n % i)
  je .not_prime # if n % i == 0, jump to .not_prime
  addl $2, %r8d # i += 2
  jmp .loop_test # continue the for loop

.prime:
  movl $1, %eax # %eax = 1
  ret # return 1 (true)

.not_prime:
  xorl %eax, %eax # %eax = 0
  ret # return 0 (false))


# int isPrime(int n){
#     if(n < 2)
#         return 0;
#     if(n % 2 == 0)
#         return n == 2;
#     /* only test odd divisors i while i*i <= n */
#     for(int i = 3; i * i <= n; i += 2){
#         if(n % i == 0)
#             return 0;
#     }
#     return 1;
# }
