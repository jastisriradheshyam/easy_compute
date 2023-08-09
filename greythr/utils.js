const getCookies = (cookiesStrings) => {
  const cookies = new Map();
  cookiesStrings.forEach((cookiesString) => {
    const cookieKeyValue = cookiesString.split(';')[0];
    const separatorIndex = cookieKeyValue.indexOf('=');
    const key = cookieKeyValue.slice(0, separatorIndex);
    const value = cookieKeyValue.slice(separatorIndex + 1);
    cookies.set(key, value);
  });
  return cookies;
}

const createNonce = () => {
  let t = "";
  const n = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  for (let e = 0; e < 40; e++)
    t += n.charAt(Math.floor(Math.random() * n.length));
  return t;
}

module.exports = {
  getCookies, createNonce
}