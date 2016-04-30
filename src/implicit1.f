          SUBROUTINE IMPLICIT1(Y1,T01,H1,N1)
            DIMENSION X1(N1),WK1(N1*(3*N1+15)/2),PAR1(N1+1),Y1(N1)
         EXTERNAL FCN1
C ITERATION SCHEME FOR BACKWARD EULER APPROXMIATION
C OF AN INITIAL VECTOR VALUED PROBLEM
C ITERATION SCHEME IS BASED ON ON A QUASI-NEWTON
C METHOD IN AN 1984 IMSL SUBROUTINE.
C REFERENCE IS THE MINIPACK PACKAGE
C  BASED ON POWELL'S HYBRID ALGORITHM WHICH USES A FINITE DIFFERENCE
C APPROX. TO THE JACOBIAN AND TAKES PERCAUTIONS TO AVOID LARGE STEP SIZES
C OR INCREASING RESIDUALS
C X(*)=INITIAL STARTING VECTOR FOR QUASI NEWTON METHOD
C THE CLOSER THE GUESS,THE FASTER IT CONVERGES.
         do i=1,N1
         X1(i)=1.0*Y1(i)
         
        PAR1(i)=Y1(i)
       enddo
            PAR1(N1+1)=H1
          NSIG1=3
            ITMAX1=200
           write(6,*)'in implicit1'
          CALL ZSPOW1(FCN1,NSIG1,N1,ITMAX1,PAR1,X1,FNORM1,WK1,IER1)
       IF(IER1 .EQ. 131)then
        write(*,*)'implicit1',X1(1),X1(2),Y1(1),Y1(2)
        stop
        endif
      DO 10 I=1,N1
       Y1(I)=X1(I)
10     CONTINUE
c     write(6,*)y(1),y(2)
c               WRITE(27,22)
22          FORMAT('IMPLICIT SCHEME 1')
            RETURN
            END