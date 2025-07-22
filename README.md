# 🧭 Trailcraft – Smart Map Explorer (iOS)

**Trailcraft** is a modern iOS app built using **SwiftUI** and **Swift Concurrency** that 
turns maps into collaborative spaces. Add rich media markers, 
explore nearby places from Wikipedia, and communicate through integrated chat.

[📄 Privacy Policy](https://elfknell.github.io/Licenses/privacy_policy.html)

---

## 🚀 Features

- 🗺️ Add markers to any location on the map  
- 🖼 Attach **photos**, **videos**, and **descriptions** to markers using `PhotosUI` and `AVKit`
- 🌍 Auto-fetch **nearby landmarks** using **Wikipedia API**
- 💬 Add **messages** and **comments** to each marker via a shared chat
- 🧩 Create and share **map sections** (e.g. trip segments or events)
- 🔗 Share maps publicly and allow comments from others
- 🔄 Offline persistence with **SwiftData**
- ☁️ Firebase integration: **Firestore**, **Firebase Storage**

---

## 🧑‍💻 Tech Stack

| Technology         | Usage                         |
|--------------------|-------------------------------|
| `SwiftUI`          | Declarative UI                |
| `MapKit`           | Map rendering, annotations    |
| `SwiftData`        | Local persistence             |
| `Swift Concurrency`| Async APIs and network calls  |
| `PhotosUI`         | Media picker for photo/video  |
| `AVKit`            | Video playback                |
| `Kingfisher`       | Image loading from URLs       |
| `Firebase`         | Firestore DB + Media Storage  |
| `URLSession`       | Wikipedia API integration     |
| `MVVM + DI`        | Clean architecture            |

---

## 📦 Installation

git clone https://github.com/ElfKnell/UICoordinator.git
cd UICoordinator
open Trailcraft.xcodeproj

✅ Requires Xcode 15+
✅ Supports iOS 17+

📲 Enable Firebase via your own GoogleService-Info.plist
