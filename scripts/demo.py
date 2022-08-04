# 
# Blockchain certification of research outputs and
# academic achievements: A case of scientific
# conference, 2022
# 
# This file contains a demo of contract deployment
# token/certification minting, displaying certificates,
# and list of participants.
# 
# Robert Susik (rsusik@kis.p.lodz.pl)
# 
# 

import json
from brownie import ConfCertToken, accounts
from scripts.data_generator import get_random_certificate
from scripts.schema_validator import validate_json


def main():
    deployer     = accounts[0]
    organizer    = accounts[1]
    other        = accounts[2]
    participants = accounts[3:]

    print('Users:')
    print(f'owner/organizer {organizer}')
    print(f'deployer        {deployer}')
    print(f'other           {other}')
    print(f'participants    {participants}')
    print('---')


    
    c1 = deployer.deploy(ConfCertToken, organizer, 0x176fa1c276cf)
    contractAddress = c1.address
    print('Deployment test success!')
    print(f'Contract address: {contractAddress}')
    print(f'Contract name   : {c1.name()}')
    print(f'Contract symbol : {c1.symbol()}')
    print('---')

    try:
        c1.mint(participants[0], 'somecertificate')
    except:
        print('Unauthorized mint test success!')
        print('Cannot mint as not an organizer. That\'s expected.')
        print('---')

    transactions = []
    certificates = []
    # Generate random certificate for each participant
    print('Minting certificates test')
    for idx, participant in enumerate(participants):
        certificate = get_random_certificate()
        if not validate_json(json.dumps(certificate)):
            print('Exception: Generated json is not valid.')
            exit()
        cert_filename = f'certificates/{idx}.json'
        with open(f'./{cert_filename}', 'wt') as f:
            json.dump(certificate, f, indent=4)
        certificates += [certificate]
        transaction = c1.mint(participant, cert_filename, {'from': organizer})
        transactions += [transaction]
        print(f'Certificate no.{len(certificates)} ({cert_filename}, ID {transaction.return_value})\n -> minted for participant no.{idx} ({participant})')
    print('Success!\n---')

    print('Test reading all information')
    print(f'All certificates: {c1.totalSupply()}')
    for i in range(c1.totalSupply()):
        tokenId = c1.tokenByIndex(i)
        print(f'  Certificate no.{i}  ID: {tokenId} URL: {c1.tokenURI(tokenId)}')
    print('-----')
    print('Number of participants: ', c1.ownersNumber())
    for i in range(c1.ownersNumber()):
        participantId = c1.ownerByIndex(i)
        print(f'  Participant no.{i}: {participantId}')
        print('  Participant\'s tokens:')
        for j in range(c1.balanceOf(participantId)):
            tokenId = c1.tokenOfOwnerByIndex(participantId, j)
            print(f'    {j}. ID: {tokenId} URL: {c1.tokenURI(tokenId)}')
        print()
    print('Success!\n---')

    
    # test burning
    print('Burn all')
    counter = 0
    while c1.totalSupply() > 0:
        tokenId = c1.tokenByIndex(0)
        print(f'  Burning token no.{counter}: {tokenId}')
        c1.burn(tokenId, {'from': organizer})
        counter+=1
    print('Success!\n---')
    print(f'Number of certificates: {c1.totalSupply()}')
    print(f'Number of participants: {c1.ownersNumber()}')

    print('The end')