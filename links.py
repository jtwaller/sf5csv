from bs4 import BeautifulSoup

file = open('lead.html', 'r')
output = open('out.txt', 'w')
soup = BeautifulSoup(file, 'html.parser')

for link in soup.find_all('a'):
  output.write('http://sfv.fightinggame.community' + link.get('href') + '\n')

file.close()
output.close()
