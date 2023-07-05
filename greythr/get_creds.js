const CryptoJS = require("crypto-js");
const creds = require('./creds.json');
const { getCookies, createNonce } = require('./utils');

const greythr = async () => {
  const response = await fetch(`https://${creds.companyCode}.greythr.com`);
  return response.headers.get('set-cookie')?.split(';')[0];
}

const loginPage = async (JSESSIONID) => {
  const response = await fetch(`https://${creds.companyCode}.greythr.com/uas/portal/auth/login`, {
    headers:
      { 'cookie': `JSESSIONID=${JSESSIONID}` }
  })
  const html = await response.text()

  const sessionStorageList = html.match(/sessionStorage\.setItem\((.*?)\);/g)?.filter((ss) => !!ss.match(/'encryptKey'|'accessId'/));
  console.log(sessionStorageList)
  const getValuesFromSetItemString = (setItemString) => {
    return setItemString.split(',')[1].split(')')[0].replace(/"/g, '').replace(/'/g, '').trim();
  }
  let encryptKey = "";
  let accessId = "";
  Array.isArray(sessionStorageList) && sessionStorageList.forEach(sessionStorageElement => {
    if (sessionStorageElement.includes('encryptKey')) {
      encryptKey = getValuesFromSetItemString(sessionStorageElement);
    }
    if (sessionStorageElement.includes('accessId')) {
      accessId = getValuesFromSetItemString(sessionStorageElement);
    }
  });
  console.log({ encryptKey, accessId })
  return { encryptKey, accessId }
}

const getLoginChallenge = async (accessId) => {
  const nonce = await createNonce();
  const response = await fetch(`https://goth.greythr.com/oauth2/auth?response_type=id_token%20token&client_id=greythr&state=${encodeURIComponent(nonce)}&redirect_uri=https%3A%2F%2Fidp.greythr.com%2Fuas%2Fportal%2Fauth%2Fcallback&scope=openid%20offline&nonce=${encodeURIComponent(nonce)}&access_id=${encodeURIComponent(accessId)}&gt_user_token=&origin_user=`, {
    "referrer": `https://${creds.companyCode}.greythr.com/`,
    "method": "GET",
    redirect: 'manual'
  });
  const loginChallenge = new URL(response.headers.get('location')).searchParams.get('login_challenge')
  console.log(loginChallenge)
  console.log(getCookies(response.headers.getSetCookie()))
  return { loginChallenge, oauth2_authentication_csrf_insecure: getCookies(response.headers.getSetCookie()).get('oauth2_authentication_csrf_insecure'), nonce };
}

const initiateLogin = async (challenge) => {
  const res = await fetch(`https://${creds.companyCode}.greythr.com/uas/v1/initiate-login/${challenge}`);
  console.log(await res.json())
}

const doLogin = async (JSESSIONID, username, password, encryptKey, challenge, oauth2_authentication_csrf_insecure) => {
  const encryptedPassword = CryptoJS.AES.encrypt(password, encryptKey).toString();

  const response = await fetch(`https://${creds.companyCode}.greythr.com/uas/v1/login`, {
    method: 'POST',
    body: JSON.stringify({
      userName: username,
      password: encryptedPassword
    }),
    headers:
    {
      'cookie': `JSESSIONID=${JSESSIONID}`,
      'content-type': 'application/json',
      'X-OAUTH-CHALLENGE': challenge
    },
    redirect: 'manual'
  })
  console.log(response.status)
  console.log(response.headers)
  console.log(oauth2_authentication_csrf_insecure)
  const loginData = await response.json();
  console.log(loginData)

  const loginRedirectResponse = await fetch(loginData.redirectUrl, {
    method: 'GET',
    headers:
    {
      'Referer': `https://${creds.companyCode}.greythr.com/uas/portal/auth/login?login_challenge=${challenge}`,
      'Cookie': `oauth2_authentication_csrf_insecure=${oauth2_authentication_csrf_insecure}`,

    },
    redirect: 'manual'
  })
  console.log(loginRedirectResponse.status)
  console.log(loginRedirectResponse.headers)
  const oauthCookies = getCookies(loginRedirectResponse.headers.getSetCookie());
  const oauth2_authentication_session_insecure = oauthCookies.get('oauth2_authentication_session_insecure');
  const oauth2_consent_csrf_insecure = oauthCookies.get('oauth2_consent_csrf_insecure');

  const idp = await fetch(loginRedirectResponse.headers.get('location'), {
    method: 'GET',
    redirect: 'manual'
  })

  console.log(idp.headers)

  const consent_verifierRes = await fetch(idp.headers.get('location'), {
    method: 'GET',
    headers:
    {
      'cookie': `oauth2_authentication_csrf_insecure=${oauth2_authentication_csrf_insecure}; oauth2_consent_csrf_insecure=${oauth2_consent_csrf_insecure}`,
      // 'x-oauth-challenge': challenge
    },
    redirect: 'manual'
  })

  console.log(consent_verifierRes.headers)

  const callbackRes = await fetch(consent_verifierRes.headers.get('location'), {
    method: 'GET',
    headers:
    {
      // 'cookie': `oauth2_authentication_csrf_insecure=${oauth2_authentication_csrf_insecure}; oauth2_consent_csrf_insecure=${oauth2_consent_csrf_insecure}`,
      // 'x-oauth-challenge': challenge
    },
    redirect: 'manual'
  })
  const accessToken = new URL(consent_verifierRes.headers.get('location')).hash.split('&')[0].split('#')[1].split('access_token=')[1];
  console.log(accessToken)

  const callbackInitRes = await fetch('https://idp.greythr.com/uas/v1/initiate/callback', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'ACCESS-TOKEN': accessToken
    },
    body: '{}'
  })
  console.log(callbackInitRes.status)
  console.log(callbackInitRes.headers)
  console.log(await callbackInitRes.json())
  return { accessToken, oauth2_authentication_session_insecure, oauth2_consent_csrf_insecure };
}

const setSessionCookie = async (JSESSIONID, access_token) => {
  const responseSessionCookie = await fetch(`https://${creds.companyCode}.greythr.com/uas/v1/session-cookie`, {
    method: 'GET',
    headers:
    {
      'ACCESS-TOKEN': access_token,
      'cookie': `JSESSIONID=${JSESSIONID};`,
    },
    redirect: 'manual'
  })
  console.log({ JSESSIONID, access_token })
  console.log(responseSessionCookie.headers)
}

const startGreythr = async (JSESSIONID, access_token) => {
  const responseSessionCookie = await fetch(`https://${creds.companyCode}.greythr.com`, {
    method: 'GET',
    headers:
    {
      cookie: `JSESSIONID=${JSESSIONID}; access_token=${access_token}`
    },
    redirect: 'manual'
  })
}

const getJSSESSIONGif = async (JSESSIONID, access_token) => {
  const response = await fetch(`https://${creds.companyCode}.greythr.com/app-loading.gif`, {
    headers: {
      cookie: `JSESSIONID=${JSESSIONID}; access_token=${access_token}`
    }
  });
  console.log(response.headers)
  const JSSESSION_Cookie_string = getCookies(response.headers.getSetCookie()).get('JSESSIONID');
  console.log(JSSESSION_Cookie_string)
  return JSSESSION_Cookie_string;
}

const getJSSESSION = async (JSESSIONID, access_token) => {
  const response = await fetch(`https://${creds.companyCode}.greythr.com/home.do`, {
    headers: {
      cookie: `JSESSIONID=${JSESSIONID}; access_token=${access_token}`
    }
  });
  console.log(response.headers)
  console.log(getCookies(response.headers.getSetCookie()))
  const JSSESSION_Cookie_string = getCookies(response.headers.getSetCookie()).get('JSESSIONID');
  return JSSESSION_Cookie_string;
}


const getPlaySession = async (JSESSIONID, access_token) => {
  const response = await fetch(`https://${creds.companyCode}.greythr.com/v3/portal`, {
    headers: {
      cookie: `JSESSIONID=${JSESSIONID}; access_token=${access_token}`
    }
  });
  console.log(getCookies(response.headers.getSetCookie()))
  const PLAY_SESSION_Cookie_string = getCookies(response.headers.getSetCookie()).get('PLAY_SESSION');
  return PLAY_SESSION_Cookie_string;
}

const loginStatus = async (JSESSIONID, PLAY_SESSION, access_token) => {
  const loginStatusRes = await fetch(`https://${creds.companyCode}.greythr.com/v3/login-status`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'cookie': `JSESSIONID=${JSESSIONID}; access_token=${access_token}; PLAY_SESSION=${PLAY_SESSION}`
    },
    body: '{}'
  });
  console.log(await loginStatusRes.headers);
  console.log(await loginStatusRes.json());
}

const getCreds = async () => {
  let JSESSIONID;
  const JSESSIONIDCookie = await greythr();
  JSESSIONID = JSESSIONIDCookie.split(';')[0].split('=')[1];
  const { encryptKey, accessId } = await loginPage(JSESSIONID);
  const { loginChallenge, oauth2_authentication_csrf_insecure, nonce } = await getLoginChallenge(accessId);
  await initiateLogin(loginChallenge);
  const { accessToken: access_token } = await doLogin(JSESSIONID, creds.username, creds.password, encryptKey, loginChallenge, oauth2_authentication_csrf_insecure);
  await setSessionCookie(JSESSIONID, access_token)
  await startGreythr(JSESSIONID, access_token);
  JSESSIONID = await getJSSESSIONGif(JSESSIONID, access_token);
  await getJSSESSION(JSESSIONID, access_token);
  const PLAY_SESSION = await getPlaySession(JSESSIONID, access_token);
  await loginStatus(JSESSIONID, PLAY_SESSION, access_token);
  return {
    JSESSIONID, PLAY_SESSION, access_token
  }
};

module.exports = { getCreds }
