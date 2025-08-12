#!/usr/bin/env python3

import subprocess
import tkinter as tk
from datetime import datetime


recording_process = None

def take_screenshot():
    filename = f"/home/valentin/Images/Screenshots/screenshot_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"
    subprocess.run(["grim", "-g", subprocess.check_output(["slurp"]).decode().strip(), filename])
    root.destroy()
    exit()



def toggle_record():
    global recording_process
    if recording_process is None:
        filename = f"/home/valentin/Vidéos/Captures/recording_{datetime.now().strftime('%Y%m%d_%H%M%S')}.mp4"
        region = subprocess.check_output(["slurp"]).decode().strip()
        recording_process = subprocess.Popen(["wf-recorder", "-g", region, "-f", filename])
        record_button.config(text="Arrêter l'enregistrement")
    else:
        recording_process.terminate()
        recording_process = None
        root.destroy()
        exit()

# Pour l'interface ->


root = tk.Tk()
root.geometry("300x100+800+50")
root.configure(bg="#054585")
root.overrideredirect(True)
button_style = {
    "bg": "#ffffff",
    "activebackground": "#cce6ff",
    "highlightthickness": 2,
    "highlightbackground": "#ffffff",
    "bd": 0,
    "font": "bold",
    "relief": "solid",
    "padx": 10,
    "pady": 5
}
screenshot_button = tk.Button(root, text="    Prendre une capture d'écran",  command=take_screenshot)
screenshot_button.pack(pady=10)
record_button=tk.Button(root, text ="    Démarrer l'enregistrement d'écran", command=toggle_record)
record_button.pack(pady=10)
root.mainloop()