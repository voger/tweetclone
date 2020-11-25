/**
 * @asset(tweetclone/backgrounds/parrot.jpg)
 * @asset(qx/icon/${qx.icontheme}/48/*)
 * @asset(tweetclone/icons/tango-icon-theme/32x32/apps/internet-group-chat.png)
 *
 */
qx.Class.define("tweetclone.widgets.WelcomeLeft", {
  extend: qx.ui.container.Composite,

  construct: function() {
    this.base(arguments);

    this.setLayout(new qx.ui.layout.Canvas());

    this.__addImage();
    this.__addText();
  },

  members: {
    __addImage: function() {
      const bgImage = new qx.ui.basic.Image("tweetclone/backgrounds/parrot.jpg");
      bgImage.setScale(true);
      bgImage.set({
        allowGrowX: true,
        allowGrowY: true,
        allowShrinkX: true,
        allowShrinkY: true
      });

      this.bind("height", bgImage, "height");
      this.add(bgImage, {edge: 0});
    },

    __addText: function() {

      // prepare a container for labels
      const layout = new qx.ui.layout.VBox();
      layout.set({
        alignX: "center",
        alignY: "middle"
      });
      const labelContainer = new qx.ui.container.Composite(layout);

      const iconPath = "icon/48"
      const list = [ 
        {icon: `${iconPath}/actions/system-search.png`, label: "Follow your interests."},
        {icon: `${iconPath}/apps/preferences-users.png`, label: "Hear what people are talking about."},
        {icon: "tweetclone/icons/tango-icon-theme/32x32/apps/internet-group-chat.png", label: "Join the conversation."}
      ];

      list.forEach(({icon, label}) => {
        const atom = this.__createAtom(icon, label);
        labelContainer.add(atom);
      });


      // prepare a container for putting the label container
      var mainContainer = new qx.ui.container.Composite(new qx.ui.layout.HBox());

      mainContainer.add(new qx.ui.core.Spacer(), {flex: 1});
      mainContainer.add(labelContainer);
      mainContainer.add(new qx.ui.core.Spacer(), {flex: 1});
      this.add(mainContainer, {edge:0});
    },

    __createAtom: function(icon, label) {
      const atom = new qx.ui.basic.Atom(label, icon);
      this.add(atom, {left:30, top:30})
      return atom;
    }
  }
});
