# sf5csv

Web scraper and data visualizer for data from http://sfv.fightinggame.community/.

python requirements:  
python3  
beautifulsoup4 (pip install BeautifulSoup4)

R packages:  
ggplot2  
dplyr  
reshape  
DT

To pull data:

1) "python links.py"  
-linkbuilder/links.py pulls all links from the top 500 leaderboard.  
-User must manually edit out.txt to just contain relevant player links (linkbuilder/out.txt)  
-move and rename the out.txt file to /csvbuilder/urls.txt

2) "python build.py"  
-csvbuilder/build.py scrapes links from urls.txt into output.csv.

3) Move output.csv to Rapp directory

4)  Run the app in R.  Change to Rapp directory.  
"R"  
"library(shiny)"  
"runApp()"
