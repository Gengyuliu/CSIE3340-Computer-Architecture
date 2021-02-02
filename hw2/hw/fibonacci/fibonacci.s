.global fibonacci
.type fibonacci, %function
.align 2
# unsigned long long int fibonacci(int n){
#	if (n <= 1)
#		return n;
#	else
#		return fib(n-1) + fib(n-2)
#}
fibonacci:  
    # insert code here
   				#a0 <- memo[0], a1 <- n
	addi 	sp, sp, -48
	sd  	ra, 40(sp)
	sd	s0, 32(sp)
	sd	s1, 24(sp)
	addi	s0, sp, 48
	sd	a0, -40(s0)	#	
		
	mv	a5, a1
	sw	a5, -44(s0)
	lw	a5, -44(s0)
	slli	a5, a5, 0x3
	ld	a4, -40(s0)
	add	a5, a5, a4
	ld	a5, 0(a5)
	beqz	a5, L1
	lw	a5, -44(s0)
	slli	a5, a5, 0x3
	ld	a4, -40(s0)
	add	a5, a5, a4
	ld	a5, 0(a5)
	j	L2
L1:
	lw	a5, -44(s0)
	sext.w	a4, a5
	li	a5, 1
	blt	a5, a4, L3
	lw	a5, -44(s0)
	slli	a5, a5, 0x3
	ld 	a4, -40(s0)
	add	a5, a5, a4
	lw	a4, -44(s0)
	sd	a4, 0(a5)
	lw	a5, -44(s0)
	j	L2
L3:
	lw	a5, -44(s0)
	addiw	a5, a5, -1
	sext.w 	a5, a5
	mv 	a1, a5
	ld	a0, -40(s0)	
	jal	ra, fibonacci
	mv 	s1, a0
	lw	a5, -44(s0)
	addiw	a5, a5, -2
	sext.w	a5, a5
	mv	a1, a5
	ld	a0, -40(s0)
	jal	ra, fibonacci
	mv	a3, a0
	lw	a5, -44(s0)
	slli	a5, a5, 0x3
	ld 	a4, -40(s0)
	add	a5, a5, a4
	add 	a4, s1, a3
	sd	a4, 0(a5)
	lw	a5, -44(s0)
	slli	a5, a5, 0x3
	ld	a4, -40(s0)
	add	a5, a5, a4
	ld 	a5, 0(a5)
L2:
	mv	a0, a5
	ld	ra, 40(sp)
	ld	s0, 32(sp)
	ld	s1, 24(sp)
	addi	sp, sp, 48
	ret	
