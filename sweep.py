import os, sys
import numpy

widths    = [0.5, 1.5]
gaps      = [0.5]
laminates = [(31.5, 3.89, 0.006)]
pre_pregs  = [(2, 3.19, 0.007)]

sp_path = 'diff_stripline.sp'

# Remove all .rlgc files
os.system('rm -rf *.rlgc')

for width in widths:
  for gap in gaps:
    for (l_t,l_dk,l_df) in laminates:
      for (p_t,p_dk,p_df) in pre_pregs:
        print("\n============================================")
        print("SWEEP width={}, gap={}, L={}, P={}".format(
          width, gap, (l_t,l_dk,l_df), (p_t,p_dk,p_df) ))
        print("============================================\n")

        with open(sp_path, "r+") as sp_file:

          # Read text
          text = sp_file.read()
          lines = text.split('\n')
          for i in range(len(lines)):

            # Only edit .PARAM lines
            if ".PARAM" not in lines[i]:
              continue

            # Replace new parameters
            words = lines[i].split()
            if words[1] == "width":
              words[3] = str(width)
            if words[1] == "space":
              words[3] = str(gap)
            if words[1] == "core":
              words[3] = str(l_t)
            if words[1] == "dk_core":
              words[3] = str(l_dk)
            if words[1] == "df_core":
              words[3] = str(l_df)
            if words[1] == "preg":
              words[3] = str(p_t)
            if words[1] == "dk_preg":
              words[3] = str(p_dk)
            if words[1] == "df_preg":
              words[3] = str(p_df)
            lines[i] = ' '.join(words)
          
          # Replace new tex
          text = '\n'.join(lines)
          sp_file.close()

        with open(sp_path, "w") as sp_file:
          sp_file.write(text)
          sp_file.close()

          # Run HSPICE
          if os.path.isfile('out'):
              os.system('rm out')
          os.system('./sweep.sh')

          # Copy to filename
          sp_name = str(width) + '_' + str(gap) + '_' + str(l_t) + '_' + str(p_t) + '.rlgc'
          os.system('mv diff_stripline.rlgc ' + sp_name)
