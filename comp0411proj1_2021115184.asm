# -------------------------------------------------------------------

# [KNU COMP411 Computer Architecture] Skeleton code for the 1st project (calculator)

# -------------------------------------------------------------------





.data 

input_string : .space 17 #alloc 32bit input

enter_string: .string "\n"

error_string: .string "this is not operation. " # no input -> enter



.text	

# main

main:

	

	jal x1, test #functionality test, Do not modify!!

	

	#----TODO-------------------------------------------------------------
	#1. read a string from the console
	#2. perform arithmetic operations
	#3. print a string to the console to show the computation result
	#----------------------------------------------------------------------

	

	input_start: 

	

	addi a0, zero, 62		# '>'

	li a7, 11 # print

	ecall

	

	addi a0, zero, 32		# space

	li a7, 11

	ecall

	

	# read a string from the console (no input -> exit)

	la a0, input_string            

	li a1, 25

	li a7, 8

	ecall

	

	

	la s0, input_string

	li t0, 0

	li t1, 43 # '+'

	li t2, 45 # '-'

	li t3, 42 # '*'

	li t4, 47 # '/'

	

	li s1, 48		# checking operand / opcode //askicode '0'	

	li s3, 58		# '9' = 57

	

	li s4, 0		# sum1

	li s6, 0		# sum2

	

	#-----------------------------------------

	# input_string : 123+20 

	# 1. sum = 1 (문자 1  - '0' = 숫자 1)

	# 2. sum = 1*10 + 2 = 12

	# 3. sum = sum*10 + 3 = 123

	#-----------------------------------------

	

	# first operand

	valueLoop_first:

	add t5, s0, t0		# string's adress

	lb t6, 0(t5)		# string's value

	# 밑에서 숫자로 변환해줄 것 (아직 문자인 상태)

	

	# for check opcode or operation

	blt t6, s1, check_operation	# < 48 -> check_operation

	bge t6, s3, check_operation	# >= 58 -> check_operation

	

	neg s5, s1		# string -> int

	add t6, t6, s5

	

	li a2, 0		# a2 = sum1

	li a3, 10		

	li s7, 0		# s7 = j

	

	# sum1 = sum1 * 10

	Loop_Sum:

	add a2, a2, s4

	addi s7, s7, 1		# j++

	blt s7, a3, Loop_Sum	# if j < 10, go to Loop_Sum

		

	add s4, a2, t6		# sum1 = sum1 + (string->int 's result)

	

	addi t0, t0, 1		# i++  -> char 1byte

	beq zero, zero, valueLoop_first

	

	check_operation:# check opcode

	li a1, 0

	beq t6, t1, valueLoop_second		# if '+' : add

	li a1, 1

	beq t6, t2, valueLoop_second		# if '-' : sub

	li a1, 2

	beq t6, t3, valueLoop_second		# if '*' : mul

	li a1, 3

	beq t6, t4, valueLoop_second		# if '/' : div

	

	la a0, error_string			# none & enter -> error print, exit

	li a7, 4

	ecall

	

	beq zero, zero, Exit



	# second operand (same upper)

	valueLoop_second:

	addi t0, t0, 1		# count incre (i)

	add t5, s0, t0		# input string's adress

	lb t6, 0(t5)		# input_string's value(char)

	

	blt t6, s1, oper	# if (input_string != number) -> oper

	bge t6, s3, oper	

	

	neg s5, s1		# string -> int

	add t6, t6, s5

	

	li a2, 0		# a2 = sum2

	li a3, 10		

	li s7, 0		# s7 = j

	

	# sum2 = sum2 * 10

	Loop_Sum2:

	add a2, a2, s6

	addi s7, s7, 1		# j++

	blt s7, a3, Loop_Sum2	# if(j < 10) -> Loop_Sum

				

	add s6, a2, t6		# 숫자로 바꾼 것을 더해줌

	

	beq zero, zero, valueLoop_second

	

	oper:

	li a0, 0

	li a2, 0

	li a3, 0

	add a2, a2, s4

	add a3, a3, s6

	jal ra, calc

	

	

print:



	li t1, 43 # +

	li t2, 45 # -

	li t3, 42 # *

	li t4, 47 # /

		

	li t0, 0

	add t0, t0, a0			# save result value

	

	li a0, 0			# print first operand

	add a0, a0, a2

	li a7, 1

	ecall

	

	# print operation

	li t5, 0

	beq a1, t5, add_p		#a1 == 0 : +

	addi t5, t5, 1

	beq a1, t5, sub_p		#a1 == 1 : -

	addi t5, t5, 1

	beq a1, t5, mul_p		#a1 == 2 : *

	addi t5, t5, 1

	beq a1, t5, div_p		#a1 == 3 : /



	#<+>

	add_p:

	li a1, 43		

	beq zero, zero, ari_p

	

	#<->

	sub_p:

	li a1, 45		

	beq zero, zero, ari_p

	

	#<*>

	mul_p:

	li a1, 42		

	beq zero, zero, ari_p

	

	#</>

	div_p:

	li a1, 47		

	beq zero, zero, ari_p

	

	ari_p:

	li a0, 0			# print : operation

	add a0, a0, a1

	li a7, 11

	ecall

	li a0, 0			# print : second operand

	add a0, a0, a3 

	li a7, 1

	ecall

	

	

	addi a0, zero, 61		# print : =

	li a7, 11

	ecall

	

	li a0, 0			# print : result

	add a0, a0, t0

	li a7, 1

	ecall

	

	beq a1, t4, remainPrint		# if ( operation == "divison" ) -> print_remain

	

	la a0, enter_string

	li a7, 4

	ecall

	

	

	#--------------------------re-----------------------------------

	beq zero, zero, input_start

        

        remainPrint:

        addi a0, zero, 44	

	li a7, 11

	ecall

        

        addi a0, zero, 32		

	li a7, 11

	ecall

	

	li a0, 0			# print : result

	add a0, a0, a4

	li a7, 1

	ecall

	

	la a0, enter_string

	li a7, 4

	ecall

	

	beq zero, zero, input_start	

	

	Exit:

	

        li a0, 0

        li a7, 93

        ecall

        ebreak

	



#----------------------------------
#name: calc
#func: performs arithmetic operation
#x11(a1): arithmetic operation (0: addition, 1:  subtraction, 2:  multiplication, 3: division)
#x12(a2): the first operand
#x13(a3): the second operand
#x10(a0): return value
#x14(a4): return value (remainder for division operation)
#----------------------------------

calc:


	li t0, 0

	beq a1, t0, add_f

	li t0, 1

	beq a1, t0, sub_f

	li t0, 2

	beq a1, t0, mul_f

	li t0, 3

	beq a1, t0, div_f

	

	# add

	add_f:

		add a0, a2, a3

		jalr x0, 0(x1)

		

	# sub

	sub_f:

		neg t0, a3

		add a0, a2, t0

		jalr x0, 0(x1)

	

	# mul

	mul_f:

		li a0, 0		# a0 reset

		li t0, 0		# t0 = i

	

		add s6, zero, a2	# multiplicand

		add s7, zero, a3	# ㅅㅡㅇㅅㅜ

		li s8, 1		

		li s10, 32		# repeat 

		

		loopMul:

		add s9, zero, s7		

		and s9, s8, s9			

		beq s9, zero, shiftRight	
		add a0, a0, s6			

	

		shiftRight:

		slli s6, s6, 1			# shift left

		srli s7, s7, 1			# shift right

		addi t0, t0, 1			# i++

		blt t0, s10, loopMul		# if (i < 32) -> loop_mul

		

		jalr x0, 0(x1)

	

	#div

	div_f:			

		li t0, 0		# i

		li a0, 0		# quotient

		

		add s6, zero, a2	# rem

		add s7, zero, a3	# divisor

		li a4, 16		# 32bit

		sll s7, s7, a4

		li s9, 0		# quotient

		li s10, 17		# re

		li a4, 0		# reset remain

		

		loopDiv:

		neg s8, s7		# s8 = -s7

		add s6, s6, s8		# rem-div

		

		blt s6, zero, div2	

		slli s9, s9, 1		

		addi s9, s9, 1		

		beq x0, x0, div3

		

		div2:

		add s6, s6, s7		

		slli s9, s9, 1		

		

		div3:

		srli s7, s7, 1		# shift right

		

		addi t0, t0, 1		# i++

		blt t0, s10, loopDiv	# if(i < 17) -> loop_mul

		

		add a0, a0, s9

		add a4, a4, s6	

		jalr x0, 0(x1)

	

	





.include "common.asm"

