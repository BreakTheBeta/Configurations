#!/usr/bin/env python3
"""Clone the audited fork revisions without touching existing checkouts."""
import argparse
import json
from pathlib import Path
import subprocess

root = Path(__file__).resolve().parent.parent
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--apply', action='store_true')
args = parser.parse_args()
for fork in json.loads((root / 'inventory/forks.json').read_text()).values():
    target = Path.home() / 'Projects' / fork['directory']
    if target.exists():
        print(f'Keeping existing checkout: {target}; compare inventory/forks.json manually.')
        continue
    print(f"Clone https://github.com/{fork['repository']}.git at {fork['commit']} -> {target}")
    if args.apply:
        target.parent.mkdir(parents=True, exist_ok=True)
        subprocess.run(['git', 'clone', '--no-checkout', 'https://github.com/' + fork['repository'] + '.git', str(target)], check=True)
        subprocess.run(['git', '-C', str(target), 'checkout', '--detach', fork['commit']], check=True)
