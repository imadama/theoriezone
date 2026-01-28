import os
import json
import re
import quopri
from bs4 import BeautifulSoup

SOURCE_DIR = '/home/imad/Documents/GitHub/theoriezone/backend/database/seeders/raw_html'
OUTPUT_FILE = '/home/imad/Documents/GitHub/theoriezone/backend/database/seeders/all_questions.json'

def extract_html_from_mhtml(content):
    # Probeer de HTML sectie te vinden
    # MHTML boundaries zijn vaak ----MultipartBoundary...
    # We zoeken gewoon naar <!DOCTYPE html> tot einde of volgende boundary
    
    # Eerst alles decoden van Quoted-Printable als het lijkt op QP
    if '=3D' in content:
        try:
            # Decode QP
            content = quopri.decodestring(content.encode('utf-8')).decode('utf-8', errors='ignore')
        except:
            pass

    # Zoek HTML start
    match = re.search(r'<!DOCTYPE html>.*', content, re.DOTALL | re.IGNORECASE)
    if match:
        return match.group(0)
    
    # Fallback: misschien is het gewoon HTML
    return content

def parse_file(filepath):
    print(f"Processing {os.path.basename(filepath)}...")
    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        raw_content = f.read()
    
    html_content = extract_html_from_mhtml(raw_content)
    soup = BeautifulSoup(html_content, 'html.parser')
    
    table = soup.find('table', class_='app_tablefull')
    if not table:
        print(f"Skipping {filepath}: No table found (HTML length: {len(html_content)})")
        return []

    questions = []
    rows = table.find_all('tr')[1:]
    
    for row in rows:
        cols = row.find_all('td')
        if len(cols) < 4:
            continue
            
        # ID
        try:
            q_id = cols[0].get_text(strip=True)
        except: continue

        # Category
        try:
            category = cols[1].get_text(strip=True)
        except: category = "Overig"
        
        # Question Text
        try:
            text = cols[3].get_text(strip=True)
        except: continue
        
        # Image
        image_src = None
        try:
            img_tag = cols[4].find('img')
            if img_tag and 'src' in img_tag.attrs:
                src = img_tag['src']
                if 'base64' not in src and 'ico/' not in src:
                    image_src = src
        except: pass

        if text:
            questions.append({
                'external_id': q_id,
                'category': category,
                'text': text,
                'image_raw': image_src
            })
        
    print(f" -> Found {len(questions)} questions")
    return questions

all_data = []
for filename in os.listdir(SOURCE_DIR):
    if filename.endswith('.jpg') or filename.endswith('.md') or filename.endswith('.py'):
        continue
        
    path = os.path.join(SOURCE_DIR, filename)
    all_data.extend(parse_file(path))

# Deduplicate
unique_questions = {}
for q in all_data:
    unique_questions[q['text']] = q # Dedupe on text to be sure

print(f"Totaal gevonden unieke vragen: {len(unique_questions)}")

with open(OUTPUT_FILE, 'w') as f:
    json.dump(list(unique_questions.values()), f, indent=2)
