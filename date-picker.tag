//- Date Picker written in Pug for Riot.js
date-picker
	//- The <input> element whose value is the chosen Date
	input(type="text" value="{formatValue()}"
		onfocus="{focus}" onblur="{blur}" onchange="{change}")
	//- The UI for the date picker
	.picker(if="{showPicker}" onmousedown="{pickerClick}")
		.monthSelector
			button(click="{prevMonth}") {opts.prevButton || "◀"}
			.currMonth {months[currentMonth]}
			button(click="{nextMonth}") {opts.nextButton || "▶"}
			button(click="{prevYear}") {opts.prevButton || "◀"}
			.currYear {currentYear}
			button(click="{nextYear}") {opts.nextButton || "▶"}
		table
			thead
				tr
					th(each="{weekday in weekdays}") {weekday}
			tbody
				tr(each="{row in rows}")
					td(class="{cur: d.getMonth() == currentMonth,"+
						"selected: d.valueOf() === value.valueOf(),"+
						"today: d.toDateString() === new Date().toDateString()}"
						each="{d in row}"
						click="{setValue}") {d.getDate()}
	script.
		// Sanitize `val` and set `this.value`
		var setValue = (val) => {
			this.value = new Date(val);
			// Invalid Date is changed to "today"
			if(isNaN(this.value.valueOf() ) ) {
				this.value = new Date();
			}
		};
		// Set `value` of default "picked" Date
		setValue(opts.value);
		// Set `formatValue` function
		this.formatValue = typeof opts.formatValue === "function" ?
			opts.formatValue : () => {
				return this.value.toLocaleDateString();
			};
		// Pre-calculate weekday and month names using current locale
		var d = new Date("1/1/2017");
		this.months = new Array(12);
		for(var i = 0; i < 12; i++) {
			d.setMonth(i);
			this.months[i] = d.toLocaleString(undefined, {"month": opts.monthFormat || "long"});
		}
		// Note: 1/1/17 was a Sunday
		d = new Date("1/1/2017");
		this.weekdays = new Array(7);
		for(var i = 0; i < 7; i++) {
			this.weekdays[i] = d.toLocaleString(undefined, {"weekday": opts.weekdayFormat || "short"});
			d.setDate(d.getDate() + 1);
		}

		// Current month displayed in the date picker UI
		this.monthOffset = 0;
		// Show the date picker UI when the <input> element is focused
		this.showPicker = false;
		this.focus = (e) => {
			if(this.showPicker)
				e.preventUpdate = true;
			else
				this.showPicker = true;
		};
		// Hide the picker on <input> blur, unless the picker itself is clicked
		this.pickerClick = (e) => {
			this.abortBlur = true;
			e.preventUpdate = true;
		};
		this.blur = (e) => {
			if(this.abortBlur) {
				e.currentTarget.focus();
				this.abortBlur = false;
				e.preventUpdate = true;
			} else {
				this.showPicker = false;
				this.monthOffset = 0;
			}
		};

		// If <input> element is changed directly, update `this.value`
		this.change = (e) => {
			setValue(e.currentTarget.value);
			// Clear `monthOffset`
			this.monthOffset = 0;
			// Manually update the <input>'s value (just in case Riot doesn't)
			e.currentTarget.value = this.formatValue(this.value);
		};

		// Value is set by clicking on a date in the picker UI
		this.setValue = (e) => {
			this.value = e.item.d;
			this.monthOffset = 0;
		};

		// Set the `monthOffset` accordingly
		this.prevMonth = (e) => {
			this.monthOffset--;
		};
		this.nextMonth = (e) => {
			this.monthOffset++;
		};
		this.prevYear = (e) => {
			this.monthOffset -= 12;
		};
		this.nextYear = (e) => {
			this.monthOffset += 12;
		};

		// Update the picker UI based on the `monthOffset`
		this.on("update", () => {
			var d = new Date(this.value);
			// Set to the 1st of the month
			d.setDate(1);
			// Set to the correct month according to the `monthOffset`
			d.setMonth(d.getMonth() + this.monthOffset);
			this.currentMonth = d.getMonth();
			this.currentYear = d.getFullYear();
			// Set to the previous Sunday (unless we are already Sunday)
			d.setDate(d.getDate() - d.getDay() );
			// Update calendar rows
			var row = [];
			this.rows = [row];
			// Render the first row of Dates
			for(var i = 0; i < 7; i++) {
				row.push(new Date(d));
				d.setDate(d.getDate() + 1);
			}
			/* Now `d` definitely points to the current month.
				Create a new row as long as we remain in that month. */
			while(this.currentMonth === d.getMonth() ) {
				row = [];
				for(var i = 0; i < 7; i++) {
					row.push(new Date(d));
					d.setDate(d.getDate() + 1);
				}
				this.rows.push(row);
			}
		});

	style(scoped).
		@import "./date-picker.styl"
