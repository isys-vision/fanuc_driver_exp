/PROG  ROS_MOVESM
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "ROS//r3b";
PROG_SIZE	= 1290;
CREATE		= DATE 17-07-25  TIME 09:00:00;
MODIFIED	= DATE 26-04-09  TIME 17:28:40;
FILE_NAME	= ;
VERSION		= 0;
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
  22:  J PR[R[71:curr_pr]] 70% CNT50 ACC100    ;
  23:  JMP LBL[44] ;
  24:  LBL[55:last_pt] ;
  25:  J PR[R[71:curr_pr]] 70% FINE ACC100    ;
  26:  JMP LBL[44] ;
  27:   ;
  28:  LBL[44:after_move] ;
  29:  IF R[74:ros_skip]<>0,JMP LBL[20] ;
  30:  R[73:nr_pts2drv]=R[73:nr_pts2drv]-1    ;
  31:  R[72:curr_pt]=R[72:curr_pt]+1    ;
  32:  IF R[72:curr_pt]>=R[76:buff_size],JMP LBL[18] ;
  33:  JMP LBL[10] ;
  34:  LBL[18:end_of_buff] ;
  35:  R[72:curr_pt]=0    ;
  36:  DO[145:last_batch]=OFF ;
  37:  DO[146:wrt_allowed]=ON ;
  38:  JMP LBL[10] ;
  39:   ;
  40:  LBL[22:no_drv_pts] ;
  41:  WAIT    .01(sec) ;
  42:  DO[146:wrt_allowed]=ON ;
  43:  JMP LBL[10] ;
  44:  LBL[20:skip_handler] ;
  45:   ;
  46:  !in any case re-enable skip ;
  47:  SKIP CONDITION R[74:ros_skip]<>0    ;
  48:   ;
  49:  !on any unknown err, abort ;
  50:  IF R[74:ros_skip]<>1,JMP LBL[999] ;
  51:  IF R[74:ros_skip]=1,JMP LBL[999] ;
  52:   ;
  53:  !traj stop from ros_traj: ;
  54:  !don't touch R[74:ros skip], ;
  55:  !that is the responsibility ;
  56:  !of ros_traj. ;
  57:  JMP LBL[10] ;
  58:   ;
  59:   ;
  60:  LBL[999:abort] ;
  61:  !something else, abort ;
  62:  MESSAGE[ ROS Motion ABORT ] ;
  63:  ABORT ;
  64:  ! mikado gave up control ;
  65:  LBL[998:exit] ;
  66:  END ;
/POS
/END
