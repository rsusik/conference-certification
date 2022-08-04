import json, sys
from jsonschema import RefResolver, Draft7Validator

# if len(sys.argv)>1:
#     exampl_filename = sys.argv[1]
# else:
#     exampl_filename = './schema/example.json'

def validate_json(examplestr):

    with open('./schema/conference.schema.json') as confjson, \
        open('./schema/work.schema.json') as workjson, \
        open('./schema/certificate.schema.json') as certjson:
        confschemastr = confjson.read()
        workschemastr = workjson.read()
        certschemastr = certjson.read()

    confschema = json.loads(confschemastr)
    workschema = json.loads(workschemastr)
    certschema = json.loads(certschemastr)
    schema_store = {
        confschema['$id'] : confschema,
        workschema['$id'] : workschema,
        certschema['$id'] : certschema,
    }


    resolver = RefResolver.from_schema(certschema, store=schema_store)
    validator = Draft7Validator(certschema, resolver=resolver)

    jsonData = json.loads(examplestr)
    if validator.validate(jsonData) is None:
        return True
    return False