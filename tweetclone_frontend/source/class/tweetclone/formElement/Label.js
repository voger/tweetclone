qx.Class.define("tweetclone.formElement.Label", {
  statics: {
    register: function () {
      qxl.dialog.Dialog.registerFormElementHandlers(
        "infolabel",
        this._registration
      );
    },

    _registration: {
      initElement: function (fieldType, fieldData, key) {
        const formElement = new tweetclone.widgets.Label();

        ["value", "font", "textAlign"].forEach(function (property) {
          if (fieldData[property] !== undefined) {
            formElement.set(property, fieldData[property]);
          }
        });
        return formElement;
      },
    },
  },
});
