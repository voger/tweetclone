qx.Class.define("tweetclone.renderer.DialogRenderer", {
  extend: qxl.dialog.FormRenderer,
  implement: qx.ui.form.renderer.IFormRenderer,

  members: {
    addItems: function (items, names, title) {
      if (title !== null) {
        this._add(this._createHeader(title), {
          row: this._row,
          column: 0,
          colSpan: 2,
        });
        this._row++;
      }
      for (let i = 0; i < items.length; i++) {
        let item = items[i];
        let widget;
        let label;
        if (item instanceof qx.ui.form.RadioGroup) {
          if (item.getUserData("orientation") === "horizontal") {
            widget = this._createHBoxForRadioGroup(item);
          } else {
            widget = this._createWidgetForRadioGroup(item);
          }
        } else {
          widget = item;
        }
        if (names[i] && item.getUserData("excluded")) {
          label = new qx.ui.basic.Label(names[i]);
          label.setRich(true);
          this._add(label, {
            row: this._row,
            column: 0,
            colSpan: 2,
          });
        } else if (
          item instanceof qx.ui.form.CheckBox ||
          item instanceof tweetclone.widgets.Label
        ) {
          this._add(widget, {
            row: this._row,
            column: 0,
            colSpan: 2,
          });
          this._getLayout().getCellWidget(this._row, 0).setAlignX("left");
        } else if (!names[i]) {
          this._add(widget, {
            row: this._row,
            column: 0,
            colSpan: 2,
          });
        } else {
          label = this._createLabel(names[i], item);
          label.setRich(true);
          this._add(label, {
            row: this._row,
            column: 0,
          });
          this._add(widget, {
            row: this._row,
            column: 1,
          });
        }
        this._row++;
      }
    },
  },
});
