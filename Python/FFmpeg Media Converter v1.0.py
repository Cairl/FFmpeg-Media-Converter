import os
import sys
import subprocess

source_location = sys.argv[1]

output_ext = input('Enter the target file extension (default uses the original extension): ').lstrip('.')

if not output_ext:
    if os.path.isdir(source_location):
        while not output_ext:
            output_ext = input('Extension must be specified for folder conversion: ').lstrip('.')
    else:
        output_ext = os.path.splitext(source_location)[1][1:]

files_to_convert = (
    [os.path.join(source_location, f) for f in os.listdir(source_location) if os.path.isfile(os.path.join(source_location, f))]
    if os.path.isdir(source_location) else [source_location]
)

converted_files = []
sr_files = []

for i, file_path in enumerate(files_to_convert, 1):
    file_name, ext = os.path.splitext(os.path.basename(file_path))
    dir_name = os.path.dirname(file_path)
    tmp_file = f'{dir_name}/[RR] {file_name}.{output_ext}'
    dst_file = f'{dir_name}/[FF] {file_name}.{output_ext}'
    src_file = f'{dir_name}/[SR] {file_name}{ext}'

    os.system(f'title [{i}/{len(files_to_convert)}] {file_name}')
    subprocess.run(['ffmpeg', '-hide_banner', '-i', file_path, tmp_file, '-y'])
    os.rename(tmp_file, dst_file)
    os.rename(file_path, src_file)

    converted_files.append(dst_file)
    sr_files.append(src_file)

input('\nConversion complete. \nPress Enter to remove file identifiers and restore originals...')

for file_path in converted_files:
    file_name = os.path.basename(file_path)
    dir_name = os.path.dirname(file_path)
    if file_name.startswith('[FF] '):
        os.rename(file_path, f"{dir_name}/{file_name.replace('[FF] ', '')}")

for sr_file in sr_files:
    if os.path.isfile(sr_file):
        os.remove(sr_file)

input('Process complete!')