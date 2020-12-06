qx.Class.define("tweetclone.renderer.LoginFormRenderer", {
  extend: qx.ui.form.renderer.AbstractRenderer,

  construct: function (form) {
    const layout = new qx.ui.layout.Grid();
    layout.setSpacing(6);
    this._setLayout(layout);
    this.base(arguments, form);
  },

  members: {
    _row: 0,
    _buttonColumn: null,

    // override
    addItems: function (items, names, title) {
      // add the items
      for (var i = 0; i < items.length; i++) {
        var label = this._createLabel(names[i], items[i]);
        this._add(label, { row: this._row + ((i * 2) % 2), column: i % 2 });
        var item = items[i];
        label.setBuddy(item);

        this._connectVisibility(item, label);

        this._add(item, { row: this._row + ((i * 2) % 2) + 1, column: i % 2 });
        if (i % 2 == 1) {
          this._row += 2;
        }

        // store the names for translation
        if (qx.core.Environment.get("qx.dynlocale")) {
          this._names.push({ name: names[i], label: label, item: items[i] });
        }
      }

      if (i % 2 == 1) {
        this._row += 2;
      }
    },

    /**
     * Adds a button the form renderer. All buttons will be added in a
     * single row at the bottom of the form.
     *
     * @param button {qx.ui.form.Button} The button to add.
     */
    addButton: function (button) {
      if (this._buttonColumn == null) {
        // create button row
        this._buttonColumn = new qx.ui.container.Composite();
        this._buttonColumn.setAllowGrowY(false);
        const hbox = new qx.ui.layout.HBox();
        hbox.setAlignX("left");
        hbox.setAlignY("top");
        // hbox.setSpacing(5);
        this._buttonColumn.setLayout(hbox);

        this._add(this._buttonColumn, {
          row: this.__findFirstNonLabelRow(),
          column: this.getLayout().getColumnCount() 
        });

        // increase the row
        this._row++;
      }

      // add the button
      this._buttonColumn.add(button);
    },

    /**
     * Returns the set layout for configuration.
     *
     * @return {qx.ui.layout.Grid} The grid layout of the widget.
     */
    getLayout: function () {
      return this._getLayout();
    },

    /**
     * Creates a label for the given form item.
     *
     * @param name {String} The content of the label without the
     *   trailing * and :
     * @param item {qx.ui.core.Widget} The item, which has the required state.
     * @return {qx.ui.basic.Label} The label for the given item.
     */
    _createLabel: function (name, item) {
      var label = new qx.ui.basic.Label(this._createLabelText(name, item));
      // store labels for disposal
      this._labels.push(label);
      label.setRich(true);
      return label;
    },

    /**
     * Returns the first row where the widget of the cell in the first
     * column is not a label
     * @return {Integer} The row number where the first widget is not a Label
     */
    __findFirstNonLabelRow: function () {
      const layout = this.getLayout();

      for (let i = 0; i < layout.getRowCount(); i++) {
        if (layout.getCellWidget(i, 0).classname !== "qx.ui.basic.Label") {
          return i;
        }
      }
      return 0;
    },

    /**
     * Creates a header label for the form groups.
     *
     * @param title {String} Creates a header label.
     * @return {qx.ui.basic.Label} The header for the form groups.
     */
    _createHeader: function (title) {
      var header = new qx.ui.basic.Label(title);
      // store labels for disposal
      this._labels.push(header);
      header.setFont("bold");
      if (this._row != 0) {
        header.setMarginTop(10);
      }
      header.setAlignX("left");
      return header;
    },
  },

  /*
  *****************************************************************************
     DESTRUCTOR
  *****************************************************************************
  */
  destruct: function () {
    // first, remove all buttons from the bottom row because they
    // should not be disposed
    if (this._buttonColumn) {
      this._buttonColumn.removeAll();
      this._disposeObjects("_buttonColumn");
    }
  },
});
