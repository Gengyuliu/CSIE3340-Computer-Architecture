.global matrix_mul
.type matrix_mul, %function

.align 2
# void matrix_mul(unsigned int A[][], unsigned int B[][], unsinged int C[][]);
matrix_mul:
    
    # insert code here
    # Green card here: https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf
    # Matrix multiplication: https://en.wikipedia.org/wiki/Matrix_multiplication
	#Naive computation	
	# for (i = 0; i < 127; ++i)
	#	for (j = 0; j < 127; ++j)
	#		for (k = 0; k < 127; ++k)
	#			C[i][j] += A[i][k]*B[k][j] % MOD
	addi	sp,sp,-64
	sd	s0,56(sp)
	addi	s0,sp,64
	sd	a0,-40(s0)	# store C[0][0]
	sd	a1,-48(s0)	# store A[0][0]
	sd	a2,-56(s0)	# store B[0][0]
	sw	zero,-20(s0)	# store i
	j	lp1 		# go to lp1, to check if i < 127
L1:
	sw	zero,-24(s0)	# store j
	j	lp2 
L2:
	sw	zero,-28(s0)	#store k
	j	lp3
L3:
	lw	a5,-20(s0)
	slli	a5,a5,0x8
	ld	a4,-40(s0)
	add	a4,a4,a5
	lw	a5,-24(s0)
	slli	a5,a5,0x1
	add	a5,a5,a4
	lhu	a5,0(a5)
	sext.w	a4,a5
	lw	a5,-20(s0)
	slli	a5,a5,0x8
	ld	a3,-48(s0)
	add	a3,a3,a5
	lw	a5,-28(s0)
	slli	a5,a5,0x1
	add	a5,a5,a3
	lhu	a5,0(a5)
	sext.w	a3,a5
	lw	a5,-28(s0)
	slli	a5,a5,0x8
	ld	a2,-56(s0)
	add	a2,a2,a5
	lw	a5,-24(s0)
	slli	a5,a5,0x1
	add	a5,a5,a2
	lhu	a5,0(a5)
	sext.w	a5,a5
	mulw	a5,a3,a5
	sext.w	a5,a5
	addw	a5,a5,a4
	sext.w	a5,a5
	mv	a4,a5
	sraiw	a5,a4,0x1f
	srliw	a5,a5,0x16
	addw	a4,a4,a5
	andi	a4,a4,1023
	subw	a5,a4,a5
	sext.w	a2,a5
	lw	a5,-20(s0)
	slli	a5,a5,0x8
	ld	a4,-40(s0)
	add	a3,a4,a5
	slli	a4,a2,0x30
	srli	a4,a4,0x30
	lw	a5,-24(s0)
	slli	a5,a5,0x1
	add	a5,a5,a3
	sh	a4,0(a5)
	lw	a5,-28(s0)
	addiw	a5,a5,1
	sw	a5,-28(s0)
lp3:
	lw	a5,-28(s0)
	sext.w	a4,a5
	li	a5,127
	bge	a5,a4,L3
	lw	a5,-24(s0)
	addiw	a5,a5,1
	sw	a5,-24(s0)
lp2:
	lw	a5,-24(s0)
	sext.w	a4,a5
	li	a5,127
	bge	a5,a4, L2
	lw	a5,-20(s0)
	addiw	a5,a5,1
	sw	a5,-20(s0)
lp1:
	lw	a5,-20(s0)
	sext.w	a4,a5
	li	a5,127
	bge	a5,a4, L1
	nop
	ld	s0,56(sp)
	addi	sp,sp,64
	ret	    
