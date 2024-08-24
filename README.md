# VIBES EMS
AI Doctor for QB-CORE

# Description :

This script is designed for servers where EMS or doctors are not available. Players can pay to receive immediate assistance and be revived on the spot by a doctor arriving in a moving ambulance.


# Features:

- **Enhanced Roleplay Experience:** This script is perfect for large servers, offering players more immersive roleplay opportunities by reducing the need for constant respawning or just sitting around.
- **Responsive EMS Ped:** The EMS ped in the ambulance can respond from any location, ensuring timely and well-coordinated assistance regardless of where you are on the map.
- **Configurable Notifications:** Tailor the script notifications to your server's needs. Choose from various notification systems such as QB-Notify, OkokNotify, Mythic Notify, or even provide your own custom notification function.
- **Phone Integration:** If you're using a phone system like lb-phone, the script can send notifications directly to the player's phone, enhancing the immersive experience.
- **Obstacle Navigation:** The EMS ped is now smarter and can navigate around obstacles, including vehicles, to reach the player more efficiently.
- **Seamless Integration:** Designed to enhance roleplay and minimize respawning, this script is compatible with the QBCORE framework.
- **Community Collaboration:** Hosted on GitHub, this script welcomes pull requests. Feel free to contribute by adding useful changes and improvements.
- **Open Usage Policy:** Use this script freely to enhance your server, but please don't edit and resell it.
- **Shoutouts:** Big thanks to @hh_aidoc for the fork. https://github.com/hhfw1/hh_aidoc

# Changelog:
## [1.8.0]  Changelog 2024-06-06

New Features:
EMS Timer Added: A new timer system has been integrated, providing real-time updates on EMS arrival times. If no response after 2x the quoted time, an automatic recall will be triggered to ensure prompt assistance.

Distance & Miles Ox Timer: Implemented a timer that accounts for the distance and miles to the incident scene, helping EMS units optimize their routes and response times.

Commands & Checks:
EMS Manual Command: EMS personnel can now manually command their systems for more precise operations. /ems

EMS Arrive Check: A new feature to verify when EMS arrives on the scene, ensuring that all incidents are logged and responded to accurately. Checks if the player has been revived

These enhancements are all about making our EMS system more efficient and responsive. Stay safe, and keep the good vibes rolling!



## [1.2.0] - 2024-06-06

### Added
- Vehicle Emergency Lights and Seirens options added to config.  
- NCP retries on failed revive attempt. Sometimes they get knocked out of the way by other elements in the city such as cars other npcs or adccidents.  
- Added Option to change spawned emergency vehicle in the config
- The NPC vehicle goes back to original spawn point


## [1.1.0] - 2024-06-06

### Added
- Configurable notification system support:
  - QB-Notify
  - OkokNotify
  - Mythic Notify
  - Custom notification function
- Phone integration for lb-phone, allowing notifications to be sent directly to the player's phone
- Obstacle navigation for the EMS ped, enabling smarter pathfinding around vehicles and other obstacles

### Changed
- Refactored the `Notify` function to handle different notification systems based on the configuration
- Updated the `DoctorNPC` function to retrieve the player's phone number and send notifications accordingly

### Fixed
- Resolved issues with the EMS ped getting stuck behind obstacles during navigation
- Fixed incorrect version comparison in the update notification system

## [1.0.0] - 2024-05-28

### Added
- Initial release of the Vibes EMS script
- Responsive EMS ped that can respond from any location on the map
- Integration with the QBCORE framework
- GitHub repository for community collaboration and open usage policy

# Install 

- Drop into resource folder 

	exports['vibes-ems']:TriggerAmbulanceCall()

This export can be used in other scripts such as qb-hospital.  I included the trigger in my script when the player is dead.  It will check for in citer players on the job then send ems  
