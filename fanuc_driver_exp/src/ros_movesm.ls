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
    :  F[20:msm_ready]=(OFF) ;
    :  F[21:msm_dready]=(OFF) ;
    :   ;
    :  !listen to ros_traj for SKIPs ;
    :  SKIP CONDITION R[105:ros skip]<>0;
    :   ;
    :   ;
    :  LBL[10] ;
    :   ;
    :  !we're ready for new point ;
    :  F[20:msm_ready]=(ON) ;
    :   ;
    :  !wait for relay ;
    :  WAIT (F[21:msm_dready])    ;
    :   ;
    :  !cache in temp preg ;
    :  PR[41:pos cache]=PR[40:pos]    ;
    :   ;
    :  !first rdy low, then ack copy ;
    :  !TODO: can this be ON? ;
    :  F[20:msm_ready]=(OFF) ;
    :  F[21:msm_dready]=(OFF) ;
    :   ;
    :  !move to point ;
    :J PR[41:pos cache] 100% CNT 75 Skip,LBL[10]    ;
    :   ;
    :  !skipped, goto handler ;
    :  JMP LBL[20] ;
    :   ;
    :   ;
    :  !see what the problem is ;
    :  LBL[20:skip handler] ;
    :   ;
    :  !in any case re-enable skip ;
    :  SKIP CONDITION R[105:ros skip]<>0;
    :   ;
    :  !on any unknown err, abort ;
    :  IF R[105:ros skip]<>1,JMP LBL[999] ;
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
