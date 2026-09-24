.global secondMax
# v1 in %di, v2 in %si, v3 in %dx, v4 in %cx  (signed 16-bit); result in %ax
secondMax:
    cmpw %si, %di # compare v1 - v2
    jl .v2_bigger # jump to .v2_bigger if v1 < v2
    movw %di, %r8w # first = v1
    movw %si, %r9w # second = v2
    jmp .check_v3 # jump to check v3

.v2_bigger:
    # first = v2, second = v1
    movw %si, %r8w # first = v2
    movw %di, %r9w # second = v1

.check_v3:
    cmpw %r8w, %dx # compare v3 - first
    jle .v3_not_first # jump to .v3_not_first if v3 <= first
    movw %r8w, %r9w # second = first
    movw %dx, %r8w # first = v3
    jmp .check_v4 # jump to check v4

.v3_not_first:
    cmpw %r9w, %dx # compare v3 - second
    jle .check_v4 # jump to .check_v4 if v3 <= second
    movw %dx, %r9w # second = v3

.check_v4:
    cmpw %r8w, %cx # compare v4 - first
    jle .v4_not_first # jump to .v4_not_first if v4 <= first
    movw %r8w, %r9w # second = first
    movw %cx, %r8w # first = v4
    jmp .done # 

.v4_not_first:
    cmpw %r9w, %cx # compare v4 - second
    jle .done # jump to .done if v4 > second
    movw %cx, %r9w # second = v4

.done:
    movw %r9w, %ax # return second
    ret

# short secondMax(short v1, short v2, short v3, short v4){
#     short first, second;
#     if(v1 >= v2){ first = v1; second = v2; }
#     else        { first = v2; second = v1; }
#     if(v3 > first)       { second = first; first = v3; }
#     else if(v3 > second) { second = v3; }
#     if(v4 > first)       { second = first; first = v4; }
#     else if(v4 > second) { second = v4; }
#     return second;
# }
