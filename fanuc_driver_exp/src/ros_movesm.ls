/PROG  ROS_MOVESM
/ATTR
OWNER       = MNEDITOR;
COMMENT     = "ROS//r3b";
PROG_SIZE	= 1102;
CREATE      = DATE 17-07-25  TIME 09:00:00;
MODIFIED    = DATE 17-07-25  TIME 09:00:00;
FILE_NAME   = ;
VERSION     = 0;
LINE_COUNT	= 54;
MEMORY_SIZE	= 1518;
PROTECT     = READ_WRITE;
TCD:  STACK_SIZE    = 0,
      TASK_PRIORITY = 50,
      TIME_SLICE    = 0,
      BUSY_LAMP_OFF = 0,
      ABORT_REQUEST = 0,
      PAUSE_REQUEST = 0;
DEFAULT_GROUP   = 1,*,*,*,*;
CONTROL_CODE    = 00000000 00000000;
/APPL
/MN
    :   ;
    :  !init: not rdy, no ack ;
    :  R[38:curr pr] = 0 ;
    :  R[36:adj nr of pts] = -1 ;
    :  R[33:nr of pts b1] = 0 ;
    :  R[34:nr of pts b2] = 0 ; 
    :  F[1:buff1 wrdy]=(OFF) ;
    :  F[2:buff1 mrdy]=(ON) ;
    :  F[3:buff2 wrdy]=(OFF) ;
    :  F[4:buffw mrdy]=(ON) ;
    :   ;
    :  !listen to ros_traj for SKIPs ;
    :  SKIP CONDITION R[35:ros skip]<>0 ;
    :  WAIT (F[1:buff1 wrdy]) ;
    :   ;
    :  LBL[10] ;
    :   ;
    :  ! wait for buff being rdy ;
    :  WAIT (F[1:buff1 wrdy]) ;
    :  F[2:buff1 mrdy]=(OFF) ;
    :   ;
    :  !MESSAGE[Buff1: moving] ;
    :  !move to points ;
    :  R[36:adj nr of pts] = R[33:nr of pts b1] - 1 ;
    :  FOR R[37:iterator]=0 TO R[36:adj nr of pts] ;
    :   R[38:curr pr] = R[37:iterator] + R[31:first pr b1] ;
    : ! USE PTH INSTUCTION? J PR[R[38:curr pr]] 100% CNT 75 PTH ;
    :   J PR[R[38:curr pr]] 100% CNT 75 ;
    :   IF R[35:ros skip]<>0, JMP LBL[20] ;
    :  ENDFOR ;
    :   ;
    :  R[33:nr of pts b1] = 0 ;
    :  F[2:buff1 mrdy]=(ON) ;
    :  ;
    :  ! wait for buffer2 being rdy ;
    :  WAIT (F[3:buff2 wrdy]) ;
    :  F[4:buff2 mrdy]=(OFF) ;
    :  !WAIT (F[4:buff2 mrdy]) ;
    :  ! F[4:buff2 mrdy]=(OFF) ;
    :  ;
    :  !move to points ;
    :  !MESSAGE[Buff2: moving'] ;
    :  R[36:adj nr of pts] = R[34:nr of pts b2] - 1 ;
    :  FOR R[37:iterator]=0 TO R[36:adj nr of pts] ;
    :   R[38:curr pr] = R[37:iterator] + R[32:first pr b2] ;
    : ! USE PTH INSTUCTION? J PR[R[38:curr pr]] 100% CNT 75 PTH ;
    :   J PR[R[38:curr pr]] 100% CNT 75 ;
    :   IF R[35:ros skip]<>0, JMP LBL[20] ;
    :  ENDFOR ;
    :   ;
    :  R[34:nr of pts b2] = 0 ;
    :  F[4:buff2 mrdy]=(ON) ;
    :  ;
    :  JMP LBL[10] ;
    :   ;
    :   ;
    :  !see what the problem is ;
    :  LBL[20:skip handler] ;
    :   ;
    :  !in any case re-enable skip ;
    :  SKIP CONDITION R[35:ros skip]<>0;
    :   ;
    :  !on any unknown err, abort ;
    :  IF R[35:ros skip]<>1,JMP LBL[999] ;
    :  IF R[35:ros skip]=1,JMP LBL[999] ;
    :   ;
    :  !traj stop from ros_traj: ;
    :  !don't touch R[5:ros skip], ;
    :  !that is the responsibility ;
    :  !of ros_traj. ;
    :  JMP LBL[10] ;
    :   ;
    :   ;
    :  LBL[999:abort];
    :  !something else, abort ;
    :  MESSAGE[ ROS Motion ABORT ] ;
    :  ABORT ;
    :   ;
/POS
/END
