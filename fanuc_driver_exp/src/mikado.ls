/PROG  MIKADO
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "r3";
PROG_SIZE	= 512;
CREATE		= DATE 16-09-30  TIME 09:07:42;
MODIFIED	= DATE 26-04-09  TIME 17:10:08;
FILE_NAME	= ;
VERSION		= 0;
LINE_COUNT	= 19;
MEMORY_SIZE	= 980;
PROTECT		= READ_WRITE;
TCD:  STACK_SIZE	= 1000,
      TASK_PRIORITY	= 50,
      TIME_SLICE	= 0,
      BUSY_LAMP_OFF	= 0,
      ABORT_REQUEST	= 0,
      PAUSE_REQUEST	= 7;
DEFAULT_GROUP	= 1,*,*,*,*;
CONTROL_CODE	= 00000000 00000000;
/MN
   1:  ! reset blocker DOs before start ;
   2:  DO[145:last_batch]=OFF ;
   3:  DO[146:wrt_allowed]=OFF ;
   4:  IF DO[147:giveup_cntrl]=ON,JMP LBL[1] ;
   5:  RUN ROS_STATE ;
   6:  ! init user log screen takes some ;
   7:  WAIT    .30(sec) ;
   8:  RUN ROS_TRAJ ;
   9:  RUN ROS_IO ;
  10:  LBL[1:mik_loop] ;
  11:  DO[147:giveup_cntrl]=OFF ;
  12:  CALL ROS_MOVESM    ;
  13:  IF (DO[147:giveup_cntrl]=ON),JMP LBL[2] ;
  14:  WAIT    .30(sec) ;
  15:  JMP LBL[1] ;
  16:  LBL[2:own_code] ;
  17:  MESSAGE[ ROS_MOVESM exit ctrl ] ;
  18:  ! You can call your own functions ;
  19:  ! here. For Example: ;
  20:  ! CALL ProgramXYZ ;
  21:  !------------------- ;
  22:  ! If you want to exit ;
  23:  ! the program, remove ;
  24:  ! the JMP underneath or ;
  25:  ! add a condition to skip ;
  26:  ! the JMP e.g. a FLG ;
  27:  JMP LBL[1] ;
/POS
/END
