/**
 * @asset(tweetclone/backgrounds/hoverfly.jpg)
 *
 */
qx.Class.define("tweetclone.pages.Welcome", {
  extend: qx.ui.container.Composite,

  construct: function () {
    this.base(arguments);

    this.setLayout(new qx.ui.layout.HBox());

    this.__createLeftPanel();
    this.__createRightPanel();
  },

  members: {
    __createLeftPanel: function () {
      this.add(new tweetclone.widgets.WelcomeLeft(), { flex: 1 });
    },

    __createRightPanel: function () {
      this.add(new tweetclone.pages.LandingGate(), { flex: 1 });
    },
  },
});
