# sf5csv

Web scraper to pull data from http://sfv.fightinggame.community/.

requirements:
python3
beautifulsoup4 (pip install BeautifulSoup4)


Two scripts needs to be run to pull data:

1)
-linkbuidler/links.py pulls all links from the top 500 leaderboard.
-User must manually edit out.txt to just contain relevant player links (linkbuilder/out.txt)
-move and rename the out.txt file to /csvbuilder/urls.txt

2)
-csvbuilder/build.py scrapes all links from previous step into output.csv.  All other files in csvbuilder/ were just used to help build the tool out.
