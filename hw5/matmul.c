// See LICENSE for license details.

#include "dataset.h"
#include "util.h"
#include <stddef.h>
#include <stdio.h>
#pragma GCC optimize ("unroll-loops")


void __attribute__((noinline)) matmul(const size_t coreid, const size_t ncores, const size_t lda,  const data_t A[], const data_t B[], data_t C[])
{
  //size_t i, j, k;
  //size_t ii, jj, kk;
  //size_t block = lda / ncores;
  //size_t start = block * coreid;
   size_t i, k;
   size_t j = coreid*(lda/ncores);
   size_t jend = (coreid+1)*(lda/ncores);
   for ( ; j < jend; j++ )
   {
      size_t j32 = j << 6;
      data_t* Cj32 = C + j32;
      for ( k = 0; k < lda; k+=2 )
      {
         data_t Aj32k  = A[k + j32];
         data_t Aj32k2 = A[k + 1 + j32];
         data_t* Bk32  = B + (k << 6);
         data_t* Bk322 = Bk32 + 64;
         for ( i = 0; i < lda; i+=4 )
         {
            Cj32[i]   += Aj32k  * Bk32   [i];
            Cj32[i]   += Aj32k2 * Bk322  [i];
            Cj32[i+1] += Aj32k  * Bk32 [i+1];
            Cj32[i+1] += Aj32k2 * Bk322[i+1];
            Cj32[i+2] += Aj32k  * Bk32 [i+2];
            Cj32[i+2] += Aj32k2 * Bk322[i+2];
            Cj32[i+3] += Aj32k  * Bk32 [i+3];
            Cj32[i+3] += Aj32k2 * Bk322[i+3];
         }
         barrier(ncores);
      }
   }
   //size_t block = lda/ncores;
   //size_t start = block*coreid;
   //for (i = 0; i < lda; ++i){
   //     for (j = start; j < (start+block); ++j){
   //     	data_t sum = 0;
   //     	for (k = 0; k < lda; ++k){
   //     		sum += A[j*lda + k]*B[k*lda + i];
   //     	}
   //     	C[i + j*lda] = sum;
   //     }
   //}
   
   //for (i = 0; i < lda; ++i){
   //	for (j = start; j < (start+block); ++j){
   //     	printf("%d ", C[i+j*lda]);
   //     }
   //     printf("\n");
   //}
  
   
  //size_t BLK_SZ   = 4;
  //size_t BLK_SZ_k = 4; 
  //size_t i_idx, j_idx, k_idx;
  //for (i = 0; i < lda/BLK_SZ; ++i){
  //  for (j = start/BLK_SZ; j < (start+block)/BLK_SZ; ++j){
  //    for (k = 0; k < lda/BLK_SZ_k; ++k){
  //    	for (ii = 0; ii < BLK_SZ; ++ii){
  //        i_idx = i*BLK_SZ + ii;
  //        for (jj = 0; jj < BLK_SZ; ++jj){
  //          j_idx = j*BLK_SZ + jj;
  //          //#pragma unroll(4)
  //          for (kk = 0; kk < BLK_SZ_k; ++kk){
  //      	k_idx = k*BLK_SZ_k + kk;
  //          	C[i_idx+ j_idx*lda] += A[j_idx*lda + k_idx] + B[k_idx*lda + i_idx];
  //          }
  //        }
  //      }
  //    }
  //  }
  //}
}
