import feedparser
import re
import pdb
import pprint

def pretty_print(obj):
    pprint.pprint(obj)

def versions(obj):
    ver = []
    for entry in obj:
        if 'リリース' in entry:
            ver.append(entry)
    return re.findall('[0-9].[0-9].[0-9]', ','.join(ver))

if __name__ == '__main__':
    RSS_URL = 'https://www.ruby-lang.org/ja/feeds/news.rss'
    entries = feedparser.parse(RSS_URL).entries
    titles = [obj.title for obj in entries]
    print(versions(titles)[0])
