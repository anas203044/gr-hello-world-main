import json

def process_json_file(file_path):
    with open(file_path, 'r') as file:
        data = json.load(file)
        return data

# Usage
json_file_path = 'example_1.json'
processed_data = process_json_file(json_file_path)

# Save processed data as an artifact
with open('artifact.json', 'w') as output_file:
    json.dump(processed_data, output_file)
