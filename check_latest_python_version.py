import pdb
import pprint
import requests
from bs4 import BeautifulSoup

def is_num(s):
    return s.replace(',', '').replace('.', '').replace('-', '').replace('/', '').isnumeric()

if __name__ == '__main__':
    RELEASES_URL = 'https://docs.python.org/release/'
    source = requests.get(RELEASES_URL)
    soup = BeautifulSoup(source.text, 'html.parser')
    versions = soup.find_all('a')
    versions_text = []
    for v in versions:
        if is_num(v.get_text()):
            versions_text.append(v.get_text().replace('/', ''))

    print(sorted(versions_text)[-1])
