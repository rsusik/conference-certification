# Conference certification on blockchain

## About

Blockchain certification of research outputs and academic achievements: A case of scientific conference.

## Requirements

* Python >= 3.8
* Miniconda/Anaconda (for managing environment, optional)
* brownie == 1.17.2
* node/npm (to install and run Ganache)
* Ganache == v6.12.2

## Project

* Standard: project is based on ERC721 OpenZeppelin implementation.
* JSON schema: Certificates are stored in JSON format. The schema of the certificates as well as it's dependencies are stored in [`schema`](./schema/) folder.
* Scripts: All scripts including demo, data validation and data generation are stored in [`scripts`](./scripts/) folder.
* Certificates: All generated sample certificates are stored in [`scripts/certificates`](./scripts/certificates/) folder.
* Output: The output of the demo is saved in [`output.txt`](./output.txt) file.
* ERC721 extension: to give easy access to conference participant list (certificate holders) we implemented `ERC721EnumerableOwners` extension. Its interface ([`IERC721EnumerableOwners.sol`](./contracts/IERC721EnumerableOwners.sol)) and implementation ([`ERC721EnumerableOwners.sol`](./contracts/ERC721EnumerableOwners.sol)) are in [`contracts`](./contracts/) folder.

## Deployment

### Environment setup

```
conda create -n pat python=3.8
conda activate pat
pip install -r requirements.txt

npm install ganache-core@2.13.2
npm install ganache-cli@6.12.2
```

> Note: `conda` commands can be omitted but is recommend.

### Demo

Demo that deploys the smart contract, mint certificates on blockchain and tests functionality is implemented in [`demo.py`](./scripts/demo.py) script.
The demo produces and output such as [`output.txt`](./output.txt).
Tu run demo execute:

```
brownie run demo
```

> Note: to save the output to file without coloring ANSI escape codes execute: `brownie run demo | sed -e 's/\x1b\[[0-9;]*m//g' > output.txt`

## _Disclaimer_

_This repository contains a source codes written for research purposes. There is no warranty and you use it at your own risk._
