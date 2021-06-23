#!/usr/bin/env python
# coding: utf-8

# # Simulation Control Notebook

# This notebook will handle all of the scripting that would typically be done in bash but I decided to try in python to keep in with the primary theme
# This should also help a TON with the math and such since bash doesn't do decimal arithmetic by itself.

# ## Bar Dimensions
# 
# |X mm|Y mm|Z mm|
# |---|---|---|
# |4.8|80|10|

# In[1]:


import numpy as np, os
from subprocess import call
from datetime import datetime


# ## Actual Simulation Portion

# The beam dimensions are being varied by steps of 5 for both the height and width. Since we want every width to have every height nested for loops were used. Inside the loops a function from the module sys is being utilized, `sys.call`. `sys.call` allows a command from the terminal Ex. `ls`, `cd`, `sed`, and `grep` to be issued in another process. This allows me to use the math and logic of Python to cleanly impliment the looping then use the terminal's `sed` command to change a pattern of text in the run.mac file to what I need it to be.
# 
# 

# In[ ]:


for energy in range(9, 11, 1):
    for width in range(5, 51, 5):
        for height in range(5, 51, 5):
            for angle in range(0, 360, 15):
                with open('data/log.txt', 'a') as file:
                    print(f'I am on angle {angle} with width {width} and height of {height} at {str(datetime.now())}', file=file)

                # Changes the dimensions and alignments of detector and beam
                call(f'sed -i "s:/gate/source/mybeam/gps/pos/halfx.*:/gate/source/mybeam/gps/pos/halfx {width/2:.2f} mm:" mac/run.mac', shell=True)
                call(f'sed -i "s:/gate/source/mybeam/gps/pos/halfy.*:/gate/source/mybeam/gps/pos/halfy {height/2:.2f} mm:" mac/run.mac', shell=True)
                call(f'sed -i "s:/gate/cluster/placement/setRotationAngle.*:/gate/cluster/placement/setRotationAngle {angle} deg:" mac/run.mac', shell=True)
                call(f'sed -i "s:/gate/source/mybeam/gps/ene/mono.*:/gate/source/mybeam/gps/ene/mono {energy} MeV:" mac/run.mac', shell=True)
                
                # mades a zero padded string version of the dimensions
                pad_width = str(width).zfill(2)
                pad_height = str(height).zfill(2)
                pad_angle = str(angle).zfill(3)
                pad_energy = str(energy).zfill(2)

                # edits the root name of the output file to represent the correct width height and angle
                call(f'sed -i "s:/gate/output/ascii/setFileName output/.*:/gate/output/ascii/setFileName output/E{pad_energy}__W{pad_width}__H{pad_height}__A{pad_angle}_bars_:" mac/run.mac', shell=True)
                call('Gate mac/run.mac', shell=True)


# ### Sed
# `sed` is a tool developed for text manipulation of files. It is **extremely** fast and light weight. It is also a product of the early days of computing so following with sterotypes it is 'clunky and fragile' to use. I will walk you through what is going on.
# 
# - First:
# `sed` stands for "stream editor" which makes sense since all it does is edit sequences of text in streams. `sed -i` tells `sed` to do its thing **Inline**. Normally it would "open" the file to memory, do its edits on the file in memory then print it out to standard out or the user would redirect the printing to another file. This is useful but not what we want, we want the file to be edited right then and there.
# 
# - Second
# `s:` stands for substitution, `sed` matches patterns of text based on **regular expressions**. The pattern following `:` is the pattern being looked for, the `.*` matches any amount of any character its a super wild card. The stuff following the second `:` is what the first pattern will be replaced or substituted with.
# - This is where Python makes this easy, I'm using an fstring to create a string and put the value of the variable width divided by 2 and with 2 decimals in the location it appears in the string. I get easy formatting and string manipulation unlike bash
# The final `:` denotes the end of the `sed` comand and the `"` maks the end of the pattern stuff to the command. The patterns must be passed to `sed` as strings which is why I am using `"`.
# 
# - Third
# The last part of the string `mac/run.mac` is the file being changed by `sed`

# In[ ]:




