# -*- coding: utf-8 -*-

import re
import subprocess
import csv

communities  = {
    '2164/329'
    #'2164/330',
    #'2164/331',
    #'2164/318',
    #'2164/705'
}
# Export metadata csv from DSpace for each community
def export_metadata():
    # Loop through communities
    for community in communities:
        # Format file name string
        community_string = community.replace('/','-')
        # Export communities metadata
        subprocess.Popen(['../dspace/bin/dspace metadata-export -a -f '+community_string+'.csv -i '+community], shell = True).wait()
        print(community+': metadata exported')
        print('--------------------------------')

# Update csv metadata and write it to new csv for import
def update_metadata():
    # Loop through communities
    for community in communities:
        # Format file name string
        community_string = community.replace('/','-')
        # Load exported community metadata csv
        with open(community_string+'.csv', 'r') as csv_file:
            csv_reader = csv.DictReader(csv_file)
            # 
            try:
                # Create tempory csv file to save updated and reformatted csv
                with open(community_string+'_temp.csv', 'w', newline='') as new_file:
                    # Define limited headers needed for updated import
                    csv_writer = csv.DictWriter(new_file, fieldnames=['id','collection','dc.identifier.vol[en]','dc.identifier.iss[en]'], extrasaction='ignore')
                    # Write new reduced headers to temp csv
                    csv_writer.writeheader()
                    # Loop through exported csv
                    for line in csv_reader:
                        try:
                            # Load citation string to extract volume and issue number
                            citation = line['dc.identifier.citation[en]']
                            # Extract volume value
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
                            # Extract issue number
                            if find_number(citation, 'no. ') != None:
                                issue = find_number(citation, 'no. ')
                                iss = ''.join(issue)
                            print(line['dc.title[en]'])
                            print(vol)
                            print(iss)
                            print('--------------------------------')
                            # Set volume and issue values in the temp csv
                            line['dc.identifier.vol[en]'] = vol
                            line['dc.identifier.iss[en]'] = iss
                            # Remove unwanted PURE text from temp csv
                            if line['id'].__contains__('Updated'):
                                del line['id']
                                print('PURE text removed')
                            # Remove all the un-needed columns for reformatted csv
                            del line['dc.contributor.author']
                            del line['dc.contributor.author[en]']
                            del line['dc.contributor.composer']
                            del line['dc.contributor.editor']
                            del line['dc.contributor.institution[en]']
                            del line['dc.date.accessioned']
                            del line['dc.date.accessioned[]']
                            del line['dc.date.available']
                            del line['dc.date.embargoedUntil']
                            del line['dc.date.issued']
                            del line['dc.description.abstract[en]']
                            del line['dc.description.provenance']
                            del line['dc.description.provenance[en]']
                            del line['dc.description.sponsorship[en]']
                            del line['dc.description.status[en]']
                            del line['dc.description.version[en]']
                            del line['dc.description[en]']
                            del line['dc.format.extent']
                            del line['dc.format.extent[en]']
                            del line['dc.format.mimetype']
                            del line['dc.identifier.citation[en]']
                            del line['dc.identifier.doi']
                            del line['dc.identifier.isbn']
                            del line['dc.identifier.issn']
                            del line['dc.identifier.other']
                            del line['dc.identifier.other[en]']
                            del line['dc.identifier.uri']
                            del line['dc.identifier.uri[]']
                            del line['dc.identifier.uri[en]']
                            del line['dc.language.iso[en]']
                            del line['dc.publisher']
                            del line['dc.publisher[en]']
                            del line['dc.relation.ispartof[en]']
                            del line['dc.relation.ispartofseries[en]']
                            del line['dc.rights[en]']
                            del line['dc.subject.lcc[en]']
                            del line['dc.subject.lcsh[en]']
                            del line['dc.subject[en]']
                            del line['dc.title.alternative[en]']
                            del line['dc.title[en]']
                            del line['dc.type[en]']
                        except ValueError:
                            print('dc.identifier.citation[en] does not contain a value')
                        # Write rows to temp csv csv
                        csv_writer.writerow(line)
            except IOError:
                print('Failed to open csv file')
        # Load temp csv to remove any empty rows and write to new 'updated' csv
        with open(community_string+'_temp.csv') as input, open(community_string+'_update.csv', 'w', newline='') as output:
            writer = csv.writer(output)
            # Loop through all rows and delete empty rows
            for row in csv.reader(input):
                if any(field.strip() for field in row):
                    writer.writerow(row)

# Import metadata back into DSpace
def import_metadata():
    # Loop through communities and upload individual updated csv's
    for community in communities:
        # Format file name string
        community_string = community.replace('/','-')
        # Import updated csv
        subprocess.Popen(['../dspace/bin/dspace metadata-import -e bparkes@ed.ac.uk -f /home/lib/dspace/volume-issue/'+community_string+'_update.csv -s'], shell = True)

# Regular expression function to extract volume and issue numbers
def find_number(text, c):
    return re.findall(r'%s(\d+)' % c, text)

#export_metadata()
update_metadata()
#import_metadata()