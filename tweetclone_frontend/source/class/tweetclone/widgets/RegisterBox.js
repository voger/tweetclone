/**
 * @asset("tweetclone/icons/custom/hello_cat.png")
 *
 */
qx.Class.define("tweetclone.widgets.RegisterBox", {
  extend: qx.ui.container.Composite,

  construct: function () {
    this.base(arguments);
    const layout = new qx.ui.layout.VBox();
    layout.setSpacing(6);
    this.setLayout(layout);
    this.setMaxWidth(380);

    this._init();
  },

  members: {
    _init: function () {
      const logo = new qx.ui.basic.Image(
        "tweetclone/icons/custom/hello_cat.png"
      );
      logo.set({
        width: 50,
        height: 50,
        scale: true,
        marginBottom: 20,
        marginTop: 20,
      });

      const slogan = new qx.ui.basic.Label(
        this.tr("See what’s happening in the world right now")
      );
      slogan.setAppearance("slogan");
      slogan.set({
        appearance: "slogan",
        rich: true,
        marginBottom: 60,
      });

      const jnoinNow = new qx.ui.basic.Label(this.tr("Join tweetclone today."));
      jnoinNow.set({
        marginBottom: 10,
        rich: true,
        font: qx.bom.Font.fromString("16px NotoSans bold"),
      });

      const registerButton = new qx.ui.form.Button(this.tr("Register"));
      registerButton.set({
        allowGrowX: true,
      });
      registerButton.addListener("execute", this.__onRegister, this);

      const loginButton = new qx.ui.form.Button(this.tr("Log In"));
      loginButton.set({
        allowGrowX: true,
      });

      this.add(logo);
      this.add(slogan);
      this.add(jnoinNow);
      this.add(registerButton);
      this.add(loginButton);
    },

    __onRegister: function () {
      tweetclone.formElement.DateSelect.register();
      tweetclone.formElement.Label.register();
      const pageData = [
        {
          message:
            "<p style='font-weight:bold'>" +
            this.tr("Create new account") +
            "</p>",
          formData: {
            name: {
              type: "textfield",
              label: this.tr("Your name"),
            },
            email: {
              type: "textfield",
              label: this.tr("e-mail"),
            },
            birthday: {
              type: "dateselect",
              label: this.tr("Birthday"),
              // allowNull: true,
            },
          },
        },
        {
          message:
            "<p style='font-weight:bold'>" +
            this.tr("Customize your experience") +
            "</p>" +
            "<p>" +
            this.tr("These options don't really do anything") +
            "</p>",
          formData: {
            label: {
              type: "infolabel",
              value: this.tr("Get more out of Tweetclone"),
              rich: true,
              font: qx.bom.Font.fromString("16px NotoSans bold"),
            },
            email_subscribe: {
              type: "checkbox",
              label: this.tr(
                "Receive email about your Tweetclone activity and recommendations."
              ),
              value: false,
            },
          },
        },
      ];

      let wizard = new qxl.dialog.Wizard({
        width: 500,
        maxWidth: 500,
        pageData: pageData,
        allowCancel: true,
        setupFormRendererFunction: function (form) {
          return new tweetclone.renderer.DialogRenderer(form);
        },
        callback: (map) => {
          qxl.dialog.Dialog.alert(
            "Thank you for your input. See log for result."
          );
          this.debug(qx.util.Serializer.toJson(map));
        },
        caption: "Test",
      });
      wizard.start();
    },
  },
});
