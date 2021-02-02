.global matrix_mul
.type matrix_mul, %function

.align 2
# void matrix_mul(unsigned int A[][], unsigned int B[][], unsinged int C[][]);
matrix_mul:
    
    # insert code here
    	# Matrix multiplication: https://en.wikipedia.org/wiki/Matrix_multiplication
	#This is the one using blocking to keep register reused twice
	#Mostly based on https://en.wikipedia.org/wiki/Loop_nest_optimization	

	addi	sp,sp,-80
	sd	s0,72(sp)
	addi	s0,sp,80
	sd	a0,-56(s0)
	sd	a1,-64(s0)
	sd	a2,-72(s0)
	sw	zero,-28(s0)
	j	lp1 
L1:
	sw	zero,-32(s0)
	j	lp2
L2:
	sh	zero,-18(s0)
	sh	zero,-20(s0)
	sh	zero,-22(s0)
	sh	zero,-24(s0)
	sw	zero,-36(s0)
	j	lp3
L3:
	lw	a5,-28(s0)
	slli	a5,a5,0x8
	ld	a4,-64(s0)
	add	a4,a4,a5
	lw	a5,-36(s0)
	slli	a5,a5,0x1
	add	a5,a5,a4
	lhu	a4,0(a5)
	lw	a5,-36(s0)
	slli	a5,a5,0x8
	ld	a3,-72(s0)
	add	a3,a3,a5
	lw	a5,-32(s0)
	slli	a5,a5,0x1
	add	a5,a5,a3
	lhu	a5,0(a5)
	mulw	a5,a4,a5
	slli	a5,a5,0x30
	srli	a5,a5,0x30
	lhu	a4,-18(s0)
	addw	a5,a5,a4
	sh	a5,-18(s0)
	lw	a5,-28(s0)
	slli	a5,a5,0x8
	ld	a4,-64(s0)
	add	a4,a4,a5
	lw	a5,-36(s0)
	slli	a5,a5,0x1
	add	a5,a5,a4
	lhu	a4,0(a5)
	lw	a5,-36(s0)
	slli	a5,a5,0x8
	ld	a3,-72(s0)
	add	a3,a3,a5
	lw	a5,-32(s0)
	addiw	a5,a5,1
	sext.w	a5,a5
	slli	a5,a5,0x1
	add	a5,a5,a3
	lhu	a5,0(a5)
	mulw	a5,a4,a5
	slli	a5,a5,0x30
	srli	a5,a5,0x30
	lhu	a4,-20(s0)
	addw	a5,a5,a4
	sh	a5,-20(s0)
	lw	a5,-28(s0)
	addi	a5,a5,1
	slli	a5,a5,0x8
	ld	a4,-64(s0)
	add	a4,a4,a5
	lw	a5,-36(s0)
	slli	a5,a5,0x1
	add	a5,a5,a4
	lhu	a4,0(a5)
	lw	a5,-36(s0)
	slli	a5,a5,0x8
	ld	a3,-72(s0)
	add	a3,a3,a5
	lw	a5,-32(s0)
	slli	a5,a5,0x1
	add	a5,a5,a3
	lhu	a5,0(a5)
	mulw	a5,a4,a5
	slli	a5,a5,0x30
	srli	a5,a5,0x30
	lhu	a4,-22(s0)
	addw	a5,a5,a4
	sh	a5,-22(s0)
	lw	a5,-28(s0)
	addi	a5,a5,1
	slli	a5,a5,0x8
	ld	a4,-64(s0)
	add	a4,a4,a5
	lw	a5,-36(s0)
	slli	a5,a5,0x1
	add	a5,a5,a4
	lhu	a4,0(a5)
	lw	a5,-36(s0)
	slli	a5,a5,0x8
	ld	a3,-72(s0)
	add	a3,a3,a5
	lw	a5,-32(s0)
	addiw	a5,a5,1
	sext.w	a5,a5
	slli	a5,a5,0x1
	add	a5,a5,a3
	lhu	a5,0(a5)
	mulw	a5,a4,a5
	slli	a5,a5,0x30
	srli	a5,a5,0x30
	lhu	a4,-24(s0)
	addw	a5,a5,a4
	sh	a5,-24(s0)
	lw	a5,-36(s0)
	addiw	a5,a5,1
	sw	a5,-36(s0)
lp3:
	lw	a5,-36(s0)
	sext.w	a4,a5
	li	a5,127
	bge	a5,a4, L3
	lw	a5,-28(s0)
	slli	a5,a5,0x8
	ld	a4,-56(s0)
	add	a4,a4,a5
	lw	a5,-32(s0)
	slli	a5,a5,0x1
	add	a5,a5,a4
	lhu	a4,-18(s0)
	sh	a4,0(a5)
	lw	a5,-28(s0)
	slli	a5,a5,0x8
	ld	a4,-56(s0)
	add	a4,a4,a5
	lw	a5,-32(s0)
	addiw	a5,a5,1
	sext.w	a5,a5
	slli	a5,a5,0x1
	add	a5,a5,a4
	lhu	a4,-20(s0)
	sh	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,1
	slli	a5,a5,0x8
	ld	a4,-56(s0)
	add	a4,a4,a5
	lw	a5,-32(s0)
	slli	a5,a5,0x1
	add	a5,a5,a4
	lhu	a4,-22(s0)
	sh	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,1
	slli	a5,a5,0x8
	ld	a4,-56(s0)
	add	a4,a4,a5
	lw	a5,-32(s0)
	addiw	a5,a5,1
	sext.w	a5,a5
	slli	a5,a5,0x1
	add	a5,a5,a4
	lhu	a4,-24(s0)
	sh	a4,0(a5)
	lw	a5,-32(s0)
	addiw	a5,a5,2
	sw	a5,-32(s0)
lp2:
	lw	a5,-32(s0)
	sext.w	a4,a5
	li	a5,127
	bge	a5,a4, L2 
	lw	a5,-28(s0)
	addiw	a5,a5,2
	sw	a5,-28(s0)
lp1:
	lw	a5,-28(s0)
	sext.w	a4,a5
	li	a5,127
	bge	a5,a4, L1
	nop
	ld	s0,72(sp)
	addi	sp,sp,80
	ret	
