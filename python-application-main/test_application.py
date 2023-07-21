import json

from application import process_json_file

def test_process_json_file():
    # Define the file path and JSON data
    file_path = 'example_1.json'
    json_data = {
        "fruit": "Apple",
        "size": "Large",
        "color": "Red"
    }

    # Save the JSON data to a temporary file
    with open(file_path, 'w') as file:
        json.dump(json_data, file)

    # Call the process_json_file function
    processed_data = process_json_file(file_path)

    # Check if the processed data matches the expected data
    assert processed_data == json_data
