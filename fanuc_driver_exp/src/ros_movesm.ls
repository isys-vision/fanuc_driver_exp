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
    :  WAIT DO[145:pts2drv block] = OFF ;
    :  DO[145:pts2drv block] = ON;
    :  WAIT DO[146:curr_pt block] = OFF ;
    :  DO[146:curr_pt block] = ON;
    :  R[71:curr pr] = 0 ;
    :  R[72:curr pt] = 0 ;
    :  R[73:nr pts to drv] = 0 ;
    :  DO[145:pts2drv block] = OFF;
    :  DO[146:curr_pt block] = OFF;
    :  R[74:ros skip] = 0 ;
    :   ;
    :  !listen to ros_traj for SKIPs ;
    :  SKIP CONDITION R[74:ros skip]<>0 ;
    :   ;
    :  LBL[10] ;
    :   ;
    :  IF (R[73:nr pts to drv]<=0), JMP LBL[22] ;
    :   ;
    :  R[71:curr pr] = R[72:curr pt] + R[75:first pr] ;
    :  IF (R[73:nr pts to drv]=1), JMP LBL[55] ;
    :  J PR[R[71:curr pr]] 80% CNT 80 ACC 70 ;
    :  JMP LBL[44] ;
    :  LBL[55:last pt] ;
    :  J PR[R[71:curr pr]] 50% CNT 5 ACC 60 ;
    :  JMP LBL[44] ;
    :  ;
    :  LBL[44:after move] ;
    :  IF R[74:ros skip]<>0, JMP LBL[20] ;
    :  WAIT DO[145:pts2drv block] = OFF ;
    :  DO[145:pts2drv block] = ON ;
    :  WAIT DO[146:curr_pt block] = OFF ;
    :  DO[146:curr_pt block] = ON;
    :  R[73:nr pts to drv] = R[73:nr pts to drv] - 1 ;
    :  R[72:curr pt] = R[72:curr pt] + 1 ;
    :  DO[145:pts2drv block] = OFF;
    :  DO[146:curr_pt block] = OFF;
    :  IF R[72::curr pt] >= R[76:buff size], JMP LBL[18] ;
    :  JMP LBL[10] ;
    :  LBL[18] ;
    :  WAIT DO[146:curr_pt block] = OFF ;
    :  DO[146:curr_pt block] = ON ;
    :  R[72:curr pt] = 0 ;
    :  DO[146:curr_pt block] = OFF ;
    :  JMP LBL[10] ;
    :   ;
    :  LBL[22:no drv pts] ;
    :  WAIT 0.02sec ;
    :  JMP LBL[10] ;
    :  LBL[20:skip handler] ;
    :   ;
    :  !in any case re-enable skip ;
    :  SKIP CONDITION R[74:ros skip]<>0 ;
    :   ;
    :  !on any unknown err, abort ;
    :  IF R[74:ros skip]<>1,JMP LBL[999] ;
    :  IF R[74:ros skip]=1,JMP LBL[999] ;
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
