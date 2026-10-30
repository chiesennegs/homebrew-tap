import hashlib
import json
from pathlib import Path
import re
import sys
import tarfile

root = Path(sys.argv[1])
version = sys.argv[2]
if not re.fullmatch(r'\d+\.\d+\.\d+', version):
    raise SystemExit('Version must be X.Y.Z')
filename = f'delta-wifi-{version}-macos-universal.tar.gz'
archive = root/filename
checksum = hashlib.sha256(archive.read_bytes()).hexdigest()
checksum_file = (root/(filename+'.sha256')).read_text().split()
assert checksum_file == [checksum, filename], 'Release checksum mismatch'
formula = (root/'delta-wifi.rb').read_text()
expected = f'https://github.com/chiesennegs/delta-wifi/releases/download/v{version}/{filename}'
assert re.search(r'^  url "'+re.escape(expected)+r'"$', formula, re.M), 'Unexpected formula URL'
assert re.search(r'^  version "'+re.escape(version)+r'"$', formula, re.M), 'Version mismatch'
assert re.search(r'^  sha256 "'+checksum+r'"$', formula, re.M), 'Formula checksum mismatch'
with tarfile.open(archive) as tar:
    entry = tar.getmember(f'delta-wifi-{version}/release-manifest.json')
    manifest = json.load(tar.extractfile(entry))
assert manifest['version'] == version
assert set(manifest['architectures']) == {'arm64','x86_64'}, 'Expected universal helper release'
print('Release version, URL, archive checksum, and architectures verified.')
