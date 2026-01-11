<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Jaltejas Mobile App – Documentation</title>

<style>
body {
  font-family: "Segoe UI", Roboto, Arial, sans-serif;
  margin: 0;
  background: #0b1220;
  color: #e5e7eb;
  line-height: 1.6;
}

header {
  background: linear-gradient(135deg, #0ea5e9, #2563eb);
  padding: 50px 20px;
  text-align: center;
}

header h1 {
  font-size: 3rem;
  margin-bottom: 10px;
}

header p {
  max-width: 900px;
  margin: auto;
  font-size: 1.2rem;
}

section {
  padding: 50px 10%;
}

h2 {
  color: #38bdf8;
  margin-bottom: 15px;
  font-size: 2rem;
}

h3 {
  color: #a5f3fc;
  margin-top: 30px;
}

.card {
  background: #111827;
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 25px;
  box-shadow: 0 10px 25px rgba(0,0,0,0.4);
}

ul {
  padding-left: 20px;
}

.badge {
  display: inline-block;
  background: #1e40af;
  padding: 6px 12px;
  border-radius: 20px;
  margin: 5px;
  font-size: 0.9rem;
}

.gallery {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 20px;
}

.gallery img {
  width: 100%;
  border-radius: 12px;
  box-shadow: 0 8px 20px rgba(0,0,0,0.5);
}

.code {
  background: #020617;
  padding: 15px;
  border-radius: 8px;
  overflow-x: auto;
  font-family: monospace;
  font-size: 0.9rem;
}

.diagram {
  background: #020617;
  padding: 20px;
  border-radius: 12px;
  font-family: monospace;
  white-space: pre-wrap;
}

footer {
  text-align: center;
  padding: 30px;
  background: #020617;
  color: #94a3b8;
}

.feature-list {
  list-style: none;
  padding-left: 0;
}

.feature-list li::before {
  content: "✔";
  color: #38bdf8;
  margin-right: 10px;
}

.feature-list li {
  margin-bottom: 10px;
}


</style>
</head>

<body>

<header>
  <h1>📱 Jaltejas Mobile Application</h1>
  <p>
    The official Flutter-based control application for the Jaltejas Underwater ROV.
    It enables secure authentication, real-time ROV control, mission planning,
    telemetry visualization, AI alerts, and Firebase-powered data storage.
  </p>
</header>

<section>
  <h2>🚀 Key Features</h2>
  <div class="card">
    <span class="badge">Flutter</span>
    <span class="badge">Firebase</span>
    <span class="badge">ROV Control</span>
    <span class="badge">AI Alerts</span>
    <span class="badge">Live Video</span>

  <ul class="feature-list">
  <li>Secure Pilot Authentication</li>
  <li>Mission creation & tracking</li>
  <li>Live video streaming from ROV</li>
  <li>Depth, heading & battery telemetry</li>
  <li>AI-based underwater object alerts</li>
</ul>

  </div>
</section>

<section>
  <h2>📸 App UI Screenshots</h2>
  <div class="gallery">
    <img src="ui-screenshot/1.png" alt="Screenshot 1"/>
    <img src="ui-screenshot/2.png" alt="Screenshot 2"/>
    <img src="ui-screenshot/3.png" alt="Screenshot 3"/>
    <img src="ui-screenshot/4.png" alt="Screenshot 4"/>
    <img src="ui-screenshot/5.png" alt="Screenshot 5"/>
    <img src="ui-screenshot/6.png" alt="Screenshot 6"/>
    <img src="ui-screenshot/7.png" alt="Screenshot 7"/>
    <img src="ui-screenshot/8.png" alt="Screenshot 8"/>
  </div>
</section>

<section>
  <h2>🧱 Application Architecture</h2>
  <div class="diagram">
Flutter UI
   ↓
State Management
   ↓
Firebase Auth & Firestore
   ↓
ROV Communication (MAVLink / UDP)
   ↓
AI Detection Alerts
  </div>
</section>

<section>
  <h2>🔄 Application Flowchart</h2>
  <div class="diagram">
App Launch
   ↓
Pilot Login / Signup
   ↓
Dashboard
   ├── Live Video
   ├── Telemetry
   ├── Create Mission
   └── Mission History
   ↓
Firebase Sync
  </div>
</section>

<section>
  <h2>🗄️ Firebase Database Design</h2>

  <h3>📌 Collection: Pilots</h3>
  <div class="code">
pilotId: "Rajat" (string)
Name: "Rajat Singhal" (string)
Phone: 9760197197 (number)
passcode: 6179 (number)
max_depth: "30.5 m" (string)
total_time: "10h 20m" (string)
  </div>

  <h3>📌 Collection: Missions</h3>
  <div class="code">
mission_id: "Mission01" (string)
mission_name: "My Mission" (string)
pilotId: "Rajat" (string)
location: "Pacific" (string)
depth: "12.5" (string)
duration: "40m 20s" (string)
status: "COMPLETE" (string)
imageUrl: "https://picsum.photos/seed/rov1/400/200" (string)
date: January 20, 2026 at 1:33:24 AM (timestamp)
  </div>
</section>

<section>
  <h2>🧩 ER Diagram</h2>
  <div class="diagram">
PILOTS ||----o{ MISSIONS

PILOTS:
- pilotId (PK)
- Name
- Phone
- max_depth
- total_time

MISSIONS:
- mission_id (PK)
- pilotId (FK)
- depth
- duration
- location
- status
- date
  </div>
</section>

<section>
  <h2>⚙️ How to Run the App</h2>
  <div class="card">
    <div class="code">
flutter doctor
flutter pub get
flutter run
    </div>
  </div>
</section>

<section>
  <h2>🏆 Hackathon Value</h2>
  <div class="card">
    <ul>
      <li>Real-time robotics control</li>
      <li>Cloud-based mission logging</li>
      <li>AI-powered underwater analysis</li>
      <li>Industry-grade mobile architecture</li>
    </ul>
  </div>
</section>

<footer>
  © 2026 Jaltejas Underwater ROV | Hack-the-Winter | Team Nishchay
</footer>

</body>
</html>
