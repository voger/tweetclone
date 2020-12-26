qx.Class.define("tweetclone.formElement.DateSelect", {
  statics: {
    register: function () {
      qxl.dialog.Dialog.registerFormElementHandlers(
        "dateselect",
        this._registration
      );
    },

    _registration: {
      initElement: function (fieldType, fieldData, key) {
        let formElement = new qxDateSelect.qxDateSelect();

        ["format", "allowNull", "years", "descendingYears"].forEach(function (property) {
          if(fieldData[property] !== undefined) {
            formElement.set({
              property: fieldData["propery"]
            });
          }
        });

        return formElement;
      },

      addToFormController: function (fieldType, fieldData, key, formElement) {
        this._formController.addTarget(formElement, "value", key, true, null, {
          converter: function (value) {
            this._form.getValidationManager().validate();
            return value;
          }.bind(this),
        });
      },
    },
  },
});
