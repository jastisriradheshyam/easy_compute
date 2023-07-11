const { getCreds } = require("./get_creds");
const creds = require('./creds.json');

const doSignIn = async (JSESSIONID, PLAY_SESSION, access_token) => {
  const response = await fetch(`https://${creds.companyCode}.greythr.com/v3/api/attendance/mark-attendance?action=Signin`, {
    method: 'POST',
    body: JSON.stringify({ "attLocation": 56, "remarks": "" }),
    headers:
    {
      'content-type': 'application/json',
      'accept': 'application/json',
      'cookie': `JSESSIONID=${JSESSIONID}; access_token=${access_token}; PLAY_SESSION=${PLAY_SESSION}`,
    },
  });
  console.log(response.status);
  console.log(response.headers);
  console.log((response.headers.get('content-type').includes('json')) ? await response.json() : await response.text());
}

const checkSwipes = async (JSESSIONID, PLAY_SESSION, access_token) => {
  const response = await fetch(`https://${creds.companyCode}.greythr.com/v3/api/attendance/swipes`, {
    method: 'GET',
    headers:
    {
      'accept': 'application/json',
      'cookie': `JSESSIONID=${JSESSIONID}; access_token=${access_token}; PLAY_SESSION=${PLAY_SESSION}`,
    },
  });
  console.log(response.status);
  console.log(response.headers);
  console.log((response.headers.get('content-type').includes('json')) ? await response.json() : await response.text());
}

const do_attend = async () => {
  const {
    JSESSIONID, PLAY_SESSION, access_token
  } = await getCreds();
  await doSignIn(JSESSIONID, PLAY_SESSION, access_token)
  await checkSwipes(JSESSIONID, PLAY_SESSION, access_token)
}

do_attend()
