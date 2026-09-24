.global mult7div8
# a in %dil (signed char), overflow pointer in %rsi; result in %eax
mult7div8:
  movb %dil, %al # %al = mult = a
  shlb $3, %al # mult = mult << 3 = 8 * a
  subb %dil, %al # mult = 8 * a - a = 7 * a
  testb %dil, %dil # test a
  jg .left # check rest of left side if a > 0
  jl .right # check rest of right side if a < 0
  jmp .else # fallthrough for == 0 case

.left:
  testb %al, %al # test mult
  jg .else # jump to else if mult > 0
  movl $1, (%rsi) # *overflow = 1
  jmp .end
  
.right:
  testb %al, %al # test mult
  jl .else # jump to else if mult < 0
  movb $1, (%rsi) # *overflow = 1
  jmp .end

.else:
  movb $0, (%rsi) # *overflow = 0

.end:
  # since we wanna divide mult by 8, the bias is 7 via 2^k-1
  movb %al, %cl
  sarb $7, %cl      # %cl = 0x00 if mult >= 0, 0xFF if mult < 0
  andb $7, %cl      # %cl = 0 or 7
  addb %cl, %al     # mult += bias
  sarb $3, %al      # signed divide by 8


# char mult7div8(char a, char *overflow){
#     char mult = (7 * a);
#     if(a > 0 && mult < 0 || a < 0 && mult > 0)
#       *overflow = 1;
#     else
#       *overflow = 0;
#     return mult/8;
# }
