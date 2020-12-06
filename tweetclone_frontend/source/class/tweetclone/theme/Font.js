/* ************************************************************************

   Copyright: 2020 undefined

   License: MIT license

   Authors: undefined

 ************************************************************************ */
/**
 * @asset(tweetclone/fonts*)
 *
 */
qx.Theme.define("tweetclone.theme.Font", {
  extend: qx.theme.indigo.Font,

  fonts: {
    promo: {
      size: 19,
      family: ["NotoSans"],
      bold: true,
    },

    slogan: {
      size: 24,
      family: ["NotoSans"],
      bold: true,
    },
  },
});
