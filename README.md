ShareStationPhotoOverlay
------------------------

What ulitmately should be customizable from CMS:
1. Background image on all publicly visable pages. This is a 2048x1536 in landscape mode, 1536x2048 in portrait.
2. Next and Back buttons. Size TBD.
3. Location of Next and Back (top or bottom)
    - This will necessitate some programmatic constraints on things.
4. Whether camera is autoshutter with countdown, or button.
5. What info fields are required:
    - Name
    - Email
    - Age Gate
    - Gender (m/f/n)
    - Perhaps allow for generic "data" fields.
        inputType:          text
        inputPropertyName:  favoriteBand
        inputPrompt:        Your Favorite Band
        inputRequired:      true
        
6. Whether the overlay picker view is ever shown. If not, the user goes right from first tap to camera view. Whenever there is only one overlay, the picker is never shown.
7. Portrait or Landscape operation.

