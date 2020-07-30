from sty import fg, bg, ef, rs
import sys

logo = '''
               
             | | (_)              
  _ __   __ _| |_ ___   _____     
 | '_ \ / _` | __| \ \ / / _ /
 | | | | (_| | |_| |\ V /  __|
 |_| |_|\__,_|\__|_| \_/ \___/
     | |                          
   __| | _____   _____ _ ____   __
  / _` |/ _ \ \ / / _ \ '_ \ \ / /
 | (_| |  __/\ V /  __/ | | \ V /
  \__,_|\___| \_/ \___|_| |_|\_/

'''

step = int(len(logo) / 256)
if not step:
    step = 1

for i in range (0, len(logo)):
    c = fg(i * step) +  logo[i]
    sys.stdout.write(c )
sys.stdout.write(bg.rs)
