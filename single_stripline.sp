* 50 ohm Single Stripline *
* Material: XXX, RTF copper foil
 
************************************************************************* 
 .PARAM thick	= 0.6		* Trace thickness, mils -- 1/2 oz copper
 .PARAM width	= 4.0		* Trace width, mils
 .PARAM etch	= 0.0		* Trace etch factor, mils
 .PARAM rrms	= 4u		* RMS trace roughness, meters
 .PARAM core	= 5.0		* Core dielectric thickness, mils  (2x1035)
 .PARAM preg	= 5.6		* Pre-preg dielectric thickness, mils  (2x1035)
 .PARAM dk_core	= 4.0		* Core relative dielectric constant 
 .PARAM dk_preg	= 4.0		* Pre-preg relative dielectric constant
 .PARAM df_core	= 0.009		* Core dissipation factor
 .PARAM df_preg	= 0.009		* Pre-preg dissipation factor
 .PARAM length	= 10.0		* Trace length, inches
 .PARAM Zo	= 50		* Impedance, ohms
************************************************************************* 

 Vs 1    gnd  AC 2
 R1 1    in1  Zo
 R2 out1 0    Zo
 
 W1 in1 gnd out1 gnd FSmodel=single_stripline INCLUDERSIMAG=YES N=1 l='0.0254*length' delayopt=3
 .MATERIAL diel_1 DIELECTRIC ER=dk_core LOSSTANGENT=df_core
 .MATERIAL diel_2 DIELECTRIC ER=dk_preg LOSSTANGENT=df_preg
 
 .MATERIAL copper METAL CONDUCTIVITY=57.6meg ROUGHNESS=rrms
 
 .SHAPE trap TRAPEZOID TOP='(width-2*etch)*25.4e-6' BOTTOM='width*25.4e-6' HEIGHT='thick*25.4e-6'
 
 .LAYERSTACK stack_1
 + LAYER=(copper,'thick*25.4e-6'), LAYER=(diel_1,'core*25.4e-6')
 + LAYER=(diel_2,'preg*25.4e-6'), LAYER=(copper,'thick*25.4e-6')
 
 .FSOPTIONS opt1 PRINTDATA=YES
 + COMPUTE_GD=YES
 + COMPUTE_RS=YES
 
 .MODEL single_stripline W MODELTYPE=FieldSolver
 + LAYERSTACK=stack_1, FSOPTIONS=opt1 RLGCFILE=single_stripline.rlgc
 + CONDUCTOR=(SHAPE=trap, MATERIAL=copper, ORIGIN=(0,'(thick+core)*25.4e-6'))
 
 .OPTION POST=1 ACCURATE
 .AC DEC 100 1meg 40G
 .END

