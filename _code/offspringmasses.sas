data meanmass;
input SIRENUM$ SIREFAM$ DAMNUM$	DAMFAM$	SEX$ MASS;
*removed data;
cards;
A21	A	B20	B	F	0.1239
A21	A	B20	B	F	0.1876
;

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

data malemass; set meanmass;
   if sex='F' then delete;
   rename mass=malemass;

/*proc print data=malemass;
 run;*/

data femmass; set meanmass;
   if sex='M' then delete;
   rename mass=femmass;

/*proc print data=femmass;
   run;*/

PROC MIXED DATA = malemass COVTEST ASYCOV;
title1 'offspring masses--all data-not means';
title3 'Testing for ALL';
TITLE2 'male offspring mass';
CLASS SIREFAM DAMFAM;
MODEL malemass = /SOLUTION OUTP=resm RESIDUAL;
RANDOM SIREFAM*DAMFAM/ TYPE = LIN(5) LDATA = II;
PARMS/ LOWERB = 0,0,0,0,0,0;
RUN;

PROC MIXED DATA = malemass COVTEST ASYCOV;
TITLE2 'male offspring mass';
TITLE3 'testing for paternal';
CLASS SIREFAM DAMFAM;
MODEL malemass = /SOLUTION OUTP=RHATPRO RESIDUAL;
RANDOM SIREFAM*DAMFAM/ TYPE = LIN(5) LDATA = II;
PARMS 0,0,0,0,0.000491,0.001952/ LOWERB = 0,0,0,0,0,0 HOLD=1,2,3,4;
RUN;

PROC MIXED DATA = malemass COVTEST ASYCOV;
TITLE2 'male offspring mass';
TITLE3 'RSCA';
CLASS SIREFAM DAMFAM;
MODEL malemass = /SOLUTION OUTP=RHATPRO RESIDUAL;
RANDOM SIREFAM*DAMFAM/ TYPE = LIN(5) LDATA = II;
PARMS 0,0,0,0.000251,0,0.001952/ LOWERB = 0,0,0,0,0,0 HOLD=1,2,3,5;
RUN;

data prob;
title 'Fry Analysis';
TITLE2 'Male Mass';
TITLE3 'PROB paternal';
chiprob = 1 - probchi(6, 1);
proc print;
run;

data prob;
title 'Fry Analysis';
TITLE2 'Male Mass';
TITLE3 'PROB RSCA';
chiprob = 1 - probchi(16, 1);
proc print;
run;

PROC MIXED DATA = femmass COVTEST ASYCOV;
title1 'offspring masses--all data-not means';
title2 'Testing for ALL';
TITLE3 'female offspring mass';
CLASS SIREFAM DAMFAM;
MODEL femmass = /SOLUTION OUTP=resm RESIDUAL;
RANDOM SIREFAM*DAMFAM/ TYPE = LIN(5) LDATA = II;
PARMS/ LOWERB = 0,0,0,0,0,0;
RUN;

PROC MIXED DATA = femmass COVTEST ASYCOV;
TITLE2 'female offspring mass-SCA';
CLASS SIREFAM DAMFAM;
MODEL femmass = /SOLUTION OUTP=RHATPRO RESIDUAL;
RANDOM SIREFAM*DAMFAM/ TYPE = LIN(5) LDATA = II;
PARMS 0,0,0,0,0.000364,0.004516/ LOWERB = 0,0,0,0,0,0 HOLD=1,2,3,4;
RUN;

PROC MIXED DATA = femmass COVTEST ASYCOV;
TITLE2 'female offspring mass-RSCA';
CLASS SIREFAM DAMFAM;
MODEL femmass = /SOLUTION OUTP=RHATPRO RESIDUAL;
RANDOM SIREFAM*DAMFAM/ TYPE = LIN(5) LDATA = II;
PARMS 0,0.000234,0,0,0,0.004516/ LOWERB = 0,0,0,0,0,0 HOLD=1,3,4,5;
RUN;

data prob;
title 'Fry Analysis';
TITLE2 'Female Mass';
TITLE3 'PROB SCA';
chiprob = 1 - probchi(1, 1);
proc print;
run;

data prob;
title 'Fry Analysis';
TITLE2 'Female Mass';
TITLE3 'PROB RSCA';
chiprob = 1 - probchi(2.9, 1);
proc print;
run;

quit;
