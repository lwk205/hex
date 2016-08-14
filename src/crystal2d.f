      program crystal2d                                                      nk
!c      use ieee_arithmetic
!     implicit double precision (a-h,o-z)                                    dp
!***********************************************************************
!                                                                      *
!                                                                      *
!                                                                      *
!                                                                      *
!      copyright through   North Carolina State University
!      by M.A.  Zikry (1994),all rights reserved
!                                                                      *
!***********************************************************************
!                                                                      *
!                          p l e a s e   n o t e                       *
!                                                                      *
!                                                                      *
!             recipients of crystal2d are asked not to distribute      *
!             their source to other facilities.
!                                                                      *
!      Permission must be obtained for use, contact M.A.  Zikry        *
!                                                                      *
!                                                                      *
!                                                                      *
!***********************************************************************
!                                                                      *
!                          l e g a l   n o t i ! e                     *
!                                                                      *
!                                                                      *
!  copyright and distribution held by North Carolina State University
!  this work has been generated by M.A. Zikry and his students
!
!
!  This is an implicit two dimensional quasi-static and dynamic code
!  specialized for large crystalline deformation, it is tailored for
!  inelastic deformation and failure.
!***********************************************************************
!  The work for this code is based on the finite -strain high strain-rate
!  work developed by M.A.  Zikry from papers published in 1990-1994
!  that work has been extended and modified in this code
!  by M.  Kao as part of his doctoral research
!  M.A.  Zikry and M.  Kao do not hold any legal responsibilty
!  for use  of this code.  All questions and need for documentation can be obtained
!  from this research group.
!
!  This code has been developed based on a constitutive formulation that accounts
!  for mobile and immobile dislocation densities coupled to a multiple-slip
!  crytalline framework. These formulations are given in modules matslip.
!  Details are given in papers by M. A. Zikry and M. Kao
!
!
!
!  This is the main program
! this code has been developed for the Sun but there are versions for the Cray
!
!
!
! [ P A R A M E T E R S]
! ......................
      use CN_Objects_manager


!!!!!!!!!!!!      integer, parameter :: nume   = 40000
!!!!!!!!!!!!      integer, parameter :: nss    = 24

      real*8 hed                                                        vax750
!!!!!!	  common/WMLBC/BCflag
      common/hourglass/fhg(40000,8),fhghis(40000,8)
      common/hourglass2/hgsstore(40000),hgshis(40000)
      common/hgenergy/hgenerstore(40000),hgenerhis(40000)
      common/totalenergy/totenerstore(40000),totenerhis(40000),
     1inertener(40000)
      common/hgstress/hgstress1store(40000),hgstress2store(40000),
     1   hgstress1his(40000),hgstress2his(40000)
      common/irdmp1/lendr,lenhr,irt,trt,ityprs
      common/bk00/ioff(96)
      common/bk01/h4(4,5),p14(4,5),p24(4,5)
      common/bk02/ioofc,iphase,imass,lpar(9)
      common/bk03/numdc,imassn,idampn,irller,penstf
      common/bk04/nprm(8)
      common/bk05/ifil,iadd,maxsiz,head(12)
      common/bk06/nprnt,mprint,itmpop,numelt,jprint,idump,locstr
      common/bk07/mbfc,nelpg,hed(12)
      common/bk08/kprint,nstep,ite,ilimit,newstf
      common/bk09/maxref,rhsn,rhsvn,cvtl,iteref,ectl,tolls
      common/bk10/npb,nodep(2,8)
      common/bk11/cnwmk(2),iequit,iprint,isref
      common/bk12/ntlen
      common/bk14/lfna(15),lfnt(6)
      common/bk15/cpuio(36),cpuip(36)
      common/bk16/maxint,hgc
      common/bk17/dn1,dn2,nwebuf,ntime,numnp,neq,ibar,mthsol
      common/bk18/nummat,ityp2d,ako(31)
      common/bk20/ntotal
      common/bk23/itemp,itherm,irtin
      character*4 mess
      common/bk25/mess
      common/bk26/dt,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10
      common/bk27/nlcur,nptst,nthpy,nthpz,nthps,xmy,xmz,xms,nload,nptm
      common/bk30/numlp,numpc,h22(2,2),pl2(2,2),h33(3,2),pl3(3,2)
      common/bk32/nsref,nequit,time,timep,lprint,nprint
      common/bk33/irfreq,krfreq,iress
      common/bk49/bulkmx,ncon(30)
      logical rezone
      common/rezone/rezone,nrzn,nctr,irzcnt,nrezon
      common/slar3/nsl,nsntl,nmntl,nslnmx,sltol,slhrd
      common/riksw1/sp1,ds0,cs01,cs02,rrsp,linsch,igso,irco,idamp
      common/riksw2/rlnew,alfa0,dsx,iteopt,idctrl,riksf,numspu,mthunl
      common/automt/dtmin,dtmax,mxback,termtm
      common/fissn0/maxneq,mwspac,ntpe0,ntpe1,nfissl(3)
      common/fissn1/melemt,nnns,ntpe2,n2g,llls
      common/fissn2/nwpblk,numblk,mwsusd,mxnepb,maxch,matpr,mench,ifa(2)
      common/fissn3/ifissl,kfissl(3)
      common/total/itrlas,irflas,irhlas,itrtot,irftot,irhtot
      common/xcom0/imeth,interq,imess
      common/cn0/iconv,lpb,nrcc,icon,iband,idirw,ftlst
      common/cn1/numati,numnpi,numeli,nblk1,nslidi,ntslvi,ntmsri,
     1           nnpbi,nepbi,ncnpi
      common/cn2/nlcuri,nlcmxi,ncnldi,npresi,ndbci,nbfri,nbfzi,
     1           nbfai,ncnmai,ncndpi,initci
      common/cn3/ibbari,intgi,nmbfi,ithopi,ithcri,ithini,iengri,
     1           ijinti
      common/cn4/itypei,ianali,ibwmni,icorei,ipcori,isolti,gamai,
     1           betai,raydmi
      common/cn5/delti,nstepi,ioprti,ioplti,irstri,irezi,mthsli,
     1 ditoli,entoli,nstrfi,nstiti,nitrfi,nrfsti
      common/cn6/nunldi,mthsui,idcndi,idcdri,iarcni,iadmpi,arcszi
      common/cn7/tollsi,tolsli,rftani,tolrzi,igeomi
      common/taux1/itopaz,ithadd
      common/newz1/ibase,iadd5,iadd6,icnt6,locst6
      common/effort/number
      common/fmeml/fl

      character*8 names
      character*80 lnkarg
      common/filen/names(25)
      common/array/maxa,maxadd,ifield
      common/args/lnkarg,numargs
      common/double/iprec,ncpw,unit
!!!!!!!!!!!!!!      common/WMLthermal/thermalflag,thermalconstraint(40000),
!!!!!!!!!!!!!!     1    Tinit(40000),Rqold(40000)
!!!!!!!!!!!!!!      common/WMLthermalSolve/Rqolder(40000),Tinitdolder(40000)
      !     1    ,dummy(40000,1)
!     common/   /b(1)                                                   cray1

      common /main_block/ b(400000000)

      character*8 nameh,namef,namei,namest
!
!     define a 'heap' for the file buffers (minimum length = sum of
!     buffer lengths + 2*(number of buffers) + 2).
!     note: 'hloc=heap' must be included in the input to ldr.
!
      common/heap/  bufrs(444000)
      common/stack/ bozos(222000)
      common/excute/execut(125)
      common/vrsn/  vn,cdate,tx1(10),tx2(10)
!     version number and compile date
!
*****************
      common /wblock1/  iplotDirxy, x_area, yield_stress
      common/wblock2/  g_source, g_immob, g_minter, g_recov, b_v,
     1                             b_vvec(87),nmo,nim
!!!      common /wblock3/  density_ms, density_ims,etain(1000),ecin(1000)
      common /wblock11/ pd_counter
      common /wblock20/ mat_type(nume)

      integer       pd_counter(nume)!!!!!!!!!!!!, BCflag
      character*8   vn,cdate
      character*72  tx1,tx2


      call open_files
!
      pd_counter = 0
!
!.... set precision level
      iprec = 1
!     iprec = 2                                                                dp

!.... set characters per word
      ncpw  = 4
!      ncpw=8                                                            unics

!.... define precision of constants
      unit=1.0
!
      call rdarg                                                        wkstn
      call linky(names)
!!!!!!!!      call enablc                                                       unix
!

      imeth=0
      call getnam(lfnt(3),namei)
      call getnam(lfnt(4),nameh)
      call getnam(lfna(1),namef)

      if ((namef.eq.'rstxyz'.and.nameh.eq.'newfle').or.
     &    (namei.eq.'convert'))then

!.... input phase
!      call ovrlay('crystal2d',1,0,'recall')
       call ovrlay(1,0)


!.... initialization phase
!      call ovrlay('crystal2d',2,0,'recall')
      call ovrlay(2,0)


!.... stress initialization
      call getnam(lfna(11),namest)
      if(namest.ne.'strxyz') call strset
      endif


!.... solution phase
      write(*,*) 'calling input_data'
      call input_data
      write(*,*) '---------after calling input_data'

      close (7777)

      if(imeth.eq.0.and.nameh.eq.'newfle') then
         call solven
      endif
!---- add by ismail
      call ThermalLoadCleanMemory()
      call dtimestepsCleanMemory()
      call DiffCoeffTableCleanMemory()
!----------call the CN manager to clean the memory ismail2016-02-17
      Call CNCleanMem()
      CALL GBCleanMemory()
      CALL FractCleanMemory()
      end
