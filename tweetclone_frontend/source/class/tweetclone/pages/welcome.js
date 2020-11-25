/**
 * @asset(tweetclone/backgrounds/hoverfly.jpg)
 *
 */
qx.Class.define("tweetclone.pages.Welcome", {
  extend: qx.ui.container.Composite,

  construct: function() {
    this.base(arguments);

    this.setLayout(new qx.ui.layout.HBox());

    this.__createLeftPanel()
  },

  members: {
    __createLeftPanel: function() {

    }
  }
});
