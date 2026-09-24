.global sum
# pointer to list head in %rdi; result in %rax
# struct ll { char *name; long value; struct ll *next; }
#   offset 0  : name
#   offset 8  : value
#   offset 16 : next
sum:
    xorq %rax, %rax # %rax = total = 0
    jmp .test # jump to the test block of the while loop

.body:
    addq 8(%rdi), %rax # %rax = total + ptr->value
    movq 16(%rdi), %rdi # %rdi = ptr->next

.test:
    testq %rdi, %rdi # test ptr & ptr
    je .done # if ptr == NULL, end the loop and jump to the .done block
    jmp .body # go to start of loop

.done:
    ret # return %rax = total


# sum of the elements of a linkedlist in C
# long sum(struct ll *list){
#    long total = 0;
#    struct ll *ptr = list;
#    while(ptr){
#        total += ptr->value;
#        ptr = ptr->next;
#    }
#    return total;
# }
