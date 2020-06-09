from bs4 import BeautifulSoup
import requests
import json

page = requests.get('https://webcams.nyctmc.org/multiview2.php')
soup = BeautifulSoup(page.content, 'html.parser')
#print(soup.prettify())

rows = soup.find_all(name="tr", attrs={"id": "repCam__ctl0_trCam"})

cameras_dict = {}
for r in rows:
    try:
        if r.find(name='input'):
            cameras_dict[r.find(name='input')['value']] = r.find(name='span').string
        else:
            # cameras without the value param are inactive, ignore them
            print(f"{r.find(name='span').string} is inactive")
            continue
    except Exception as e:
        print(e)
        print(r)

with open("cameras.json", "w") as out:
    json.dump(cameras_dict, out)
