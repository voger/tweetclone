qx.Class.define("tweetclone.pages.LandingGate", {
  extend: qx.ui.container.Composite,

  construct: function () {
    this.base(arguments);

    const layout = new qx.ui.layout.VBox();
    layout.setAlignX("center");
    this.setLayout(layout);

    this.__addLoginForm();
    this.__addRegisterBox();
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
      groupBox.setAllowGrowX(false);
      groupBox.setLayout(new qx.ui.layout.Canvas());
      groupBox.setMarginBottom(100);
      groupBox.add(new tweetclone.renderer.LoginFormRenderer(form));

      this.add(groupBox);
    },

    __addRegisterBox: function () {
      const loginBox = new tweetclone.widgets.RegisterBox();
      this.add(loginBox);
    },
  },
});
