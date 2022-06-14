# -*- coding: utf-8 -*-

import subprocess
import csv
from tempfile import NamedTemporaryFile

collections  = {
    'University of Aberdeen, Arctic Domus Research Group':'2164/581',
    'University of Aberdeen, Business School':'2164/352',
    'University of Aberdeen, Business School, Economics':'2164/547',
    'University of Aberdeen, Business School, Management Studies':'2164/547',
    'University of Aberdeen, College of Life Sciences & Medicine':'2164/330',
    'University of Aberdeen, COPS Miscellaneous, COPS Administration':'2164/670',
    'University of Aberdeen, Divinity, History & Philosophy, Philosophy':'2164/611',
    'University of Aberdeen, dot.rural Digital Economy Hub':'2164/370',
    'University of Aberdeen, East Bio':'2164/705',
    'University of Aberdeen, Economics':'2164/547',
    'University of Aberdeen, Energy':'2164/705',
    'University of Aberdeen, Environment and Food Security':'2164/705',
    'University of Aberdeen, Geosciences':'2164/372',
    'University of Aberdeen, Geosciences, Archaeology':'2164/692',
    'University of Aberdeen, Geosciences, Centre for Transport Research':'2164/688',
    'University of Aberdeen, Geosciences, Geography & Environment':'2164/688',
    'University of Aberdeen, Geosciences, Geology & Petroleum Geology':'2164/686',
    'University of Aberdeen, Institute for Complex Systems and Mathematical Biology (ICSMB)':'2164/705',
    'University of Aberdeen, Institute of Applied Health Sciences':'2164/633',
    'University of Aberdeen, Institute of Medical Sciences':'2164/645',
    'University of Aberdeen, Law':'2164/561',
    'University of Aberdeen, Library & Historic Collections, Museum Collections':'2164/705',
    'University of Aberdeen, Library and Historic Collections, Library Services':'2164/705',
    'University of Aberdeen, Library, Special collections & Museums, Library Services':'2164/705',
    'University of Aberdeen, Marine Alliance for Science and Technology for Scotland (MASTS)':'2164/362',
    'University of Aberdeen, Medicine, Medical Sciences & Nutrition':'2164/365',
    'University of Aberdeen, Medicine, Medical Sciences & Nutrition, Applied Medicine':'2164/645',
    'University of Aberdeen, Medicine, Medical Sciences & Nutrition, Division Applied Medicine':'2164/645',
    'University of Aberdeen, Medicine, Medical Sciences & Nutrition, Gut Health':'2164/649',
    'University of Aberdeen, Medicine, Medical Sciences & Nutrition, Institute of Applied Health Sciences':'2164/633',
    'University of Aberdeen, Medicine, Medical Sciences & Nutrition, Institute of Medical Sciences':'2164/645',
    'University of Aberdeen, Medicine, Medical Sciences & Nutrition, Other Applied Health Sciences':'2164/633',
    'University of Aberdeen, Medicine, Medical Sciences & Nutrition, RINH':'2164/649',
    'University of Aberdeen, Natural & Computing Sciences, Chemistry':'2164/672',
    'University of Aberdeen, Natural & Computing Sciences, Computing Science':'2164/674',
    'University of Aberdeen, Natural & Computing Sciences, Mathematical Sciences':'2164/676',
    'University of Aberdeen, Natural & Computing Sciences, Physics':'2164/670',
    'University of Aberdeen, PolicyGrid II':'2164/674',
    'University of Aberdeen, Rowett Institute of Nutrition & Health, Obesity & Metabolic Health':'2164/649',
    'University of Aberdeen, Rowett Institute of Nutrition & Health, School Administration RINH':'2164/649',
    'University of Aberdeen, School of Biological Sciences':'2164/362',
    'University of Aberdeen, School of Biological Sciences, Biological Sciences':'2164/362',
    'University of Aberdeen, School of Education, Education':'2164/354',
    'University of Aberdeen, School of Engineering':'2164/678',
    'University of Aberdeen, School of Engineering, Engineering':'2164/678',
    'University of Aberdeen, School of Medical Sciences':'2164/645',
    'University of Aberdeen, School of Medical Sciences, Medical Sciences':'2164/645',
    'University of Aberdeen, School of Medicine & Dentistry, Division of Applied Health Sciences':'2164/633',
    'University of Aberdeen, School of Medicine & Dentistry, Division of Applied Medicine':'2164/645',
    'University of Aberdeen, School of Medicine & Dentistry, HERU':'2164/633',
    'University of Aberdeen, School of Medicine & Dentistry, HSRU':'2164/633',
    'University of Aberdeen, School of Psychology, Psychology':'2164/647',
    'University of Aberdeen, School of Social Science':'2164/355',
    'University of Aberdeen, School of Social Science, Anthropology':'2164/581',
    'University of Aberdeen, School of Social Science, Sociology':'2164/579',
    'University of Aberdeen, The North':'2164/705',
    'University of Aberdeen, University of Aberdeen':'2164/705',
    'University of Aberdeen.Aberdeen Biomedical Imaging Centre':'2164/645',
    'University of Aberdeen.Aberdeen Centre for Environmental Sustainability':'2164/362',
    "University of Aberdeen.Aberdeen Centre for Women's Health Research":'2164/633',
    'University of Aberdeen.Aberdeen Health Psychology Group':'2164/633',
    'University of Aberdeen.Aberdeen Institute for Coastal Science & Management (AICSM)':'2164/688',
    'University of Aberdeen.Aberdeen Institute of Energy':'2164/705',
    'University of Aberdeen.Aberdeen University Students Association (AUSA)':'2164/705',
    'University of Aberdeen.Academic Obstetrics and Gynaecology: AMND':'2164/633',
    'University of Aberdeen.Academic Urology Unit':'2164/633',
    'University of Aberdeen.Accountancy':'2164/553',
    'University of Aberdeen.Administation Applied Medicine':'2164/645',
    'University of Aberdeen.Anthropology':'2164/581',
    'University of Aberdeen.Anthropology and Development Studies':'2164/581',
    'University of Aberdeen.Applications Management':'2164/705',
    'University of Aberdeen.Applied Health Sciences Administration':'2164/633',
    'University of Aberdeen.Applied Medicine':'2164/645',
    'University of Aberdeen.Archaeology':'2164/692',
    'University of Aberdeen.Archaeology (Research Theme)':'2164/692',
    'University of Aberdeen.Arctic Domus Research Group':'2164/581',
    'University of Aberdeen.Art History':'2164/607',
    'University of Aberdeen.Biological Sciences':'2164/362',
    'University of Aberdeen.Biological Sciences (Research Theme)':'2164/362',
    'University of Aberdeen.Business and Management Studies':'2164/547',
    'University of Aberdeen.Business Development Support':'2164/705',
    'University of Aberdeen.Business Management':'2164/547',
    'University of Aberdeen.Business School':'2164/352',
    'University of Aberdeen.Business School Administration':'2164/352',
    'University of Aberdeen.CAFÉ UArctic Theme (Circumpolar Archives, Folkore and Ethnography)':'2164/581',
    'University of Aberdeen.CASS Administration':'2164/329',
    'University of Aberdeen.Celtic & Anglo Saxon':'2164/589',
    'University of Aberdeen.Centre for Academic Development':'2164/705',
    'University of Aberdeen.Centre for Applied Dynamics Research (CADR)':'2164/678',
    'University of Aberdeen.Centre for Energy Transition':'2164/705',
    'University of Aberdeen.Centre for Health Data Science':'2164/645',
    'University of Aberdeen.Centre for Healthcare Education and Research Innovation (CHERI)':'2164/631',
    'University of Aberdeen.Centre for Lifelong Learning':'2164/705',
    'University of Aberdeen.Centre for Micro- and Nanomechanics (CEMINACS)':'2164/678',
    'University of Aberdeen.Chemistry':'2164/672',
    'University of Aberdeen.Chemistry (Research Theme)':'2164/672',
    'University of Aberdeen.Chronic Disease Research Group':'2164/633', 
    'University of Aberdeen.Clinical Medicine':'2164/645',
    'University of Aberdeen.CLSM College Office':'2164/365',
    'University of Aberdeen.Communications':'2164/705',
    'University of Aberdeen.Company Development':'2164/705',
    'University of Aberdeen.Computer Science and Informatics':'2164/674',
    'University of Aberdeen.Computing Science':'2164/674',
    'University of Aberdeen.COPS Administration':'2164/670',
    'University of Aberdeen.Cryosphere and Climate Change Research Group':'2164/372',
    'University of Aberdeen.Data Safe Haven':'2164/633',
    'University of Aberdeen.Dental Education':'2164/631',
    'University of Aberdeen.DHP School Administration':'2164/359',
    'University of Aberdeen.Divinity':'2164/605',
    'University of Aberdeen.Divinity, History & Philosophy':'2164/359',
    'University of Aberdeen.dot.rural Digital Economy Hub':'2164/370',
    'University of Aberdeen.Earth Systems and Environmental Sciences':'2164/372',
    'University of Aberdeen.East Bio':'2164/705',
    'University of Aberdeen.Economics':'2164/547',
    'University of Aberdeen.Education':'2164/354',
    'University of Aberdeen.Education (Research Theme)':'2164/354',
    'University of Aberdeen.Education Other':'2164/354',
    'University of Aberdeen.Education School Administration':'2164/354',
    'University of Aberdeen.Elphinstone Institute':'2164/571',
    'University of Aberdeen.Energy':'2164/705',
    'University of Aberdeen.Engineering':'2164/678',
    'University of Aberdeen.Engineering (Research Theme)':'2164/678',
    'University of Aberdeen.English':'2164/591',
    'University of Aberdeen.English Language and Literature':'2164/591',
    'University of Aberdeen.Environment and Food Security':'2164/705',
    'University of Aberdeen.Epidemiology Group':'2164/633',
    'University of Aberdeen.Estates Central':'2164/705',
    'University of Aberdeen.Etnos: A Life History of the Etnos Concept':'2164/581',
    'University of Aberdeen.External Relations & Marketing':'2164/705',
    'University of Aberdeen.Farr Aberdeen':'2164/633',
    'University of Aberdeen.Film & Visual Culture':'2164/13633',
    'University of Aberdeen.Finance':'2164/551',
    'University of Aberdeen.French':'2164/593',
    'University of Aberdeen.Fund Raising':'2164/705',
    'University of Aberdeen.Gaelic':'2164/13635',
    'University of Aberdeen.Geography & Environment':'2164/688',
    'University of Aberdeen.Geology and Geophysics':'2164/686',
    'University of Aberdeen.Geosciences':'2164/372',
    'University of Aberdeen.Geosciences School Administration':'2164/372',
    'University of Aberdeen.Geosciences, Centre for Transport Research':'2164/688',
    'University of Aberdeen.German':'2164/595',
    'University of Aberdeen.Health Economics Research Unit':'2164/633',
    'University of Aberdeen.Health Services Research Unit':'2164/633',
    'University of Aberdeen.Hispanic Studies':'2164/597',
    'University of Aberdeen.History':'2164/609',
    'University of Aberdeen.History (Research Theme)':'2164/609',
    'University of Aberdeen.History of Art':'2164/607',
    'University of Aberdeen.Human Resources':'2164/705',
    'University of Aberdeen.HUMan-ANimal Relations Under Climate Change in NORthern Eurasia (HUMANOR)':'2164/355',
    'University of Aberdeen.Infrastructure':'2164/705',
    'University of Aberdeen.Initial Teacher Education (ITE)':'2164/567',
    'University of Aberdeen.Institute for Complex Systems and Mathematical Biology (ICSMB)':'2164/705',
    'University of Aberdeen.Institute of Applied Health Sciences':'2164/633',
    'University of Aberdeen.Institute of Biological & Environmental Sciences':'2164/619',
    'University of Aberdeen.Institute of Medical Sciences':'2164/645',
    'University of Aberdeen.International Recruitment':'2164/705',
    'University of Aberdeen.International Relations':'2164/577',
    'University of Aberdeen.Irish and Scottish Studies':'2164/358',
    'University of Aberdeen.Kosterlitz Centre for Therapeutics':'2164/705',
    'University of Aberdeen.L&L School Administration':'2164/358',
    'University of Aberdeen.Language Centre':'2164/585',
    'University of Aberdeen.Language, Literature, Music & Visual Culture, English & Film':'2164/358',
    'University of Aberdeen.Language, Literature, Music and Visual Culture':'2164/569',
    'University of Aberdeen.Law':'2164/561',
    'University of Aberdeen.Law (Research Theme)':'2164/561',
    'University of Aberdeen.Library Services':'2164/705',
    'University of Aberdeen.Life Sciences & Medicine':'2164/330',
    'University of Aberdeen.Linguistics':'2164/585',
    'University of Aberdeen.M&D Education Administration':'2164/631',
    'University of Aberdeen.M&D School Administration':'2164/365',
    'University of Aberdeen.Management Studies':'2164/547',
    'University of Aberdeen.Mandarin':'2164/585',
    'University of Aberdeen.Marine Alliance for Science and Technology for Scotland (MASTS)':'2164/619',
    'University of Aberdeen.Mathematical Science':'2164/676',
    'University of Aberdeen.Mathematical Sciences (Research Theme)':'2164/676',
    'University of Aberdeen.Medical Education':'2164/631',
    'University of Aberdeen.Medical Sciences':'2164/645',
    'University of Aberdeen.Medical Sciences - Cardiovascular Group':'2164/645',
    'University of Aberdeen.Medical Sciences - Cell, Developmental and Cancer Biology':'2164/645',
    'University of Aberdeen.Medicine, Medical Sciences & Nutrition':'2164/365',
    'University of Aberdeen.Medicine, Medical Sciences & Nutrition, Institute of Education in Medical and Dental Sciences':'2164/631',
    'University of Aberdeen.Medicine, Medical Sciences & Nutrition, Scientific Support':'2164/649',
    'University of Aberdeen.Medicine, Medical Sciences & Nutrition, Vascular Health':'2164/649',
    'University of Aberdeen.Modern Languages and Linguistics':'2164/585',
    'University of Aberdeen.MRC Centre for Medical Mycology':'2164/645',
    'University of Aberdeen.Museum Collections':'2164/705',
    'University of Aberdeen.Music':'2164/569',
    'University of Aberdeen.Music, Drama, Dance, Performing Arts, Film and Screen Studies':'2164/569',
    'University of Aberdeen.Natural & Computing Sciences':'2164/674',
    'University of Aberdeen.NCS School Administration':'2164/674',
    'University of Aberdeen.Northern Rivers Institute (NRI)':'2164/372',
    'University of Aberdeen.Other Applied Health Sciences':'2164/633',
    'University of Aberdeen.Philosophy':'2164/611',
    'University of Aberdeen.Philosophy (Research Theme)':'2164/611',
    'University of Aberdeen.Physical Sciences':'2164/670',
    'University of Aberdeen.Physics':'2164/670',
    'University of Aberdeen.Planetary Sciences':'2164/684',
    'University of Aberdeen.PolicyGrid II':'2164/674',
    'University of Aberdeen.Politics':'2164/577',
    'University of Aberdeen.Politics and International Studies':'2164/577',
    'University of Aberdeen.Principal':'2164/705',
    'University of Aberdeen.Professional Learning PGT':'2164/13629',
    'University of Aberdeen.Professional Services':'2164/705',
    'University of Aberdeen.Psychology':'2164/647',
    'University of Aberdeen.Psychology, Psychiatry and Neuroscience':'2164/645',
    'University of Aberdeen.Public Engagement':'2164/705',
    'University of Aberdeen.Public Health, Health Services and Primary Care':'2164/633',
    'University of Aberdeen.Real Estate':'2164/551',
    'University of Aberdeen.Registry':'2164/705',
    'University of Aberdeen.Relationship Management':'2164/705',
    'University of Aberdeen.Religious Studies':'2164/605',
    'University of Aberdeen.Research & Innovation':'2164/705',
    "University of Aberdeen.Riedel's Research Group":'2164/645',
    'University of Aberdeen.Rowett Institute':'2164/649',
    'University of Aberdeen.SBS School Administration':'2164/362',
    'University of Aberdeen.School Administration Psychology':'2164/647',
    'University of Aberdeen.School Administration RINH':'2164/649',
    'University of Aberdeen.Scottish Fish Immunology Research Centre':'2164/619',
    'University of Aberdeen.Senior Vice Principals':'2164/705',
    'University of Aberdeen.SMS School Administration':'2164/645',
    'University of Aberdeen.Social Science':'2164/355',
    'University of Aberdeen.Social Sciences School Administration':'2164/355',
    'University of Aberdeen.Sociology':'2164/579',
    'University of Aberdeen.Sociology (Research Theme)':'2164/579',
    'University of Aberdeen.Special Collections Centre':'2164/705',
    'University of Aberdeen.Student Advice & Support':'2164/705',
    'University of Aberdeen.Student Life':'2164/705',
    'University of Aberdeen.Student Recruitment':'2164/705',
    'University of Aberdeen.Student Resident Assistants':'2164/705',
    'University of Aberdeen.The Centre for Healthcare Randomised Trials (CHaRT)':'2164/633',
    'University of Aberdeen.The Marine Biodiscovery Centre':'2164/370',
    'University of Aberdeen.The North':'2164/705',
    'University of Aberdeen.The Political Ecology of Coastal Societies':'2164/372',
    'University of Aberdeen.The Research Institute of Irish and Scottish Studies':'2164/358',
    'University of Aberdeen.Theology and Religious Studies':'2164/605',
    'University of Aberdeen.Trusted Things and Communities':'2164/370',
    'University of Aberdeen.University of Aberdeen':'2164/705',
    'University of Aberdeen.Vice Principals':'2164/705',
    'University of Aberdeen.Centre for Planning & Environmental Management':'2164/688',
}

dctypes = {
    'dc.contributor.advisor',
    'dc.contributor.author',
    'dc.contributor.author[]',
    'dc.contributor.author[en]',
    'dc.contributor.composer',
    'dc.contributor.editor',
    'dc.contributor.illustrator',
    'dc.contributor.institution',
    'dc.contributor.institution[en]',
    'dc.contributor.inventor',
    'dc.date.accessioned',
    'dc.date.accessioned[]',
    'dc.date.available',
    'dc.date.available[]',
    'dc.date.embargoedUntil',
    'dc.date.embargoedUntil[]',
    'dc.date.issued',
    'dc.date.issued[]',
    'dc.description',
    'dc.description.abstract[en]',
    'dc.description.provenance',
    'dc.description.provenance[en]',
    'dc.description.sponsorship[en]',
    'dc.description.status',
    'dc.description.status[en]',
    'dc.description.version',
    'dc.description.version[en]',
    'dc.description[en]',
    'dc.format.extent',
    'dc.format.extent[en]',
    'dc.format.medium[en]',
    'dc.format.mimetype',
    'dc.format.type',
    'dc.format.type[en]',
    'dc.format[en]',
    'dc.identifier',
    'dc.identifier.citation',
    'dc.identifier.citation[en]',
    'dc.identifier.doi',
    'dc.identifier.doi[]',
    'dc.identifier.doi[en]',
    'dc.identifier.isbn',
    'dc.identifier.iss',
    'dc.identifier.iss[en]',
    'dc.identifier.issn',
    'dc.identifier.issn[]',
    'dc.identifier.other',
    'dc.identifier.other[]',
    'dc.identifier.other[en]',
    'dc.identifier.uri',
    'dc.identifier.uri[]',
    'dc.identifier.uri[en]',
    'dc.identifier.url[en]',
    'dc.identifier.vol',
    'dc.language.iso',
    'dc.language.iso[]',
    'dc.language.iso[en]',
    'dc.publisher',
    'dc.publisher[en]',
    'dc.relation.ispartof',
    'dc.relation.ispartof[en]',
    'dc.relation.ispartofseries',
    'dc.relation.ispartofseries[en]',
    'dc.rights',
    'dc.rights[en]',
    'dc.source.uri[en]',
    'dc.subject',
    'dc.subject.lcc',
    'dc.subject.lcc[en]',
    'dc.subject.lcsh[en]',
    'dc.subject[en]',
    'dc.title.alternative[en]',
    'dc.title[en]',
    'dc.type',
    'dc.type[en]'
}

#list_of_exemptions = []

# Export metadata csv
def export_metadata():
    print('Exporting metadata')
    print('--------------------------------')
    subprocess.Popen(["../dspace/bin/dspace metadata-export -a -f all_research_export.csv -i 2164/705"], shell = True).wait()
    update_metadata()

# Update csv metadata
def update_metadata():

    with open('all_research_export.csv', 'r') as csv_file:
        csv_reader = csv.DictReader(csv_file)

        try:        
            with open('all_research_import.csv', 'w', newline='') as new_file:
                
                csv_writer = csv.DictWriter(new_file, fieldnames=['id','collection'],extrasaction='ignore')
                csv_writer.writeheader()
                
                for line in csv_reader:
                    try:
                        inst_full = line['dc.contributor.institution[en]']
                        print(line['dc.title[en]'])
                        print(line['dc.contributor.institution[en]'])
                        print('----------------------------------')
                        if not inst_full == "":
                            if "||" not in inst_full:
                                try:
                                    handle = collections[institution]
                                except:
                                    handle = ""
                                    #list_of_exemptions.append(line['dc.identifier.uri'])
                            else:
                                last_char_index = inst_full.rfind("||")
                                last_string = inst_full[last_char_index:len(inst_full)]
                                institution = last_string.replace("||","")

                                try:
                                    handle = collections[institution]
                                except:
                                    handle = ""
                                    #list_of_exemptions.append(line['dc.identifier.uri'])
                                    
                        #print('Item: ' + line['dc.title[en]'])
                        #print('ID: ' + line['id'])
                        #print('Owning collection: ' + line['collection'])
                        #print ('Updated sub collection: ' + handle)
                        
                        if handle == "2164/705":
                            handle = ""
                            
                        if not handle == "":
                            line['collection'] = line['collection'] + '||' + handle
                        else:
                            line['collection'] = line['collection']                            
                        
                        #print(line['collection'])
                        #print('--------------------------------')
                            
                        for dc in dctypes:
                            if line[dc] != None:
                                del line[dc]
                                    
                    except ValueError:
                            print('dc.contributor.institution does not contain a value')
                    csv_writer.writerow(line)

                #with open('list_of_uri.txt', 'w') as f:
                #    for uri in list_of_exemptions:
                #        f.write(uri)
                #        f.write('\n')
                #print('\n'.join(map(str, list_of_exemptions)))
                
        except IOError:
            print('Failed to open csv file')
    #import_metadata()

def import_metadata():
    print('Importing metatdata')
    print('--------------------------------')
    subprocess.Popen(['../dspace/bin/dspace metadata-import -e bparkes@ed.ac.uk -f /home/lib/dspace/pure-mapping/all_research_import.csv -s'], shell = True)

def getHandle(institution):
    return collections[institution]

#export_metadata()
update_metadata()