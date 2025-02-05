# 🎯 Sitting Posture Detection Using FMCW Audio Signals

This project implements a **non-intrusive sitting posture detection system** using **FMCW (Frequency-Modulated Continuous Wave) audio signals**. Instead of using cameras or external sensors, the system leverages a **laptop's speaker and microphone** to transmit and receive sound waves, analyzing their reflections to classify different sitting postures.

Unlike **vision-based posture tracking**, this method:
✅ Ensures **privacy** by avoiding camera-based monitoring.  
✅ Works with **only a laptop (no extra hardware required)**.  
✅ Uses **Matlab for signal processing, clustering, and classification**.

---

## 📌 **Key Features**
✔️ **Generates FMCW signals** using a laptop’s speaker.  
✔️ **Captures reflected signals** via a microphone.  
✔️ **Processes & classifies postures** using **K-Means clustering**.  
✔️ **Eliminates self-interference** from the transmitted signal.  
✔️ **Handles noise & reflections** from stationary objects.  

---

## 📂 **Repository Structure**
📦 sitting-posture-detection/ ├── 📁 data/ # Contains recorded posture signals │ 
                              ├── posture1_UMA8SP_audio.wav # Audio when sitting straight │ 
                              ├── posture2_UMA8SP_audio.wav # Audio when leaning forward │ 
                              ├── posture3_UMA8SP_audio.wav # Audio when leaning back │ 
                              ├── 🎵 birdsound.wav # Sample test sound (optional) 
                              ├── 📜 generate_multi_fmcw_signal.m # Generates FMCW signals 
                              ├── 📜 K_mean_of_signal.m # Applies K-Means clustering 
                              ├── 📜 UMA8SP_FMCW_microphone.m # Captures microphone signals 
                              ├── 📜 UMA8SP_FMCW_speaker.m # Transmits signals via speaker 
                              ├── 📜 UMA8SP_FMCW_process.m # Processes received signals 
                              ├── 📜 recover_fmcw_blocks.m # Recovers FMCW signal blocks 
                              ├── 📜 remove_mtwister_random_phase.m # Removes random phase noise 
                              ├── 📜 apply_mtwister_random_phase.m # Applies phase correction 
                              ├── 📝 notes.txt # Developer notes
