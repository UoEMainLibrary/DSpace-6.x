import requests
import os

BASE_URL = "https://www.ros-test.hw.ac.uk/rest/"
item_request = "items"
bit_request = "/bitstreams?name="

#rootdir = '/Users/bparkes/DSpace_Dev/HWU/EGIS-Dissertation-Files_13-6-22'
rootdir = '/Users/bparkes/DSpace_Dev/ERA/DSpace-6.x/bitstream-api/EGIS-Dissertation-Files_13-6-22'

headers = {'Content-type': 'application/json', 'Accept': 'text/plain'}

full_repo_data = []
offset_incr = 0

auth = requests.post(BASE_URL + "login?email=bparkes@ed.ac.uk&password=H3rR107W@77*")
auth_json = auth.json
print(auth.cookies)

for x in range(35):
    
    #print('increment: '+str(offset_incr),end="\r")
    resp = requests.get(BASE_URL + item_request + "?limit=250&offset="+str(offset_incr)+"&expand=metadata")
    resp_in = resp.json()
    #print('response: '+str(len(resp_in)),end="\r")
    full_repo_data = full_repo_data + resp_in
    if offset_incr >= 0:
        offset_incr = len(full_repo_data)
    print('data: '+str(len(full_repo_data)),end="\r")

for x in full_repo_data:
    print(x)
    i = 1
    file_meta = ""
    meta = x['metadata']
    for y in meta:
        if y['key'] == 'dc.format.medium':
            file_meta = y['value']
    if ".pdf" in file_meta:
        for subdir, dirs, files in os.walk(rootdir):
            for file in files:
                if file == file_meta:
                    #print(x['uuid'] +" meta: "+ file_meta +" file: "+ file)
                    url = file.replace(" ", "%20").replace("-", "%2D").replace("_", "%5F").replace(",", "%2C")
                    if url.count(".") > 1:
                        url = url.replace(".", "%2E", url.count(".")-1)
                    #print(file +" : "+ url)
                    req = BASE_URL + item_request + "/" + x['uuid'] + bit_request + url
                    print(req)
                    r = requests.post(BASE_URL + item_request + "/" + x['uuid'] + bit_request + url)
                    r.headers
                    rjson = r.json
                    print(rjson)
    if i == 1:
        break


#for subdir, dirs, files in os.walk(rootdir):
#    for file in files:
#        print(file)

