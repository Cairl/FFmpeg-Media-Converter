import os, sys, subprocess
from pathlib import Path

source = Path(sys.argv[1])
ext = next(e for e in iter(
    lambda: input('Enter target extension: ').lstrip('.'), None
) if e or source.is_file() and source.suffix[1:])

files = [(f, f.parent / f'[FF] {f.stem}.{ext}', f.parent / f'[SR] {f.stem}{f.suffix}')
    for f in (source.glob('*') if source.is_dir() else [source])
    if not any(tag in f.name for tag in ['[FF]', '[SR]', '[RR]'])]

for i, (src, dst, bak) in enumerate(files, 1):
    os.system(f'title [{i}/{len(files)}] {src.stem}')
    tmp = src.parent / f'[RR] {src.stem}.{ext}'
    subprocess.run(['ffmpeg', '-hide_banner', '-i', str(src), str(tmp), '-y'])
    os.rename(tmp, dst)
    os.rename(src, bak)

input('\nConversion completed. \nPress the Enter key to remove the "[FF]" header...')
for _, dst, bak in files:
    os.rename(dst, dst.parent / dst.name.replace('[FF] ', ''))
    os.path.exists(bak) and os.remove(bak)