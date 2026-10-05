# Signature:
#   unsigned long array_max(unsigned long n, unsigned long *items)
#   Takes the number of items and the address of the list.
#   Returns the biggest number in the list.
#
# Pseudocode:
#   unsigned long biggest = 0;
#   unsigned long i = 0;
#   while (i < n) {
#       if (items[i] > biggest) {
#           biggest = items[i];
#       }
#       i = i + 1;
#   }
#   return biggest;
#
# Variable mappings:
#   n       -> %rdi
#   items   -> %rsi
#   biggest -> %rax
#   i       -> %rcx
#   tmp     -> %rdx  (holds items[i])

# Indicate beginning of code.
    .global array_max
    .text

# Make biggest = 0 and i = 0
array_max:
    enter $0, $0
    mov $0, %rax
    mov $0, %rcx

# Compare i to n to determine if there are any more numbers to look at.
# If there aren't, jump to loop_end.
# If there are, compare the number at position i to the current biggest number.
# If it is bigger, enter that number into biggest.
# If not, jump to skip.
loop_top:
    cmp %rdi, %rcx
    jae loop_end

    mov (%rsi,%rcx,8), %rdx
    cmp %rax, %rdx
    jbe skip
    mov %rdx, %rax

# Move onto next number in the list and return to loop_top.
skip:
    add $1, %rcx
    jmp loop_top

# End the function.
loop_end:
    leave
    ret
    