Product Requirements Document: NaikLah MVP
Product Overview
App Name: NaikLah Tagline: Sustainable Travel. Guaranteed Safety. Launch Goal: Deliver a functional, "demo-ready" prototype that wins the Hackathon by addressing SDG 11.2 (Safety) and 11.6 (Sustainability). Target Launch: 24 Hours (Hackathon Deadline)

Who It's For
Primary User: Lisa (The Vulnerable Commuter)
Description: A 22-year-old female university student or night-shift worker who relies on public transport but feels unsafe traveling alone after dark. Their Current Pain:

Avoids buses at night due to fear of harassment.

Finds private e-hailing (Grab) too expensive for daily commute.

Wants to be eco-friendly but prioritizes personal safety. What They Need:

Assurance that the bus she is taking is safe (Women-friendly).

A way for her parents/friends to watch over her digitally.

Financial incentives to choose the bus over a car.

Secondary User: The Guardian (Parent/Partner)
Description: Lisa’s mother or partner who worries when she travels late. What They Need:

Real-time reassurance that Lisa is on the correct route.

Instant alerts if something goes wrong (e.g., bus goes off-route).

The Problem We're Solving
Public transport is the key to sustainable cities, yet 65% of women avoid it due to safety concerns. We are solving the "Safety Gap" that prevents vulnerable groups from adopting sustainable travel.

Why Existing Solutions Fall Short:

Google Maps: Tells you how to get there, but not if it's safe for a woman at 10 PM.

Generic Rewards Apps: Only reward spending, not sustainable behavior or safety.

User Journey (The Demo Flow)
Discovery → First Use → Success
Discovery Phase

Hook: Lisa sees she can earn "Free Coffee" just for taking the bus, AND she sees a "Pink Bus" filter for safety.

Onboarding (First 2 Minutes)

Land on: Login Screen with "Gender Verification" (Simulated via Google Sign-In).

First Action: Toggle "Pink Bus Mode" on the map.

Quick Win: She sees a Pink Bus icon nearby with "Verified Female Driver."

Core Usage Loop

Trigger: Needs to go to campus/work.

Action: Books a "Pink Bus" and activates "Guardian Mode."

Reward: Guardian gets "Safe Arrival" notification; Lisa earns 50 Eco-Points.

Success Moment

"Aha!" Moment: The app alerts her Guardian automatically when the bus deviates from the route (Simulated in demo).

MVP Features
Must Have for Launch (P0 - Critical for Video)
1. PinkVerify Map Filter
What: A toggle switch on the main map.

User Story: As Lisa, I want to see only women-friendly buses so I can book a safe ride.

Success Criteria:

[ ] Toggling "Pink Mode" hides standard blue bus markers and shows pink ones.

[ ] Pink markers display "Female Driver" or "CCTV Verified" when tapped.

Priority: P0 (Critical)

2. Guardian Angel (Route Deviation Logic)
What: Real-time location tracking that detects anomalies.

User Story: As a Guardian, I want to be alerted if Lisa's bus goes off-route.

Success Criteria:

[ ] App tracks User GPS vs. Hardcoded Bus Polyline.

[ ] If distance > 100m, trigger a visible "RED ALERT" on the dashboard.

Priority: P0 (Critical - The "Wow" Factor)

3. Eco-Rewards Counter
What: A simple point accrual system.

User Story: As a user, I want to earn points for my trip.

Success Criteria:

[ ] "End Trip" button adds +50 points to user balance.

[ ] Points page shows a redeemable "Coffee Voucher" (Static image).

Priority: P1 (High)

Nice to Have (If Time Allows)
Panic Button: A floating red button that sends an SMS/WhatsApp intent with coordinates.

Employer Dashboard: A web chart showing CO2 saved (use Chart.js).

NOT in MVP (Saving for Later)
Real Payment Gateway integration.

Real-time bus GPS fetching (We will mock the bus location).

Actual AI camera integration (We will simulate occupancy).

Technical Considerations
Platform: Flutter (Mobile App) + Firebase (Backend) Responsive: Mobile-first (Portrait mode). Performance: Map markers must load instantly (Mock data). Privacy: "Ghost Mode" - Tracking stops immediately when "End Trip" is tapped.

Quality Standards
What This App Will NOT Accept:

Login Walls: For the demo, make login one-tap or auto-login. Don't waste the judge's time typing passwords.

Empty Maps: The map must start centered on a location with buses already visible.

Budget & Constraints
Timeline: 24 Hours remaining. Team: 5 Members (2 Frontend, 1 Backend, 2 Pitch/Video). Cost: $0 (Free Tier Firebase, OpenStreetMap).

Launch Strategy (The Video Demo)
Target: The Judges. Video Script Outline:

Scene 1: Lisa looking scared at a bus stop. (Problem)

Scene 2: She opens NaikLah, toggles "Pink Mode." (Solution)

Scene 3: Split screen - Lisa on bus / Mom at home getting "Safe" notification. (Impact)

Scene 4: Lisa redeeming points for coffee. (Retention)

Definition of Done for MVP
The MVP is ready to launch when:

[ ] User can toggle "Pink Mode" and see map pins change.

[ ] "Guardian" phone receives a database update when User moves.

[ ] "End Trip" updates the points balance.

[ ] The Video Team has recorded the screen interactions.