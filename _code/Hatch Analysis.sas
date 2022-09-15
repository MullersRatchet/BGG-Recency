DATA DIAHAT;
INPUT sirenum$ sirefam$	damnum$	damfam$	hatpro dayshat;

tranday = (1/(dayshat))**5;

tranhat = (arsin(hatpro)) * (arsin(hatpro));

CARDS;
*removed data;
A20	A	C21	C	0.75	12
A21	A	B20	B	0.842105263	12
;

data sasuser.frynohat; set sasuser.fry;
 *if hatpro = 0 then delete;

DATA DUMMY;
 DO ROW = 1 TO 72;
  OUTPUT;
   END;
DATA FAM1;
 DO SIRE1 = 1 TO 9;
 DO DAM1 = 1 TO 9;
  OUTPUT;
   END;
    END;
DATA FAM1;
 SET FAM1;
  IF SIRE1 = DAM1 THEN DELETE;
DATA FAM1;
 MERGE DUMMY FAM1;
DATA FAM1;
 SET FAM1;
  DO SIRE2 = 1 TO 9;
  DO DAM2 = 1 TO 9;
   OUTPUT;
    END;
	 END;
DATA FAM1;
 SET FAM1;
  IF SIRE2 = DAM2 THEN DELETE;
DATA DUMMY;
SET DUMMY;
 DO COL = 1 TO 72;
  OUTPUT;
   END;

DATA II;
 MERGE FAM1 DUMMY;
 IF ROW < COL THEN DELETE;
  IF SIRE1 = DAM1 OR SIRE2 = DAM2 OR
	(SIRE1 ^= SIRE2 AND DAM1 ^= DAM2 AND 
	SIRE1 ^= DAM2 AND DAM1 ^= SIRE2)
	 THEN DELETE;
IF SIRE1 = SIRE2 AND DAM1 = DAM2 THEN REL = 'FULLS';
 ELSE IF SIRE1 = DAM2 AND DAM1 = SIRE2 THEN REL = 'RFS';
 ELSE IF SIRE1 = SIRE2 AND DAM1 ^= DAM2 THEN REL = 'PHS';
 ELSE IF SIRE1 ^= SIRE2 AND DAM1 = DAM2 THEN REL = 'MHS';
 ELSE REL = 'RHS';
   DO PARM = 1 TO 5;
    OUTPUT;
	 END;

  DATA II;
  SET II;
   IF PARM = 1 THEN DO;   
     IF REL = 'FULLS' OR REL = 'RFS' THEN VALUE = 2;
     ELSE VALUE = 1;
	 END;
   IF PARM = 2 THEN DO;   
     IF REL = 'FULLS' OR REL = 'RFS' THEN VALUE = 1;
     ELSE DELETE;
	 END;
   IF PARM = 3 THEN DO;   
     IF REL = 'FULLS' OR REL = 'MHS' THEN VALUE = 1;
	ELSE DELETE;
	 END;
   IF PARM = 4 THEN DO;   
     IF REL = 'FULLS' OR REL = 'PHS' THEN VALUE = 1;
	ELSE DELETE;
	 END;
  IF PARM = 5 THEN DO;   
     IF REL = 'FULLS' THEN VALUE = 1;
	ELSE DELETE;
	 END;
   KEEP PARM ROW COL VALUE;


PROC MIXED DATA = diahat COVTEST ASYCOV;
title 'Diallel Analysis--no hatches included';
title2 'Days to Hatch';
TITLE3 'Testing for All';
CLASS SIREFAM DAMFAM;
MODEL tranday = /SOLUTION OUTP=RDAYHAT RESIDUAL;
RANDOM SIREFAM*DAMFAM / TYPE = LIN(5) LDATA = II;
PARMS/ LOWERB = 0,0,0,0,0,0;
RUN;

proc univariate data=RDAYHAT normal plot;
 var PEARSONRESID;
 run;

PROC MIXED DATA = diahat COVTEST ASYCOV;
title 'Diallel Analysis--no hatches included';
title2 'proportion hatching';
TITLE3 'Testing for All';
CLASS SIREFAM DAMFAM;
MODEL tranhat = /SOLUTION OUTP=Rhatpro RESIDUAL;
RANDOM SIREFAM*DAMFAM / TYPE = LIN(5) LDATA = II;
PARMS/ LOWERB = 0,0,0,0,0,0;
RUN;

proc univariate data=Rhatpro normal plot;
 var PEARSONRESID;
 run;

 quit;
