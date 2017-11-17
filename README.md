# riot-date-picker

Date picker component for Riot.js.

Weekday names and month names are not hard-coded.  They use
[Date.toLocaleDateString()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toLocaleDateString)
to get the names from the web browser.

## Options (opts)

- `value` - the default value for the Date Picker (defaults to current date
	if not specified)
- `formatValue` - the function used to format the date and display it in the
	`<input>` field
- `monthFormat` - one of "numeric", "2-digit", "narrow", "short", "long".
	Defaults to "long".  See
	[Date.toLocaleDateString()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toLocaleDateString)
	for more information.
- `weekdayFormat` - one of "long", "short", or "narrow".  Defaults to "short".
- `prevButton` - defaults to "◀"
- `nextButton` - defaults to "▶"

## Compatibility

Uses arrow functions, so it is not IE compatible.  Try using babel if you need
this working for IE 11.