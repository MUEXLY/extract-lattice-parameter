import os
import re


def printAverage(
    alloy: str,
    numRealization: int,
    latParam: float
) -> None:
    print(
        f'alloy: {alloy}\n'
        f'Realizations: {numRealization}\n'
        f'Average lattice parameter: {latParam:.15f} [Ang]'
    )
    with open('avgLattice.txt', 'w+') as f:
        f.write('#alloy #realizations #avgLatParam\n')
        f.write(f'{alloy} {numRealization} {latParam:.15f}\n')


def main():
    alloy = 'AlMg5'
    folderPattern = f'{alloy}_seed\\d+'
    latParam = 0
    numRealization = 0
    with os.scandir('.') as files:
        for f in files:
            if f.is_dir() and re.search(folderPattern, f.name):
                dirName = f.name
                seedNum = dirName.split('seed')[-1]
                fileName = f'./{dirName}/{alloy}_s{seedNum}_a_AA.txt'
                with open(fileName, 'r') as d:
                    for data in d:
                        data = float(data.strip().split(' ')[-1])
                        latParam += data
                        numRealization += 1

    latParam /= numRealization
    printAverage(alloy, numRealization, latParam)


if __name__ == '__main__':
    main()
