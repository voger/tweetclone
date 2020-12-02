qx.Class.define("tweetclone.pages.LandingGate", {
  extend: qx.ui.container.Composite,

  construct: function () {
    this.base(arguments);
    this.setLayout(new qx.ui.layout.VBox());

    this.__addLoginForm();
  },

  members: {
    __addLoginForm: function () {
      const form = new qx.ui.form.Form();

      const username = new qx.ui.form.TextField();
      form.add(username, "User Name", null, "username");

      const password = new qx.ui.form.PasswordField();
      form.add(password, this.tr("Password"), null, "password");

      const login = new qx.ui.form.Button(this.tr("Log in"));
      form.addButton(login);

      const groupBox = new qx.ui.groupbox.GroupBox();
      groupBox.setAllowGrowY(false);
      groupBox.setLayout(new qx.ui.layout.Canvas());
      groupBox.add(new qx.ui.form.renderer.Double(form));

      this.add(groupBox);
    },
  },
});
