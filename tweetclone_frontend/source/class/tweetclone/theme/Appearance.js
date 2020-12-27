/* ************************************************************************

   Copyright: 2020 undefined

   License: MIT license

   Authors: undefined

 ************************************************************************ */

qx.Theme.define("tweetclone.theme.Appearance", {
  extend: qx.theme.indigo.Appearance,
  include: [
    qxDateSelect.theme.Appearance
  ],

  appearances: {
    "welcome-list-item": {
      alias: "atom",
      include: "atom",
    },

    "welcome-list-item/label": {
      style: function () {
        return {
          textColor: "white",
          font: "promo",
        };
      },
    },

    "slogan": {
      style: function () {
        return {
          font: "slogan",
        };
      },
    },
  },
});
