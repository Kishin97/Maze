######################################SIDENOTES##########################################################
#Note: The logic used for deleting coins can be simplified since it is based on the player's position 
rather than the coin's position. However, I didn't have time to modify it and test a simplified version 
due to having to resynthesize Vivado when generating a new bitstream.
#########################################################################################################

.data 0x10010000 			# Start of data memory
a_sqr:	.space 4
a:	.word 3

.text 0x00400000			# Start of instruction memory
main:
	lui	$sp, 0x1001		# Initialize stack pointer to the 64th location above start of data
	ori 	$sp, $sp, 0x0100	# top of the stack is the word at address [0x100100fc - 0x100100ff]
	

	#starting position
	li	$t3, 20
	li	$t4, 27
	addi	$a1, $t3, 0
	addi	$a2, $t4, 0
	#(y*40 + x)*4	formula for calculating screen address
	addi	$t5, $0, 4400		
	addi	$t5, $t5, 0x10020000 	
	lw	$t1, 0($t5)		#screen address + offset 0
	li	$a0, 25
	jal pause
	#Set sound to 0 at beginning
	li $t8, 0
	sw $t8, 0x10030008($0)	#value of t8 can range from 8 to 15 to play  a sound (1000 to 1111),
	# lights defaulted to 0
	li $t9, 0		#value of t9 ranges from 0 to 8 since there are 8 coins and an LED lights up when one is collected
animate_loop:	
	li	$a0, 2			# draw character 2 here
	jal	putChar_atXY 		# $a0 is char, $a1 is X, $a2 is Y
	li	$a0, 12
	jal	pause
animate_loop_coin:
	li	$a0, 2			# draw character 2 here
	jal	putChar_atXY 		# $a0 is char, $a1 is X, $a2 is Y
	li	$a0, 25
	jal	pause
	li $t8, 0
	sw $t8, 0x10030008	#stop sound
	jal light
key_loop:	
	jal 	get_key			# get a key (if available)
	beq	$v0, $0, key_loop	# 0 means no valid key

key1:
	bne	$v0, 1, key2
	jal	smemaddr	#get position in screen memory
	lw	$t1, -4($t5)	#screen address + offset -4 (left)
	beq	$t1, 1, exit	#if charcode = 1 (player hit wall), exit loop
	bgt	$t3, 1, left	#if x > 1, go left
	j	key_loop
key2:
	bne	$v0, 2, key3
	jal	smemaddr
	lw	$t1,  4($t5)		#screen address + offset 4
	beq	$t1,4 , removeTopLeftAdjacentFromRight	#checks the charcode to see if it is the top left part of the coin
	beq	$t1, 6, removeBottomLeftAdjacentFromRight 
	beq	$t1, 1, exit	
	blt	$t3, 38, right  #if x < 38, go right	#compare with temporary regsiters, not $a1 and a2
	j	key_loop
		
key3:
	bne	$v0, 3, key4
	jal	smemaddr
	lw	$t1, -160($t5)		#screen address + offset -160
	beq	$t1, 5, removeBottomRightAdjacentFromUp	
	beq	$t1, 6, removeBottomLeftAdjacentFromUp
	beq	$t1, 1, exit
	bgt	$t4, 0, up	#if y > 1, go up	
	beq	$t4, 0, winCondition	#checks if user is at the end of the maze
	j	key_loop
key4:
	bne	$v0, 4, key_loop
	jal	smemaddr
	lw	$t1, 160($t5)		#screen address + offset 160
	beq	$t1, 3, removeTopRightAdjacentFromDown	#top right
	beq	$t1, 4, removeTopLeftAdjacentFromDown	#top left
	beq	$t1, 1, exit
	blt	$t4, 29, down	#if y < 29, go down
	beq	$t4, 29, endingReached #checks if the player has already reached the end of the maze
	j key_loop

#These methods are used to delete the coin characters adjacent 
#from the player's position prior to moving
removeTopRightAdjacentFromDown:		#means player is directly above the top right coin part and pressed down
	lw	$t1, 156($t5)	#delete top left
	li	$t7, 0
	sw	$t7, 156($t5)
	lw	$t1, 320($t5) #delete bottom right
	li	$t7, 0
	sw	$t7 320($t5)
	lw	$t1, 316($t5) #delete bottom left
	li	$t7, 0
	sw	$t7 316($t5)	
	blt $t4, 29, downCoin	
	j key_loop
removeTopLeftAdjacentFromDown:
	lw	$t1, 164($t5)	#delete top right
	li	$t7, 0
	sw	$t7, 164($t5)
	lw	$t1, 320($t5) #delete bottom left
	li	$t7, 0
	sw	$t7 320($t5)
	lw	$t1, 324($t5) #delete bottom right
	li	$t7, 0
	sw	$t7 324($t5)
	blt $t4, 29, downCoin
	j key_loop
removeBottomRightAdjacentFromUp:
	lw	$t1, -324($t5)	#delete top left
	li	$t7, 0
	sw	$t7, -324($t5)
	lw	$t1, -320($t5) #delete top right
	li	$t7, 0
	sw	$t7 -320($t5)
	lw	$t1, -164($t5) #delete bottom left
	li	$t7, 0
	sw	$t7 -164($t5)
	bgt	$t4, 0, upCoin	#if y > 1, go up	
	j key_loop
removeBottomLeftAdjacentFromUp:
	lw	$t1, -320($t5)	#delete top left
	li	$t7, 0
	sw	$t7, -320($t5)
	lw	$t1, -316($t5) #delete top right
	li	$t7, 0
	sw	$t7 -316($t5)
	lw	$t1, -156($t5) #delete bottom right
	li	$t7, 0
	sw	$t7 -156($t5)
	bgt	$t4, 0, upCoin	#if y > 1, go up	
	j key_loop
removeTopLeftAdjacentFromRight:
	lw	$t1, 8($t5)	#delete top right
	li	$t7, 0
	sw	$t7, 8($t5)
	lw	$t1, 164($t5) #delete bottom left
	li	$t7, 0
	sw	$t7 164($t5)
	lw	$t1, 168($t5) #delete bottom right
	li	$t7, 0
	sw	$t7 168($t5)
	blt	$t3, 38, rightCoin
	j key_loop
removeBottomLeftAdjacentFromRight:
	lw	$t1, -156($t5)	#delete top left
	li	$t7, 0
	sw	$t7, -156($t5)
	lw	$t1, -152($t5) #delete top right
	li	$t7, 0
	sw	$t7 -152($t5)
	lw	$t1, 8($t5) #delete bottom right
	li	$t7, 0
	sw	$t7  8($t5)
	blt	$t3, 38, rightCoin
	j key_loop

# (y * 40 + x) * 4 + screenmem
smemaddr:
sll	$t5, $t4, 5
sll	$t6, $t4, 3
add	$t5, $t6, $t5
add	$t5, $t5, $t3
sll	$t5, $t5, 2
addi	$t5, $t5, 0x10020000 	
jr $ra

left:
jal	blank
addi	$t3, $t3, -1 #decrement x position
addi	$a1, $t3, 0  #set x value to t3
j	animate_loop
right:
jal	blank
addi	$t3, $t3, 1
addi	$a1, $t3, 0	
j       animate_loop
up:
jal	blank
addi	$t4, $t4, -1
addi	$a2, $t4, 0
j	animate_loop
down:
jal	blank
addi	$t4, $t4, 1
addi	$a2, $t4, 0
j	animate_loop

downCoin:
jal	blank
li $t8, 15,	
sw $t8, 0x10030008($0) #play sound
addi	$t4, $t4, 1	
addi	$a2, $t4, 0
addi	$t9, $t9, 1	#increase number of lights displayed by 1
j	animate_loop_coin

upCoin:
jal	blank
li $t8, 14,		
sw $t8, 0x10030008($0)	
addi	$t4, $t4, -1
addi	$a2, $t4, 0
addi	$t9, $t9, 1
j	animate_loop_coin

rightCoin:
jal	blank
li $t8, 13,
sw $t8, 0x10030008($0)
addi	$t3, $t3, 1
addi	$a1, $t3, 0	
addi	$t9, $t9, 1
j       animate_loop_coin

exit:
li $t8, 9,
sw $t8, 0x10030008($0) #play sound when player hits wall
li $a0, 12
jal pause
li $t8, 0
sw $t8, 0x10030008($0)	#stop sound
j key_loop


light:
sw $t9, 0x1003000C($0)	#update number of lights
jr $ra

winCondition:
	beq $t3, 10, beginning	#send player to beginning of maze if they reached the end
	beq $t3, 11, beginning
	j key_loop
endingReached:
	beq $s4, 1,ending #if the player reached the end, allow them to move backwards from the starting position and go back to the end
	j key_loop 
beginning: # set the player's x and y coordinates to the beginning of the maze
	jal blank
	li $t3, 20
	li $t4, 29
	addi $a1, $t3, 0
	addi $a2, $t4, 0
	li $s4, 1
	j animate_loop
ending:	#set the player's x and y coordinates to the end of the maze
	jal blank	
	li $t3, 10
	li $t4, 0
	addi $a1, $t3, 0
	addi $a2, $t4, 0
	j animate_loop

#sets the character at (x,y) to the color of the background
blank:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	li	$a0, 0
	jal	putChar_atXY
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4	
	jr	$ra



	###############################
	# END using infinite loop     #
	###############################
	
				# program won't reach here, but have it for safety
end:
	j	end          	# infinite loop "trap" because we don't have syscalls to exit



######## END OF MAIN #################################################################################





.include "procs_board.asm"
#############################################################################################
