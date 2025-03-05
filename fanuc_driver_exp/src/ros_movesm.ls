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
    :  R[39:buf r2r] = 0 ;
    :  R[40:buf con] = 2 ;
    :  R[41:buf act] = 0 ;
    :  R[42:first pr] = 0 ;
    :   ;
    :  !listen to ros_traj for SKIPs ;
    :  SKIP CONDITION R[35:ros skip]<>0 ;
    :   ;
    :  LBL[10] ;
    :   ;
    :  ! wait for buff being rdy ;
    :  WAIT (R[39:buf r2r]>0) ;
    :   ;
    :  IF R[39:buf r2r] = 1, JMP LBL[11] ;
    :  ! if we reach this buffer 2 is rdy ;
    :  R[41:buf act] = 2 ;
    :  R[36:adj nr of pts] = R[34:nr of pts b2] - 1 ;
    :  R[42:first pr] = R[32:first pr b2] ;
    :  JMP LBL[15] ;
    :    ;
    :  LBL[11] ;
    :  R[41:buf act] = 1 ;
    :  R[36:adj nr of pts] = R[33:nr of pts b1] - 1 ;
    :  R[42:first pr] = R[31:first pr b1] ;
    :  JMP LBL[15] ;
    :  ;
    :  LBL[15] ;
    :  !move to points ;
    :  FOR R[37:iterator]=0 TO R[36:adj nr of pts] ;
    :   R[38:curr pr] = R[37:iterator] + R[42:first pr] ;
    : ! USE PTH INSTUCTION? J PR[R[38:curr pr]] 100% CNT 75 PTH ;
    : ! we need to test different buffer sizes an CNT values. buffer size 10 with CNT 50 is slow, with more than 50 the accuracy of cartesian movement is too low
    :   J PR[R[38:curr pr]] 100% CNT 50 ;
    :   IF R[35:ros skip]<>0, JMP LBL[20] ;
    :  ENDFOR ;
    :   ;
    :  WAIT 0.01sec ;
    :  IF R[41:buf act] = 1, JMP LBL[18] ;
    :  R[34:nr of pts b2] = 0 ;  
    :  JMP LBL[19] ;
    :  LBL[18] ;
    :  R[33:nr of pts b1] = 0 ;
    :  JMP LBL[19] ;
    :    ;
    :  LBL[19] ;
    :  R[40:buf con] = R[41:buf act] ;
    :  R[39:buf r2r] = 0 ;
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
