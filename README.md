# DofusProfessionHelper
A resources helper for dofus crafting professions.
## Usage
Pick a profession and a level range, click search. This outputs a list of all items from this profession in the level range.  
Select the quantity of each item you want to craft. Click Resources to display a list of resources needed to craft the items.  
Input the quantity of each resource that you already own to get the quantity you need to buy.
## TODO
- The data comes from a french third party database. The goal of the julia script is to scrape the official website (in both french and english) to get this data.
- General UI changes.
- Fix export button
- General cleanup
## Requirements
- Qt5: QtQuick, QtSQL, QtWidgets
