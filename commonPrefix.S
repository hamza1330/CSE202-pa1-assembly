.global commonPrefix
# a in %rdi, b in %rsi; result (prefix length) in %eax
commonPrefix:
  xorl %eax, %eax # %eax = n = 0
  jmp .test # jump to the test block for the loop

.body:
  incl %eax # n++

.test:
  movb (%rdi, %rax, 1), %dl # %dl = a[n]
  testb %dl, %dl # test a[n] & a[n]
  je .done # if a[n] == 0 jump out of loop
  cmpb (%rsi, %rax, 1), %dl # compare a[n] - b[n]
  jne .done # if a[n] != b[n] jump out of loop
  jmp .body # jump to body code

.done:
  ret # return n


# length of the longest common prefix of two null-terminated strings
# int commonPrefix(char *a, char *b){
#     int n = 0;
#     while(a[n] && a[n] == b[n])
#         n++;
#     return n;
# }
