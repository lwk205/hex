       subroutine transform(nss,slip_n0,slip_s0,slip_n0_t,slip_s0_t,  !added WML 91109  
	1            var_no)
     
       common /wblock10/ng,grain_mo(1000,3),bv(1000,87),nssmat(1000)  !added WML 91109  
	1            ,nssimmat(1000)
	  common /cleavage_plane/ cleave_n(1000,3,3)
	  common /cleavage_plane0/ cleave_n0(3,3)
       dimension slip_n0(1000,nss,3), slip_s0(1000,nss,3)!changed WML 91109
       dimension slip_n0_t(1000,nss,3),slip_s0_t(1000,nss,3)
       real  M_mo(3,3),M_mo1(63,3,3),M_mo2(3,3), vecnrm
	   integer var_no(1000) 
	   real cleave_n, cleave_n0

c      Tarek :: check for the transformation 
	   open(66,file = 'check_transform.out', status = 'unknown')

       data (((M_mo1(i,j,k), k = 1, 3), j = 1, 3), i = 1, 63)
     >      / 1.0 , 0.0 , 0.0,  0.0, 1.0, 0.0,  0.0, 0.0, 1.0, 
     > .7416, .6498, .1667,-.6667, .7416, .0749,-.0749,-.1667, .9832,
     > .0749,-.1667, .9832, .6667, .7416, .0749,-.7416, .6498, .1667,
     >-.6667, .7416, .0749,-.0749,-.1667, .9832, .7416, .6498, .1667,
     > .6667, .7416, .0749,-.7416, .6498, .1667, .0749,-.1667, .9832,
     >-.0749,-.1667, .9832, .7416, .6498, .1667,-.6667, .7416, .0749,
     >-.7416, .6498, .1667, .0749,-.1667, .9832, .6667, .7416, .0749,
     >-.0749,-.1667, .9832, .6667,-.7416,-.0749, .7416, .6498, .1667,
     >-.7416, .6498, .1667,-.6667,-.7416,-.0749, .0749,-.1667, .9832,
     > .7416, .6498, .1667, .0749, .1667,-.9832,-.6667, .7416, .0749,
     > .0749,-.1667, .9832, .7416,-.6498,-.1667, .6667, .7416, .0749,
     >-.6667, .7416, .0749,-.7416,-.6498,-.1667,-.0749,-.1667, .9832,
     > .6667, .7416, .0749,-.0749, .1667,-.9832,-.7416, .6498, .1667,
     > .6667,-.7416,-.0749, .7416, .6498, .1667,-.0749,-.1667, .9832,
     >-.6667,-.7416,-.0749, .0749,-.1667, .9832,-.7416, .6498, .1667,
     > .0749, .1667,-.9832,-.6667, .7416, .0749, .7416, .6498, .1667,
     > .7416,-.6498,-.1667, .6667, .7416, .0749, .0749,-.1667, .9832,
     >-.7416,-.6498,-.1667,-.0749,-.1667, .9832,-.6667, .7416, .0749,
     >-.0749, .1667,-.9832,-.7416, .6498, .1667, .6667, .7416, .0749,
     > .7416, .6498, .1667,-.0749,-.1667, .9832, .6667,-.7416,-.0749,
     > .0749,-.1667, .9832,-.7416, .6498, .1667,-.6667,-.7416,-.0749,
     >-.6667, .7416, .0749, .7416, .6498, .1667, .0749, .1667,-.9832,
     > .6667, .7416, .0749, .0749,-.1667, .9832, .7416,-.6498,-.1667,
     >-.0749,-.1667, .9832,-.6667, .7416, .0749,-.7416,-.6498,-.1667,
     >-.7416, .6498, .1667, .6667, .7416, .0749,-.0749, .1667,-.9832,
     >-.7071, .4082, .5774,   0.0,-.8165, .5774, .7071, .4082, .5774,
     >   0.0,-.8165, .5774, .7071, .4083, .5774,-.7071, .4082, .5774,
     > .7071, .4082, .5774,-.7071, .4083, .5774,   0.0,-.8165, .5774,
     >   0.0,-.8165, .5774, .7071, .4082, .5774,-.7071, .4082, .5774,
     > .7071, .4083, .5774,-.7071, .4082, .5774,   0.0,-.8165, .5774,
     >-.7071, .4083, .5774,   0.0,-.8165, .5774, .7071, .4082, .5774,
     > .7071, .4082, .5774,-.7071, .4082, .5774,   0.0,-.8165, .5774,
     >-.7071, .4082, .5774,   0.0,-.8165, .5774, .7071, .4083, .5774,
     >   0.0,-.8165, .5774, .7071, .4082, .5774,-.7071, .4083, .5774,
     > .7071, .4082, .5774,   0.0, .8165,-.5774,-.7071, .4082, .5774,
     >-.7071, .4082, .5774,-.7071,-.4083,-.5774,   0.0,-.8165, .5774,
     >   0.0,-.8165, .5774, .7071,-.4083,-.5774, .7071, .4082, .5774,
     >-.7071, .4082, .5774,-.7071,-.4082,-.5774,   0.0,-.8165, .5774,
     >   0.0,-.8165, .5774, .7071,-.4082,-.5774, .7071, .4083, .5774,
     > .7071, .4082, .5774,   0.0, .8165,-.5774,-.7071, .4083, .5774,
     >   0.0,-.8165, .5774, .7071,-.4082,-.5774, .7071, .4082, .5774,
     > .7071, .4083, .5774,   0.0, .8165,-.5774,-.7071, .4082, .5774,
     >-.7071, .4083, .5774,-.7071,-.4082,-.5774,   0.0,-.8165, .5774,
     >   0.0, .8165,-.5774,-.7071, .4082, .5774, .7071, .4082, .5774,
     >-.7071,-.4083,-.5774,   0.0,-.8165, .5774,-.7071, .4082, .5774,
     > .7071,-.4083,-.5774, .7071, .4082, .5774,   0.0,-.8165, .5774,
     >-.7071,-.4082,-.5774,   0.0,-.8165, .5774,-.7071, .4082, .5774,
     > .7071,-.4082,-.5774, .7071, .4083, .5774,   0.0,-.8165, .5774,
     >   0.0, .8165,-.5774,-.7071, .4083, .5774, .7071, .4082, .5774,
     > .7071,-.4082,-.5774, .7071, .4082, .5774,   0.0,-.8165, .5774,
     > .7071,-.4082,-.5774, .7071, .4082, .5774,   0.0,-.8165, .5774,
     >-.7071,-.4082,-.5774,   0.0,-.8165, .5774,-.7071, .4083, .5774,
     >-.7071, .4082, .5774, .7071, .4082, .5774,   0.0, .8165,-.5774,
     >   0.0,-.8165, .5774,-.7071, .4082, .5774,-.7071,-.4083,-.5774,
     > .7071, .4082, .5774,   0.0,-.8165, .5774, .7071,-.4083,-.5774,
     >   0.0,-.8165, .5774,-.7071, .4082, .5774,-.7071,-.4082,-.5774,
     > .7071, .4083, .5774,   0.0,-.8165, .5774, .7071,-.4082,-.5774,
     >-.7071, .4083, .5774, .7071, .4082, .5774,   0.0, .8165,-.5774,
     > .7071, .4082, .5774,   0.0,-.8165, .5774, .7071,-.4082,-.5774,
     >-.7071, .4082, .5774, .7071, .4083, .5774,   0.0, .8165,-.5774,
     >   0.0,-.8165, .5774,-.7071, .4083, .5774,-.7071,-.4082,-.5774,
     > 1.0 , 0.0 , 0.0,  0.0, 1.0, 0.0,  0.0, 0.0, 1.0,
     > 1.0 , 0.0 , 0.0,  0.0, 1.0, 0.0,  0.0, 0.0, 1.0/


*
* phi1, phi2, phi3 are Euler angles, where phi3 = capital phi
* see V. Randle "The measurment of grain boundar geometry"
*

       do ig = 1, ng

          write(66,*) 'material number    ',ig
		  phi1 = grain_mo(ig,1)
          phi2 = grain_mo(ig,2)
          phi3 = grain_mo(ig,3)

c          write(66,*) phi1, phi2, phi3

          M_mo(1,1) = cos(phi1)*cos(phi2) - 
     >                sin(phi1)*sin(phi2)*cos(phi3)
          M_mo(1,2) = sin(phi1)*cos(phi2) + 
     >                cos(phi1)*sin(phi2)*cos(phi3)
          M_mo(1,3) = sin(phi2)*sin(phi3)
          M_mo(2,1) = -cos(phi1)*sin(phi2) - 
     >                sin(phi1)*cos(phi2)*cos(phi3)
          M_mo(2,2) = -sin(phi1)*sin(phi2) + 
     >                cos(phi1)*cos(phi2)*cos(phi3)
          M_mo(2,3) = cos(phi2)*sin(phi3)
          M_mo(3,1) = sin(phi1)*sin(phi3)
          M_mo(3,2) = -cos(phi1)*sin(phi3)
          M_mo(3,3) = cos(phi3)
        
		  j = var_no(ig)+1

		  M_mo2(1,1) = M_mo(1,1)*M_mo1(j,1,1) + 
     >                 M_mo(1,2)*M_mo1(j,2,1) +  
     >                 M_mo(1,3)*M_mo1(j,3,1)
		  M_mo2(1,2) = M_mo(1,1)*M_mo1(j,1,2) + 
     >                 M_mo(1,2)*M_mo1(j,2,2) +  
     >                 M_mo(1,3)*M_mo1(j,3,2)
		  M_mo2(1,3) = M_mo(1,1)*M_mo1(j,1,3) + 
     >                 M_mo(1,2)*M_mo1(j,2,3) +  
     >                 M_mo(1,3)*M_mo1(j,3,3)

		  M_mo2(2,1) = M_mo(2,1)*M_mo1(j,1,1) + 
     >                 M_mo(2,2)*M_mo1(j,2,1) +  
     >                 M_mo(2,3)*M_mo1(j,3,1)
		  M_mo2(2,2) = M_mo(2,1)*M_mo1(j,1,2) + 
     >                 M_mo(2,2)*M_mo1(j,2,2) +  
     >                 M_mo(2,3)*M_mo1(j,3,2)
		  M_mo2(2,3) = M_mo(2,1)*M_mo1(j,1,3) + 
     >                 M_mo(2,2)*M_mo1(j,2,3) +  
     >                 M_mo(2,3)*M_mo1(j,3,3)

		  M_mo2(3,1) = M_mo(3,1)*M_mo1(j,1,1) + 
     >                 M_mo(3,2)*M_mo1(j,2,1) +  
     >                 M_mo(3,3)*M_mo1(j,3,1)
		  M_mo2(3,2) = M_mo(3,1)*M_mo1(j,1,2) + 
     >                 M_mo(3,2)*M_mo1(j,2,2) +  
     >                 M_mo(3,3)*M_mo1(j,3,2)
		  M_mo2(3,3) = M_mo(3,1)*M_mo1(j,1,3) + 
     >                 M_mo(3,2)*M_mo1(j,2,3) +  
     >                 M_mo(3,3)*M_mo1(j,3,3)
        
          write(66,*) M_mo2(1,1),M_mo2(1,2),M_mo2(1,3)
          write(66,*) M_mo2(2,1),M_mo2(2,2),M_mo2(2,3)
          write(66,*) M_mo2(3,1),M_mo2(3,2),M_mo2(3,3)
		  
		  do i = 1, 3
		  
		  cleave_n(ig,i,1) = M_mo2(1,1)*cleave_n0(i,1) + 
     >                           M_mo2(1,2)*cleave_n0(i,2) + 
     >                      M_mo2(1,3)*cleave_n0(i,3)
		  cleave_n(ig,i,2) = M_mo2(2,1)*cleave_n0(i,1) + 
     >                           M_mo2(2,2)*cleave_n0(i,2) + 
     >                      M_mo2(2,3)*cleave_n0(i,3)
		  cleave_n(ig,i,3) = M_mo2(3,1)*cleave_n0(i,1) + 
     >                           M_mo2(3,2)*cleave_n0(i,2) + 
     >                      M_mo2(3,3)*cleave_n0(i,3)

          
		  end do
		  
		  do i = 1, nssmat(ig)
		  vecnrm = sqrt(slip_n0(ig,i,1)**2.0+
     >                          slip_n0(ig,i,2)**2.0+
     >                          slip_n0(ig,i,3)**2.0)
             slip_n0_t(ig,i,1) = M_mo2(1,1)*slip_n0(ig,i,1) + 
     >                           M_mo2(1,2)*slip_n0(ig,i,2) + 
     >                      M_mo2(1,3)*slip_n0(ig,i,3)
             slip_n0_t(ig,i,1) = slip_n0_t(ig,i,1)/vecnrm
			 slip_n0_t(ig,i,2) = M_mo2(2,1)*slip_n0(ig,i,1) + 
     >                           M_mo2(2,2)*slip_n0(ig,i,2) + 
     >                       M_mo2(2,3)*slip_n0(ig,i,3)
             slip_n0_t(ig,i,2) = slip_n0_t(ig,i,2)/vecnrm
			 slip_n0_t(ig,i,3) = M_mo2(3,1)*slip_n0(ig,i,1) + 
     >                           M_mo2(3,2)*slip_n0(ig,i,2) + 
     >                       M_mo2(3,3)*slip_n0(ig,i,3)

             slip_n0_t(ig,i,3) = slip_n0_t(ig,i,3)/vecnrm
			 vecnrm = sqrt(slip_s0(ig,i,1)**2.0+
     >                          slip_s0(ig,i,2)**2.0+
     >                          slip_s0(ig,i,3)**2.0)
			 slip_s0_t(ig,i,1) = M_mo2(1,1)*slip_s0(ig,i,1) + 
     >                           M_mo2(1,2)*slip_s0(ig,i,2) + 
     >                       M_mo2(1,3)*slip_s0(ig,i,3)
             slip_s0_t(ig,i,1) = slip_s0_t(ig,i,1)/vecnrm
			 slip_s0_t(ig,i,2) = M_mo2(2,1)*slip_s0(ig,i,1) + 
     >                           M_mo2(2,2)*slip_s0(ig,i,2) + 
     >                       M_mo2(2,3)*slip_s0(ig,i,3)
             slip_s0_t(ig,i,2) = slip_s0_t(ig,i,2)/vecnrm
			 slip_s0_t(ig,i,3) = M_mo2(3,1)*slip_s0(ig,i,1) + 
     >                           M_mo2(3,2)*slip_s0(ig,i,2) + 
     >                       M_mo2(3,3)*slip_s0(ig,i,3)
			 slip_s0_t(ig,i,3) = slip_s0_t(ig,i,3)/vecnrm


	
	write(66,*) slip_s0_t(ig,i,1),slip_s0_t(ig,i,2),slip_s0_t(ig,i,3)
	write(66,*) slip_n0_t(ig,i,1),slip_n0_t(ig,i,2),slip_n0_t(ig,i,3)

          
		  
		  end do

       end do

	   close(66)
       return
       end


                    
       