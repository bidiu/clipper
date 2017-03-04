// create a range,
// will be loaded and executed by Selenium context

const MIN_TEXT_LEN = 20
const RANGE_LEN = 10

function isHidden(element) {
    var style = window.getComputedStyle(element);
    return style.display === "none";
}


var ps = document.getElementsByTagName("p");
if (ps.length === 0) {
  // failed
  return null;
}

for (let p of ps) {
  if (isHidden(p)) {
    // have to make selection range on visible elment
    // otherwise, won't trigger Diggo extension
    continue;
  }
  textNode = p.firstChild;
  if (textNode.nodeType !== Node.TEXT_NODE) {
    continue;
  }
  let text = textNode.textContent.trim();
  if (text.length < MIN_TEXT_LEN) {
    continue;
  }

  let range = document.createRange();
  let start = textNode.textContent.indexOf(text[0])
  range.setStart(textNode, start);
  range.setEnd(textNode, start + RANGE_LEN + 1);
  window.getSelection().addRange(range);

  // trigger mousedown event
  let downEvent = document.createEvent("MouseEvents");
  downEvent.initMouseEvent("mousedown", true, true, window, 0, 0, 0, 0,
          false, false, false, false, 0, null);
  document.body.dispatchEvent(downEvent);

  // trigger mouseup event
  let upEvent = document.createEvent("MouseEvents");
  upEvent.initMouseEvent("mouseup", true, true, window, 0, 0, 0, 0,
          false, false, false, false, 0, null);
  document.body.dispatchEvent(upEvent);
  // succeeded
  return range.toString().trim();
}
// failed
return null;
