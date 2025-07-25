# Matrix Navigation Model

## Navigation Structure

The data model uses a 2D matrix where:

- **Vertical axis (Y)**: Dates - scroll up for past dates, down for future dates
- **Horizontal axis (X)**: Time versions - scroll left for earlier versions, right for newer versions

## Current Position (July 27, 12:37:30)

``` text
         Earlier ← TIME → Later
         
Earlier  │ July 25  │ [09:15:00] → [14:30:00]
    ↑    │ July 26  │ [10:00:00] → [16:45:00]
  DATES  │ July 27  │ [08:30:00] → [12:12:10] → [12:37:30] ← CURRENT
    ↓    │ July 28  │ [09:00:00]
 Later   │   ...    │
```

## Key Features

1. **Date Navigation**: Swipe up/down to navigate between dates
2. **Version Navigation**: Swipe left/right to navigate between versions on the same date
3. **Current Position Tracking**: System maintains current position in the matrix
4. **Efficient Access**: Uses indexed structure for fast navigation
5. **Metadata Support**: Each note version includes tags, timestamps, and modification tracking

## Data Access Pattern

```javascript
// Get current note
const currentNote = notes[currentDate].versions[currentVersionIndex];

// Navigate to previous day
const previousDate = getPreviousDate(currentDate);
const previousDayNotes = notes[previousDate];

// Navigate to earlier version
const earlierVersion = notes[currentDate].versions[currentVersionIndex - 1];
```