import urllib.request
from bs4 import BeautifulSoup
import csv

def linebuilder(url):
  with urllib.request.urlopen(url) as response:
    html = response.read()
  #f = open('TS-Sabin', 'r')
  #html = f
  
  soup = BeautifulSoup(html, 'html.parser')
  
  # Player, Games Played, LP, Region, Platform, Character, Vs[1,16]:%,games
  # player 0, games played 12, lp 18, region 20, platform 22, character 28, overall 30
  # list 32 -> eof
  
  lines = list(soup.stripped_strings)
  output = [lines[0], lines[12], lines[18], lines[20], lines[22], lines[28], lines[30].replace("%","")]
  #print(output) 
  
  #initialize characters
  tempd = {'Alex': ['0', '0'], 'Birdie': ['0', '0'], 'Cammy': ['0', '0'], 'Claw': ['0','0'], 'Chun Li': ['0','0'], 'Dhalsim': ['0', '0'], 'Dictator': ['0', '0'], 'Fang': ['0', '0'], 'Karin': ['0', '0'], 'Ken': ['0', '0'], 'Laura': ['0','0'], 'Nash': ['0', '0'], 'Necalli': ['0', '0'], 'R. Mika': ['0', '0'], 'Rashid': ['0', '0'], 'Ryu': ['0', '0'], 'Zangief': ['0', '0']}   
  
  for x in range(32,len(lines)):
    if x % 4 == 0 and lines[x] == lines[36]: #line is player's main character
      tempd[lines[x+1]] = [lines[x+2].replace("%",""), lines[x+3]]
      #print(tempd[lines[x+1]])
    #else:
      #print(lines[x])
  
  for k in sorted(tempd):
    #print(k, tempd[k])
    output.append(tempd[k][0])
    output.append(tempd[k][1])
  
  return output
#  f.close()


def main():

  datahead = ['Player', 'Games', 'LP', 'Region', 'Platform', 'Character', 'Overall', 'AlexWin', 'AlexGames', 'BirdieWin', 'BirdieGames', 'CammyWin', 'CammyGames', 'ChunWin', 'ChunGames', 'ClawWin', 'ClawGames', 'DhalsimWin', 'DhalsimGames', 'DictatorWin',' DictatorGames', 'FangWin', 'FangGames', 'KarinWin', 'KarinGames', 'KenWin', 'KenGames', 'LauraWin', 'LauraGames', 'NashWin', 'NashGames', 'NecalliWin', 'NecalliGames', 'RMikaWin', 'RMikaGames', 'RashidWin', 'RashidGames', 'RyuWin', 'RyuGames', 'ZangiefWin', 'ZangiefGames']
  urls = open('urls.txt', 'r')
  outfile = open('output.csv', 'w')


  wr = csv.writer(outfile, quoting=csv.QUOTE_NONE)
  wr.writerow(datahead)

  for i in urls:
    print('Fetching: ', i)
    wr.writerow(linebuilder(i))

  urls.close()
  outfile.close()


main()
