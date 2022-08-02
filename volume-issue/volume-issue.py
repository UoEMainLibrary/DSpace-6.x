# -*- coding: utf-8 -*-

import re
import subprocess
import csv

communities  = {
    #'2164/329',
    #'2164/330'
    #'2164/331'
    #'2164/318'
    '2164/705'
}

dctypes = {
    'dc.contributor.author','dc.contributor.editor','dc.contributor.institution[en]','dc.contributor.inventor','dc.date.accessioned','dc.date.accessioned[]','dc.date.available','dc.date.available[]','dc.date.embargoedUntil','dc.date.issued','dc.description.provenance','dc.description.provenance[en]','dc.description.status[en]','dc.description.version[en]','dc.description[en]','dc.format.extent','dc.format.extent[en]','dc.identifier','dc.identifier.citation[en]','dc.identifier.doi','dc.identifier.isbn','dc.identifier.issn','dc.identifier.other','dc.identifier.uri','dc.identifier.uri[]','dc.identifier.uri[en]','dc.identifier.url[en]','dc.language.iso','dc.publisher','dc.relation.ispartof[en]','dc.relation.ispartofseries[en]','dc.rights[en]','dc.subject.lcc[en]','dc.subject[en]','dc.title.alternative[en]','dc.title[en]','dc.type[en]'
}
# Export metadata csv
def export_metadata():
    print('Exporting metatdata')
    print('--------------------------------')
    for community in communities:
        community_string = community.replace('/','-')
        subprocess.Popen(['../dspace/bin/dspace metadata-export -a -f '+community_string+'.csv -i '+community], shell = True).wait()
        print(community+': metadata exported')
        print('--------------------------------')

# Update csv metadata
def update_metadata():
    print('Updating metatdata')
    print('--------------------------------')
    for community in communities:
        community_string = community.replace('/','-')
        
        with open(community_string+'.csv', 'r') as csv_file:
            csv_reader = csv.DictReader(csv_file)  
            
            try:
                with open(community_string+'_temp.csv', 'w', newline='') as new_file:
                    csv_writer = csv.DictWriter(new_file, fieldnames=['id','collection','dc.identifier.vol[en]','dc.identifier.iss[en]'], extrasaction='ignore')
                    csv_writer.writeheader()
                    
                    for line in csv_reader:
                        try:
                            citation = line['dc.identifier.citation[en]']
                            if find_number(citation, 'vol. ') != None:
                                volume = find_number(citation, 'vol. ')
                                if len(volume) > 1:
                                    vol = ''.join(volume[0])
                                    if len(vol) > 3:
                                        vol = ''
                                else:
                                    vol = ''.join(volume)
                                    if len(vol) > 3:
                                        vol = ''
                            if find_number(citation, 'no. ') != None:
                                issue = find_number(citation, 'no. ')
                                iss = ''.join(issue)
                            print(line['dc.title[en]'])
                            print(vol)
                            print(iss)
                            print('--------------------------------')
                            
                            line['dc.identifier.vol[en]'] = vol
                            line['dc.identifier.iss[en]'] = iss
                            
                            if line['id'].__contains__('Updated'):
                                del line['id']
                                
                            for dc in dctypes:
                                if line[dc] != None:
                                    del line[dc]
                            
                        except ValueError:
                                print('dc.identifier.citation[en] does not contain a value')
                        csv_writer.writerow(line)
                        
            except IOError:
                print('Failed to open csv file')
                
        with open(community_string+'_temp.csv') as input, open(community_string+'_update.csv', 'w', newline='') as output:
            writer = csv.writer(output)
            for row in csv.reader(input):
                if any(field.strip() for field in row):
                    writer.writerow(row)

def import_metadata():
    print('Importing metatdata')
    print('--------------------------------')
    for community in communities:
        community_string = community.replace('/','-')
        subprocess.Popen(['../dspace/bin/dspace metadata-import -e bparkes@ed.ac.uk -f /home/lib/dspace/volume-issue/'+community_string+'_update.csv -s'], shell = True)

def find_number(text, c):
    return re.findall(r'%s(\d+)' % c, text)

export_metadata()
update_metadata()
import_metadata()


