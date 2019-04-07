      SUBROUTINE WETAIR2(DB,WB,RH,DP,BP,E,ESAT,VD,RW,TVIR,TVINC,DENAIR,
     *                      CP,WTRPOT)

C     NICHEMAPR: SOFTWARE FOR BIOPHYSICAL MECHANISTIC NICHE MODELLING

C     COPYRIGHT (C) 2018 MICHAEL R. KEARNEY AND WARREN P. PORTER

C     THIS PROGRAM IS FREE SOFTWARE: YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C     IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C     THE FREE SOFTWARE FOUNDATION, EITHER VERSION 3 OF THE LICENSE, OR (AT
C      YOUR OPTION) ANY LATER VERSION.

C     THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C     WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C     MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C     GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C     YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C     ALONG WITH THIS PROGRAM. IF NOT, SEE HTTP://WWW.GNU.ORG/LICENSES/.

C     SUBROUTINE WETAIR2 CALCULATES SEVERAL PROPERTIES OF HUMID AIR.  THIS VERSION
C     WAS TAKEN FROM "PROPERTIES OF AIR: A MANUAL FOR USE IN BIOPHYSICAL ECOLOGY"

C*********************************************************************

C     SUBROUTINE WETAIR2 CALCULATES SEVERAL PROPERTIES OF HUMID AIR SHOWN AS
C     OUTPUT VARIABLES BELOW.  THE PROGRAM IS BASED ON EQUATIONS FROM LIST,
C     R. J. 1971.  SMITHSONIAN METEOROLOGICAL TABLES. SMITHSONIAN
C     INSTITUTION PRESS. WASHINGTON, DC.  WETAIR2 MUST BE USED IN CONJUNCTION
C     WITH FUNCTION VAPPRS2.

C     INPUT VARIABLES ARE SHOWN BELOW.  THE USER MUST SUPPLY KNOWN VALUES
C     FOR DB AND BP (BP AT ONE STANDARD ATMOSPHERE IS 101 325 PASCALS).
C     VALUES FOR THE REMAINING VARIABLES ARE DETERMINED BY WHETHER THE USER
C     HAS EITHER (1) PSYCHROMETRIC DATA (WB OR RH), OR (2) HYGROMETRIC DATA
C     (DP).

C     (1) PSYCHROMETRIC DATA:
C     IF WB IS KNOWN BUT NOT RH THEN SET RH = -1. AND DP = 999.
C     IF RH IS KNOWN BUT NOT WB THEN SET WB = 0. AND DP = 999.

C     (2) HYGROMETRIC DATA:
C     IF DP IS KNOWN THEN SET WB = 0. AND RH = 0.

C************************* INPUT VARIABLES ***************************

C     DB = DRY BULB TEMPERATURE (DEGREE CELSIUS)
C     WB = WET BULB TEMPERATURE (DEGREE CELSIUS)
C     RH = RELATIVE HUMIDITY (PER CENT)
C     DP = DEW POINT TEMPERATURE (DEGREE CELSIUS)
C     BP = BAROMETRIC PRESSURE (PASCAL)

C************************* OUTPUT VARIABLES **************************

C     E =      VAPOR PRESSURE (PASCAL)
C     ESAT =   SATURATION VAPOR PRESSURE (PASCAL)
C     VD =     VAPOR DENSITY (KILOGRAM PER CUBIC METRE)
C     RW =     MIXING RATIO (KILOGRAM PER KILOGRAM)
C     TVIR =   VIRTUAL TEMPERATURE (KELVIN)
C     TVINC =  VIRTUAL TEMPERATURE INCREMENT (KELVIN)
C     DENAIR = DENSITY OF HUMID AIR (KILOGRAM PER CUBIC METRE)
C     CP =     SPECIFIC HEAT OF AIR AT CONSTANT PRESSURE (JOULE PER
C            KILOGRAM KELVIN)
C     WTRPOT = WATER POTENTIAL (PASCAL)

C*********************************************************************
      IMPLICIT NONE

      DOUBLE PRECISION BP,CP,DB,DENAIR,DLTAE,DP,E,ESAT,RH,RW,TK,TVINC
      DOUBLE PRECISION TVIR,VAPPRS2,VD,WB,WBD,WBSAT,WTRPOT


      TK  = DB + 273.15
      ESAT = VAPPRS2(DB)
      IF (DP .LT. 999.0) GO TO 100
      IF (RH .GT. -1.0) GO TO 200
      WBD = DB - WB
      WBSAT = VAPPRS2(WB)
      DLTAE = 0.000660 * (1.0 + 0.00115 * WB) * BP * WBD
      E = WBSAT - DLTAE
      GO TO 300
100   E = VAPPRS2(DB)
      GO TO 300
200   E = ESAT * RH / 100.
      GO TO 400
300   RH = (E / ESAT) * 100.
400   RW = ((0.62197 * 1.0053 * E) / (BP - 1.0053 * E))
      VD = E * 0.018016 / (0.998 * 8.31434 * TK)
      TVIR = TK * ((1.0 + RW / (18.016 / 28.966)) / (1.0 + RW))
      TVINC = TVIR - TK
      DENAIR = 0.0034838 * BP / (0.999 * TVIR)
      CP = (1004.84 + (RW * 1846.40)) / (1.0 + RW)
      IF (RH .LE. 0.0) GO TO 500
      WTRPOT = 4.615E+5 * TK * DLOG(RH / 100.0)
      GO TO 600
500   WTRPOT = -999
600   RETURN
      END