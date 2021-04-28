# Map-Share
A personal project for learning more about SwiftUI, MVVM, finite-state machine model and some other models and patterns. 

There also exists a server (Node/TS/Express/MongoDB) and a client (React) hosted on Heroku ([Link to repository](https://github.com/Pedshi/share-map-heroku)). These are only used to experiment with the app live.

### Register
<p align="center">
  <img src="https://github.com/Pedshi/Share-Map/blob/main/register.gif" alt="Register Demo"/> 
</p>

### Login
<p align="center">
  <img src="https://github.com/Pedshi/Share-Map/blob/main/login.gif" alt="Login Demo"/> 
</p>

### Map
<p align="center">
  <img src="https://github.com/Pedshi/Share-Map/blob/main/map.gif" alt="Map View Demo"/>
</p>

---

## Some features

- Unidirectional data flow using finite-state machine model with [CombineFeedback](https://github.com/sergdort/CombineFeedback). A graph of the states, events and transitions for the Login view is depicted below. 

<p align="center">
  <img src="https://github.com/Pedshi/Share-Map/blob/main/login_fsm.png?raw=true" alt="State graph for login"/>
</p>

There exists no global state for the whole app, instead each 'View - View Model' pair has its own state management.

- Generic endpoints
- API request functions stored in enums, making it easier to find possible API requests for an entity
- Key Chain management for password and token
- Method injection (API) and initializer injection (KeyChainManager)
- Unit tests for API and Key Chain
- Small design system using [tokens](https://medium.com/eightshapes-llc/tokens-in-design-systems-25dd82d58421)

## Exceptions

- Sign in with Apple, not implemented since it would require an apple developer account
- MapWithMarker violates MVVM because it manipulates data

## Credits
- [Modern MVVM iOS App Architecture with Combine and SwiftUI](https://www.vadimbulavin.com/modern-mvvm-ios-app-architecture-with-combine-and-swiftui/)
- Login and register illustrations by [Alzea Arafat](https://ui8.net/users/kubikel-studio)
- [Design System for SwiftUI](https://github.com/vince19972/SwiftUI-Design-System-Demo)