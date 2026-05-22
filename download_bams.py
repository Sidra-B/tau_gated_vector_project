import os
import requests
import re

BASE_URL = "https://app.flow.bio/api"
EXECUTION_ID = "923930691099489556"
DOWNLOAD_DIR = "./bam_files"

USERNAME = os.getenv("FLOW_USERNAME")
PASSWORD = os.getenv("FLOW_PASSWORD")

if not USERNAME or not PASSWORD:
    print("Error: Please set FLOW_USERNAME and FLOW_PASSWORD environment variables")
    exit(1)

# Authenticate
s = requests.Session()
try:
    s.post(f"{BASE_URL}/login", json={"username": USERNAME, "password": PASSWORD}).raise_for_status()
    access = s.get(f"{BASE_URL}/token").json().get("token")
    s.headers.update({"Authorization": f"Bearer {access}"})
    print("✓ Authentication successful\n")
except Exception as e:
    print(f"✗ Authentication failed: {e}")
    exit(1)

os.makedirs(DOWNLOAD_DIR, exist_ok=True)

# Get execution data
print(f"Fetching execution {EXECUTION_ID}...")
try:
    exec_resp = s.get(f"{BASE_URL}/executions/{EXECUTION_ID}")
    exec_resp.raise_for_status() # Catches 404s/500s before parsing JSON
    execution_data = exec_resp.json()
except Exception as e:
    print(f"✗ Failed to fetch execution data: {e}")
    exit(1)

process_execs = execution_data.get("process_executions", [])

# Find all sorted.bam files
found_files = []

print(f"Searching {len(process_execs)} processes...\n")

for proc in process_execs:
    if not proc:
        continue
    
    proc_name = proc.get("name", "")
    downstream = proc.get("downstream_data", [])
    
    # downstream_data is already a list of file objects
    for file_obj in downstream:
        filename = file_obj.get("filename", "")
        
        # Search filter (Indentation fixed here)
        if re.search(r'.*sorted\.bam(\.bai)?$', filename):
            found_files.append(file_obj)
            print(f"✓ Found: {filename}")

if not found_files:
    print("\n✗ No BAM files found")
    exit(1)

# Download files
print(f"\n\nDownloading {len(found_files)} files...\n")

for file_obj in found_files:
    file_id = file_obj.get("id")
    filename = file_obj.get("filename")
    filepath = os.path.join(DOWNLOAD_DIR, filename)
    file_size = file_obj.get("size", 0)
    
    try:
        url = f"https://app.flow.bio/files/downloads/{file_id}/{filename}"
        print(f"Downloading {filename} ({file_size / (1024**3):.2f} GB)...")
        
        response = s.get(url, stream=True, timeout=300)
        response.raise_for_status()
        
        downloaded = 0
        with open(filepath, 'wb') as f:
            for chunk in response.iter_content(chunk_size=1024*1024):
                if chunk:
                    f.write(chunk)
                    downloaded += len(chunk)
                    percent = (downloaded / file_size * 100) if file_size > 0 else 0
                    # Added padding spaces to ensure clean terminal overwriting
                    print(f"  {percent:.1f}% complete          ", end='\r')
        
        # Added padding here as well
        print(f"✓ Downloaded: {filepath}                 ")
    except Exception as e:
        print(f"\n✗ Failed to download {filename}: {e}")

print("\n✓ Download complete!")