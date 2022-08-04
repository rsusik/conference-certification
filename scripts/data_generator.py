from essential_generators import DocumentGenerator
import random, json
gen = DocumentGenerator()

locations = ['Paris, France', 'London, England', 'Berlin, Germany', 'Prague, Czechia', 'Lodz, Poland', 'Madrid, Spain']
univ_tpl = ['{WORD1} University of Technology', '{WORD1} University', 'University of {WORD1}', 'University of Eastern {WORD2}']

def get_random_certificate():
    year = random.randint(2000, 2022)
    month = random.randint(1, 12)
    day = random.randint(1, 20)

    conf_subject = gen.word()
    conf_name = f'International Conference on {conf_subject} {year}'
    conf_acronym = ''.join([w[0] for w in conf_name.split()[:-1] if w != 'on']).upper() + conf_name.split()[-1]
    conf_start = f'{day}.{month}.{year}'
    conf_end = f'{day + random.randint(0, 3)}.{month}.{year}'
    location = locations[random.randint(0, len(locations)-1)]
    organizers = [
        {'name': univ_tpl[random.randint(0, len(univ_tpl)-1)].replace('WORD1', location.split(', ')[0]).replace('WORD2', location.split(', ')[1])}
    ]

    cert_name = f'Certificate of Participation in {conf_name}'
    cert_identifier = gen.guid()
    cert_date = conf_end
    participant = gen.name()
    participant_email = gen.email()
    
    work_name = gen.sentence()
    work_authors = [participant] + [gen.name() for i in range(random.randint(0, 3))]
    work_abstract = gen.paragraph()
    work_keywords = [gen.word() for i in range(random.randint(3, 6))]
    work_identifier = f'ISBN {random.randint(1200, 3999)}-{random.randint(4200, 9999)}'
    work_publisher = f'{gen.word()} Press'
    
    certificate = {
        'name': cert_name,
        'participant': participant,
        'participantEmail': participant_email,
        'identifier': cert_identifier,
        'achievedAt': cert_date,
        'conference': {
            'name': conf_name,
            'acronym': conf_acronym,
            'startDate': conf_start,
            'endDate': conf_end,
            'location': location,
            'subject': conf_subject,
            'organizer': organizers
        },
        'work': {
            'name': work_name,
            'authors': work_authors,
            'abstract': work_abstract,
            'keywords': work_keywords,
            'identifier': work_identifier,
            'publisher': work_publisher
        }
    }

    return certificate

    # with open(f'./certificates/{i}.json', 'wt') as f:
    #     json.dump(certificate, f, indent=4)

