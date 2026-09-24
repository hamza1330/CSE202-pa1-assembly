.global reverse
# list in %rdi (array of char*), n in %esi
reverse:
  xorl %edx, %edx # %edx = i = 0
  jmp .test # jump to the test block

.while:
  movq (%rdi,%rdx,8), %rax # %rax = temp = list[i]
  movl %esi, %ecx # %ecx = n
  subl %edx, %ecx # %ecx = n - i
  subl $1, %ecx # %ecx = n - i - 1
  movq (%rdi,%rcx,8), %r9 # %r9 = list[n - i - 1] 
  movq %r9, (%rdi,%rdx,8) # list[i] = list[n - i - 1]
  movq %rax, (%rdi,%rcx,8) # list[n - i - 1] = temp
  incl %edx # i++

.test:
  # I wanted to test if n == 0 here so we avoid division by 0, but the c code doesn't do that
  movl %esi, %r8d # %r8d = n
  shrl $1, %r8d # %r8d = n >> 1 = n / 2
  cmp %edx, %r8d # compare n/2 - i
  ja .while # jump to while body if unsigned n/2 > i (i < n/2) 

.done:
  ret


# void reverse(char **list, unsigned n){
#     unsigned i = 0;
#     while (i < n/2){
#      char *temp = list[i];
#      list[i] = list[n-i-1];
#      list[n-i-1] = temp;
#      i++;
#     }
# }
