/PROG  ROS_MOVESM
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "ROS//r3b";
PROG_SIZE	= 1290;
CREATE		= DATE 17-07-25  TIME 09:00:00;
MODIFIED	= DATE 26-04-09  TIME 17:28:40;
FILE_NAME	= ;
VERSION		= 1;
LINE_COUNT	= 65;
MEMORY_SIZE	= 1790;
PROTECT		= READ_WRITE;
TCD:  STACK_SIZE	= 0,
      TASK_PRIORITY	= 50,
      TIME_SLICE	= 0,
      BUSY_LAMP_OFF	= 0,
      ABORT_REQUEST	= 0,
      PAUSE_REQUEST	= 0;
DEFAULT_GROUP	= 1,*,*,*,*;
CONTROL_CODE	= 00000000 00000000;
/APPL
/MN
   1:   ;
   2:  R[71:curr_pr]=0    ;
   3:  R[72:curr_pt]=0    ;
   4:  R[73:nr_pts2drv]=0    ;
   5:  DO[145:last_batch]=OFF ;
   6:  DO[146:wrt_allowed]=OFF ;
   7:  DO[147:giveup_cntrl]=OFF ;
   8:  R[74:ros_skip]=0    ;
   9:   ;
  10:  !listen to ros_traj for SKIPs ;
  11:  SKIP CONDITION R[74:ros_skip]<>0    ;
  12:   ;
  13:  LBL[10:move_loop] ;
  14:   ;
  15:  WAIT DO[146:wrt_allowed]=OFF OR DO[147:giveup_cntrl]=ON    ;
  16:  IF (DO[147:giveup_cntrl]=ON),JMP LBL[998] ;
  17:   ;
  18:  IF (R[73:nr_pts2drv]<=0),JMP LBL[22] ;
  19:  ;
  20:  R[71:curr_pr]=R[72:curr_pt]+R[75:first_pr]    ;
  21:  IF ((R[73:nr_pts2drv]=1) AND (DO[145:last_batch]=ON)),JMP LBL[55] ;
  22:  ! Depending on the application, CNT and ACC can be modified, but use caution. ;
  23:  ! High ACC and low CNT can result in jerky motion, depending on the trajectory. ;
  24:  J PR[R[71:curr_pr]] R[77:velocity]% CNT50 ACC60    ;
  25:  JMP LBL[44] ;
  26:  LBL[55:last_pt] ;
  27:  J PR[R[71:curr_pr]] R[77:velocity]% FINE ACC60    ;
  28:  JMP LBL[44] ;
  29:   ;
  30:  LBL[44:after_move] ;
  31:  IF R[74:ros_skip]<>0,JMP LBL[20] ;
  32:  R[73:nr_pts2drv]=R[73:nr_pts2drv]-1    ;
  33:  R[72:curr_pt]=R[72:curr_pt]+1    ;
  34:  IF R[72:curr_pt]>=R[76:buff_size],JMP LBL[18] ;
  35:  JMP LBL[10] ;
  36:  LBL[18:end_of_buff] ;
  37:  DO[145:last_batch]=OFF ;
  38:  DO[146:wrt_allowed]=ON ;
  39:  JMP LBL[10] ;
  40:   ;
  41:  LBL[22:no_drv_pts] ;
  42:  WAIT    .01(sec) ;
  43:  DO[146:wrt_allowed]=ON ;
  44:  JMP LBL[10] ;
  45:  LBL[20:skip_handler] ;
  46:   ;
  47:  !in any case re-enable skip ;
  48:  SKIP CONDITION R[74:ros_skip]<>0    ;
  49:   ;
  50:  !on any unknown err, exit ;
  51:  JMP LBL[999] ;
  52:   ;
  53:  !traj stop from ros_traj: ;
  54:  !don't touch R[74:ros_skip], ;
  55:  !that is the responsibility ;
  56:  !of ros_traj. ;
  57:   ;
  58:  LBL[999:ros_skip_exit] ;
  59:  !something else, exit ;
  60:  MESSAGE[ ROS Motion exit ] ;
  61:  ! mikado gave up control ;
  62:  LBL[998:exit] ;
  63:  END ;
/POS
/END
