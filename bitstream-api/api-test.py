import requests
import os

BASE_URL = "https://www.ros-test.hw.ac.uk/rest/"
item_request = "items"
bit_request = "/bitstreams?name="

full_repo_data = []
offset_incr = 0

for x in range(35):
    
    print('increment: '+str(offset_incr))
    resp = requests.get(BASE_URL + item_request + "?limit=250&offset="+str(offset_incr))
    resp_in = resp.json()
    print('response: '+str(len(resp_in)))
    full_repo_data = full_repo_data + resp_in
    if offset_incr >= 0:
        offset_incr = len(full_repo_data)
    print('data: '+str(len(full_repo_data)))

#print(full_repo_data)

for x in full_repo_data:
    if x['handle'] == '123456789/8705':
        #resp = requests.get(BASE_URL + item_request + x['uuid'] + "/metadata")
        #resp_in = resp.json()
        print(x['expand'][0])
    #try:
    #    file_ref = x['dc.format.medium']
    #    print(file_ref)
    #except:
    #    pass


rootdir = '/Users/bparkes/DSpace_Dev/HWU/EGIS-Dissertation-Files_13-6-22'

#for subdir, dirs, files in os.walk(rootdir):
#    for file in files:
#        print(file)

