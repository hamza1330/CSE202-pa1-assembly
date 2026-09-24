.global binsearch
# arr in %rdi, n in %esi, target in %edx
binsearch:
  xorl %r8d, %r8d # %r8d = lo = 0
  movl %esi, %r9d # %r9d = %esi = n = hi
  subl $1, %r9d # %r9d = n - 1
  jmp .test

.test:
  cmpl %r9d, %r8d # compare lo - hi
  jg .fail # jump to fail if lo > hi

.body:
  movl %r9d, %r10d # %r10d = %r9d = hi
  subl %r8d, %r10d # %r10d = hi - lo
  sarl $1, %r10d # %r10d = %r10d >> 1 = (hi - lo) / 2
  addl %r8d, %r10d # %r10d = lo + (hi - lo) / 2
  cmpl (%rdi, %r10, 4), %edx # compare target - arr[mid]
  je .if # jump to .if if target == arr[mid]
  jg .elif # jump to .elif if target > arr[mid]
  jmp .else # forced jump to else

.if:
  movl %r10d, %eax # %eax = mid
  ret

.elif:
  movl %r10d, %r8d # lo = mid
  addl $1, %r8d # lo = mid + 1
  jmp .test

.else:
  movl %r10d, %r9d # hi = mid
  subl $1, %r9d # hi = mid - 1
  jmp .test

.fail:
  movl $-1, %eax # %eax = -1
  ret # return -1


# binary search over a sorted int array; returns the index of target, or -1
# int binsearch(int *arr, unsigned n, int target){
#     int lo = 0;
#     int hi = (int)n - 1;
#     while(lo <= hi){
#         int mid = lo + (hi - lo) / 2;
#         if(arr[mid] == target)
#             return mid;
#         else if(arr[mid] < target)
#             lo = mid + 1;
#         else
#             hi = mid - 1;
#     }
#     return -1;
# }
