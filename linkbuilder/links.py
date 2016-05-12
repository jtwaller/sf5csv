from bs4 import BeautifulSoup
from urllib.request import urlopen

# file = open('lead.html', 'r')
file = urlopen("http://sfv.fightinggame.community/leaderboard")
output = open('out.txt', 'w')
soup = BeautifulSoup(file, 'html.parser')

for link in soup.find_all('a'):
  output.write('http://sfv.fightinggame.community' + link.get('href') + '\n')

#file.close()
output.close()
