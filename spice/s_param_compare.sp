* S31, S41 Comparisons *
 
************************************************************************* 
 .PARAM length	= 11.79		* Trace length, inches
 .PARAM Zo_diff	= 100		* Differential impedance, ohms
************************************************************************* 

 V1 g1  0   AC 1.25
 V2 0   g2  AC 0

 Rs1 g1   sp1  '0.5*Zo_diff'
 Rs2 g2   sp3  '0.5*Zo_diff'
 Rs3 sp2  0    '0.5*Zo_diff'
 Rs4 sp4  0    '0.5*Zo_diff'
 Ra1 g1   ap1  '0.5*Zo_diff'
 Ra2 g2   ap3  '0.5*Zo_diff'
 Ra3 ap2  0    '0.5*Zo_diff'
 Ra4 ap4  0    '0.5*Zo_diff'
 Re1 g1   ep1  '0.5*Zo_diff'
 Re2 g2   ep3  '0.5*Zo_diff'
 Re3 ep2  0    '0.5*Zo_diff'
 Re4 ep4  0    '0.5*Zo_diff'
 Rm1 g1   mp1  '0.5*Zo_diff'
 Rm2 g2   mp3  '0.5*Zo_diff'
 Rm3 mp2  0    '0.5*Zo_diff'
 Rm4 mp4  0    '0.5*Zo_diff'
 
* Isotropic Stripline *
 W1 sp1 sp3 gnd sp2 sp4 gnd RLGCmodel=diff_stripline N=2 l='0.0254*length' delayopt=3

* Anisotropic Stripline *
 *W2 ap1 ap3 gnd ap2 ap4 gnd RLGCmodel=diff_aniso_stripline N=2 l='0.0254*length' delayopt=3

* Embedded Microstrip *
 *W3 ep1 ep3 gnd ep2 ep4 gnd RLGCmodel=embedded_diff_microstrip N=2 l='0.0254*length' delayopt=3

* Microstrip *
 *W4 mp1 mp3 gnd mp2 mp4 gnd RLGCmodel=diff_microstrip N=2 l='0.0254*length' delayopt=3

 .INCLUDE '../stripline_model/diff_stripline.rlgc'
 *.INCLUDE './diff_aniso_stripline.rlgc'
 *.INCLUDE './embedded_diff_microstrip.rlgc'
 *.INCLUDE './diff_microstrip.rlgc'
 .OPTION POST=1 ACCURATE
 .AC DEC 100 1meg 40G
 .END


