# -*- coding: utf-8 -*-

import re
import subprocess as sp
import pandas as pd
import csv
import shutil
from tempfile import NamedTemporaryFile

communities  = {
    #'2164/329',
    #'2164/330',
    #'2164/331',
    #'2164/318',
    #'2164/705'
    '2164/329'
}
# Export metadata csv
def export_metadata():
    for community in communities:
        community_string = community.replace('/','-')
        #print(community_string)
        sp.Popen(["../dspace/bin/dspace metadata-export -a -f "+community_string+".csv -i "+community], shell = True).wait()
        print(community+': Metadata exported')
        print('--------------------------------')
    #update_metadata()

# Update csv metadata
def update_metadata():

    for community in communities:
        community_string = community.replace('/','-')
        print(community_string)
        with open(community_string+'.csv', 'r') as csv_file:
            csv_reader = csv.DictReader(csv_file)
            headers = csv_reader.fieldnames
            print(headers)
            print('--------------------------------')
            try:        
                with open(community_string+'.csv', 'w') as new_file:
                    
                    csv_writer = csv.DictWriter(new_file, fieldnames=headers)
                    csv_writer.writeheader()
                    
                    for line in csv_reader:
                        try:
                            citation = line['dc.identifier.citation[en]']
                            print(citation)
                            #volume = re.search('vol.:P(\d+)', citation)
                            #issue = re.search('no.:P(\d+)', citation)
                            
                            #if find_number(citation, 'vol. ') != 'null':
                            #    volume = find_number(citation, 'vol. ')
                            #if find_number(citation, 'no. ') != 'null':
                            #    issue = find_number(citation, 'no. ')
                            
                            #for v in volume:
                            #    print('Volume: '+v)
                            #print('Issue: '+issue)
                            #print('--------------------------------')
                            
                        except ValueError:
                                print('dc.identifier.citation does not contain a value')
                        #csv_writer.writerow(line)
                    
            except IOError:
                print('Failed to open csv file')

def getHandle(institution):
    return collections[institution]

def find_number(text, c):
    return re.findall(r'%s(\d+)' % c, text)

#export_metadata()
update_metadata()

# Import updated metadata csv
#subprocess.Popen(["../dspace/bin/dspace metadata-import -f test_file.csv -e dspace@lac-sdlc-sta-test.is.ed.ac.uk -w -n -t"], shell = True)
