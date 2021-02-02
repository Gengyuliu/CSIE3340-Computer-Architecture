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
   				#a0 <- n
	addi 	sp, sp, -48
	sd  	ra, 40(sp)
	sd	s0, 32(sp)
	sd	s1, 24(sp)
	addi	s0, sp, 48
	
	mv	a5, a0
	sw	a5, -36(s0)
	lw	a5, -36(s0)
	sext.w	a4, a5		#sign extension
	li	a5, 1		#a5 = 1
	blt	a5, a4, L1	#if n > 1, go to L1
	j	L2
L1:	
	lw	a5, -36(s0)	#a5 = n
	addiw	a5, a5, -1	#a5 = n-1
	sext.w	a5,a5
	mv 	a0, a5
	jal	ra, fibonacci	#fibo(n-1)
	mv	s1, a0		#store fibo(n-1)
	lw 	a5, -36(s0)	#a5 = n
	addiw	a5, a5, -2	#a5 = n-2
	sext.w	a5, a5
	mv	a0, a5
	jal	ra, fibonacci	#fibo(n-2)
	mv	a5, a0		#a5 = fibo(n-2)
	add	a5, a5, s1
	mv	a0, a5
L2:	
	
	sext.w	a0, a0	
	ld	ra, 40(sp)
	ld	s0, 32(sp)
	ld	s1, 24(sp)
	addi	sp, sp, 48
	ret	
