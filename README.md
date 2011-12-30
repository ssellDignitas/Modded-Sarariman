# Modded Sarariman
### Steven Sell, Dignitas Technologies; ssell@dignitastechnologies.com

**Notice:** the code is still very rough and the system is NOT production ready

Updated the original Sarariman Time-Tracking tool with a new look, grid-based timecard tracking, and QuickBooks Web Connector integration.

All pages beginning with `UC_*` are updated visually, and in release will have the `UC_*` removed. When starting this project I wished to maintain
the integrity of the original website design in case something horrific occured, hence the presence of the original site at `index.html`.

Any additions to the system for interfacing with the QuickBooks Web Connect is located at `src/java/com/dignitastechnologies/sarariman/qb`. The actual
PHP Framework is credited to Keith Palmer Jr., ConsoliBYTE.com. The modified framework is found in the `php_framework` folder and should be housed
in `/var/www/QBWC`

## Future Plans

> 1. Code/system clean-up
2. .QWC generator
3. Task Creator to pull jobs from QuickBooks and create associated tasks in Sarariman database
4. Drop-down task editor option on grid-view (opposed to current modal)
