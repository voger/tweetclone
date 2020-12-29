qx.Class.define("tweetclone.widgets.Label", {
  extend: qx.ui.basic.Label,
  implement: [qx.ui.form.IForm, qx.ui.form.IStringForm],

  include: [qx.ui.form.MForm],

  /**
   * The purpose of this class is to simply implement the required
   * interfaces to be qualyfied by `qx.ui.form.validation.Manager`
   * and be able to add it to a qxl.Dialog form.
   *
   * This class I am pretty sure it commits some OOP sin
   * but it gets the job done.
   *
   */

  properties: {
    rich: {
      refine: true,
      init: true}
  }
});
