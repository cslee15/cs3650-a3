# Signature:
#   int main(int argc, char *argv[])
#   Takes two numbers from the command line, calls crunch on them,
#   and prints hat (negative), tea (zero), or beer (positive)
#   based on crunch's results.
#   Prints an error and returns 1 if not given exactly two numbers.
#
# Pseudocode:
#   if (argc != 3) {
#       puts("Two arguments required.");
#       return 1;
#   }
#   long a = atol(argv[1]);
#   long b = atol(argv[2]);
#   long result = crunch(a, b);
#   if (result < 0) {
#       puts("hat");
#   } else if (result == 0) {
#       puts("tea");
#   } else {
#       puts("beer");
#   }
#   return 0;
#
# Variable mappings:
#   argc   -> %rdi
#   argv   -> %rsi, saved in %r12 (needed after calling atol)
#   a      -> %r13 (needed after calling atol again)
#   b      -> %rsi (crunch's 2nd input)
#   result -> %rax (crunch's return value)

# Indicate the start of the code.
  .global main
  .text

# Save registers to use, set up stack frame, and save argv.
main:
  push %r12
  push %r13
  enter $0, $0
  mov %rsi, %r12

# Determine if argc is equal to 3. If not, jump to error.
  cmp $3, %rdi
  jne error

# If argc is equal to 3, move the second part of the input (first number)
# into %rdi, call atol to convert this into a number, and
# move the result into %r13.
  mov 8(%r12), %rdi
  call atol
  mov %rax, %r13

# Move the third part of the input (second number) into %rdi.
# Call atol to convert this into a number and move the result into
# %rsi.
  mov 16(%r12), %rdi
  call atol
  mov %rax, %rsi

# Move the first number into %rdi and call crunch.
  mov %r13, %rdi
  call crunch

# If result of crunch is less than 0, jump to is_hat.
# If result of crunch is equal to 0, jump to is_tea.
# If result of crunch is greater than 0, move $beer_msg into %rdi,
# print the message, and jump to end.
  cmp $0, %rax
  jl is_hat
  je is_tea
  mov $beer_msg, %rdi
  call puts
  jmp end

# Move $hat_msg into %rdi, print the message, and jump to end.
is_hat:
  mov $hat_msg, %rdi
  call puts
  jmp end

# Move $tea_msg into %rdi, print the message, and proceed to end.
is_tea:
  mov $tea_msg, %rdi
  call puts

# Move $0 into %rax to indicate success. Jump to done.
end:
  mov $0, %rax
  jmp done

# If argc is not equal to 3, move $error_msg into %rdi, print the message,
# and move $1 into %rax to indicate an unsuccessful run.
error:
  mov $error_msg, %rdi
  call puts
  mov $1, %rax

# Clean workspace, reset registers, and return to setup code.
done:
  leave
  pop %r13
  pop %r12
  ret 

# Create messages to print.
.data
error_msg:
  .asciz "Two arguments required."
hat_msg:
  .asciz "hat"
tea_msg:
  .asciz "tea"
beer_msg:
  .asciz "beer"
