from flask import Flask, jsonify, request
from pyngrok import ngrok
import firebase_admin
from firebase_admin import firestore
from firebase_admin import credentials, storage, initialize_app, firestore
from vlc import State
import os
import vlc

video_files = {}
media_player = None

app = Flask(__name__)


cred = credentials.Certificate("credential.json")
firebase_app = initialize_app(cred, {
    'storageBucket': 'pdcdb-ed421.appspot.com'
})
storage_client = storage.bucket(app=firebase_app)
db = firestore.client()


folder_name = "videos"

local_directory = "./videos/"

# Ensure local directory exists
os.makedirs(local_directory, exist_ok=True)

# Set ngrok authentication token
ngrok.set_auth_token("2fbK3XRIsUtUAbECqw6NoKbLE0K_sL6ikr327mkm7NZBmAod")
def initialize_player(video_file):
    global media_player
    if media_player is not None:
        media_player.stop()
    media = vlc.Media(video_file)
    media_player = vlc.MediaPlayer()
    media_player.set_media(media)
    media_player.set_fullscreen(True)
    media_player.play()
    print("there is the state")
    while True:
        value = media_player.get_state()
        # print(value)
        if value == State.Ended:
            media.release()
            initialize_player(video_file)
            # media_player.previous() 

        


def create_ngrok_tunnel(port):
    try:
        # Open a TCP tunnel on the specified port
        tunnel = ngrok.connect(port, "tcp")
        tunnel_url = tunnel.public_url

        print("Ngrok tunnel created successfully.")
        print("Tunnel URL:", tunnel_url)

        # Check if there are any existing documents in the collection
        tunnel_ref = db.collection('ngrok_tunnels')
        existing_docs = tunnel_ref.get()

        # If there are existing documents, update the first one found with the current tunnel URL
        if existing_docs:
            for doc in existing_docs:
                doc_ref = tunnel_ref.document(doc.id)
                doc_ref.update({'tunnel_url': tunnel_url})
                print("Existing tunnel URL updated in Firebase.")
                break  # Update only the first document found

        # If there are no existing documents, create a new one with the current tunnel URL
        else:
            tunnel_ref.add({'tunnel_url': tunnel_url})
            print("New tunnel URL stored in Firebase.")

    except Exception as e:
        print("Error creating ngrok tunnel:", e)



def download_all_videos():
    print('Downloading... all.. Videos...')
    global video_files  # Accessing global variable
    # Retrieve list of blobs (files) in the specified folder
    blobs = storage_client.list_blobs(prefix=folder_name)

    # Clear previous data in video_files
    video_files.clear()

    # Initialize count for numbering videos
    count = 1

    # Download each video file and ensure unique filenames
    for blob in blobs:
        # Extract the file name from the blob path
        filename = os.path.basename(blob.name)

        # Generate the new filename with the prefix and count
        new_filename = f"video{count}.mp4"

        # Download the video file to local storage
        blob.download_to_filename(os.path.join(local_directory, new_filename))
        video_files[f"video{count}"] =  os.path.join(local_directory, new_filename)
        video_files= video_files
        print(f"Downloaded {new_filename}")

        # Increment count for the next video
        count += 1

    print("All videos downloaded successfully.")
    print("videofiles",video_files)
@app.route('/hello', methods=['GET'])
def helloworld():
    print('Hello')
    data = {"data": "Hello World"}
    return jsonify(data)

@app.route('/download_videos', methods=['GET'])
def download_videos():
    print('Downloading... Videos')
    download_all_videos()
    return jsonify({"message": "Videos downloaded successfully.", "video_files": video_files})

@app.route('/play/<video_name>', methods=['GET'])

def play(video_name):
    print(video_files)
    print('Play',video_name)
    video_file = video_files.get(video_name)
    if video_file:
        initialize_player(video_file)
        data = {"data": f"Playing {video_name}"}
    else:
        data = {"error": "Video not found"}
    return jsonify(data)


@app.route('/pause', methods=['GET'])
def pause():
    print('Pause')
    if media_player is not None:
        media_player.pause()
    data = {"data": "Paused"}
    return jsonify(data)


@app.route('/p', methods=['GET', 'POST'])
def plays():
    print('Play')
    if request.method == 'GET' or request.method == 'POST':
        if media_player is None:
            initialize_player()
        media_player.play()
        data = {"data": "Playing"}
        return jsonify(data)


if __name__ == "__main__":
    port = 5000  # Change to the port your Flask app runs on
    create_ngrok_tunnel(port)
    download_all_videos()
    app.run(debug=True)