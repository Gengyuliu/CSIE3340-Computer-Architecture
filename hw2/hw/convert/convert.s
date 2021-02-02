.global convert
.type convert, %function

.align 2
# int convert(char *);
convert:

    # insert your code here
  	addi	sp, sp, -48
	sd	s0, 40(sp)
	addi	s0, sp, 48
	sd	a0, -40(s0)	#store char *s
	sw	zero, -24(s0)
	sw	zero, -28(s0)
	ld	a5, -40(s0)
	lbu	a5, 0(a5)
	mv 	a4, a5		#a4 = s[0]
	li	a5, 45		#a5 = 45('+')
	bne	a4, a5, L1
	li	a5, 1		#sign<-a5 = 1
	sw	a5, -28(s0)
	j	L2
L1:
	ld	a5, -40(s0)
	lbu	a5, 0(a5)
	mv	a4, a5		#a4 <- a5 = s[0]
	li	a5, 47		#a5 = 47 
	bgeu	a5, a4, L2	#if a5 >= a4, go to L2
	ld 	a5, -40(s0)	#a5 <- sum = s[0]	
	lbu	a5, 0(a5)
	mv 	a4, a5		#a4 <- a5 = s[0]
	li	a5, 57		
	bltu	a5, a4, L2	#if a5 < a4, go to L2
	ld	a5, -40(s0)	#a5 = s
	lbu	a5, 0(a5)	#a5 = s[0]
	sext.w	a5, a5
	addiw	a5, a5, -48	#a5 = a5 - 48
	sw	a5, -24(s0)	
L2:
	li	a5, 1
	sw	a5, -20(s0)
	j	L3
L7:
	lw	a5, -20(s0)
	ld	a4, -40(s0)
	add	a5, a5, a4
	lbu	a5, 0(a5)
	mv 	a4, a5
	li	a5, 47
	bgeu 	a5, a4, L4
	lw	a5, -20(s0)
	ld	a4, -40(s0)
	add	a5, a5, a4
	lbu	a5, 0(a5)
	mv	a4, a5
	li	a5, 57
	bltu	a5, a4, L4
	lw	a5, -20(s0)
	ld	a4, -40(s0)
	add	a5, a5, a4
	lbu	a5, 0(a5)
	sext.w	a5, a5
	addiw	a5, a5, -48
	sw	a5, -32(s0)
	lw	a4, -24(s0)
	mv	a5, a4
	slliw	a5, a5, 0x2
	addw	a5, a5, a4
	slliw	a5, a5, 0x1
	sext.w	a5, a5
	lw	a4, -32(s0)
	addw	a5, a5, a4
	sw	a5, -24(s0)
	lw	a5, -20(s0)
	addiw	a5, a5, 1
	sw	a5, -20(s0)
    	j	L3
L4:
	li	a5, -1
	j 	L5
L3:
	lw	a5, -20(s0)
	sext.w	a4, a5
	li	a5, 14
	blt	a5, a4, L6
	lw	a5, -20(s0)
	ld	a4, -40(s0)
	add	a5, a5, a4
	lbu	a5, 0(a5)
	bnez	a5, L7
L6:
	lw	a5, -28(s0)
	sext.w  a4, a5
	li 	a5, 1
	bne	a4, a5, L8
	lw	a5, -24(s0)
	negw	a5,a5
	sw	a5, -24(s0)
L8:
	lw	a5, -24(s0)
L5:
	mv	a0, a5
	ld	s0, 40(sp)
	addi	sp, sp, 48
	ret

