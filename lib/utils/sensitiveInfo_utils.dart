class SensitiveInfoUtils {
  /**
   * [中文姓名] 如果长度为2，后一位隐藏为星号<例子：李*>，如果长度>2，中间隐藏为星号<例子：李*星>
   *
   * @param fullName 姓名
   * @return
   */
  static String chineseName(String fullName) {
    if (fullName.isEmpty) {
      return "";
    }
    String sb = fullName.substring(fullName.length - 1, fullName.length);
    if (fullName.length >= 3){
      return '**$sb';
    }
    return '*$sb';
//     for (int i = 0; i < fullName.length - 2; i++) {
// //sb.append("*");
//       sb = '*$sb';
//     }
//     if (fullName.length > 2) {
//       sb += fullName.substring(fullName.length - 1);
//     } else {
//       sb += "*";
//     }
    return sb.toString();
  }

  /**
   * [身份证号] 显示最后四位，其他隐藏。共计18位或者15位。<例子：*************5762>
   *
   * @param id
   * @return
   */
  static String idCardNum(String id) {
    if (id.isEmpty) {
      return "";
    }
    String sb = '';
    for (int i = 0; i < id.length - 4; i++) {
     // sb.append("*");
      sb += '*';
    }
    sb += id.substring(id.length - 4);
    return sb;
  }

// /**
//  * [身份证号] 前六位，后四位，其他用星号隐藏每位1个星号<例子:451002********1647>
//  *
//  * @param cardId
//  * @return
//  */
// String idCard(String cardId) {
// if (TextUtils.isEmpty(cardId)) {
// return "";
// }
// StringBuilder sb = new StringBuilder();
// sb.append(cardId.subSequence(0, 6));
// for (int i = 0; i < cardId.length() - 10; i++) {
// sb.append("*");
// }
// sb.append(cardId.substring(cardId.length() - 4));
// return sb.toString();
// }

}
